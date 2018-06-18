%% Import and Convert GPS data to Cartesian Coordinate System 

importGpsData;

[zone, h, x, y, convergence, scale] = Gps2UtmConvert(longitude,latitude);

%% Extended Kalman Filter set up

T = 1; 

% State Noise
sigmaSqax = 10;
sigmaSqay = 10;

Q2 = [0.25*T^4 (T^3)/3; (T^3)/3 T^2]; % Eq 15 Li, Jilkov
CovGw = blkdiag(sigmaSqax * Q2, sigmaSqax * Q2); 


% Meas Noise
sigmaSqx = 10;
sigmaSqy = 10;
sigmaSqv = sqrt(2);

Istate = [x(2); 0; y(2); 0];

KFobj = unscentedKalmanFilter(@stFbncf,@mFbncf, double(Istate));

KFobj.HasAdditiveProcessNoise = true;      % uses logical variables as input
KFobj.HasAdditiveMeasurementNoise = true;   % uses logical variables as input

KFobj.ProcessNoise     = CovGw;
KFobj.MeasurementNoise  = diag([sigmaSqx,sigmaSqy,sigmaSqv]);

% KFobj.StateTransitionJacobianFcn = @stJacobianFbncf;
% KFobj.MeasurementJacobianFcn     = @mJacobianFbncf;


%%

N = length(x);

Ps = NaN(4,N);
Cs = NaN(4,N);

for jj = 3: N

    [PredictedState,PredictedStateCovariance] = predict(KFobj); 
    
    Ps(:,jj) =  PredictedState; 
    
    [CorrectedState,CorrectedStateCovariance] = correct(KFobj,[x(jj); y(jj); speed(jj)]);  
    
    Cs(:,jj) = CorrectedState; 
end

%%

plot(x);
hold on;
plot(Cs(1,:));
hold on;
plot(Ps(1,:));


%%
[PredictedState,PredictedStateCovariance] = predict(KFobj);

[CorrectedState,CorrectedStateCovariance] = correct(KFobj,[x(3); y(3); speed(3)]);

 