%% nifti_imagereader.m 
%
% this is a function to read the each 3D nii image custom
%
% - written by: Dimitri Lezcano

function [nii_img, nii_info] = nifti_imagereader(filename, sizeout, norm_method)
    arguments
        filename string;
        sizeout (3,1) {mustBeInteger};
        norm_method string = 'none';
    end
    nii_info = niftiinfo(filename);
    nii_img = niftiread(filename);
    if strcmp(norm_method, 'over-all')
        nii_img = uint8(nii_img);
        nii_img = double(nii_img) / 255;
    elseif strcmp(norm_method, 'individual')
        nii_img = double(nii_img)/double(max(nii_img, [], 'all'));
    else
        nii_img = double(nii_img);
    end
    
    % pad nifti 3D image
%     nii_img = padarray(nii_img, [0, 0, 0]); % [216, 256, 16]
    nii_img = imresize3(nii_img, sizeout);
   
    
end