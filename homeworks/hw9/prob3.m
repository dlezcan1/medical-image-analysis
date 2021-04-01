%% prob3.m
%
% script to handle problem 3 in Homework 9
%
% - written by: Dimitri Lezcano

function prob3
    %% Set-up
    A = [0 0 0 0 0;
         0 4 6 0 0;
         0 2 4 6 0;
         0 4 6 0 0;
         0 0 0 0 0];
    B = [5 5 5 5 5;
         5 5 3 2 5;
         5 5 1 4 2;
         5 5 4 2 5;
         5 5 5 5 5];
     
    %% Part a
    % compute joint histogram
    joint_hist = jointHist(A, B);
    
    % plot the joint histogram
    [X, Y] = meshgrid(0:size(joint_hist,1)-1, 0:size(joint_hist,2)-1);
    fa = figure(1);
    surf(X, Y, joint_hist);
    view(2); title("Problem 3a: Joint Histogram of A & B");
    xlabel('Image A'); ylabel('Image B');
    saveas(fa, 'prob3a.png');
    
    %% part b-c
    translations = -2:2; % translations left-right
    
    result_bc = zeros(length(translations), 4);
    for i = 1:length(translations)
        result_bc(i, 1) = translations(i);
        result_bc(i, 2) = joint_entropy_hshift(A, B, translations(i));
        result_bc(i, 3) = mutual_information_hshift(A, B, translations(i));
        result_bc(i, 4) = least_squares_hshift(A, B, translations(i));
    end
    
    result_bc = array2table(result_bc, 'VariableNames', {'t', 'JE', 'MI', 'LST'})
    writetable(result_bc, 'prob3b-c.xlsx');
    
    
end

%% Helper functions
function lst = least_squares_hshift(A, B, t)
    arguments
        A (:,:);
        B (:,:) {mustBeEqualSize(A, B)};
        t {mustBeInteger};
    end
    
    % shift B
    if t <= 0
        B_shift = [B(:, 1-t:end), zeros(size(B,1), -t)];
    else
        B_shift = [zeros(size(B,1), t), B(:, 1:end-t)];
    end
    
    lst = norm(A - B_shift)^2;

end

function mi = mutual_information_hshift(A, B, t)
    arguments
        A (:,:);
        B (:,:) {mustBeEqualSize(A, B)};
        t {mustBeInteger};
    end
    
    % shift B
    if t <= 0
        B_shift = [B(:, 1-t:end), zeros(size(B,1), -t)];
    else
        B_shift = [zeros(size(B,1), t), B(:, 1:end-t)];
    end
    
    mi = entropy(A) + entropy(B_shift) - joint_entropy_hshift(A, B, t);

end

function jnt_entpy = joint_entropy_hshift(A, B, t)
    arguments
        A (:,:);
        B (:,:) {mustBeEqualSize(A, B)};
        t {mustBeInteger};
    end
    
    % shift B
    if t <= 0
        B_shift = [B(:, 1-t:end), zeros(size(B,1), -t)];
    else
        B_shift = [zeros(size(B,1), t), B(:, 1:end-t)];
    end
    
    % compute joint histogram
    jnt_hist = jointHist(A, B_shift);
    pAB = jnt_hist/sum(jnt_hist, 'all'); % probability table
    
    % compute joint entropy
    jnt_entpy = - sum(pAB .* log(pAB), 'all', 'omitnan');
    
end

function entpy  = entropy(A)
    arguments
        A (:,:);
    end
    
    % compute histogram
    [hist_A, ~] = histcounts(A(:));
%     centers = 1/2 * (edges(1:end-1) + edges(2:end));
    
    p_A = hist_A/sum(hist_A, 'all');
    
    % compute entropy
    entpy = -sum (p_A .* log(p_A), 'all', 'omitnan');
end
    
    
