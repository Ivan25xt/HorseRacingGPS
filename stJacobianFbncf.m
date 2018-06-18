function [Jx] = stJacobianFbncf(xk)
%
% Jacobian Matrix of the State Transition Function for GPS
% 2D Tracking in Cartesian coordinates
%
% Inputs: 
% xk - x[k], states at time k; 
% w  - w[k], noisy acceleration at time k;  
% T  - sampling time  
%
% Output 
% Jx - Jacobian Matrix of x[k]
%
% Matrix of partial derivatives with respect to states and noise components 
%
% See also extendedKalmanFilter, unscentedKalmanFilter
%
%   Copyright 2018 Ivan Rajkovic
%

% xkp1(1) = xk(1) + T*xk(2); % position x

T = 1;

Jx(1,1) = 1;
Jx(1,2) = T;
Jx(1,3) = 0;
Jx(1,4) = 0;


% xkp1(2) = xk(2)  % speed vx
Jx(2,1) = 0;
Jx(2,2) = 1;
Jx(2,3) = 0;
Jx(2,4) = 0;


% xkp1(3) = xk(3) + T*xk(4); % position y
Jx(3,1) = 0;
Jx(3,2) = 0;
Jx(3,3) = 1;
Jx(3,4) = T;


% xkp1(4) = xk(4); % speed vy

Jx(4,1) = 0;
Jx(4,2) = 0;
Jx(4,3) = 0;
Jx(4,4) = 1;

end

