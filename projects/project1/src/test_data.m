%% test_data.m
%
% script to see what the data is like
%
% - written by: Dimitri Lezcano

%% Set-up
data_dir = "../data/";
patient_num = 1;

img_maxs = zeros(100, 3);
img_mins = zeros(size(img_maxs));
img_stds = zeros(size(img_maxs));
for patient_num = 1:100
    % patient directory
    patient_dir = data_dir + sprintf("patient%03d/", patient_num);

    % patient files
    patient_filebase    = patient_dir + sprintf("patient%03d_", patient_num);
    
    patient_f_info      = patient_dir + "Info.cfg";
    
    patient_f_4d        = patient_filebase + "4d.nii.gz";

    patient_f_fnums     = ls(patient_filebase + "frame??.nii.gz"); % all frame numbers
    
    patient_f_f1 = patient_dir + strip(patient_f_fnums(1,:));
    patient_f_f1_gt = strrep(patient_f_f1, '.nii.gz', '_gt.nii.gz');
    
    patient_f_f2    = patient_dir + strip(patient_f_fnums(2,:));
    patient_f_f2_gt = strrep(patient_f_f2, '.nii.gz', '_gt.nii.gz');

    %% Load in each of the images
    patient_4d    = uint8(niftiread(patient_f_4d));
    patient_f1    = uint8(niftiread(patient_f_f1));
    patient_f1_gt = uint8(niftiread(patient_f_f1_gt));
    patient_f2    = uint8(niftiread(patient_f_f2));
    patient_f2_gt = uint8(niftiread(patient_f_f2_gt));
    
    %% Check the maximum and minimum
    img_maxs(patient_num, 1) = max(patient_4d, [], 'all');
    img_maxs(patient_num, 2) = max(patient_f1, [], 'all');
    img_maxs(patient_num, 3) = max(patient_f2, [], 'all');
    
    img_mins(patient_num, 1) = min(patient_4d, [], 'all');
    img_mins(patient_num, 2) = min(patient_f1, [], 'all');
    img_mins(patient_num, 3) = min(patient_f2, [], 'all');
    
    img_stds(patient_num, 1) = std(double(patient_4d), 0, 'all');
    img_stds(patient_num, 2) = std(double(patient_f1), 0, 'all');
    img_stds(patient_num, 3) = std(double(patient_f2), 0, 'all');
end

img_maxs = array2table(img_maxs, 'VariableNames', {'4d', 'f01', 'f12'});
img_mins = array2table(img_mins, 'VariableNames', {'4d', 'f01', 'f12'});
img_stds = array2table(img_stds, 'VariableNames', {'4d', 'f01', 'f12'});

%%
disp('max');
summary(img_maxs)
disp('min');
summary(img_mins)
disp('std');
summary(img_stds)