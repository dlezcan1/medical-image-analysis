%% mammoprob3.m
%
% script to run for part 2 of homework 1
%
% - written by: Dimitri Lezcano

%% Load the files
f1 = "mdb015.pgm";
f2 = "mdb016.pgm";

% original images
img1 = imread(f1);
img2 = imread(f2);

%% (a) determine if right breast or not
[img1a, isright1] = mammostep1(f1);
[img2a, isright2] = mammostep1(f2);

fig1a = figure(1);
imshow(img1a);
if isright1
    title(f1 + " | Right Breast, flipped");
else
    title(f1 + " | Left Breast");
end

fig2a = figure(2);
imshow(img2a);
if isright2
    title(f2 + " | Right Breast, flipped");
else
    title(f2 + " | Left Breast");
end

% saving
saveas(fig1a, strrep("part2_1a-" + f1, '.pgm', '.png'));
saveas(fig2a, strrep("part2_1a-" + f2, '.pgm', '.png'));


%% (b) Segment out the breasts
seg1 = mammostep2(img1a);
seg2 = mammostep2(img2a);

% color mask
mask1 = uint8(cat(3, zeros(size(seg1,1), size(seg1,2), 2), 255*seg1));
mask2 = uint8(cat(3, zeros(size(seg2,1), size(seg2,2), 2), 255*seg2));

% masked images
img1b_seg = img1a;
img1b_seg(~seg1) = 0;

img2b_seg = img2a;
img2b_seg(~seg2) = 0;

% images to show
img1b = 1/2*repmat(img1a, 1, 1, 3) + 1/2 * mask1;
img2b = 1/2*repmat(img2a, 1, 1, 3) + 1/2 * mask2;

% plot the segmentations
fig1b = figure(3);
imshow(img1b);
if isright1
    title(f1 + " | Right Breast, flipped");
else
    title(f1 + " | Left Breast");
end

fig2b = figure(4);
imshow(img2b);
if isright2
    title(f2 + " | Right Breast, flipped");
else
    title(f2 + " | Left Breast");
end

% saving
saveas(fig1b, strrep("part2_1b-" + f1, '.pgm', '.png'));
saveas(fig2b, strrep("part2_1b-" + f2, '.pgm', '.png'));

%% (c) Canny edge detection
canny_1c = edge(seg1, 'canny');
canny_2c = edge(seg2, 'canny');

% plot the canny edge detaction
fig1c = figure(5);
imshow(canny_1c);
if isright1
    title(f1 + " | Right Breast, flipped");
else
    title(f1 + " | Left Breast");
end

fig2c = figure(6);
imshow(canny_2c);
if isright2
    title(f2 + " | Right Breast, flipped");
else
    title(f2 + " | Left Breast");
end

% saving
saveas(fig1c, strrep("part2_1c-" + f1, '.pgm', '.png'));
saveas(fig2c, strrep("part2_1c-" + f2, '.pgm', '.png'));

%% (d) histogram of canny edge detection
% prepare plot legends
labels = {};
if isright1
    labels{1} = "right | " + f1;
else
    labels{1} = "left | " + f1;
end

if isright2
    labels{2} = "right | " + f2;
else
    labels{2} = "left | " + f2;
end

% plot the image histogram restricted to the breast segmentations
fighist_d = figure(7);
imhist(img1b_seg); hold on;
imhist(img2b_seg); hold off;
legend(labels);


% compare the canny images
figcanny_d = figure(8);
subplot(1,3,1);
imshow(canny_1c);
if isright1
    title(f1 + " | Right Breast, flipped");
else
    title(f1 + " | Left Breast");
end

subplot(1,3,2);
imshow(canny_2c);
if isright2
    title(f2 + " | Right Breast, flipped");
else
    title(f2 + " | Left Breast");
end

subplot(1,3,3);
imshow(abs(canny_1c - canny_2c));
title(sprintf("| canny(%s) - canny(%s) |", f1, f2));


% saving
saveas(fighist_d, 'part2_d-hist.png');
saveas(figcanny_d, 'part2_d-canny.png');
