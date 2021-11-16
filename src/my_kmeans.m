function [groups, numIters] = my_kmeans(X, k, method, useXY)

% X should be 5 x N where N is the number of pixels in the original image
% k is the number of clusters
% method is "random" or "kmpp"
% useXY is a bool
% groups is a vector of cluster numbers
% numIters is the number of iterations of the while loop


if ~useXY
    X = X(1:3,:); 
end


%% STEP 1: Set initial groups for all points

if strcmp(method, "kmpp")
    groups = kmpp(X, k);
elseif strcmp(method, "random")
    groups = RndInit(X, k);
else
    error("Unknown method specified!");
end

n = numel(groups);
prevGroups = zeros(1,n);
numIters = 1;

while any(groups ~= prevGroups)
    
    %Remove any empty clusters
    [~,~,prevGroups(:)] = unique(groups);      
    
    %% Step 2: Compute cluster centres
    mu = X * NormaliseX(sparse(1:n, prevGroups, 1), 1); 
    
    %% Step 3: Assign clusters to the nearest cluster centre
    [~, groups] = min(1/2 * dot(mu,mu,1)' - mu'*X ,[] , 1);
    
    numIters = numIters + 1;
end


end

function Y = NormaliseX(X, dim)
%NormaliseX This function normalises the input matrix X along dimension dim

Y = X./sum(X,dim);
end
