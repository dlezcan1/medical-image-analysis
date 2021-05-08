clear all
  
mynet = load('../models/trained3DUNet-deeper-2021-04-26-12-31-54-Epoch-250.mat').net_train;
% mynet = coder.loadDeepLearningNetwork('../models/trained3DUNet-deeper-2021-04-26-12-31-54-Epoch-250.mat');
  
% format longG

%%
for num = 1:100
%reading names:  
    if (length(num2str(num)) == 1)
        STnum = append('0', '0', num2str(num));
    elseif (length(num2str(num)) == 2)
        STnum = append('0', num2str(num));
    else
        STnum = num2str(num);
    end
    

    input_path = strcat('../data/patient',STnum, '/');
    file_name = strcat( 'patient', STnum, '_4d.nii.gz');
    input_path_complete = strcat(input_path,file_name);
    %
    FourDFile = niftiread(input_path_complete);
%%%    
    
    %
    input_path_complete_InfoCfg = strcat(input_path,'Info.cfg');
    file = fscanf(fopen(input_path_complete_InfoCfg), '%s');
    group = split(file,":");
    group = split(group(4),"Height");
    group = char(group(1));
    
    % disease: 
        % 1 = NOR
        % 2 = MINF
        % 3 = DCM
        % 4 = HCM
        % 5 = RV
    if (group(1) == 'N')
        groupnum = 1;
    elseif (group(1) == 'M')
        groupnum = 2;
    elseif (group(1) == 'D')
        groupnum = 3;
    elseif (group(1) == 'H')
        groupnum = 4;
    elseif (group(1) == 'R')
        groupnum = 5;
    end
        
    
%
    %% 

    %calculate the volume at each time point; output = four 1x time_length
    %vector
    
    sizeFor4D = size(FourDFile);
    for i = 1:sizeFor4D(4)
        image_timepoint = FourDFile(:, :, :, i);
        image_timepoint_scaled = imresize3(image_timepoint, [216 256 16]);
%         output = predict(mynet, image_timepoint_scaled);
        output_net = semanticseg(image_timepoint_scaled, mynet);
        output = imresize3(output_net, size(image_timepoint));
        % data for 4 part: LVC, RVC, Myocardium, others (DIMENSIONS ARE OFF)
%             LVC(i) = sum(sum(sum(output(:,:,:,1))));
%             RVC(i) = sum(sum(sum(output(:,:,:,2))));
%             Myocardium(i) = sum(sum(sum(output(:,:,:,3))));
%             others(i) = sum(sum(sum(output(:,:,:,4))));      
            
            % updated form
            LVC(i) = sum(output == 'leftVC', 'all');
            RVC(i) = sum(output == 'rightVC', 'all');
            Myocardium(i) = sum(output == 'myocardium', 'all');
            others(i) = sum(output == 'background');
    end
    % compare between each time point and calculate EF
    % As we are comparing the ratio, assume the distance between each layer
    % is 1; Thus the Volume = Area * 1 = Area
    % LVC
    LVC_EDV = max(LVC);
    LVC_ESV = min(LVC);
    LVC_SV = LVC_EDV - LVC_ESV;
    LVC_EF = LVC_SV / LVC_EDV; 
    LVC_volume = mean(LVC);
    %RVC
    RVC_EDV = max(RVC);
    RVC_ESV = min(RVC);
    RVC_SV = RVC_EDV - RVC_ESV;
    RVC_EF = RVC_SV / RVC_EDV;
    RVC_volume = mean(RVC);
    %Myocardium
    MC_volume = mean(Myocardium);

    patientData = [num, groupnum, LVC_EDV, LVC_ESV, LVC_SV, LVC_EF, LVC_volume, RVC_EDV, RVC_ESV, RVC_SV, RVC_EF, RVC_volume, MC_volume];
TOTALDATA(num,:) = patientData;

end

writematrix(TOTALDATA, '../data/train_val_diagnosis_data.csv');

