% 
% I = imread('cameraman.tif');
% % imshow(I)
% 
% h_sobel=fspecial('sobel')
% SobelI=imfilter(I,h_sobel)
% 
% h_laplacian=fspecial('laplacian')
% LaplacianI=imfilter(I,h_laplacian);
% 
% h_log=fspecial('log')
% LaplacianGI=imfilter(I,h_log);
% 
% CannyI = edge(I,'Canny')
% 
% figure
% imshow(SobelI)
% figure
% imshow(LaplacianI)
% figure
% imshow(LaplacianGI)
% figure
%  imshow(CannyI)
% 
%  figure
% [dx, dy] = gradient(double(SobelI));
% [rows, columns] = size(SobelI);
% [x y] = meshgrid(1:columns, 1:rows);
% quiver(x, y, dx, dy)
% 
%  figure
% [dx, dy] = gradient(double(LaplacianI));
% [rows, columns] = size(LaplacianI);
% [x y] = meshgrid(1:columns, 1:rows);
% quiver(x, y, dx, dy)
% 
%  figure
% [dx, dy] = gradient(double(LaplacianGI));
% [rows, columns] = size(LaplacianGI);
% [x y] = meshgrid(1:columns, 1:rows);
% quiver(x, y, dx, dy)
% 
%  figure
% [dx, dy] = gradient(double(CannyI));
% [rows, columns] = size(CannyI);
% [x y] = meshgrid(1:columns, 1:rows);
% quiver(x, y, dx, dy)

close all
%Canny, log, Sobel and zerocross

% canny = edge(I,'canny')
% figure
% imshow(canny)
% 
% log = edge(I,'log')
% figure
% imshow(log)
% 
% sobel = edge(I,'sobel')
% figure
% imshow(sobel)
% 
% zerocross = edge(I,'zerocross')
% figure
% imshow(zerocross)

filtreSobel(I,200)
