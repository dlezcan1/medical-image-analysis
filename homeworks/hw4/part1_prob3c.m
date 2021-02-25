%% part1_prob3c.m
%
% this is to answer the active contour overlap question
%
% - written by: Dimitri Lezcano


%% 
function part1_prob3c
    %% Draw the circle image
    img = zeros(400, 'uint8');
    
    [J, I] = meshgrid(1:length(img), 1:length(img)); % get the indices
    
    R = size(img, 1)/4.2; % radius of the circle
    
    overlap = 0;
    center = size(img, [1,2])/2; % put circle in the center
    center1 = center - [R - overlap, 0];
    center2 = center + [R - overlap, 0];
    
    dist1 = vecnorm(center1 - [I(:), J(:)], 2, 2);
    dist2 = vecnorm(center2 - [I(:), J(:)], 2, 2);
    
    img = uint8(255*reshape(dist1 <= R | dist2 <= R, size(img)));

    
    %% Perform active contour (stock MATLAB method)
    bw = activecontour(img, img > 0, 'edge', 'SmoothFactor', 1, 'ContractionBias', -1);
    
    
    %% Show the results
    imshow(img); hold on;
    visboundaries(bw, 'Color', 'r'); hold off;

end