%% Random sampling and test (90 training, 10 validation)
accuracy = [];
for sampleNum = 1:1000
    % we found         
        % 1 - 20 is NOR
        % 21 - 40 is MINF
        % 41 - 60 is DCM
        % 61 - 80 is HCM
        % 81 - 100 is RV
    validationNum = [];
    rd = (randperm(10));
    validationNum = rd(1:2);
    rd = (randperm(10));
    validationNum = [validationNum, rd(1:2) + 20];
    rd = (randperm(10));
    validationNum = [validationNum, rd(1:2) + 40];
    rd = (randperm(10));
    validationNum = [validationNum, rd(1:2) + 60];
    rd = (randperm(10));
    validationNum = [validationNum, rd(1:2) + 80]; 

    validationNum = sort(validationNum);
    trainingNum = setdiff([1:100],validationNum);

    % training set
    trainingData = [];
    for i = 1:90
        nu = trainingNum(i);
        trainingData(i,:) = TOTALDATA(nu,:);    
    end

    % validation set
    validationData = [];
    for i = 1:10
        nu = validationNum(i);
        validationData(i,:) = TOTALDATA(nu,:);    
    end


        % [LVC_EDV, LVC_ESV, LVC_SV, LVC_EF, LVC_volume, RVC_EDV, RVC_ESV, RVC_SV, RVC_EF, RVC_volume, MC_volume]
    NOR = TOTALDATA(1:18,3:13);
    MINF = TOTALDATA(19:36,3:13);
    DCM = TOTALDATA(37:54,3:13);
    HCM = TOTALDATA(55:72,3:13);
    RV = TOTALDATA(73:90,3:13);



    % [LVC_EDV, LVC_ESV, LVC_SV, LVC_EF, LVC_volume, RVC_EDV, RVC_ESV, RVC_SV, RVC_EF, RVC_volume, MC_volume]
    NOR_stat = mean(NOR);
    NOR_stat(2,:) = std(NOR);

    MINF_stat = mean(MINF);
    MINF_stat(2,:) = std(MINF);

    DCM_stat = mean(DCM);
    DCM_stat(2,:) = std(DCM);

    HCM = TOTALDATA(61:80,3:13);
    HCM_stat = mean(HCM);
    HCM_stat(2,:) = std(HCM);

    RV_stat = mean(RV);
    RV_stat(2,:) = std(RV);

    % validation
    truegr = [];
    predictgr = [];


        sumcor = 0;

    for j = 1:10   
        input = validationData(j,3:13);
            for i = 1:11   
                NOR_score = sumcor + abs(input(i) - NOR_stat(1,i)) / NOR_stat(2,i);
            end

            for i = 1:11   
                MINF_score = sumcor + abs(input(i) - MINF_stat(1,i)) / MINF_stat(2,i);
            end

            for i = 1:11   
                DCM_score = sumcor + abs(input(i) - DCM_stat(1,i)) / DCM_stat(2,i);
            end

            for i = 1:11   
                HCM_score = sumcor + abs(input(i) - HCM_stat(1,i)) / HCM_stat(2,i);
            end

            for i = 1:11   
                RV_score = sumcor + abs(input(i) - RV_stat(1,i)) / RV_stat(2,i);
            end

            score = [NOR_score, MINF_score, DCM_score, HCM_score, RV_score];
            predi = find(score == (min(score)));
            predictgr(length(predictgr) + 1 ) = predi;
            truegr(length(truegr) + 1 ) = validationData(j,2);

                % 1 - 20 is NOR
                % 21 - 40 is MINF
                % 41 - 60 is DCM
                % 61 - 80 is HCM
                % 81 - 100 is RV
    end
    predictgr;
    truegr;
    accuracy(length(accuracy) + 1) = sum(predictgr==truegr);
end
mean(accuracy)/10
%% 
figure
subplot(3,2,1)
plot(TOTALDATA(:,2), TOTALDATA(:,6),'.');
title("Ejection Fraction of the left ventricle")

subplot(3,2,2)
plot(TOTALDATA(:,2), TOTALDATA(:,11),'.');
title("Ejection Fraction of the right ventricle")

subplot(3,2,3)
plot(TOTALDATA(:,2), TOTALDATA(:,3),'.');
title("Diastolic left ventricular volume")
subplot(3,2,4)
plot(TOTALDATA(:,2), TOTALDATA(:,13),'.');
title("Myocardial volume")

plot(TOTALDATA(:,2), TOTALDATA(:,3),'.');
title("Diastolic left ventricular volume")
subplot(3,2,5)
plot(TOTALDATA(:,2), TOTALDATA(:,12),'.');
title(" right ventricle volume")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% random forest




