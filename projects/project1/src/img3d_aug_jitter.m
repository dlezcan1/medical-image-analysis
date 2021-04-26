%% img3d_aug_jitter.m
% 
% this is a function for data augmentation of image jitter
%
% - written by: Dimitri Lezcano

function data_out = img3d_aug_jitter(data_in, mag, prob)
    arguments
        data_in;
        mag double {mustBePositive} = 10;
        prob double = 0.5;
    end
    
    data_out = data_in;
    
    % random augmentation
    r = rand();
    if r > prob
        for i = 1:length(data_in.inputImage)
            max_img = max(data_in.inputImage{i}, [], 'all');

            img_out = data_in.inputImage{i} + mag*randn(size(data_in.inputImage{i}));
            img_out(img_out > max_img) = max_img; % ceiling
            img_out(img_out < 0) = 0;

            % return value
            data_out.inputImage{i} = img_out;
            data_out.pixelLabelImage{i} = data_in.pixelLabelImage{i};
        end
    end

end