%% part1_2.m
%
% number 2 for part 1 of homework 1
%
% - written by: Dimitri Lezcano

%% File to read in
vol = analyze75read('KKI2009-01-MPRAGE_stripped.hdr');

%% (a) histogram
[counts,bin_edges] = histcounts(vol(:),100);
bin_mids = bin_edges(1:end-1) + (bin_edges(2) - bin_edges(1))*0.5;
fig = figure(1); bar(bin_mids,log(counts))
saveas(fig, 'part1-2a.png');

%% (b) GM and WM
% GM
gm_thresh = 458250
gm_counts = counts(bin_mids == gm_thresh)

% WM
wm_thresh = 881250
wm_counts = counts(bin_mids == wm_thresh)

%% (c) GM and WM mask
gm_mask = abs(vol - gm_thresh) < 5e4;
wm_mask = abs(vol - wm_thresh) < 5e4;

% mask out the images
vol_gm = 1*gm_mask;

vol_wm = 1*wm_mask;

% plot the masks: GM
% plot an axial (constant z) slice
fig_gm = figure(2)
subplot(1,2,1);
imagesc(flipud(vol_gm(:,:,155))) % z = 155, flip so head facing up
title('axial slice')
colormap gray
axis image
axis off

% plot an sagittal (constant y) slice
subplot(1,2,2);
I = squeeze(vol_gm(:,60,:));  % y = 60
I = rot90(I);
imagesc(I);
title('sagittal slice')
colormap gray
axis image
sgtitle('Gray Matter mask');

% plot the masks: WM
% plot the masks: GM
% plot an axial (constant z) slice
fig_wm = figure(3)
subplot(1,2,1);
imagesc(flipud(vol_wm(:,:,155))) % z = 155, flip so head facing up
title('axial slice')
colormap gray
axis image
axis off

% plot an sagittal (constant y) slice
subplot(1,2,2);
I = squeeze(vol_wm(:,60,:));  % y = 60
I = rot90(I);
imagesc(I);
title('sagittal slice')
colormap gray
axis image
sgtitle('White Matter mask');

saveas(fig_gm, 'part1_2c-gray.png');
saveas(fig_wm, 'part1_2c-white.png');

%% (d) GM and WM voxel count
gm_count = sum(gm_mask, 'all')
wm_count = sum(wm_mask, 'all')

fid = fopen('part1_2d.txt', 'w');
fprintf(fid, 'gray matter voxel count: %f', gm_count);
fprintf(fid, '\nwhite matter voxel count: %f', wm_count);
fclose(fid);
