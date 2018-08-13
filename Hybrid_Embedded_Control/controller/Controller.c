
state_coordinate[ 0][0] = -1.25; state_coordinate[ 0][1] = -1.25; 
state_coordinate[ 1][0] = -1.25; state_coordinate[ 1][1] = -0.75; 
state_coordinate[ 2][0] = -1.25; state_coordinate[ 2][1] = -0.25; 
state_coordinate[ 3][0] = -1.25; state_coordinate[ 3][1] =  0.25; 
state_coordinate[ 4][0] = -1.25; state_coordinate[ 4][1] =  0.75; 
state_coordinate[ 5][0] = -1.25; state_coordinate[ 5][1] =  1.25; 
state_coordinate[ 6][0] = -0.75; state_coordinate[ 6][1] =  1.25; 
state_coordinate[ 7][0] = -0.75; state_coordinate[ 7][1] =  0.75; 
state_coordinate[ 8][0] = -0.75; state_coordinate[ 8][1] =  0.25; 
state_coordinate[ 9][0] = -0.75; state_coordinate[ 9][1] = -0.25; 
state_coordinate[10][0] = -0.75; state_coordinate[10][1] = -0.75; 
state_coordinate[11][0] = -0.75; state_coordinate[11][1] = -1.25; 
state_coordinate[12][0] = -0.25; state_coordinate[12][1] = -1.25; 
state_coordinate[13][0] = -0.25; state_coordinate[13][1] = -0.75; 
state_coordinate[14][0] = -0.25; state_coordinate[14][1] = -0.25; 
state_coordinate[15][0] = -0.25; state_coordinate[15][1] =  0.25; 
state_coordinate[16][0] = -0.25; state_coordinate[16][1] =  0.75; 
state_coordinate[17][0] = -0.25; state_coordinate[17][1] =  1.25; 
state_coordinate[18][0] =  0.25; state_coordinate[18][1] =  1.25; 
state_coordinate[19][0] =  0.25; state_coordinate[19][1] =  0.75; 
state_coordinate[20][0] =  0.25; state_coordinate[20][1] =  0.25; 
state_coordinate[21][0] =  0.25; state_coordinate[21][1] = -0.25; 
state_coordinate[22][0] =  0.25; state_coordinate[22][1] = -0.75; 
state_coordinate[23][0] =  0.25; state_coordinate[23][1] = -1.25; 
state_coordinate[24][0] =  0.75; state_coordinate[24][1] = -1.25; 
state_coordinate[25][0] =  0.75; state_coordinate[25][1] = -0.75; 
state_coordinate[26][0] =  0.75; state_coordinate[26][1] = -0.25; 
state_coordinate[27][0] =  0.75; state_coordinate[27][1] =  0.25; 
state_coordinate[28][0] =  0.75; state_coordinate[28][1] =  0.75; 
state_coordinate[29][0] =  0.75; state_coordinate[29][1] =  1.25; 
state_coordinate[30][0] =  1.25; state_coordinate[30][1] =  1.25; 
state_coordinate[31][0] =  1.25; state_coordinate[31][1] =  0.75; 
state_coordinate[32][0] =  1.25; state_coordinate[32][1] =  0.25; 
state_coordinate[33][0] =  1.25; state_coordinate[33][1] = -0.25; 
state_coordinate[34][0] =  1.25; state_coordinate[34][1] = -0.75; 
state_coordinate[35][0] =  1.25; state_coordinate[35][1] = -1.25;

// Convert goal into meters for the offline sim and arduino
// x_m = x_true/100.0;     
// y_m = y_true/100.0;
// Don't convert for the online simulator
x_m = x_true;     
y_m = y_true;

// Calculate deltas
delta_x = endx - x_m;
delta_y = endy - y_m;
angle_diff = atan2(delta_y, delta_x)*180.0/PI - theta_true;
if (angle_diff > 180) {
    angle_diff -= 360;
} 
else if (angle_diff <= -180) {
    angle_diff += 360;
}

vc1 = cos(theta_true*PI/180.0);
vc2 = sin(theta_true*PI/180.0);

d0 = delta_x*vc1 + delta_y*vc2;
dg = cos_g*delta_x + sin_g*delta_y;   // Velocity
dp = sin_g * (x_m - beginx + p_param*vc1) - cos_g * (y_m - beginy + p_param*vc2); // Direction

if ((fabs(delta_x) <= end_tol) && (fabs(delta_y) <= end_tol)) { // Position at target
	if(state != 3) {
        Serial.print("**************** \n");
        Serial.print("ARRIVED AT GOAL! \n");
        Serial.print("**************** \n");
        send_done();
        v = 0;
        w = 0;
    }
	state = 3;
} 
else {
	if (fabs(angle_diff) > angle_tol) {  // Turn towards target
		w = K_psi*angle_diff;
		if (sqrt(delta_x*delta_x + delta_y*delta_y) < close_tol) v = K_omega*d0;
		else v = 0;
		v = 0;
		state = 1;
    } 
    else { // Go towards target
        v = K_omega * dg;
        w = K_psi/p_param * dp;
        state = 2;
    }
}

// For real 
// if (v > v_limit) v = v_limit;
// else if (v < -v_limit) v = -v_limit;
// for simulator
if (v > v_limit * 0.01) v = v_limit * 0.01;
else if (v < -v_limit * 0.01) v = -v_limit * 0.01;
if (w > v_limit) w = v_limit;
else if (w < -v_limit) w = -v_limit;

right = v + w/2;
left = v - w/2;	

// Limit outputs to avoid saturation
if (right > v_limit) {
    left = left - (right - v_limit);
    right = v_limit;
}
if (left > v_limit) {
    right = right - (left - v_limit);
    left = v_limit;
}
if (right < -v_limit) {
    left = left + (right - v_limit);
    right = -v_limit;
}
if (left < -v_limit) {
    right = right + (left - v_limit);
    left = -v_limit;
}


// Waypoints
if (follow_waypoints >  1 && state == 3) {
    wp_start = waypoints[curr];
    curr = (curr + 1) % way_length;
    wp_end   = waypoints[curr];
    // beginx = state_coordinate[wp_start][0];
    // beginy = state_coordinate[wp_start][1];   
    beginx = x_m;
    beginy = y_m;
    endx = state_coordinate[wp_end][0];
    endy = state_coordinate[wp_end][1];

    delta_x_g = endx - beginx;
    delta_y_g = endy - beginy;
    norm_g = sqrt(delta_x_g*delta_x_g + delta_y_g*delta_y_g);
    cos_g = delta_x_g / norm_g;
    sin_g = delta_y_g / norm_g;
}

// Print d0, dg, dp
Serial.print("dg (vel): ");
Serial.print(dg, DEC);
Serial.print("\nd0 (vel): ");
Serial.print(d0, DEC);
Serial.print("\ndp (dir): ");
Serial.print(dp, DEC);
Serial.print("\n");

// Print deltas
Serial.print("delta x: ");
Serial.print(delta_x, DEC);
Serial.print("\ndelta y: ");
Serial.print(delta_y, DEC);
Serial.print("\nd angle: ");
Serial.print(angle_diff, DEC);
Serial.print("\n");

// Print controll outputs
Serial.print("v: ");
Serial.print(v, DEC);
Serial.print("\nw: ");
Serial.print(w, DEC);
Serial.print("\n");
Serial.print("left: ");
Serial.print(left, DEC);
Serial.print("\nright: ");
Serial.print(right, DEC);
Serial.print("\n");
/*
Serial.print("\n state: ");
Serial.print(state, DEC);
*/
