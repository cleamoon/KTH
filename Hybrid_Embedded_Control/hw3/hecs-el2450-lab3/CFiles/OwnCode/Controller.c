/* 1 - Turning only
 * 2 - Go to reference point
 * 3 - Line tracing
 * 4 - Line tracing with advanced angle controller
 * 5 - Hybrid controller
 */
//	case 1: 
/*
double K_psi = 5.0;
right = (90-theta_true)*K_psi/(2);
left = -right;
*/

//	case 2: 
/*
double targetx = 1.5;
double targety = 2.0;
double K_psi = 5.0;
double K_omega = 500;

double delta_x = targetx - x_true;
double delta_y = targety - y_true;
double vc1 = cos(theta_true*PI/180);
double vc2 = sin(theta_true*PI/180);
double d0 = delta_x*vc1 + delta_y*vc2;
Serial.print(d0, DEC);
double v = K_omega * d0;
double w = K_psi*(atan((targety-y_true)/(targetx-x_true))*180/PI-theta_true);
right = v + w/2;
left = v - w/2;
*/

// case 3: 

double targetx = endx;
double targety = endy;
double startx = beginx;
double starty = beginx;
double K_psi = 5.0;
double K_omega = 120;

double delta_x = targetx - x_true ;
double delta_y = targety - y_true;
double start_angle;
if (startx < 1e-7) {
	if (starty < 1e-7) start_angle = 0;
	else start_angle = PI/2;
} else start_angle = abs(atan(starty/startx));
double target_angle = atan(targety/targetx);
double theta_g = abs(start_angle - target_angle);
double vg1 = cos(theta_g);
double vg2 = sin(theta_g);
double d0 = delta_x*vg1 + delta_y*vg2;
Serial.print(d0, DEC);
double v = K_omega * d0;
double w = K_psi*(atan((targety-y_true)/(targetx-x_true))*180/PI-theta_true);
right = v + w/2;
left = v - w/2;


//case 4:
/*
double targetx = -1.5;
double targety = -2.0;
double startx = 0.0;
double starty = 0.0;
double K_psi = 5;
double K_omega = 200;

double start_angle;
if (startx < 1e-7) {
	if (starty < 1e-7) start_angle = 0;
	else start_angle = PI/2;
} else {
	start_angle = abs(atan(starty/startx));
}
double target_angle;
if (startx < 1e-7) {
	if (starty < 1e-7) start_angle = 0;
	else start_angle = PI/2;
} else {
	start_angle = abs(atan(starty/startx));
}

double theta_g = abs(start_angle - target_angle);

double delta_x = targetx - x_true ;
double delta_y = targety - y_true;
double vg1 = cos(theta_g);
double vg2 = sin(theta_g);
double d0 = delta_x*vg1 + delta_y*vg2;
double v = K_omega * d0;
// double v = 0;

double p = 1;
double vp_x = x_true - startx + p * cos(theta_true/180*PI);
double vp_y = y_true - starty + p * sin(theta_true/180*PI);
double vgp1 = sin(theta_g);
double vgp2 = -cos(theta_g);
double dp = vp_x*vgp1 + vp_y*vgp2;
double w = K_psi * dp * 180 / PI;

right = v + w/2;
left = v - w/2;
Serial.print(left, DEC);
Serial.print(" ");
Serial.print(right, DEC);
*/

// case 5:
/*
double startx = beginx;
double starty = beginy;
double targetx = endx;
double targety = endy;
double K_psi = 5.0;
double K_omega = 500;
double v, w;

double start_angle;
if (abs(startx) < 1e-7) {
	start_angle = PI/2;
} else {
	start_angle = (atan(starty/startx));
}
double target_angle;
if (abs(targetx) < 1e-7) {
	target_angle = PI/2;
} else {
	target_angle = atan(targety/targetx);
}
double theta_g = abs(start_angle - target_angle);


Serial.print(startx, DEC);
Serial.print(" ");
Serial.print(starty, DEC);
Serial.print("\n");
Serial.print(targetx, DEC);
Serial.print(" ");
Serial.print(targety, DEC);
Serial.print("\n");

double angle_diff = atan((targety-y_true)/(targetx-x_true))*180/PI-theta_true;
Serial.print("start angle: ");
Serial.print(start_angle, DEC); 
Serial.print("target angle: ");
Serial.print(target_angle, DEC); 


double** state_coordinate = (double**) malloc (36*sizeof(double*));

for (int i = 0; i < 36; i++) {
	state_coordinate[i] = (double*) malloc (2*sizeof(double));
}
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

int waypoints[] = {6, 7, 18, 17, 20, 21, 28, 33, 34, 35, 36, 25, 24, 13, 14, 15, 16, 17, 20};
int way_length = 20;

if (ft || (abs(targetx-x_true)<=0.03 && abs(targety-y_true)<=0.03)) {
	ft = false;
	if(state == 3) {
		if(curr < way_length) {
			beginx = state_coordinate[waypoints[curr]-1][0];
			beginy = state_coordinate[waypoints[curr]-1][1];
			endx = state_coordinate[waypoints[curr+1]-1][0];
			endy = state_coordinate[waypoints[curr+1]-1][1];
			curr ++;
		} else {
			endx = beginx;
			endy = beginy;
		}
		state = 1;
	}
	Serial.print("\n Ways: ");
	Serial.print(waypoints[curr], DEC);
	Serial.print("\n");
	Serial.print(endx, DEC);
	Serial.print(" ");
	Serial.print(endy, DEC);
	state = 3;
} else {
	if (abs(angle_diff) > 3) {
		w = K_psi*min(angle_diff, 180-angle_diff);
		v = 0;
		state = 1;
	} else {
		double delta_x = targetx - x_true;
		double delta_y = targety - y_true;
		double vc1 = cos(theta_true*PI/180);
		double vc2 = sin(theta_true*PI/180);
		double d0 = delta_x*vc1 + delta_y*vc2;
		// Serial.print(d0, DEC);
		v = K_omega * d0;
		w = 0;
		state = 2;
	}
	right = v + w/2;
	left = v - w/2;	
}

Serial.print("\n state: ");
Serial.print(state, DEC);
Serial.print("\n left: ");
Serial.print(w, DEC);
Serial.print("\n right:  ");
Serial.print(v, DEC);
*/
