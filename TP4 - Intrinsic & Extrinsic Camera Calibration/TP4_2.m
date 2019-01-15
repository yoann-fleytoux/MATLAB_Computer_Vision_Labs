close all
clear all
clc

file=importdata('A1_2.pts',' ',1);
% I1=imread('A1.bmp');
% I2=imread('A2.bmp');
P=file.data(:,2:end);

S1=size(P,1)/2;

A_B = [P(:,3), P(:,4), P(:,5), ones(size(P,1),1), zeros(size(P,1),4)...
    -P(:,1).*P(:,3), -P(:,1).*P(:,4), -P(:,1).*P(:,5), -P(:,1);
    zeros(size(P,1),4), P(:,3), P(:,4), P(:,5), ones(size(P,1),1)...
    -P(:,2).*P(:,3), -P(:,2).*P(:,4), -P(:,2).*P(:,5), -P(:,2)];

% 1 - In calculating the matrix M instead of imposing the constraint M 12 = 1
% use the decomposition in Singular values ​​as described in the theoretical class;

% Singular value decomposition expresses an m-by-n matrix A as A = U*S*V'.
% Here, S is an m-by-n diagonal matrix with singular values of A on its diagonal.
% The columns of the m-by-m matrix U are the left singular vectors for corresponding singular values.
% The columns of the n-by-n matrix V are the right singular vectors for corresponding singular values.
% V' is the Hermitian transpose (the complex conjugate of the transpose) of V.

[U,S,V] = svd(A_B);

% Create diagonal matrix or get diagonal elements of matrix
dS=diag(S);
[v c]=min(dS); %v: value, c:coordinate
M=[ V(1:4,c)';V(5:8,c)';V(9:12,c)' ]

% 2-Calculate the intrinsic and extrinsic parameters (from matrix M)
% as described in the theoretical class;

q1=M(1,1:3)';
q2=M(2,1:3)';
q3=M(3,1:3)';

%Principal Point Offset,
ox=q1'*q3
oy=q2'*q3

% Focal Length, fx, fy
fx=sqrt(q1'*q1-ox^2)
fy=sqrt(q2'*q2-oy^2)

%  Parameters Intrinsic (Axis Skew=0)

K=[fx 0 ox;0 fy oy;0 0 1]

%  Parameters Extrinsic

R=[(ox*M(3,1)-M(1,1))/fx, (ox*M(3,2)-M(1,2))/fx, (ox*M(3,3)-M(1,3))/fx;
    (oy*M(3,1)-M(2,1))/fy, (oy*M(3,2)-M(2,2))/fy, (oy*M(3,3)-M(2,3))/fy;
    q3(1),q3(2),q3(3)];
Tz=M(3,4);
Tx=(ox*Tz-M(1,4))/fx;
Ty=oy*Tz-M(2,4)/fy;
T_2=[Tx;Ty;Tz];
R_T_2=[R,T_2];

R_T=inv(K)*M

% 3-Calculate the maximum, minimum, median, mean and standard deviation differences as in part 1.

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

hist(D);
title('Disparities');


% 5-Calculate the intrinsic and extrinsic parameters using the QR decomposition. 
%   Compare the results with those obtained in the previous paragraphs and make a critical analysis.

[Q R]=qr(M)
M
K*R_T
Q*R
% We can see that both M=K*R_T=Q*R
Q
R_T% rotation and translation
R
K% intrisic matrix
% we can see that R and K are quite similar (if we dont consider the sign)


