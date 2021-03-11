%% prob2.m
%
% this is a script to handle problem 2 of HW 6
%
% - written by: Dimitri Lezcano

function prob2
    %% Set-up
    patient_num = 1;
    data_dir = "../../projects/project2/data/training/"; % data directory 
    
    % data files
    file_base = data_dir + sprintf("patient%03d/patient%03d", patient_num, patient_num);
    file_t1ce_img = file_base + "_t1ce.nii.gz";
    file_t2_img = file_base + "_t2.nii.gz";
    file_seg_img = file_base + "_seg.nii.gz";
    file_flair_img = file_base + "_flair.nii.gz";
    
    % read in the images
    t1ce_img = niftiread(file_t1ce_img);
    t2_img = niftiread(file_t2_img);
    gt_seg_img = niftiread(file_seg_img);
    flair_img = niftiread(file_flair_img);
    
    %% Part 1
    tumor_mask = ismember(gt_seg_img, [1,2,4]);
    brain_mask = (t2_img > 0) & ~tumor_mask;
    
    
    %% Part 2
    flatten = @(x) reshape(x, 1, []);
    % tumor masks
    flair_tumor_masked = flatten(flair_img(tumor_mask));
    t1ce_tumor_masked = flatten(t1ce_img(tumor_mask));
    N_tumor = sum(tumor_mask, 'all');
    
    % non-tumor/brain masks
    flair_brain_masked = flatten(flair_img(brain_mask));
    t1ce_brain_masked = flatten(t1ce_img(brain_mask));
    N_brain = sum(brain_mask, 'all');
    
    % select 100 voxels of tumor and brain
    rand
    idx_tumor = randperm(N_tumor, 100);
    idx_brain = randperm(N_brain, 100);
    
    % grab the voxel intensities ([ flair intensity; t1ce intensity ])
    tumor_intensity = [flair_tumor_masked(idx_tumor); t1ce_tumor_masked(idx_tumor)];
    brain_intensity = [flair_brain_masked(idx_brain); t1ce_brain_masked(idx_brain)];
    
    % plot the figure
    fig = figure(1);
    plot(tumor_intensity(1,:), tumor_intensity(2,:), 'r*', 'DisplayName', "tumor"); hold on;
    plot(brain_intensity(1,:), brain_intensity(2,:), 'b*', 'DisplayName', "non-tumor"); hold off;
    xlabel('FLAIR Intensity'); ylabel('T1CE Intensity');
    title("Scatter plot of T1CE Intensity vs. FLAIR Intensity in Brain Scan");
    legend('Location', 'bestoutside')
    axis square; grid on;
    
    % save the figure
    saveas(fig, 'prob2.png');
    disp("Saved figure: 'prob2.png'");
    
    
    
    
end