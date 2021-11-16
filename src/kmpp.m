function [groups] = kmpp(X, k)
% kmpp This algorithm applies the k means plus plus initialisation
% algorithm to the set of points X, returning an initial k groupings spaced
% far away from each other

%STEP 1: Choose the first cluster centre randomly (using rand)
n = size(X,2);
Dist = inf(1, n);
mu = X(:,ceil(n*rand));

for i = 2:k
    
    %STEP 2: Compute the distance-squared between each point in X and the
    %existing cluster centre(s)
    Dist = min(Dist,sum((X-mu(:,i-1)).^2,1));
    
    %STEP 3: Randomly select a new cluster centre in X with probability
    %weighted to the distance-squared
    mu(:,i) = X(:,RandomIndexFromDistance(Dist));
end

[~,groups] = min(dot(mu,mu,1)'/2-mu'*X,[],1); 
end

function i = RandomIndexFromDistance(pdf)
%RandomIndexFromDistance This function randomly selects an index i for X
%using a probabilty distribution function, pdf, based on the distance
%squared between existing cluster centres

%Normalise the PDF
nPDF = normalize(pdf);

%Find the first time the cumulative sum is greater than rand, giving a
%random index
i = find(rand<cumsum(nPDF),1);
end