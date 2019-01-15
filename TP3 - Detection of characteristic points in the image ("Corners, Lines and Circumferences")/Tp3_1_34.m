I = imread('chess_2.png');
IG = rgb2gray(I);
%Ismall = imresize(IG,0.5);

%To test algorithm, use checkerboard

%C = checkerboard(25,5,5);

%Test of detectCheckerboardPoints
[imagePoints,boardSize] = detectCheckerboardPoints(IG);
imshow(IG); hold on; 
plot(imagePoints(:,1), imagePoints(:,2), 'ro');

%[hough,theta,rho] = teste(Ismall,1/200);

%Test of corner (1)
% figure;
% HarrisMatrixCorner = corner(IG,'Harris');
% imshow(IG); hold on;
% plot(HarrisMatrixCorner(:,1,1),HarrisMatrixCorner(:,2,1), 'ro');
%Test of corner (2)
% figure;
% MinEigenValueMatrixCorner = corner(IG,'MinimumEigenvalue');
% imshow(IG); hold on;
% plot(MinEigenValueMatrixCorner(:,1,1),MinEigenValueMatrixCorner(:,2,1), 'ro');
% Test of detectHarrisFeatures
% figure;
% HarrisFeatures = detectHarrisFeatures(IG);
% imshow(IG); hold on;
% plot(HarrisFeatures.selectStrongest(200));
% 
% %Test of detectMinEigenFeatures
% figure;
% MinEigFeatures = detectMinEigenFeatures(IG);
% imshow(IG); hold on;
% plot(MinEigFeatures.selectStrongest(200));

% figure
% imshow(GX)
% figure
% imshow(GY)
% figure
% imshow(IG)