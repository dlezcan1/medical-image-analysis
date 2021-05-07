%% unet_segmentation

function unet_segmentation
    %% Set-up
    % saving parameters
    patient_base = "patient%03d";
    ed_base = patient_base + "_ED.nii.gz";
    es_base = patient_base + "_ES.nii.gz";
    frame_base = patient_base + "_frame%02d.nii.gz";
    info_file = "Info.cfg";
    
%     % Load UNet
%     unet_train = load('../models/trained3DUNet-deeper-2021-04-26-12-31-54-Epoch-250.mat').net_train;
    imgreader = @(file) nifti_imagereader(file, unet_train.Layers(1).InputSize(1:3));

    % Data and output directories
    data_dir = "../data/testing/";
    out_dir = fullfile(data_dir, 'prediction');
    
    if ~isfolder(out_dir) % make output directory if not already
        mkdir(out_dir);
    end
    
    % Patient data
    patient_data = dir(data_dir + "patient*");
    fprintf("# patients detected: %d\n\n", numel(patient_data));
    
    %% Iterate over the patients
    for i = 1:numel(patient_data)
        % patient directory parse
        pat_i = fullfile(patient_data(i).folder, patient_data(i).name);
        re_result = regexp(patient_data(i).name, 'patient([0-9]+)', 'tokens');
        if isempty(re_result)
            disp(pat_i + " is not valid formatted");
            continue;
        end
        pat_i_num = str2double(re_result{1}{1});
        
        % patient data files
        pat_i_info = parse_patientinfo(fullfile(pat_i, info_file));
        pat_i_ed_file = fullfile(pat_i, sprintf(frame_base, pat_i_num, pat_i_info.ED));
        pat_i_es_file = fullfile(pat_i, sprintf(frame_base, pat_i_num, pat_i_info.ES));
        pat_i_ed_outfile = fullfile(out_dir, sprintf(ed_base, pat_i_num));
        pat_i_es_outfile = fullfile(out_dir, sprintf(es_base, pat_i_num));
        
        % read in ED and ES files
        pat_i_ed = imgreader(pat_i_ed_file);
        pat_i_es = imgreader(pat_i_es_file);
        pat_i_edes_input = cat(5, pat_i_ed, pat_i_es);
        
        % classify ED and ES image
        pat_i_edes_class = semanticseg(pat_i_edes_input, unet_train);
%         [pat_i_edes_classnum_v, gN] = grp2idx(pat_i_edes_class(:));
%         pat_i_edes_classnum = reshape(pat_i_edes_classnum_v, size(pat_i_edes_class);
        pat_i_edes_classnum = reshape(grp2idx(pat_i_edes_class(:)), size(pat_i_edes_class)) - 1;
        
        % save the output files
        niftiwrite(pat_i_edes_classnum(:,:,:,1), pat_i_ed_outfile);
        disp("Saved niftimage: " + pat_i_ed_outfile);
        
        niftiwrite(pat_i_edes_classnum(:,:,:,2), pat_i_es_outfile);
        disp("Saved niftimage: " + pat_i_es_outfile);
        
        disp(" ");
    end
    
end