%% prob1.m
%
% this is to answer problem 1 in the homework
%
% - written by: Dimitri Lezcano

function prob1
    %% part a
    disp('Part a')
    T1 = [3 8 7; 5 2 7; 1 5 6]
    T2 = [9 4 5; 7 9 6; 7 6 3]
    
    start1 = [7;5];
    start2 = [3;8];
    
    kmeans_prob1 = @(X, start) kmeans(X, 2, 'Start', start, 'MaxIter', 3);
    
    disp("T1");
    fprintf("Start: [%d, %d]\n", start1);
    [T1_start1_idx, C_T1_start1] = kmeans_prob1(T1(:), start1);
    T1_start1 = reshape(C_T1_start1(T1_start1_idx), size(T1))
    fprintf("Cluster centers: [%f, %f]\n", C_T1_start1);
    
    fprintf("Start: [%d, %d]\n", start2);
    [T1_start2_idx, C_T1_start2] = kmeans_prob1(T1(:), start2);
    T1_start2 = reshape(C_T1_start2(T1_start2_idx), size(T1))
    fprintf("Cluster centers: [%f, %f]\n", C_T1_start2);
    
    disp("T2");
    fprintf("Start: [%d, %d]\n", start1);
    [T2_start1_idx, C_T2_start1] = kmeans_prob1(T2(:), start1);
    T2_start1 = reshape(C_T2_start1(T2_start1_idx), size(T2))
    fprintf("Cluster centers: [%f, %f]\n", C_T2_start1);
    
    fprintf("Start: [%d, %d]\n", start2);
    [T2_start2_idx, C_T2_start2] = kmeans_prob1(T2(:), start2);
    T2_start2 = reshape(C_T2_start2(T2_start2_idx), size(T2))
    fprintf("Cluster centers: [%f, %f]\n", C_T2_start2);


end