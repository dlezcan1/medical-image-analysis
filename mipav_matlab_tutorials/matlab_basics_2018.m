% Introduction to basic matlab commands
% Medical Image Analysis (520.433 / 520.623)
% Andrew Lang
% 1/29/2014
%%%%%%%%%
% Edit 01/29/2018. Lianrui Zuo
%% (1) A good way to start every script
clc       % Clear command window
clearvars % Clear all variables. Not recommended to use "clear all" in latest Matlab versions
close all % Close all figures

%% (2) Help files
% Typing 'doc' before any function name shows the documentation for that function (ex. 'doc plot', 'doc repmat')
% Also see 'doc matlab' for basic matlab commands (syntax, plot, math, etc.)

%% (3) Debug commands
% Click the '-' on the left, next to the line numbers, to set a breakpoint
% f5  - run the code up to breakpoint, or continue from current breakpoint
% f10 - step through code one line at a time (from breakpoint)
% f11 - step into a function

%% (4) Other useful shortcuts
% ctrl+r - comment current line
% ctrl+t - uncomment current line
% ctrl+c - terminate current progress
% These commands are different in MacOS. You can customize them in 'preferences' window.
%% (5) Creating vectors

x = [1, 2, 3, 4, 5]  % Create a row vector
x = [1 2 3 4 5]      % Commas are not necessary
x = [1 2 3 4 5];     % use a semi-colon to supress output to the command window

x = [1; 2; 3; 4; 5]  % Create a column vector
x = [1 2 3 4 5]'     % Alternately, transpose a row vector

x = 1:5     % Row vector with values 1, 2, 3, 4, 5
x = 0:3:12  % Row vector with values 0, 3, 6, 9, 12
x = 5:-1:1  % Row vector with values 5, 4, 3, 2, 1

%% (6) Creating matrices
clc

A = [1:5; 6:10; 11:15]  % Create a 3x5 matrix
A = eye(3)     % 3x3 identity matrix
A = ones(3)    % 3x3 matrix of all ones - equivalent to ones(3,3)
A = ones(5,2)  % 5x2 matrix of all ones
A = zeros(5)   % 5x5 matrix of zeros
A = zeros(3,2) % 3x2 matrix of all zeros
A = diag([1 2 3]) % 3x3 diagonal matrix
A = randn(3,2) % 3x2 matrix with iid normal distributed random entries
A = false(3,3) % binary matrix of zeros
A = true(3,3)  % binary matrix of ones

%% (7) Array indexing
% 1. Important - Arrays are indexed by (row, column), not (x, y)
clc

A = zeros(3,3)
A(1,3) = 3         % set a single element (first row, third column)
A(:,1) = [1 2 3]'  % set a column
A(2,:) = [4 5 6]'  % set a row

b = A(1,2)   % get an element
b = A(:,3)   % get a column
b = A(:)     % get the whole matrix as a column vector
B = reshape(b,size(A)) % Reshape back to original size

% 2. Loops are not always necessary
A = rand(3)
for i = 1:size(A,1)      % # of rows
    for j = 1:size(A,2)  % # of columns
        if A(i,j) > 0.5
            A(i,j) = 5;
        else
            A(i,j) = 0;
        end
    end
end
A
% Alternatively:
A = rand(3)
A(A > 0.5) = 5
A(A < 0.5) = 0


% 3. Logical indexing
A = rand(3)
At = A > 0.5 % threshold at 0.5
A(At) = 5    % logical indexing - changes only the true values
A(~At) = 0   % equivalent to A(A<=0.5) = 0

A = rand(3)
A(A<0.8 & A>0.2) = 0 % logical 'AND'
A = rand(3)
A(A>0.8 | A<0.2) = 0 % logical 'OR'

%% (8) Useful matrix functions
clc

A = randn(4,3);

% 1. Size of a matrix
[n_rows, n_cols] = size(A) % Size of the matrix
[~, n_cols] = size(A)      % suppress the 1st output
n_rows = size(A,1)
n_cols = size(A,2)
l = length(A)              % Size of largest dimension (more useful for vectors)

% 2. Matrices combination
B = ones(4,2);

C = cat(2,A,B)      % Combine matrices
C = repmat(A,[2 1]) % Replicate a matrix

% 3. Useful matrix functions 
A = randn(3,3)
[V,D] = eig(A)    % compute eigenvalues and eigenvectors
[S,V,D] = svd(A)  % singular value decomposition

A = randn(3,5)
sumA = sum(A(:))   % sumation over all elements
sumA = sum(sum(A)) % sumation over all elements

%% (9) Arithmetic
clc

% matrix operations
A = 2*ones(3,3);
B = randn(3,3);  
C = 3*A
C = A+B
C = A*B
D = inv(3*eye(3))

% solve simple linear system Ax = b
A = randn(3,3);
b = randn(3,1);
x = inv(A) * b
x = A\b         % equivalent but more efficient than inv(A)*b

% element-wise operations
C = A.*B
C = A.^2

% subtract each element by a same number
C = 1:10;
pt = 2;
D = C - pt * ones(size(C)) % equivalent
D = C - pt                 % equivalent 

%% (10) Plot 2d data points or curve
clc

% plot y = f(x)
x = -5:0.1:5;
y = 5*exp(-x.^2/2/1^2); % a gaussian function

figure
plot(x,y,'.r')  % plot dots
axis equal

% Use 'hold on' to plot multiple things in the same figure
hold on 
y = 3*exp(-(x-2).^2/2/1);
plot(x,y,'--b','LineWidth',2) % plot continous curve, customize line width
hold off

% plot random points
x = rand(1,1000);
y = rand(1,1000); % a gaussian function

figure
plot(x,y,'.k')    % plot dots
axis equal

%% (11) Plot 3d data points or surface
[x,y] = meshgrid(-5:0.25:5, -5:0.25:5); % generate coordinates for 2d grid
% help file of meshgrid:
% [X,Y,Z] = meshgrid(x,y,z) returns the grid cordinates defined by vector
% x, y and z. The grid represented by X, Y and Z has size:
% length(y)-by-length(x)-by-length(z).
z = 5*exp(-(x.^2+y.^2)/2/1^2); 

figure
subplot(121);
plot3(x,y,z,'r.') % plot 3d dots
grid on

subplot(122);
surf(x,y,z)       % plot 3d surface
grid on           % turn on grid

%% (12) Histogram
x = randn(1,1000);
figure
histogram(x,50)

% Another useful function when creating histograms
[counts,bin_edges] = histcounts(x);