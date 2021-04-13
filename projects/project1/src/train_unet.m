%% train_unet.m
%
% script to train a unet network
%
% - written by: Dimitri Lezcano

%% Set-up
% training options
initialLearningRate = 0.05;
maxEpochs = 150;
minibatchSize = 16;
l2reg = 0.0001;
options = trainingOptions('sgdm',...
    'InitialLearnRate',initialLearningRate, ...
    'Momentum',0.9,...
    'L2Regularization',l2reg,...
    'MaxEpochs',maxEpochs,...
    'MiniBatchSize',minibatchSize,...
    'LearnRateSchedule','piecewise',...    
    'Shuffle','every-epoch',...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.05, ...
    'Plots','training-progress', ...
    'VerboseFrequency',20);

% UNet options
img_size = [216, 256, 16, 1] % pad each image on left and right by 3
% image input size is going to be [216, 256, 16, 1, N] | N is the number of
%    samples
numclasses = 4;
encoder_depth = 2;

% UNet
net = unet3dLayers(img_size, numclasses, 'EncoderDepth', encoder_depth, ...
            'NumFirstEncoderFilters', 16);
        
% - input layer
inputlayer = image3dInputLayer(img_size, 'Normalization', 'zscore',...
                'NormalizationDimension', 'channel', 'Name', net.InputNames{1});
net = replaceLayer(net, net.InputNames{1}, inputlayer);

% - output layer
outputlayer = dicePixelClassificationLayer('Name',net.OutputNames{1});
net = replaceLayer(net, net.OutputNames{1}, outputlayer);

% Saving options
save_dir = "../models/";
savefile_net = "";

%% training data load
data_dir = "../data/training/";
img_ds = imageDatastore(fullfile(data_dir, 'image'), 'IncludeSubfolders', true,...
    'FileExtensions', '.gz', 'LabelSource', 'foldernames', 'ReadFcn', @ nifti_imagereader);
gt_ds = pixelLabelDatastore(fullfile(data_dir, 'label'), ...
        {'background', 'rightVC', 'myocardium', 'leftVC'},...
        [0, 1, 2, 3], 'IncludeSubfolders', true,...
        'FileExtensions', '.gz');
gt_ds.ReadFcn = @ nifti_gtreader;

total_ds = pixelLabelImageDatastore(img_ds, gt_ds);
