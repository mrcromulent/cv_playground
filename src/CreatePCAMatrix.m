function [Gamma, imRows, imCols, idxArray] = CreatePCAMatrix(fPath, numSubjects, descriptions, descRepeat)
% CreatePCAMatrix This function reads all the images in the training/test
% sets and creates the matrix of faces, Gamma. It also returns the row and
% column size of the images and an array of filepaths, idxArray.
%   descRepeat determines whether or not to loop over each description
%   (e.g. in the training set)

%Construct the filepath to the images
initPath = strjoin([fPath, "subject", num2str(1, "%02i"), ".", descriptions(1), ".png"], "");
initIm = imread(initPath);
initSize = numel(initIm);
[imRows, imCols] = size(initIm);


if descRepeat
    
    %Initialise Gamma and idxArray
    Gamma = NaN(initSize, numSubjects * length(descriptions));
    idxArray = {};
    
    index = 1;
    for subj = 1:numSubjects
        for desc = 1:length(descriptions)
            
            %Construct the path to the specific image
            path = strjoin([fPath, "subject", num2str(subj, "%02i"), ".", descriptions(desc), ".png"], "");
            
            %Read, resize the image and add it to Gamma
            im = imread(path);
            im = im2double(im);
            rsIm = reshape(im, [numel(im), 1]);
            Gamma(:, index) = rsIm;
            
            %Add the filepath to idxArray
            idxArray{index} = path;
            index = index + 1;
        end
    end
else
    
    %Initialise Gamma and idxArray
    Gamma = NaN(initSize, numSubjects);
    idxArray = {};
    
    
    for subj = 1:numSubjects
        
        %Construct the filepath to each image
        path = strjoin([fPath, "subject", num2str(subj, "%02i"), ".", descriptions(subj), ".png"], "");
        
        %Read, resize the image
        im = imread(path);
        im = im2double(im);
        rsIm = reshape(im, [numel(im), 1]);
        Gamma(:, subj) = rsIm;
        
        %Add the filepath to idxArray
        idxArray{subj} = path;

    end
end





end

