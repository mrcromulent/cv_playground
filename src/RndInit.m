function [groups] = RndInit(X, k)
%   RndInit performs a random initialisation for k-means clustering by picking 
%   k vectors out of X and computing the initial grouping based on those
%   cluster centres

%Pick k vectors using rand
dataLen = size(X,1);
mu = rand(dataLen,k);

%Compute the initial grouping
[~,groups] = min(dot(mu,mu,1)'/2-mu'*X,[],1); 
end