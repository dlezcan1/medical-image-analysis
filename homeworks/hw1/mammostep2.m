%% mammostep2.m
%
% function to process gray-scale image in order to segment out breasts
%
% - written by: Dimitri Lezcano

function segment = mammostep2(img)
    %% Threshold
    img_thresh = (img > 80); % remove the background
    
    %% Connected component analysis
    cc = bwconncomp(img_thresh, 4);
    [~, sort_idx] = sort(cellfun(@length, cc.PixelIdxList), 'descend');
    keep_pxs = cc.PixelIdxList{sort_idx(1)}; % keep the largest connected component
    
    %% Generate the mask
    segment = zeros(size(img));
    
    segment(keep_pxs) = 1;
    
    %% Perform binary closing to fill holes
    segment = bwmorph(segment, 'fill', Inf);
%     segment = bwmorph(segment, 'close', Inf);
    
end