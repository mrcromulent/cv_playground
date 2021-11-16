function [X] = ConvertToPoints(im)
% ConvertToPoints This function takes an RGB image and converts it into a
% matrix of size 5 x numel(im), X. The first three rows of X are the
% pixel's values in the LAB colour space and the last two rows are its row
% and column coordinates

%Convert to LAB colour space
imLab = rgb2lab(im);
lStar = imLab(:,:,1);
aStar = imLab(:,:,2);
bStar = imLab(:,:,3);

%Initialise X
X = NaN(5, numel(lStar));
[nRows, nCols] = size(lStar);

%Loop over the rows of imLab, assigning the pixel values to X
matrixIdx = 1;

for row = 1:nRows

X(1, matrixIdx:(matrixIdx+nCols-1)) = lStar(row, :);
X(2, matrixIdx:(matrixIdx+nCols-1)) = aStar(row, :);
X(3, matrixIdx:(matrixIdx+nCols-1)) = bStar(row, :);
X(4, matrixIdx:(matrixIdx+nCols-1)) = (1:nCols)/nCols;
X(5, matrixIdx:(matrixIdx+nCols-1)) = row/nRows;

matrixIdx = matrixIdx + nCols;
end

%Convert X to a double and return it
X = im2double(X);

end
