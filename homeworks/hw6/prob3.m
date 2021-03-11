%% prob3.m
%
% this is a script to address problem 3 of HW6
%
% - written by: Dimitri Lezcano

function prob3
    %% Set-up
    data_dir = "../../projects/project2/data/training/"; % data directory 
    data_file = "info.json"; % data file to look for
    
    % locate all of the info files
    info_files = dir(data_dir + "patient*/" + data_file);
    
    %% Gather the data
    % data set-up
    survival = zeros(1, length(info_files));
    age = zeros(size(survival));
    
    % iterate through info_files
    for i = 1:length(info_files)
        file_in = strcat(info_files(i).folder, '\', info_files(i).name);
        data = jsondecode(fileread(file_in));
        survival(i) = data.survival;
        age(i) = data.age;
        
    end

    %% Calculate Correlation coefficient
    R = corrcoef(age, survival);
    fprintf("The correlation between age and survival is:\n  %f\n\n", R(1,2));

end