%% part1_prob3b.m
%
% this is to answer the active contour question
%
% - written by: Dimitri Lezcano


%% 
function part1_prob3b
    %% Draw the circle image
    img = zeros(400, 'uint8');
    
    [J, I] = meshgrid(1:length(img), 1:length(img)); % get the indices
    
    R = size(img, 1)/4; % radius of the circle
    
    center = size(img, [1,2])/2; % put circle in the center
    
    dist = vecnorm(center - [I(:), J(:)], 2, 2);
    
    img = uint8(255*reshape(dist <= R, size(img)));

    
    %% Perform active contour (stock MATLAB method)
    bw = activecontour(img, img > 0, 'edge');
    
    
    %% Show the results
    imshow(img); hold on;
    visboundaries(bw, 'Color', 'r'); hold off;

end