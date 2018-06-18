function [xkp1] = stFbncf(xk)
% State Transition Function for GPS
% 2D Tracking in Cartesian coordinates
% Input - the previous state xk; w - acceleration noise;  T - sampling time  
% Output xkp1 - the next state xk + 1
% Ivan Rajkovic
% June 2018

T = 1; % GPS time sampling

xkp1(1) = xk(1) + T*xk(2);   % position x
xkp1(2) = xk(2);             % speed vx
xkp1(3) = xk(3) + T*xk(4);   % position y
xkp1(4) = xk(4);             % speed vy

end

