%% process_MRdata_t1ce.m
%
% this is a function for reading MR images and ground truth label volumes from
% the training data from project 2
%
% - written by: Dimitri Lezcano

% Args:
%   - data_dir: string containing the data directory
%   - patient_num: int8 indicating the patient number (1 - 100)
%
% Returns:
%   - Mean intensity of enhancing tumor (label 4)
%   - MR image (t1ce)
%   - ground truth segmentation
%   - t1ce meta information
%   - segmentation meta information

function [mu_I, mr_t1ce_img, mr_seg_img, mr_t1ce_meta, mr_seg_meta] = process_MRdata_t1ce(data_dir, patient_num)
    %% Arguments block
    arguments
        data_dir string;
        patient_num int8 {mustBeLessThan(patient_num, 101), mustBeGreaterThan(patient_num, 0)};
    end
    %% Read in the MR information
    file_base = data_dir + sprintf("patient%03d/patient%03d", patient_num, patient_num);
    file_t1ce = file_base + "_t1ce.nii.gz";
    file_seg = file_base + "_seg.nii.gz";
    
    % read in t1ce
    mr_t1ce_img = niftiread(file_t1ce);
    mr_t1ce_meta = niftiinfo(file_t1ce);
    
    % read in segmentation
    mr_seg_img = niftiread(file_seg);
    mr_seg_meta = niftiinfo(file_seg);
    
    %% Compute mean intensity for tumor
    % mask determination
    tumor_mask = (mr_seg_img == 4);
    
    % mean over the tumor points
    mu_I = mean(mr_t1ce_img(tumor_mask), 'all');
    
    
end