%% nifti_gtreader.m
%
% function to read in gt data
%
% - written by: Dimitri Lezcano

function [nii_gt, nii_info] = nifti_gtreader(filename, sizeout)
    arguments
        filename string;
        sizeout (3,1) {mustBeInteger};
    end
    
    nii_info = niftiinfo(filename);
    nii_gt = niftiread(filename);
    
    nii_gt = imresize3(nii_gt, sizeout);
    
end