
int curr = 0;
int state = 3;

// Parameters
double p_param = 0.015;
double R_true = 0.1001405119340;
double L_true = 0.5052864456892;
double K_psi = L_true/R_true;
// double K_omega = 180/(PI*R_true); // Real
double K_omega = 0.01 * 180/(PI*R_true); // Simulator
double v_limit = 500;
double end_tol = 0.03;
double angle_tol = 20;
double close_tol = 0.3;

// Reference point variables
double beginx;
double beginy;
double endx;
double endy;
double delta_x_g;
double delta_y_g;
double norm_g;
double cos_g;
double sin_g;

// Control variables
double x_m, y_m;
double delta_x, delta_y;
double angle_diff;
double vc1;
double vc2;
double d0;
double dg;
double dp;
double v, w;

// state variables
int follow_waypoints = 0; 
int wp_start;
int wp_end;

double side_len = 3.0;
double disc = 0.5;
int states_per_side = side_len/disc;
int num_states = states_per_side * states_per_side;

double state_coordinate[36][2];
// state_coordinate[ 0][0] = -1.25; state_coordinate[ 0][1] = -1.25; 
// state_coordinate[ 1][0] = -1.25; state_coordinate[ 1][1] = -0.75; 
// state_coordinate[ 2][0] = -1.25; state_coordinate[ 2][1] = -0.25; 
// state_coordinate[ 3][0] = -1.25; state_coordinate[ 3][1] =  0.25; 
// state_coordinate[ 4][0] = -1.25; state_coordinate[ 4][1] =  0.75; 
// state_coordinate[ 5][0] = -1.25; state_coordinate[ 5][1] =  1.25; 
// state_coordinate[ 6][0] = -0.75; state_coordinate[ 6][1] =  1.25; 
// state_coordinate[ 7][0] = -0.75; state_coordinate[ 7][1] =  0.75; 
// state_coordinate[ 8][0] = -0.75; state_coordinate[ 8][1] =  0.25; 
// state_coordinate[ 9][0] = -0.75; state_coordinate[ 9][1] = -0.25; 
// state_coordinate[10][0] = -0.75; state_coordinate[10][1] = -0.75; 
// state_coordinate[11][0] = -0.75; state_coordinate[11][1] = -1.25; 
// state_coordinate[12][0] = -0.25; state_coordinate[12][1] = -1.25; 
// state_coordinate[13][0] = -0.25; state_coordinate[13][1] = -0.75; 
// state_coordinate[14][0] = -0.25; state_coordinate[14][1] = -0.25; 
// state_coordinate[15][0] = -0.25; state_coordinate[15][1] =  0.25; 
// state_coordinate[16][0] = -0.25; state_coordinate[16][1] =  0.75; 
// state_coordinate[17][0] = -0.25; state_coordinate[17][1] =  1.25; 
// state_coordinate[18][0] =  0.25; state_coordinate[18][1] =  1.25; 
// state_coordinate[19][0] =  0.25; state_coordinate[19][1] =  0.75; 
// state_coordinate[20][0] =  0.25; state_coordinate[20][1] =  0.25; 
// state_coordinate[21][0] =  0.25; state_coordinate[21][1] = -0.25; 
// state_coordinate[22][0] =  0.25; state_coordinate[22][1] = -0.75; 
// state_coordinate[23][0] =  0.25; state_coordinate[23][1] = -1.25; 
// state_coordinate[24][0] =  0.75; state_coordinate[24][1] = -1.25; 
// state_coordinate[25][0] =  0.75; state_coordinate[25][1] = -0.75; 
// state_coordinate[26][0] =  0.75; state_coordinate[26][1] = -0.25; 
// state_coordinate[27][0] =  0.75; state_coordinate[27][1] =  0.25; 
// state_coordinate[28][0] =  0.75; state_coordinate[28][1] =  0.75; 
// state_coordinate[29][0] =  0.75; state_coordinate[29][1] =  1.25; 
// state_coordinate[30][0] =  1.25; state_coordinate[30][1] =  1.25; 
// state_coordinate[31][0] =  1.25; state_coordinate[31][1] =  0.75; 
// state_coordinate[32][0] =  1.25; state_coordinate[32][1] =  0.25; 
// state_coordinate[33][0] =  1.25; state_coordinate[33][1] = -0.25; 
// state_coordinate[34][0] =  1.25; state_coordinate[34][1] = -0.75; 
// state_coordinate[35][0] =  1.25; state_coordinate[35][1] = -1.25; 

// int coord2state(double x, double y){
    // int num_side = side_len/disc;
    // x += 1.5; 
    // y += 1.5;
    // int x_state =  x/disc;
    // int y_state =  y/disc;
    // if (x_state < 0) x_state = 0;
    // if (x_state >= states_per_side) x_state = states_per_side - 1;   
    // if (y_state < 0) y_state = 0;
    // if (y_state >= states_per_side) y_state = states_per_side - 1;
    // int state = x + y * states_per_side;
// }

// void coord2center(double x, double y, double *x_out, double *y_out) {
    // int state_ind = coord2state(double x, double y);
    // &x_out = state_coordinate[state_ind][0];
    // &y_out = state_coordinate[state_ind][1];
// }

const int way_length = 19;
int waypoints[19] = {6, 7, 18, 17, 20, 21, 28, 33, 34, 35, 36, 25, 24, 13, 14, 15, 16, 17, 20};

