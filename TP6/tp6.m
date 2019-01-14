clear all;
close all;
clc

l1 = imread('left01.jpg');
l2 = imread('left02.jpg');
l3 = imread('left03.jpg');
r1 = imread('right01.jpg');
r2 = imread('right02.jpg');
r3 = imread('right03.jpg');

[imagePointsL1,boardSizeL1] = detectCheckerboardPoints(l1);
[imagePointsL2,boardSizeL2] = detectCheckerboardPoints(l2);
[imagePointsL3,boardSizeL3] = detectCheckerboardPoints(l3);
[imagePointsR1,boardSizeR1] = detectCheckerboardPoints(r1);
[imagePointsR2,boardSizeR2] = detectCheckerboardPoints(r2);
[imagePointsR3,boardSizeR3] = detectCheckerboardPoints(r3);

% figure('Name','left_1');
% imshow(l1); hold on;
% plot(imagePointsL1(:,1), imagePointsL1(:,2), 'ro');
% 
% figure('Name','right_1');
% imshow(r1); hold on;
% plot(imagePointsR1(:,1), imagePointsR1(:,2), 'ro');
% 
% figure('Name','left_2');
% imshow(l2); hold on;
% plot(imagePointsL2(:,1), imagePointsL2(:,2), 'ro');
% 
% figure('Name','right_2');
% imshow(r2); hold on;
% plot(imagePointsR2(:,1), imagePointsR2(:,2), 'ro');
% 
% figure('Name','left_3');
% imshow(l3); hold on;
% plot(imagePointsL3(:,1), imagePointsL3(:,2), 'ro');
% 
% figure('Name','right_3');
% imshow(r3); hold on;
% plot(imagePointsR3(:,1), imagePointsR3(:,2), 'ro');

%1 - Algorithm of the 8 points
pointsLeft = [imagePointsL1; imagePointsL2; imagePointsL3];
pointsRight = [imagePointsR1; imagePointsR2; imagePointsR3];

allLeftX = pointsLeft(:,1);
allLeftY = pointsLeft(:,2);
allRightX = pointsRight(:,1);
allRightY = pointsRight(:,2);

%Estimate camera Params
%squareSize = 38;
%[worldPointsL1] = generateCheckerboardPoints(boardSizeL1,squareSize);
%[cameraParamsL1,imagesUsed,estimationErrors] = estimateCameraParameters(imagePoints,worldPoints);
nbPoints = size(pointsLeft);

%Means and delta
deltaL = 0;
deltaR = 0;
meanLX = mean(allLeftX);
meanRX = mean(allRightX);
meanLY = mean(allLeftY);
meanRY = mean(allRightY);

for i=1:nbPoints(1)
    deltaL = deltaL+sqrt((allLeftX(i)-meanLX)^2+(allLeftY(i)-meanLY)^2);
    deltaR = deltaR+sqrt((allRightX(i)-meanRX)^2+(allRightY(i)-meanRY)^2);
end
deltaL = deltaL/(nbPoints(1)*sqrt(2));
deltaR = deltaR/(nbPoints(1)*sqrt(2));

TL = [1, 0, -meanLX; 0, 1, -meanLY; 0, 0,  deltaL];%I*means+delta
TR = [1, 0, -meanRX; 0, 1, -meanRY; 0, 0,  deltaR];%I*means+delta

%fill the hats
pLHat = (TL*[pointsLeft ones(nbPoints(1),1)]'/deltaL)';
pRHat = (TR*[pointsRight ones(nbPoints(1),1)]'/deltaR)';

%A and FHat
A = [pLHat(:,1).*pRHat(:,1), pRHat(:,1).*pLHat(:,2), pRHat(:,1)...
    pLHat(:,1).*pRHat(:,2), pLHat(:,2).*pRHat(:,2), pRHat(:,2)...
    pLHat(:,1), pLHat(:,2), ones(nbPoints(1),1)];
[U,D,V]=svd(A);
[M,I] = min(diag(D));
FHat = [V(1:3,I)';V(4:6,I)';V(7:9,I)'];
[U2,D2,V2] = svd(FHat);
[M2,I2] = min(diag(D2));
D2(I2,I2)=0;

%FPrime and F
FPrime = U2*D2*V2';
F = TR'*FPrime*TL;

%2 - Epipoles
[UF,DF,VF] = svd(F);
[MF,IF]=min(diag(DF));

eHatLeft = VF(:,IF);
eHatLeft = eHatLeft/eHatLeft(3);
eHatRight = UF(:,IF);
eHatRight = eHatRight/eHatRight(3);

%Print that
%plot(eHatLeft(1), eHatLeft(2),'b+');
%hold on;
%imshow(l1);
% figure('name','Epipoles on left1')
% plot(eHatLeft(1),eHatLeft(2),'r.','MarkerSize',25)
% hold on, imshow(l1), hold on
% for i=1:nbPoints(1)
%     plot([eHatLeft(1) allLeftX(i)],[eHatLeft(2) allLeftY(i)])
%     plot(allLeftX(i),allLeftY(i),'r.','MarkerSize',4)
% end
% 
% figure('name','Epipoles on right1')
% plot(eHatRight(1),eHatRight(2),'r.','MarkerSize',25)
% hold on, imshow(r1), hold on
% for i=1:nbPoints(1)
%     plot([eHatRight(1) allRightX(i)],[eHatRight(2) allRightY(i)])
%     plot(allRightX(i),allRightY(i),'r.','MarkerSize',4)
% end
% Values apparently too wrong to give a satisfying answer

%4 - EstimateFundamentalMatrix
FMat = estimateFundamentalMatrix(pointsLeft,pointsRight);

[UMat,DMat,VMat] = svd(FMat);
[MMat,IMat]=min(diag(DMat));

eHatLeftMat = VMat(:,IMat);
eHatLeftMat = eHatLeftMat/eHatLeftMat(3);
eHatRightMat = UMat(:,IMat);
eHatRightMat = eHatRightMat/eHatRightMat(3);
%Same reason for no printing

%5 - Essential Matrix
KR=[533.0031,0,341.568; 0,533.1526,234.259; 0,0,1];
KL=[536.9826,0,326.472; 0,536.56938,249.3326; 0,0,1];
E = KR'*F*KL

%6 - Translation and rotation
[UE DE VE] = svd(E);
TE=UE(:,3);
RE=UE*[0,-1,0;1,0,0;0,0,1]*VE';

%7 - 3D Reconstruction

