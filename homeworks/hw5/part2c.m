%% mammoprob3.m
%
% script to run for part 2 of homework 1
%
% - written by: Dimitri Lezcano

%% Options
load_init = true;


%% Load the files
f1 = "mdb015.pgm";
f2 = "mdb016.pgm";

% original images
img1 = imread(f1);
img2 = imread(f2);

% init files
init_file1 = "snake-init_" + strrep(f1, ".pgm", ".csv");
init_file2 = "snake-init_" + strrep(f2, ".pgm", ".csv");

%% (a) determine if right breast or not
[img1a, isright1] = mammostep1(f1);
[img2a, isright2] = mammostep1(f2);

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

%% (c) Canny edge detection
canny_1c = edge(seg1, 'canny');
canny_2c = edge(seg2, 'canny');

%% hw5: part2c - Snake initialization
% file 1
if load_init && (exist(init_file1) > 0)
    X_init = readmatrix(init_file1);
    x1_init = X_init(:,1);
    y1_init = X_init(:,2);
    
else
    figure(1);
    imshow(1 - (canny_1c));
    title(f1);
    [x1_init,y1_init] = ginput();
    [x1_init,y1_init] = snakeinterp(x1_init,y1_init,3,1); % this is for student version
    
    writematrix([x1_init, y1_init], init_file1);
end

% file 2
if load_init && (exist(init_file2) > 0)
    X_init = readmatrix(init_file2);
    x2_init = X_init(:,1);
    y2_init = X_init(:,2);
    
else
    imshow(1 - canny_2c);
    [x2_init,y2_init] = ginput();
    [x2_init,y2_init] = snakeinterp(x2_init,y2_init,3,1);
    title(f2);

    writematrix([x2_init, y2_init], init_file2);
end 
close all;

%% hw5: part 2c - GVF Snake
disp("GVF Snake...");
% file 1
disp("Working on: " + f1);
% - GVF calculation
disp(' Compute GVF ...');
[u,v] = GVF(canny_1c, 0.2, 80); 
disp(' Nomalizing the GVF external force ...');
mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10); 

% - Iterative optimization
x1 = x1_init; y1 = y1_init; % initialization
disp(' Beginning optimization');
for i=1:25
   [x1,y1] = snakedeform(x1,y1,0.05,0,1,2,px,py,5);
   [x1,y1] = snakeinterp(x1,y1,3,1); % this is for student version
   % for professional version, use 
   %   [x,y] = snakeinterp(x,y,2,0.5);  
end
disp(' Completed optimization');
disp(' ');

% file 2
disp("Working on: " + f2);
% - GVF calculation
disp(' Compute GVF ...');
[u,v] = GVF(canny_2c, 0.2, 80); 
disp(' Nomalizing the GVF external force ...');
mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10); 

% - Iterative optimizatition
x2 = x2_init; y2 = y2_init; % initialization
disp(' Beginning optimization');
for i=1:25
   [x2,y2] = snakedeform(x2,y2,0.05,0,1,2,px,py,5);
   [x2,y2] = snakeinterp(x2,y2,3,1); % this is for student version
   % for professional version, use 
   %   [x,y] = snakeinterp(x,y,2,0.5);  
end
disp(' Completed optimization');
disp(' ');

%% hw5: part2c - Traditional Snake
disp("Traditional Snake...");
% file 1
disp("Working on: " + f1);
% - calculate force field
f0 = gaussianBlur(canny_1c,1);
[px,py] = gradient(f0);

% - iterative optimization
x1t = x1_init; y1t = y1_init;
disp(" Beginning optimization");
for i=1:100
       [x1t,y1t] = snakedeform(x1t,y1t,0.05,0,1,4,px,py,5);
       [x1t,y1t] = snakeinterp(x1t,y1t,3,1); % this is for student version
       
end
fprintf(" Completed optimization\n\n");

% file 2
disp("Working on: " + f2);
% - calculate force field
f0 = gaussianBlur(canny_2c,1);
[px,py] = gradient(f0);

% - iterative optimization
x2t = x2_init; y2t = y2_init;
disp(" Beginning optimization");
for i=1:100
       [x2t,y2t] = snakedeform(x2t,y2t,0.05,0,1,4,px,py,5);
       [x2t,y2t] = snakeinterp(x2t,y2t,3,1); % this is for student version
       
end
fprintf(" Completed optimization\n\n");

%% Display results
fig1 = figure(1);
colormap(gray(64)); imshow(canny_1c * 40); axis('square', 'off');
snakedisp(x1,y1,'r');
snakedisp(x1t,y1t,'g');
legend('GVF', 'Traditional', 'Location', 'bestoutside')
title(f1);

fig2 = figure(2);
colormap(gray(64)); imshow(canny_2c * 40); axis('square', 'off');
snakedisp(x2,y2,'r'); hold on;
snakedisp(x2t,y2t, 'g'); hold off;
legend('GVF', 'Traditional', 'Location', 'bestoutside')
title(f2);

saveas(fig1, "prob2c-" + strrep(f1, ".pgm", ".png"));
saveas(fig2, "prob2c-" + strrep(f2, ".pgm", ".png"));

%% Helper functions
% check for boundary passes
function [x, y] = check_boundaries(x, y, im_sz)
    arguments
        x;
        y;
        im_sz (2,1);
    end
    % top-left boundary
    x(x < 1) = 1;
    y(y < 1) = 1;
    
    % bottom-right boundary
    x(x > im_sz(1)) = im_sz(1);
    y(y > im_sz(2)) = im_sz(2);  
    

end