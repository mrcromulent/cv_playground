% CLAB3 

%% Setup
clearvars();
close all;

%Decide whether to recompute points from image
computePointsFromPhoto = false;

if computePointsFromPhoto
    
    %Import image
    im1 = imread("data/stereo2012a.jpg");
        
    %Points in image coordinates
    figure(); imshow(im1);
    [u1, v1] = ginput(12); 
    
    %Points in world coordinate frame
    X = 7 * [0; 0; 0; 0; 1; 3; 3; 1; 1; 1; 3; 3];
    Y = 7 * [6; 6; 1; 1; 6; 6; 1; 1; 0; 0; 0; 0];
    Z = 7 * [3; 1; 1; 3; 0; 0; 0; 0; 3; 1; 1; 3];
    XYZ = [X, Y, Z];
    
    %Save data
    save("data/mydata.mat", "im1", "u1", "v1",  "XYZ");
    close all;
    
else
    
    %If not computing new points, load old ones
    load("data/mydata.mat", "im1", "u1", "v1",  "XYZ");
    
end

%% Extract data from save file

uv1 = [u1, v1];

%% Calibrate the camera

C = calibrate(im1, XYZ, uv1);

%% Extract the camera intrinsics
[K, R, t] = vgg_KR_from_P(C, []);

%% Find the focal length and pitch angle

%Convert K to homogeneous representation
K = K/K(3,3);

%Find the focal lengths
fx = K(1,1);
fy = K(2,2);

%Find the pitch
pitch = atan2d(R(2,1), R(1,1));
