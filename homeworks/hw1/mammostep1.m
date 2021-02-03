%% mammostep1.m
%
% subroutine for hw1 part 2 a
%
% - written by: Dimitri Lezcano

function [ret_img, isright] = mammostep1(f)

    %% Read in the images
    img = imread(f);
    
    isright = isRightBreast(img);
    
    % flip the right breast
    if isright
        ret_img = flipdim(img, 2);
        
    else
        ret_img = img;
    
    end
    
    
end


%% Helper functions
% function to determine if it is a right breast or not (looks like left in
% image)
function bool_val = isRightBreast(img)
    img_thresh = (img > 50);
    
%     % connected component analysis
%     cc = bwconncomp(img_thresh);
%     [~, idx] = sort(cellfun(@length, cc.PixelIdxList), 'descend');
%     idxs_keep = cc.PixelIdxList{idx(1)};
%     
%     % masked out image
%     img_mask = zeros(size(img_thresh));
%     img_mask(idxs_keep) = 1;
%     
    % calculate the orientation of the image_mask
    res = regionprops(img_thresh, {'Area', 'Orientation'});
    [~, sort_idx] = sort([res.Area], 'descend');
        
    orientation = res(sort_idx(1)).Orientation;
    
    bool_val = orientation > 0; % > 0 means oriented as a right breast
end