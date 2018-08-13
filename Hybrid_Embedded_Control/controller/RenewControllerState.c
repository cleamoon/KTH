beginx = x0/100.0;
beginy = y0/100.0;
endx = xg/100.0;
endy = yg/100.0;

if (beginx == endx && beginy == endy){
    follow_waypoints++;
}
else {
    follow_waypoints = 0;
}

delta_x_g = endx-beginx;
delta_y_g = endy-beginy;
norm_g = sqrt(delta_x_g*delta_x_g + delta_y_g*delta_y_g);
cos_g = delta_x_g / norm_g;
sin_g = delta_y_g / norm_g;