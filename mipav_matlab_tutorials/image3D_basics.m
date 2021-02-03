% Introduction to basic commands for 3D data
% Medical Image Analysis (520.433)
% Andrew Lang
% 1/29/2014
%%%%%%%%
clc
clearvars
close all

%% Read and show 3d volume data (img/hdr data)
% if you have 3d data with other format, e.g. nii, raw, you can always open
% it in MIPAV and save as img format
Vol = analyze75read('data/KKI2009-01-MPRAGE_stripped.img'); % read image
% Info = analyze75info('KKI2009-01-MPRAGE_stripped.img'); % read header info in case you need it
Vol = Vol/max(Vol(:)); % adjust the intensity to [0,1]

% [N,X] = hist(Vol(:),100);
% figure; bar(X,log(N))

[counts,bin_edges] = histcounts(Vol(:),100);
bin_mids = bin_edges(1:end-1) + (bin_edges(2) - bin_edges(1))*0.5;
figure; bar(bin_mids,log(counts))

u = mean(Vol(:));
sigma2 = var(Vol(:));

% Technically you can use a movie player to look through slices of the
% data, not recommended though

%implay(Vol)
%%
% View a montage of the data
% Note that our 3D data has dimensions MxNxP, montage requires MxNx1xP, so
%   we use the permute function to change it
Vol_p = permute(Vol,[1 2 4 3]);
figure, montage(Vol_p,'Indices',100:5:180)

pause

% plot an axial (constant z) slice
figure
imagesc(flipud(Vol(:,:,155))) % z = 155, flip so head facing up
colormap gray
colorbar 
axis image
axis off
pause

% plot an sagittal (constant y) slice
figure
I = squeeze(Vol(:,60,:));  % y = 60
I = rot90(I);
imagesc(I);
colormap gray
axis image

%% read and show triangular surface
Mesh = readvtk('data/KKI2009-01-MPRAGE_centralSurface.vtk');
%Mesh % triangular mesh structure

tri = Mesh.TriVtxIds'; % triangularization
X = Mesh.VtxCoords(1,:); % vertex x coordinate
Y = Mesh.VtxCoords(2,:); % vertex y coordinate
Z = Mesh.VtxCoords(3,:); % vertex z coordinate

figure
h = trisurf(tri, X, Y, Z, 1); % triangular surface plot
material shiny
colormap(gray); caxis([0 1])
alpha(1); % opacity
set(h, 'EdgeColor', 'none') % don't display triangle edges
camlight left; lighting flat
axis equal