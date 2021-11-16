%Images to be clustered
paths = ["data/mandm.png",...
         "data/peppers.png"];

%Perform clustering for all of these k values     
kVals = [4, 6, 8];

%% Q2 Part 2: Varying k and using x,y pixel coordinates

 %For each image...
for i = 1:length(paths)

    %Read and convert the image to 24-bit
    im = imread(paths(i));
    im = im2uint8(im);

    %Convert the image to a set of feature vectors
    X = ConvertToPoints(im);
    [nRows, nCols] = size(im(:,:,1));

    for k = 1:length(kVals)

        %Decide whether or not to use pixel data by passing "true" or
        %"false" as the 4th argument
        [groupsUseXY,~] = my_kmeans(X, kVals(k), "random", true);
        [groupsNotXY,~]  = my_kmeans(X, kVals(k), "random", false);

        %Once groups have been returned, resize to shape of image
        groupsUseXY = reshape(groupsUseXY, [nCols, nRows])';
        groupsNotXY = reshape(groupsNotXY, [nCols, nRows])';

        %Display and export the result
        figure()
        imagesc(groupsUseXY)

        figure()
        imagesc(groupsNotXY)

    end        
end

%% Q2 Part 3: 

%Now we need to repeat this process using the K-means Plus Plus
%algorithm

%For each image...
for i = 1:length(paths)

    %Read and convert the image to 24-bit
    im = imread(paths{i});
    im = im2uint8(im);

    %Convert the image to a set of feature vectors
    X = ConvertToPoints(im);
    [nRows, nCols] = size(im(:,:,1));

    for k = 1:length(kVals)

        %Specify "kmpp" as the initialistion method
        [groupskmpp,~] = my_kmeans(X, kVals(k), "kmpp", false);

        %Reshape to size
        groupskmpp = reshape(groupskmpp, [nCols, nRows])';

        %Display and export the result
        figure()
        imagesc(groupskmpp)

    end        
end