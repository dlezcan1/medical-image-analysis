%% train_unet.m
%
% script to train a unet network
%
% - written by: Dimitri Lezcano

%% Set-up
% training options
initialLearningRate = 0.05;
maxEpochs = 150;
minibatchSize = 8;
l2reg = 0.0001;


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

%% training and validation data load
% training and test split
patients = 1:100;
val_patients = [2, 6, 8, 11, 15, 21, 37, 41, 43, 44, 57, 66, 71, 75, 77, 78, 79, 81, 93, 95]; % from randperm(100, 20)
train_patients = patients(all(patients ~= val_patients'));

data_dir = "../data";

% training
train_dir = fullfile(data_dir, 'training');
train_img_ds = imageDatastore(fullfile(train_dir, 'image'), 'IncludeSubfolders', true,...
    'FileExtensions', '.gz', 'LabelSource', 'foldernames', ...
    'ReadFcn', @(x) nifti_imagereader(x, img_size(1:3)));
train_gt_ds = pixelLabelDatastore(fullfile(train_dir, 'label'), ...
        {'background', 'rightVC', 'myocardium', 'leftVC'},...
        [0, 1, 2, 3], 'IncludeSubfolders', true,...
        'FileExtensions', '.gz');
train_gt_ds.ReadFcn = @(f) nifti_gtreader(f, img_size(1:3));

% validation
val_dir = fullfile(data_dir, 'validation');
val_img_ds = imageDatastore(fullfile(val_dir, 'image'), 'IncludeSubfolders', true,...
    'FileExtensions', '.gz', 'LabelSource', 'foldernames', ...
    'ReadFcn', @(x) nifti_imagereader(x, img_size(1:3)));
val_gt_ds = pixelLabelDatastore(fullfile(val_dir, 'label'), ...
        {'background', 'rightVC', 'myocardium', 'leftVC'},...
        [0, 1, 2, 3], 'IncludeSubfolders', true,...
        'FileExtensions', '.gz');
val_gt_ds.ReadFcn = @(f) nifti_gtreader(f, img_size(1:3));

% total datastore
train_total_ds = pixelLabelImageDatastore(train_img_ds, train_gt_ds);
val_total_ds = pixelLabelImageDatastore(val_img_ds, val_gt_ds);
val_total_ds.MiniBatchSize = minibatchSize;

% value jitter training dataset
train_tf_ds = transform(train_total_ds, @(x) img3d_aug_jitter(x, 5), 'IncludeInfo', false);
train_tf_ds.UnderlyingDatastore.MiniBatchSize = minibatchSize;

%% Train the network
% training options
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
    'VerboseFrequency',20, ...
    'ValidationData',val_total_ds, ...
    'ValidationFrequency',400,...
    'ExecutionEnvironment', 'gpu');

% training
modelDateTime = string(datetime('now','Format',"yyyy-MM-dd-HH-mm-ss"));
[net_train,info] = trainNetwork(train_tf_ds,net,options);
save(fullfile('../models', strcat("trained3DUNet-",modelDateTime,"-Epoch-",num2str(options.MaxEpochs),".mat")),'net_train');
