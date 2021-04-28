%% nifti_gtreader.m
%
% function to read in gt data
%
% - written by: Dimitri Lezcano

function [nii_gt, nii_info] = nifti_gtreader(filename, sizeout, type)
    arguments
        filename string;
        sizeout (3,1) {mustBeInteger};
        type string = 'all';
    end
    
    nii_info = niftiinfo(filename);
    nii_gt = niftiread(filename);
    
    nii_gt = imresize3(nii_gt, sizeout);
    
    if strcmp(type, 'heart')
        nii_gt = uint8(nii_gt > 0);
    
    elseif ~strcmp(type, 'all')
        error('Invalid type: %s', type);
    end
        
    
end