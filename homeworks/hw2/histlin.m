%% histlin.m
%
% this is a function to linearize an image's histogram
%
% - written by: Dimitri Lezcano

%% main function
function J = histlin(I, a, b)
    % arguments block
    arguments
        I (:,:) uint8;
        a double {mustBeNonzero};
        b double;
    end
    
    % prepare histogram edges
    L = 256;
    bin_edges = (0:L) - 0.5 ;
    bin_centers = 1/2 * (bin_edges(1:end-1) + bin_edges(2:end));
    
    % compute histogram
    h = histcounts(I, bin_edges);
    
    % compute the CDF
    cdfh = cumsum(h/sum(h));
        
    % transform the values
    J = zeros(size(I));
    gamma = 1/2*a*(L-1)^2 + b*(L-1);
    for i = 1:length(bin_centers)
        v = bin_centers(i); % the intensity value
        c = cdfh(i); % grab the cdf value
        J(I == v) = sqrt(b^2/a^2 + 2/a*gamma*c) - b/a;
    end
    
    % convert back to an image
    J = uint8(floor(J));

end