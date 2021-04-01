%% jointHist.m
%
% function to return the joint histogram of two 2D images of equal size
% 
% - written by: Dimitri Lezcano

function joint = jointHist(A, B)
    %% Argument block
    arguments
        A (:,:);
        B (:,:) {mustBeEqualSize(A, B)};
    end
    
    %% Set-up
    N_rows = size(A, 1);
    N_cols = size(A, 2);
    
    N = max(max(A, B), [], 'all') + 1; % number of total elements
    
    joint = zeros(N, N);
        
    %% Calculate joint histogram
    for i = 1:N_rows
        for j = 1:N_cols
            joint(A(i,j) + 1, B(i,j) + 1) = joint(A(i,j) + 1, B(i,j) + 1) + 1;
        end
    end
    
end