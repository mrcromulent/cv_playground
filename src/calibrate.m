function C = calibrate(im, XYZ, uv)
%% TASK 2: CALIBRATE
%
% Function to perform camera calibration
%
% Usage:   C = calibrate(image, XYZ, uv)
%
%   Where:   image - is the image of the calibration target.
%            XYZ - is a N x 3 array of  XYZ coordinates
%                  of the calibration target points. 
%            uv  - is a N x 2 array of the image coordinates
%                  of the calibration target points.
%            C   - is the 3 x 4 camera calibration matrix.
%  The variable N should be an integer greater than or equal to 6.
%
%  This function plots the uv coordinates onto the image of the calibration
%  target. 
%
%  It also projects the XYZ coordinates back into image coordinates using
%  the calibration matrix and plots these points too as 
%  a visual check on the accuracy of the calibration process.
%
%  Lines from the origin to the vanishing points in the X, Y and Z
%  directions are overlaid on the image. 
%
%  The mean squared error between the positions of the uv coordinates 
%  and the projected XYZ coordinates is also reported.
%
%  The function should also report the error in satisfying the 
%  camera calibration matrix constraints.

N = size(XYZ, 1); %Number of points
A = [];

%% Normalise the image and world points 
uvn = NormalisePoints("image", uv);
XYZn = NormalisePoints("world", XYZ);

%% Apply DLT

for i = 1:N
    
    %Construct Ai
    Zs = zeros(1,4);
    
    xi = uvn(i, 1);
    yi = uvn(i, 2);
    wi = 1;
    
    X = XYZn(i, 1);
    Y = XYZn(i, 2);
    Z = XYZn(i, 3);
    Xs = [X, Y, Z, 1];
    
    %Ai
    Ai = [Zs, -wi * Xs, yi * Xs;
          wi * Xs, Zs, -xi * Xs];
    
    %Append to A
    A = [A; Ai];
    
end

%Find C from the last column of the SVD of A
[~, ~, V] = svd(A);
ctilde = V(:, end);

%Normalise c and reshape to extract C-tilde
ctilde = ctilde / norm(ctilde);
CTilde = reshape(ctilde, [4,3])';

%% Denormalise to find C

C = DeNormaliseP(CTilde, XYZ);

%% Transform World coordinate points to image coordinates

XYZ1 = [XYZ, ones(length(XYZ), 1)];
tformPoints = NaN(N,3);

for i = 1:length(XYZ)
    %Transform
    tformPoints(i,:) = C * XYZ1(i,:)';
    
    %Express in homogeneous form
    tformPoints(i,:) = tformPoints(i,:)/tformPoints(i,3);
    
end

%% Plot Results

%Plot the points in image and world coordinates

%Image points
figure(); imshow(im, []); hold on;
plot(uv(:,1), uv(:,2), "r+");

%Transformed world points
plot(tformPoints(:,1), tformPoints(:,2), "b+")

%Display the Mean-Square Pixel Error
xySquareError = sum((uv - tformPoints(:,1:2)).^2,2);
meanSquareError = mean(xySquareError,1);

disp(strjoin(["The mean-square pixel error is:", num2str(meanSquareError), "px"]));

%Plot the vanishing lines
PlotVanishingLines(uv)
title(strjoin(["Image and transformed world points. MeanSquareError =", num2str(meanSquareError), "px"]));
f = get(gca, "Children");
legend([f(5), f(4), f(3), f(2), f(1)], ...
    {'Image points', 'Transformed World points',...
     'X vanishing point', ...
     'Y vanishing point', ...
     'Z vanishing point'},...
     'Location', 'SouthEast')

end


function [normPts] = NormalisePoints(type, pts)
%NormalisePoints This function normalises world or image coordinates using
%the Tnorm and Snorm matrices given in the lecture notes

normPts = NaN;

if strcmp(type, "image")
    
    %If image points, normalise with Tnorm
    uv1 = [pts, ones(length(pts), 1)];
    uv1 = uv1';
    
    Tnorm = GetTNorm();             
    uv1t = Tnorm * uv1;
    normPts = uv1t';
    
elseif strcmp(type, "world")
    
    %If world points, normalise with Snorm
    XYZ1 = [pts, ones(length(pts), 1)];
    XYZ1 = XYZ1';
    
    Snorm = GetSNorm(pts);
    XYZ1t = Snorm * XYZ1;
    normPts = XYZ1t';
    
end

end

function [P] = DeNormaliseP(PTilde, X)
%DeNormaliseP This function takes the projection matrix PTilde in
%normalised image and world coordinates and denormalises it to the
%projection matrix P

%Find Tnorm and Snorm
Tnorm = GetTNorm();
Snorm = GetSNorm(X);

%Denormalise P, ensuring its last element is 1
P = inv(Tnorm) * PTilde * Snorm;
P = P/P(3,4);


end

function [Tnorm] = GetTNorm()
%GetTNorm This function returns the normalisation matrix Tnorm
    
    %Image width and height
    w = 768;
    h = 576;
    
    Tnorm = inv(    [w + h,   0  , w/2;
                       0  , w + h, h/2;
                       0  ,   0  ,  1 ]);

end


function [Snorm] = GetSNorm(X)
%GetSNorm This function constructs the normalisation matrix SNorm

%Mean point value in world coordinates
mu = mean(X, 1)';

%Construct the S matrix, whose eigenvaluse we will extract
S = 0;
for i = 1:length(X)
    S = S + ...
        (X(i,:)' - mu) * (X(i,:)' - mu)';
end

%Extract the eigenvalues/eigenvectors and use these to build Snorm
[V,D,Vinv] = eig(S);
Dinv = diag([1/D(1,1), 1/D(2,2), 1/D(3,3)]);

Snorm = [V*Dinv*Vinv, -V*Dinv*Vinv*mu;
         zeros(1,3) ,        1      ];

end


function [] = PlotVanishingLines(uv)
%PlotVanishingLines This function plots the vanishing lines as they appear
%on the frame using polyfit. It joint points on the XY, YZ and ZX planes to
%construct lines which will meet at the vanishing points

%% X

PlotFromPoints(uv, [5, 6], [7, 8], "b");

%% Y
PlotFromPoints(uv, [1, 4], [2, 3], "r");

%% Z

PlotFromPoints(uv, [9, 10], [11, 12], "k");

%% Plotting function
function [] = PlotFromPoints(uv, idx1, idx2, col)
    
    xBounds = [1,8000];
    
    p1 = uv(idx1(1), :);
    p2 = uv(idx1(2), :);
    p3 = uv(idx2(1), :);
    p4 = uv(idx2(2), :);
    
    fit1 = polyfit([p1(1), p2(1)], [p1(2), p2(2)], 1);
%     model1 = polyval(fit1, xBounds);
%     line1 = plot(xBounds, model1, col, "LineWidth",2);
%     line1.Color(4) = 0.1;
    
    fit2 = polyfit([p3(1), p4(1)], [p3(2), p4(2)], 1);
%     model2 = polyval(fit2, xBounds);
%     line2 = plot(xBounds, model2, col, "LineWidth",2);
%     line2.Color(4) = 0.1;
    
    m1 = fit1(1); b1 = fit1(2);
    m2 = fit2(1); b2 = fit2(2);
    
    xint = (b2 - b1)/(m1 - m2); yint = m1 * xint + b1;
    xcen = 323; ycen = 332;
    
    vanLine = plot([xcen, xint], [ycen, yint], "LineWidth", 3);
    vanLine.Color(4) = 0.6;

end

end