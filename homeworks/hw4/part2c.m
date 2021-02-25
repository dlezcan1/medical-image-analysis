%% part2c.m
%
% REQUIREMENT: INSTALL GVF CODE AND "ADD TO PATH"
%
% this is a script meant to use GVF to segment out the lung from part 2a
% 
% - written by: Dimitri Lezcano

%% Run part2a.m
part2a
close all;

%% Set-Up
% snake interpolate these points
[x0,y0] = snakeinterp(x0,y0,3,1); 

% compute edges
right_edge = edge(right_adj_img, 'canny');

%% GVF
% compute GVF

[u,v] = GVF(right_edge, 0.2, 80); 
disp(' Nomalizing the GVF external force ...');
mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10); 

% run snake
disp('Running GVF Snake');
x_gvf = x0; y_gvf = y0;
for i=1:25
   [x_gvf,y_gvf] = snakedeform(x_gvf,y_gvf,0.05,0,1,0.6,px,py,5);
   [x_gvf,y_gvf] = snakeinterp(x_gvf,y_gvf,3,1);
end
disp(' ');
disp('Finished GVF Snake');
disp(' ');

%% Traditional
% compute gradient
right_img_blur = gaussianBlur(right_edge, 1);
[px,py] = gradient(right_img_blur);

% run snake
x_trad = x0; y_trad = y0;
disp('Running Traditional Snake');
for i=1:100
   [x_trad,y_trad] = snakedeform(x_trad,y_trad,0.05,0,1,0.6,px,py,5);
   [x_trad,y_trad] = snakeinterp(x_trad,y_trad,3,1);
end
disp('Finished Traditional Snake');

%% Plotting
f2c = figure;
imagesc(right_img); colormap('gray'); hold on;
snakedisp(x_gvf, y_gvf, 'r'); hold on;
snakedisp(x_trad, y_trad, 'g--'); hold off;
legend('GVF', 'Traditional');
axis equal;
title('Right Lung Snake Segmentations');
saveas(f2c, 'results/part2c.png');
disp('Saved figure: results/part2c.png');

