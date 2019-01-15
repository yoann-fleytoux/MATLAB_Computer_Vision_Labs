close all
clear all
clc
% Part 1
% We get the perspective points, and show them with A1 : blue and A2 : red

% 1. Acquire the coordinates of the calibration points belonging to different planes of
% Calibration.
% Note: The 3D coordinates can be obtained by the user manually.
% The 2D coordinates are to be obtained in the image by calculating
% the center of mass of the rectangles / squares placed in a calibration plane.
% The calibration pattern may consist of an equally spaced rectangle / squared array.
% The distance between the centers of the rectangles / squares must be known precisely.
% Consider the top left-hand point coincident with the origin of the OBJECT coordinate system,
% and the X and Y axes of the frame aligned with the rows and columns of the rectangle / squares matrix.
% Get the 3D coordinates of the Rectangles / squares

points=importdata('A1_2.pts',' ',1);
A1 = imread('A1.bmp');
A2 = imread('A2.bmp');
figure('name','Points of A1 (blue) and A2 (red) on top of A1');
imshow(A1);
title('Points of A1 (blue) and A2 (red) on top of A1');
hold on;
P=points.data(:,2:end);

plot(P(1:1:25,2),P(1:1:25,1),'b+');
plot(P(26:1:50,2),P(26:1:50,1),'r+');
hold off;
figure('name','Points of A1 (blue) and A2 (red) on top of A2');
imshow(A2);
title('Points of A1 (blue) and A2 (red) on top of A1');
hold on;
plot(P(1:1:25,2),P(1:1:25,1),'b+');
plot(P(26:1:50,2),P(26:1:50,1),'r+');
hold off;
figure('name', 'Disparities');
%Fill A and B, pseudo-inverse, then get M
% 2. Fill in the matrix A once the coordinates [X w, Y w Z w] and [x f, y f]
% of each of the points considered for calibration are known.
% Must use points that belong to more than one plane.
% Note: The coordinates [x f, y f] are obtained by calculating the centers of mass in the image
A = [P(:,3), P(:,4), P(:,5), ones(size(P,1),1), zeros(size(P,1),4)...
    -P(:,1).*P(:,3), -P(:,1).*P(:,4), -P(:,1).*P(:,5);
    zeros(size(P,1),4), P(:,3), P(:,4), P(:,5), ones(size(P,1),1)...
    -P(:,2).*P(:,3), -P(:,2).*P(:,4), -P(:,2).*P(:,5)];
B = [P(:,1);
    P(:,2)];
% 3. Calculate the pseudo-inverse matrix of A.
pseudoA = pinv(A);

% 4. Calculate the elements of matrix M, considering M 12 = 1.
% M '= B, and considering the use of a set of homologous points of calibration greater than 6,
% the elements of the vector M' are obtained through
% M '= A +. B, where A + represents the pseudo-inverse matrix of A.
M = (pseudoA*B)';
M = [M(1:4);M(5:8);M(9:11), 1];



%Disparities
% 5. Once the perspective matrix M is known, project the 3D calibration points into
% Image (p = M. P w = [x 'f, y' f]), and compute the disparity in the image.
% The disparity is calculated for each point through D=sqrt((xf-xf’)^2+(yf-yf’)^2)
Pc=M*[P(:,3:5)';ones(1,size(P,1))];

differenceX = (P(:,1)-(Pc(1,:)./Pc(3,:))');
differenceY = (P(:,2)-(Pc(2,:)./Pc(3,:))');
D = sqrt((differenceX).^2+(differenceY).^2);
% 6. Calculate the maximum, minimum, median, mean and standard deviations. 
% This parameter is a good indicator of the quality of the calibration performed
% and "also" of the quality of the calculated model parameters.
% A perfect calibration gives zero mean disparity, that is,
% all points projected on the image coincide with those calculated through the perspective matrix.
minD = min(D);
meanD = mean(D);
medD = median(D);
stdD = std(D);
maxD = max(D);

% 7. Display a histogram of disparity values. 
% IMP: Images of calibration standards, as well as 3D coordinates of the centers of the calibration circles.

hist(D);
title('Disparities');


