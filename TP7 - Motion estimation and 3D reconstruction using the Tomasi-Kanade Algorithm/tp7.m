clc
clear all;
close all;

% Modelisation of the hexagonal prism, let's turn it and compute it
ogPrism =[0 0 0;1 0 0;1 1 0;0 1 0;...
    1.5 0 0.5; 1.5 1 0.5; 0 0 1;1 0 1;...
    1 1 1;0 1 1; -0.5 0 0.5; -0.5 1 0.5];


Rotate = [cos(pi/4) -sin(pi/4) 0;
          sin(pi/4) cos(pi/4) 0;
          0         0         1];

prism2 = ogPrism*Rotate;
prism3 = prism2*Rotate;
prism4 = prism3*Rotate;

prismPoints = [ogPrism(:,1) ogPrism(:,2), ogPrism(:,3);...
    prism2(:,1) prism2(:,2), prism2(:,3);...
    prism3(:,1) prism3(:,2), prism3(:,3);...
    prism4(:,1) prism4(:,2), prism4(:,3)];

allX = prismPoints(:,1);
allY = prismPoints(:,2);
allZ = prismPoints(:,3);

W = [allZ(1:12)';allZ(13:24)';allZ(25:36)';allZ(37:48)';...
    allY(1:12)';allY(13:24)';allY(25:36)';allY(37:48)'];

for i=1:4
   meanZ{i} = mean(W(i,:)); 
   meanY{i} = mean(W(i+4,:));
   
   W(i,:) = W(i,:)-meanZ{i};
   W(i+4,:) = W(i+4,:)-meanY{i};
end

%Single value decomposition & Fill L
[U D V] = svd(W);
Ucut = [U(:,1) U(:,2) U(:,3)];
Dcut = [D(1,1:3);D(2,1:3);D(3,1:3)];
Vcut = [V(:,1) V(:,2) V(:,3)];

RT = Ucut*Dcut^(0.5);
STemp = Dcut^(0.5)*Vcut';

A = [RT(1,1)*RT(1,1) 2*RT(1,1)*RT(1,2) 2*RT(1,1)*RT(1,3)...
    RT(1,2)*RT(1,2) 2*RT(1,2)*RT(1,3) RT(1,3)*RT(1,3);
    RT(2,1)*RT(2,1) 2*RT(2,1)*RT(2,2) 2*RT(2,1)*RT(2,3)...
    RT(2,2)*RT(2,2) 2*RT(2,2)*RT(2,3) RT(2,3)*RT(2,3);
    RT(3,1)*RT(3,1) 2*RT(3,1)*RT(3,2) 2*RT(3,1)*RT(3,3)...
    RT(3,2)*RT(3,2) 2*RT(3,2)*RT(3,3) RT(3,3)*RT(3,3);
    RT(4,1)*RT(4,1) 2*RT(4,1)*RT(4,2) 2*RT(4,1)*RT(4,3)...
    RT(4,2)*RT(4,2) 2*RT(4,2)*RT(4,3) RT(4,3)*RT(4,3);
    RT(5,1)*RT(5,1) 2*RT(5,1)*RT(5,2) 2*RT(5,1)*RT(5,3)...
    RT(5,2)*RT(5,2) 2*RT(5,2)*RT(5,3) RT(5,3)*RT(5,3);
    RT(6,1)*RT(6,1) 2*RT(6,1)*RT(6,2) 2*RT(6,1)*RT(6,3)...
    RT(6,2)*RT(6,2) 2*RT(6,2)*RT(6,3) RT(6,3)*RT(6,3);
    RT(1,1)*RT(4,1) 2*RT(1,1)*RT(4,2) 2*RT(1,1)*RT(4,3)...
    RT(1,2)*RT(4,2) 2*RT(1,2)*RT(4,3) RT(1,3)*RT(4,3);
    RT(2,1)*RT(5,1) 2*RT(2,1)*RT(5,2) 2*RT(2,1)*RT(5,3)...
    RT(2,2)*RT(5,2) 2*RT(2,2)*RT(5,3) RT(2,3)*RT(5,3);
    RT(3,1)*RT(6,1) 2*RT(3,1)*RT(6,2) 2*RT(3,1)*RT(6,3)...
    RT(3,2)*RT(6,2) 2*RT(3,2)*RT(6,3) RT(3,3)*RT(6,3)];
