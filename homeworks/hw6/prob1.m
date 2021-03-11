%% prob1.m
%
% this is a script to process problem 1 of homework 6
%
% - written by: Dimitri Lezcano

function prob1
    % set-up
    patient_nums = 1:100;
    data_dir = "../../projects/project2/data/training/"; % data directory 
    
    % gather all of the mean intensities
    mean_tumor_intensities = zeros(size(patient_nums));
    for i = 1:length(patient_nums)
        mean_tumor_intensities(i) = process_MRdata_t1ce(data_dir, patient_nums(i));
        
        if mod(i, 10) == 0
            fprintf("Progress: %d%%\n", i/length(patient_nums)*100);
        end
        
    end
    
    % plot the histogram
    fig = figure(1);
    hist(mean_tumor_intensities);
    xlabel("Tumor Intensity"); ylabel("Frequency");
    title("Histogram of T1CE Tumor Intensities");
    
    saveas(fig, 'prob1.png');
    disp("Saved figure: 'prob1.png'");
    
    
end
    