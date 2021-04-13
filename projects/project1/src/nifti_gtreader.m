%% nifti_gtreader.m
%
% function to read in gt data
%
% - written by: Dimitri Lezcano

function [nii_gt, nii_info] = nifti_gtreader(filename)
    arguments
        filename string;
    end
    
    nii_info = niftiinfo(filename);
    nii_gt = niftiread(filename);
    
    nii_gt = padarray(nii_gt, [0, 0, 3]);
end