C = [1;1;1;1;1;1;0;0;0;];
LTemp = pinv(A)*C;
L = [LTemp(1) LTemp(2) LTemp(3);
    LTemp(2) LTemp(4) LTemp(5);
    LTemp(3) LTemp(5) LTemp(6)];

%Eigenvalues
[diagL matL] = eig(L);
R = RT*diagL;
S = inv(diagL)*STemp

%Display
%With the reconstruction, some of the points are on top
%of each other
figure();

%Pretty colors to differenciate to draw the lines but actually it's pretty
plot3(S(1,1),S(2,1),S(3,1),'ro');
hold on
plot3(S(1,2),S(2,2),S(3,2),'r+');
plot3(S(1,3),S(2,3),S(3,3),'r*');
plot3(S(1,4),S(2,4),S(3,4),'bo');
plot3(S(1,5),S(2,5),S(3,5),'b+');
plot3(S(1,6),S(2,6),S(3,6),'b*');
plot3(S(1,7),S(2,7),S(3,7),'go');
plot3(S(1,8),S(2,8),S(3,8),'g+');
plot3(S(1,9),S(2,9),S(3,9),'g*');
plot3(S(1,10),S(2,10),S(3,10),'ko');
plot3(S(1,11),S(2,11),S(3,11),'k+');
plot3(S(1,12),S(2,12),S(3,12),'k*');
axis square,  grid on
line([S(1,1:4) S(1,1)],[S(2,1:4) S(2,1)],[S(3,1:4) S(3,1)]);
line([S(1,7:10) S(1,7)],[S(2,7:10) S(2,7)],[S(3,7:10) S(3,7)]);
line([S(1,2) S(1,5)],[S(2,2) S(2,5)],[S(3,2) S(3,5)]);
line([S(1,3) S(1,6)],[S(2,3) S(2,6)],[S(3,3) S(3,6)]);
line([S(1,5) S(1,6)],[S(2,5) S(2,6)],[S(3,5) S(3,6)]);
line([S(1,8) S(1,5)],[S(2,8) S(2,5)],[S(3,8) S(3,5)]);
line([S(1,9) S(1,6)],[S(2,9) S(2,6)],[S(3,9) S(3,6)]);
line([S(1,10) S(1,12)],[S(2,10) S(2,12)],[S(3,10) S(3,12)]);
line([S(1,7) S(1,11)],[S(2,7) S(2,11)],[S(3,7) S(3,11)]);
line([S(1,12) S(1,11)],[S(2,12) S(2,11)],[S(3,12) S(3,11)]);
line([S(1,1) S(1,11)],[S(2,1) S(2,11)],[S(3,1) S(3,11)]);
line([S(1,4) S(1,12)],[S(2,4) S(2,12)],[S(3,4) S(3,12)]);

xlabel('X')
ylabel('Y')
zlabel('Z')

% Hotel

clear all;
%close all;
% Read sequence of photos
H{1}=imread('hotel.seq0.png');
H{2}=imread('hotel.seq4.png');
H{3}=imread('hotel.seq8.png');
H{4}=imread('hotel.seq12.png');
H{5}=imread('hotel.seq16.png');
H{6}=imread('hotel.seq20.png');
H{7}=imread('hotel.seq24.png');
H{8}=imread('hotel.seq28.png');
H{9}=imread('hotel.seq32.png');
H{10}=imread('hotel.seq36.png');

% Put points by hand in an easily readable file 
% Bad Idea finally, by hand is dirty
% imshow(H1);
% [x1,y1] = getpts;
% imshow(H2);
% [x2,y2] = getpts;
% imshow(H3);
% [x3,y3] = getpts;
% imshow(H4);
% [x4,y4] = getpts;
% imshow(H5);
% [x5,y5] = getpts;
% imshow(H6);
% [x6,y6] = getpts;
% allX = [x1;x2;x3;x4;x5;x6]
% allY = [y1;y2;y3;y4;y5;y6]
% allPoints = [allX allY]
% dlmwrite('points.pts',allPoints,'delimiter',' ');

%Get all the points
for i=1:10
    %figure
    HF{i} = detectHarrisFeatures(H{i});
    pH{i} = HF{i}.selectStrongest(6).Location;
    %imshow(H{i}); hold on;
    %plot(HF{i}.selectStrongest(6));
end
allPoints=[pH{1,1}];
% Get the points
for i=2:10
    allPoints=[allPoints; pH{1,i}];
