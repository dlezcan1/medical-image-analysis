% Introduction to basic image processing commands
% Medical Image Analysis (520.433)
% Andrew Lang
% 1/29/2014
%%%%%%%
% Edit 01-29-2018. Lianrui Zuo

clc  
clearvars
close all

%% Documentation
% doc images % image processing toolbox - contains many useful examples

% It is important to note that MATLAB treats images no differently than
% matrices! All matrix operations can be applied to images (addition,
% multiplication, etc)

%% (1) Read an image
RGBImg = imread('data/remy.png'); % read image
figure, imshow(RGBImg); % show image
title('Original RGB img');

pause % wait for key press

% We rarely use color images in this course, so lets convert to grayscale
GrayImg = rgb2gray(RGBImg);   % convert rgb to gray
GrayImg = im2double(GrayImg); % convert intensity range from [0 255] to [0 1]
% Be careful about 'im2double' and 'double'
figure, imshow(GrayImg);
title('Grayscale img');
%% (2) Different ways to view an image
% 'doc imshow' to learn more
% e.g. imshow(img,'InitialMagnification',200);
% e.g. imshow(img,'DisplayRange',[0,100]);
close all

figure, imshow(GrayImg)
figure, imagesc(GrayImg)
colormap gray
axis off
axis image

pause

% The difference between imshow and imagesc is that imagesc scales the
% colormap to match the range of intensity values in the image, while
% imshow assumes the intensity values are between 0 and 1.

GrayImg2 = GrayImg*0.5; % Scale intensities in half
figure, imshow(GrayImg2), colorbar
figure, imagesc(GrayImg2), colorbar
colormap gray
axis off
axis image
%% (3) Simple image operations
close all
% Show intensity histogram
figure, imhist(GrayImg) 

pause

% Re-scale intensities
AdjustImg = imadjust(GrayImg, [0.2 0.5], [0,1]);
figure, imshow(AdjustImg)

pause

% Filter
h = fspecial('gaussian',10,10); % create Gaussian smoothing mask
SmthImg = imfilter(GrayImg,h,'replicate'); % filter the image
figure; imshow(SmthImg)

pause

% Resize
ResizeImg = imresize(GrayImg, 0.5, 'bilinear'); % resize an image
figure, imshow(ResizeImg)

pause

% Rotate
RotImg = imrotate(GrayImg, 30, 'bilinear'); % rotate an image
figure; imshow(RotImg)