%% testing data
for num = 1:50
%reading names:  
    if (length(num2str(num)) == 1)
        STnum = append('1', '0', num2str(num));
    elseif (length(num2str(num)) == 2)
        STnum = append('1', num2str(num));
    end
    

    input_path = strcat('testing/patient',STnum, '/');
    file_name = strcat( 'patient', STnum, '_4d.nii.gz');
    input_path_complete = strcat(input_path,file_name);
    %
    FourDFile = niftiread(input_path_complete);
    
    
    
    sizeFor4D = size(FourDFile);
    for i = 1:sizeFor4D(4)
        image_timepoint = FourDFile(:, :, :, i);
        image_timepoint_scaled = imresize3(image_timepoint, [216 256 16]);
        output = predict(mynet, image_timepoint_scaled);
        % data for 4 part: LVC, RVC, Myocardium, others
            LVC(i) = sum(sum(sum(output(:,:,:,1))));
            RVC(i) = sum(sum(sum(output(:,:,:,2))));
            Myocardium(i) = sum(sum(sum(output(:,:,:,3))));
            others(i) = sum(sum(sum(output(:,:,:,4))));      
    end
    % compare between each time point and calculate EF
    % As we are comparing the ratio, assume the distance between each layer
    % is 1; Thus the Volume = Area * 1 = Area
    % LVC
    LVC_EDV = max(LVC);
    LVC_ESV = min(LVC);
    LVC_SV = LVC_EDV - LVC_ESV;
    LVC_EF = LVC_SV / LVC_EDV; 
    LVC_volume = mean(LVC);
    %RVC
    RVC_EDV = max(RVC);
    RVC_ESV = min(RVC);
    RVC_SV = RVC_EDV - RVC_ESV;
    RVC_EF = RVC_SV / RVC_EDV;
    RVC_volume = mean(RVC);
    %Myocardium
    MC_volume = mean(Myocardium);

    patientData = [num, 0, LVC_EDV, LVC_ESV, LVC_SV, LVC_EF, LVC_volume, RVC_EDV, RVC_ESV, RVC_SV, RVC_EF, RVC_volume, MC_volume];
    TestingTOTALDATA(num,:) = patientData;    
end
%% test

testPredict = [];

for testnum = 1:50
    sumcor = 0;
        input = TestingTOTALDATA(testnum,3:13);

        for i = 1:11   
            NOR_score = sumcor + abs(input(i) - NOR_stat(1,i)) / NOR_stat(2,i);
        end

        for i = 1:11   
            MINF_score = sumcor + abs(input(i) - MINF_stat(1,i)) / MINF_stat(2,i);
        end

        for i = 1:11   
            DCM_score = sumcor + abs(input(i) - DCM_stat(1,i)) / DCM_stat(2,i);
        end

        for i = 1:11   
            HCM_score = sumcor + abs(input(i) - HCM_stat(1,i)) / HCM_stat(2,i);
        end

        for i = 1:11   
            RV_score = sumcor + abs(input(i) - RV_stat(1,i)) / RV_stat(2,i);
        end
        
        score = [NOR_score, MINF_score, DCM_score, HCM_score, RV_score];
        predi = find(score == (min(score)));

        testPredict(length(testPredict) + 1 ) = predi;

            % 1 - 20 is NOR
            % 21 - 40 is MINF
            % 41 - 60 is DCM
            % 61 - 80 is HCM
            % 81 - 100 is RV
end

testPredictResult = [];

for i = testPredict

    if i == 1
        testPredictResult = [testPredictResult, 'NOR '];
    elseif i == 2
        testPredictResult = [testPredictResult, 'MINF '];
    elseif i == 3
        testPredictResult = [testPredictResult, 'DCM '];
    elseif i == 4
        testPredictResult = [testPredictResult, 'HCM '];
    elseif i == 5
        testPredictResult = [testPredictResult, 'RV '];   
    end
end       
sp = split(testPredictResult, ' ');
testPredictResult = reshape(sp(1:50),[1 50]);
testPredictResult

%% print out
printOut = [];
for i = 1:50
    if (length(num2str(i)) == 1)
        STnum = append('0', '0', num2str(i)');
    elseif (length(num2str(i)) == 2)
        STnum = append('0', num2str(i));
    end
    
    printOut = [printOut; string(['patient', STnum, ' ', cell2mat(testPredictResult(i))])];
    
end
printOut;
% convertStringsToChars(printOut)

fid = fopen('printOut.txt','wt');
for i = 1 : 50
    line = convertStringsToChars(printOut(i));
    fprintf(fid, line);
    fprintf(fid, '\n');  
end 


fclose(fid);   