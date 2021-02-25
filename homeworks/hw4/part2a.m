%% part2a.m
%
% this is a script to answer part 2a of Homework 4
%
% - written by: Dimitri Lezcano

%% Set-Up
% image set-up
img_file = 'chestxray.nii';

%% Part i
img = niftiread(img_file); % image
img_info = niftiinfo(img_file)

dig_res = img_info.PixelDimensions./img_info.ImageSize;
fprintf('Digital Resolution in Pixels/%s: \n', img_info.SpaceUnits);
disp(dig_res);

fig_i = figure(1);
imagesc(img);
colormap('gray'); colorbar;
axis equal;
title('Original Image');
saveas(fig_i, 'results/part2a_i.png');
disp('Saved figure: results/part2a_i.png');

% Answer to i)
% - This image is rotated counter clockwise, thus we need to rotate it clockwise

% rotate 90 degres
img_fixed = rot90(img, -1);
fig_i2 = figure(2);
imagesc(img_fixed); 
colormap('gray'); colorbar;
axis equal;
title('Corrected image');
saveas(fig_i, 'results/part2a_i-fixed.png');
disp('Saved figure: results/part2a_i-fixed.png');

%% Part ii
j_split = round(size(img_fixed, 2)/2);
right_img = img_fixed(:, 1:j_split);
left_img = img_fixed(:, j_split+1:end);

fig_ii = figure(3);
subplot(1,2,1);
imagesc(right_img); colormap('gray');
title('Right Lung');

subplot(1,2,2);
imagesc(left_img); colormap('gray');
title('Left Lung');
colorbar;

saveas(fig_ii, 'results/part2a_ii.png');
disp('Saved figure: results/part2a_ii.png');

%% Part iii
right_adj_img = imadjust(right_img, [], [], 2.2);

% segment out the lung
mask = right_adj_img < 50 & right_adj_img > 15; 
cc = bwconncomp(mask, 8);
[~, sort_idx] = sort(cellfun(@length, cc.PixelIdxList), 'descend');
keep_pxs = cc.PixelIdxList{sort_idx(1)}; % keep the largest connected component

segment = zeros(size(right_adj_img));
segment(keep_pxs) = 1;
segment = bwmorph(segment, 'majority', Inf);
segment = imfill(segment, 'holes');
segment = imerode(segment, ones(5));


% show the images
fig_iii = figure(4);
imagesc(right_adj_img); colormap('gray'); hold on;
M = contour(segment,'r'); hold off;
axis equal;
title('Right breast Segmentation');
saveas(fig_iii, 'results/part2a_iii.png');
disp('Saved figure: results/part2a_iii.png');

% parse the contour matrix into a set of points
N = M(2,1);
x0 = M(1,2:N+1);
y0 = M(2,2:N+1);

