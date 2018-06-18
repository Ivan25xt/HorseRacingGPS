function [zone, h, x, y, convergence, scale] = Gps2UtmConvert(long,lat)  
%
% Gps2UtmConvert 
% Ivan Rajkovic 2018
% University of Southampton
%
% UTM / WGS-84 Conversion Functions                                  
% (c) Chris Veness 2014-2017 
% MIT Licence 
%
% Equations based on Karney 2011 ‘Transverse Mercator with an accuracy of a few nanometers’,
% building on Krüger 1912 ‘Konforme Abbildung des Erdellipsoids in der Ebene’.
%

%%
    zone = floor((long +180)/6) + 1; % longitudinal zone
    Lambda0 = deg2rad((zone-1)*6 - 180 + 3); % longitude of central meridian

    vectorLength = length(lat); 
    
    phi = deg2rad(lat);      % latitude ± from equator
    Lambda = deg2rad(long) - Lambda0; % longitude ± from central meridian
%%
    
    % WGS 84: 
    a = 6378137; 
    b = 6356752.314245; 
    f = 1/298.257223563;
    
    falseEasting = 500e3; 
    falseNorthing = 10000e3;

    k0 = 0.9996; % UTM scale on the central meridian

    % ---- easting, northing: Karney 2011 Eq 7-14, 29, 35:

    e = sqrt(f*(2-f));      % eccentricity
    n = f / (2 - f);        % 3rd flattening
    
    n2 = n*n; 
    n3 = n*n2;
    n4 = n*n3; 
    n5 = n*n4; 
    n6 = n*n5; % #TODO: compare Horner-form accuracy?

    
    cosLambda = cos(Lambda); 
    sinLambda = sin(Lambda);
    tanLambda = tan(Lambda);

    tau = tan(phi); 
    
    % prime indicates angles on the conformal sphere
    
    sigma = sinh(e*atanh(e*tau./sqrt(1+tau.*tau)));

    tauPrime = tau.*sqrt(1+sigma.*sigma) - sigma.*sqrt(1+tau.*tau);

    xiPrime = atan2(tauPrime, cosLambda); % 4 quadrant atan
    
    xiPrime = repmat(xiPrime,1,6); 
    
    etaPrime = asinh(sinLambda./ sqrt(tauPrime.*tauPrime + cosLambda.*cosLambda));
    etaPrime = repmat(etaPrime,1,6); 
    
    A = a/(1+n) * (1 + 1/4*n2 + 1/64*n4 + 1/256*n6); % 2*pi*A is the circumference of a meridian

    % 6th order Krueger expressions 
    alpha = [1/2*n - 2/3*n2 + 5/16*n3 +   41/180*n4 -     127/288*n5 +      7891/37800*n6;
                   13/48*n2 -  3/5*n3 + 557/1440*n4 +     281/630*n5 - 1983433/1935360*n6;
                            61/240*n3 -  103/140*n4 + 15061/26880*n5 +   167603/181440*n6;
                                    49561/161280*n4 -     179/168*n5 + 6601661/7257600*n6;
                                                      34729/80640*n5 - 3418889/1995840*n6;
                                                                   212378941/319334400*n6];

    j = 1:6;
    j = j';
                                                          
    xi = xiPrime + (sum(alpha.*sin(2*j.*xiPrime').* cosh(2*j.*etaPrime')))'; % #CORRECTED
    
    eta = etaPrime + (sum(alpha.*cos(2*j.*xiPrime').* sinh(2*j.*etaPrime')))';

%%  Easting x and Northing y Karney 2011 Eq 13  
        
    x = k0 * A * eta;
    x = x(:,1);
    y = k0 * A * xi;
    y = y(:,1);

%% Convergence: Karney 2011 Eq 23, 24

    pPrime = 1 + (sum(2*j.*alpha.*cos(2*j.*xiPrime').* cosh(2*j.*etaPrime')))'; %(23) limit to 6 terms summation
    
    qPrime = 0 + (sum(2*j.*alpha.*sin(2*j.*xiPrime').* sinh(2*j.*etaPrime')))'; %(23) limit to 6 terms summation
  
    gammaPrime = atan((tauPrime./sqrt(1+tauPrime.*tauPrime)).*tanLambda); % #CHECKED in Karney 2011 (24)
    gammaSecond = atan2(qPrime, pPrime); % (24) uses atan2 instead of the ratio

    gamma = gammaPrime + gammaSecond;
       
%% scale: Karney 2011 Eq 25 (!) not to be confused with (28)
 
    sinPhi = sin(phi);
    kPrime = sqrt(1 - e*e*sinPhi.*sinPhi).* sqrt(1 + tau.*tau)./ sqrt(tauPrime.*tauPrime + cosLambda.*cosLambda); 
    kSecond = A./ a.* sqrt(pPrime.*pPrime + qPrime.*qPrime); % #CORRECTED

    k = k0 * kPrime.* kSecond;

%%    shift x/y to false origins

    x = x + falseEasting;             % make x relative to false easting
    
    if y < 0 
        y = y + falseNorthing;        % make y in southern hemisphere relative to false northing
    end
        
    % round to reasonable precision
    xrd = round(x,6); % nm precision
    yrd = round(y,6); % nm precision
    
    convergence = round(rad2deg(gamma),9);
    scale = round(k,12);

    h = strings(vectorLength,1); % hemisphere
    h(:) = 'N'; 
    
    h(lat < 0) = 'S'; 
    
end
