clear all
close all
clc

Img = imread('coins.png');
Img = imresize(Img,0.4);
Idown2 = imtranslate(Img,[0 1]);
Idown3 = imtranslate(Idown2,[0 1]);
Iright2 = imtranslate(Img,[1 0]);
Iright3 = imtranslate(Iright2,[1 0]);
Idiag2 = imtranslate(Img,[1 1]);
Idiag3 = imtranslate(Idiag2,[1 1]);
figure('name','Coins');
imshow(Img);
[Ix,Iy,It] = partialDerivatives(Img,Idown2);
figure('name','PartialDerivativesX');
imshow(Ix);
figure('name','PartialDerivativesY');
imshow(Iy);
figure('name','PartialDerivativesT');
imshow(It);
