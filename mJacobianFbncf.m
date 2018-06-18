function [Jh] = mJacobianFbncf(xk)
%
% Jacobian Matrix of the Measurement Function for GPS
% 2D Tracking in Cartesian coordinates
%
% Inputs: 
% xk - x[k], states at time k; 
% w  - w[k], measurement noise;  
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

T = 1; % does not depend on T

% yk(1) = xk(1); % position x
Jh(1,1) = 1;
Jh(1,2) = 0;
Jx(1,3) = 0;
Jx(1,4) = 0;


% yk(2) = xk(3); % position y
Jx(2,1) = 0;
Jx(2,2) = 0;
Jx(2,3) = 1;
Jx(2,4) = 0;


% yk(3) = sqrt(xk(2) * xk(2) + xk(4) * xk(4));
Jx(3,1) = 0; 
Jx(3,2) = xk(2)/sqrt(xk(2) + xk(4));
Jx(3,3) = 0;
Jx(3,4) = xk(4)/sqrt(xk(2) + xk(4));



end
