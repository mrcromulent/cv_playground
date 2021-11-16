%% Question 3 Part 1

descriptions = ["centerlight", ...
                "leftlight", ...
                "noglasses", ...
                "normal", ...
                "rightlight", ...
                "sad", ...
                "sleepy", ...
                "surprised", ...
                "wink"];

%Collect all the points into a big matrix, Gamma
[Gamma, imRows, imCols, idxArrTrain] = CreatePCAMatrix("data/Yale-FaceA/trainingset/", 15, descriptions, true);

%% Part 2:

%Find and display the mean face
mu = mean(Gamma, 2);
muFace = uint8(255*reshape(mu, [imRows, imCols]));
figure("Visible", "off"); axes("Visible","off");
imshow(muFace);

%Find the eigenvalues and eigenvectors for a subspace
A = Gamma - repmat(mu, [1, size(Gamma,2)]);
L = (A')*A;
[eigVecs, ~] = eig(L);

%Rotate the eigenvector matrices of the subspace so the 
%largest values come first
eigVecs = rot90(eigVecs,2);

%Extend this to the eigenvectors of the whole space
eigVecsU = A * eigVecs;

%% Part 3

%Set the number of eigenfaces to use
topK = 10;

for k = 1:topK

    %Find the kth Eigenface
    kthEigFace = eigVecsU(:,k) + mu;

    %Renormalise it and convert to uint8 for display
    kthEigFace = kthEigFace/max(kthEigFace);
    kthEigFace = uint8(255*reshape(kthEigFace, [imRows, imCols]));

    %Display and save
    figure("Visible", "off"); axes("Visible","off");
    imshow(kthEigFace);

end

%% Part 4

descriptions = ["glasses", ...
    "happy", ...
    "happy", ...
    "glasses", ...
    "happy", ...
    "happy", ...
    "glasses", ...
    "happy", ...
    "happy", ...
    "happy"];

%Create a new big matrix, GammaTest, containing vectors of the 10 test images
[GammaTest, ~, ~, idxArrTest] = CreatePCAMatrix("data/Yale-FaceA/testset/", 10, descriptions, false);

%Create a new matrix of vectors which are the difference from the mean
%vector
ATest = GammaTest - repmat(mu, [1, size(GammaTest,2)]);

%Find the projection onto the eigenface basis
weights = zeros(10,topK);

%For each test subject...
for testSub = 1:10

    for k = 1:topK
        weights(testSub,k) = dot(ATest(:,testSub),eigVecsU(:,k)) ./ dot(eigVecsU(:,k), eigVecsU(:,k));
    end

    %Find the 3 nearest neighbours to testSub in the training set (A)
    [idx, ~] = knnsearch(A', ATest(:,testSub)', "k", 3);

    %Display the 3 nearest neighbours
    figure("Visible", "off"); axes("Visible","off");
    subplot(1,4,1);
    im = imread(idxArrTest{testSub});
    imshow(im);
    title("Test Subject");

    subplot(1,4,2);
    im = imread(idxArrTrain{idx(1)});
    imshow(im);
    title("Closest Match");

    subplot(1,4,3);
    im = imread(idxArrTrain{idx(2)});
    imshow(im);
    title("Second Closest");

    subplot(1,4,4);
    im = imread(idxArrTrain{idx(3)});
    imshow(im);
    title("Third Closest");

end

%% Part 5

descriptions = ["glasses", ...
    "happy", ...
    "happy", ...
    "glasses", ...
    "happy", ...
    "happy", ...
    "glasses", ...
    "happy", ...
    "happy", ...
    "happy", ...
    "happy"];

%Create a new big matrix containing vectors of the 11 test images
%(including mine)
[GammaTest, ~, ~, idxArrTest] = CreatePCAMatrix("data/Yale-FaceA/testset/", 11, descriptions, false);

%Create a new matrix of vectors which are the difference from the mean
%vector
ATest = GammaTest - repmat(mu, [1, size(GammaTest,2)]);

%Find the projection onto the eigenface basis
weights = zeros(1,topK);

%Test subject 11 is me
for testSub = 11

    for k = 1:topK
        weights(testSub,k) = dot(ATest(:,testSub),eigVecsU(:,k)) ./ dot(eigVecsU(:,k), eigVecsU(:,k));
    end

    %Find the 3 nearest nearest neighbours in the training set (A)
    [idx, ~] = knnsearch(A', ATest(:,testSub)', "k", 3);

    %Display the 3 nearest neighbours
    figure("Visible", "off"); axes("Visible","off");
    subplot(1,4,1);
    im = imread(idxArrTest{testSub});
    imshow(im);
    title("Test Subject");

    subplot(1,4,2);
    im = imread(idxArrTrain{idx(1)});
    imshow(im);
    title("Closest Match");

    subplot(1,4,3);
    im = imread(idxArrTrain{idx(2)});
    imshow(im);
    title("Second Closest");

    subplot(1,4,4);
    im = imread(idxArrTrain{idx(3)});
    imshow(im);
    title("Third Closest");

end

%% Part 6

descriptions = ["centerlight", ...
                "leftlight", ...
                "noglasses", ...
                "normal", ...
                "rightlight", ...
                "sad", ...
                "sleepy", ...
                "surprised", ...
                "wink"];

%Collect all the points into a big matrix, Gamma
[Gamma, ~, ~, idxArrLarger] = CreatePCAMatrix("data/Yale-FaceA/trainingset/", 16, descriptions, true);


%Find the mean face
mu = mean(Gamma, 2);

%Create a new matrix of vectors which are the difference from the mean
%vector
A = Gamma - repmat(mu, [1, size(Gamma,2)]);

%Find the three nearest neighbours to testSub = 11 (me) with these new
%images in the training set
[idx, ~] = knnsearch(A', ATest(:,testSub)', "k", 3);

%Display the results
figure("Visible", "off"); axes("Visible","off");
subplot(1,4,1);
im = imread(idxArrTest{testSub});
imshow(im);
title("Test Subject");

subplot(1,4,2);
im = imread(idxArrLarger{idx(1)});
imshow(im);
title("Closest Match");

subplot(1,4,3);
im = imread(idxArrLarger{idx(2)});
imshow(im);
title("Second Closest");

subplot(1,4,4);
im = imread(idxArrLarger{idx(3)});
imshow(im);
title("Third Closest");