end
%allPoints = load('Points.pts');
allX = allPoints(:,1);
allY = allPoints(:,2);

% Measurement Matrix
W = [allX(1:6)';allX(7:12)';allX(13:18)';...
    allX(19:24)';allX(25:30)';allX(31:36)';...
    allX(37:42)';allX(43:48)';allX(49:54)';allX(55:60)';...
    allY(1:6)';allY(7:12)';allY(13:18)';...
    allY(19:24)';allY(25:30)';allY(31:36)';...
    allY(37:42)';allY(43:48)';allY(49:54)';allY(55:60)'];

% Means to normalize around 0
for i=1:10
   meanX{i} = mean(W(i,:)); 
   meanY{i} = mean(W(i+10,:));

   W(i,:) = W(i,:)-meanX{i};
   W(i+10,:) = W(i+10,:)-meanY{i};
end

%Single value decomposition & Fill L
[U D V] = svd(W);
Ucut = [U(:,1) U(:,2) U(:,3)];
Dcut = [D(1,1:3);D(2,1:3);D(3,1:3)];
Vcut = [V(:,1) V(:,2) V(:,3)];

RT = Ucut*Dcut^(0.5);
STemp = Dcut^(0.5)*Vcut';

A = [RT(1,1)*RT(1,1) 2*RT(1,1)*RT(1,2) 2*RT(1,1)*RT(1,3)...
    RT(1,2)*RT(1,2) 2*RT(1,2)*RT(1,3) RT(1,3)*RT(1,3);
    RT(2,1)*RT(2,1) 2*RT(2,1)*RT(2,2) 2*RT(2,1)*RT(2,3)...
    RT(2,2)*RT(2,2) 2*RT(2,2)*RT(2,3) RT(2,3)*RT(2,3);
    RT(3,1)*RT(3,1) 2*RT(3,1)*RT(3,2) 2*RT(3,1)*RT(3,3)...
    RT(3,2)*RT(3,2) 2*RT(3,2)*RT(3,3) RT(3,3)*RT(3,3);
    RT(4,1)*RT(4,1) 2*RT(4,1)*RT(4,2) 2*RT(4,1)*RT(4,3)...
    RT(4,2)*RT(4,2) 2*RT(4,2)*RT(4,3) RT(4,3)*RT(4,3);
    RT(5,1)*RT(5,1) 2*RT(5,1)*RT(5,2) 2*RT(5,1)*RT(5,3)...
    RT(5,2)*RT(5,2) 2*RT(5,2)*RT(5,3) RT(5,3)*RT(5,3);
    RT(6,1)*RT(6,1) 2*RT(6,1)*RT(6,2) 2*RT(6,1)*RT(6,3)...
    RT(6,2)*RT(6,2) 2*RT(6,2)*RT(6,3) RT(6,3)*RT(6,3);
    RT(1,1)*RT(4,1) 2*RT(1,1)*RT(4,2) 2*RT(1,1)*RT(4,3)...
    RT(1,2)*RT(4,2) 2*RT(1,2)*RT(4,3) RT(1,3)*RT(4,3);
    RT(2,1)*RT(5,1) 2*RT(2,1)*RT(5,2) 2*RT(2,1)*RT(5,3)...
    RT(2,2)*RT(5,2) 2*RT(2,2)*RT(5,3) RT(2,3)*RT(5,3);
    RT(3,1)*RT(6,1) 2*RT(3,1)*RT(6,2) 2*RT(3,1)*RT(6,3)...
    RT(3,2)*RT(6,2) 2*RT(3,2)*RT(6,3) RT(3,3)*RT(6,3)];
C = [1;1;1;1;1;1;0;0;0;];
LTemp = pinv(A)*C;
L = [LTemp(1) LTemp(2) LTemp(3);
    LTemp(2) LTemp(4) LTemp(5);
    LTemp(3) LTemp(5) LTemp(6)];

%Eigenvalues
[diagL matL] = eig(L);
R = RT*diagL;
S = inv(diagL)*STemp;

%Trying to reconstruct the points on the hostel

figure
imshow(H{1}); hold on;
plot(allPoints(1:6,1),allPoints(1:6,2),'+r');
figure
plot3(S(1,:),S(2,:),S(3,:),'+b');
axis square, grid on
xlabel('X')
ylabel('Y')
zlabel('Z')



