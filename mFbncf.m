function [yk] = mFbncf(xk)
% Measurement Function for GPS
% 2D Tracking in Cartesian coordinates
% Input - the state xk;   
% Output yk - the coordinates and the scalar speed v
% Ivan Rajkovic
% June 2018

yk(1) = xk(1); % position x
yk(2) = xk(3); % position y
yk(3) = sqrt(xk(2) * xk(2) + xk(4) * xk(4));

end

