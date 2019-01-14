%location /usr/local/MATLAB/R2016b/toolbox/images/imdata
I = imread('cameraman.tif');
imshow(I)
%I_G=rgb2gray(I);
%figure;
%imshow(I_G)
J1 = imnoise(I,'gaussian',0,0.1) 
% figure
% imshow(J1)
%J2 = imnoise(I,'gaussian',0,0.3) 
% figure
% imshow(J2)
% J3 = imnoise(I,'gaussian',10,0.1) 
% figure
% imshow(J3)
%J4 = imnoise(I,'gaussian',10,0.3) 
% figure
% imshow(J4)
J5 = imnoise(I,'salt & pepper',0.1)
% figure
% imshow(J5)
J6 = imnoise(I,'salt & pepper',0.5)
% figure
% imshow(J6)
J7 = imnoise(I,'speckle',0.8)
% figure
% imshow(J7)

%Carry out the filtering of each image using the average filter, the Gaussian filter and the median filter.
%fpsecial
% 'average'	
% Averaging filter
% 'disk'
% Circular averaging filter (pillbox)
% 'gaussian'
% Gaussian lowpass filter
% 'laplacian'	
% Approximates the two-dimensional Laplacian operator
% 'log'
% Laplacian of Gaussian filter
% 'motion'
% Approximates the linear motion of a camera
% 'prewitt'
% Prewitt horizontal edge-emphasizing filter
% 'sobel'
% Sobel horizontal edge-emphasizing filter
h_avf=fspecial('average')
h_gaussian =fspecial('gaussian',[3 3], 0.3)
h_gaussian2 =fspecial('gaussian',[3 3], 2)
%B = medfilt2(A) performs median filtering of the matrix A in two dimensions. 
% Each output pixel contains the median value in a 3-by-3 neighborhood around the corresponding pixel in the input image. 
% medfilt2 pads the image with 0's on the edges, 
% so the median values for points within one-half the width of the neighborhood ([m n]/2) of the edges might appear distorted.
%###############TEST#####################
% F1=imfilter(I,h_avf);
% F2=imfilter(I,h_gaussian);
% F3=medfilt2(I)
% figure
% imshow(F1)
% figure
% imshow(F2)
% figure
% imshow(F3)
%#####################################
%TEST J1
%figure
%imshow(J1)
% AJ1=imfilter(J1,h_avf);
% GJ1=imfilter(J1,h_gaussian);
% GJBis1=imfilter(J1,h_gaussian2);
%MJ1=medfilt2(J1)
%figure
% imshow(AJ1)
% figure
% imshow(GJ1)
% figure
%imshow(MJ1)
% x = [0 256];
% y = [128 128];
% figure
% hold on;
% p = improfile(I,x,y);
% p1 = improfile(J1,x,y);
% p2 = improfile(AJ1,x,y);
% p3 = improfile(GJ1,x,y);
% p4 = improfile(MJ1,x,y);
% p5 = improfile(GJBis1,x,y);
% plot(p)
% plot(p1)
% plot(p2)
% plot(p3)
% plot(p4)
% plot(p5)
% grid minor
% legend('Regular image','With Gaussian noise','Average filter','Gaussian filter','Median filter')
% legend('Regular image','With Gaussian noise','Gaussian filter variance of 0.3', 'Gaussian filter variance of 2')
% 
% hold off;
% 

%TEST J5
figure
imshow(J5)
% AJ5=imfilter(J5,h_avf);
% GJ5=imfilter(J5,h_gaussian);
MJ5=medfilt2(J5)
figure
% imshow(AJ5)
% figure
% imshow(GJ5)
% figure
imshow(MJ5)
% x = [0 256];
% y = [128 128];
% figure
% hold on;
% p = improfile(I,x,y);
% p1 = improfile(J1,x,y);
% p2 = improfile(AJ1,x,y);
% p3 = improfile(GJ1,x,y);
% p4 = improfile(MJ1,x,y);
% plot(p)
% plot(p1)
% plot(p2)
% plot(p3)
% plot(p4)
% grid minor
% legend('Regular image','With Salt&Pepper noise','Average filter','Gaussian filter','Median filter')
% hold off;
% improfile retrieves the intensity values of pixels along a line or a multiline path in the grayscale, 
% binary, or RGB image in the current axes and displays a plot of the intensity values.
%TEST J7
% figure
% imshow(J7)
% AJ7=imfilter(J7,h_avf);
% GJ7=imfilter(J7,h_gaussian);
% MJ7=medfilt2(J7)
% figure
% imshow(AJ7)
% figure
% imshow(GJ7)
% figure
% imshow(MJ7)
% x = [0 256];
% y = [128 128];
% figure
% hold on;
% p = improfile(I,x,y);
% p1 = improfile(J7,x,y);
% p2 = improfile(AJ7,x,y);
% p3 = improfile(GJ7,x,y);
% p4 = improfile(MJ7,x,y);
% plot(p)
% plot(p1)
% plot(p2)
% plot(p3)
% plot(p4)
% grid minor
% legend('Regular image','With speckle noise','Average filter','Gaussian filter','Median filter')
% hold off;

%%%HOMEMADE MEDIAN FILTER

temp = zeros(size(J5)+2);
res = zeros(size(J5));

for x=1:size(J5,1)
    for y=1:size(J5,2)
        temp(x+1,y+1)=J5(x,y);
    end
end

for k=1:size(temp,1)-2
    for j=1:size(temp,2)-2
        janela=zeros(9,1);
        current=1;
        for x=1:3
            for y=1:3
                janela(current)=temp(k+x-1,j+y-1);
                current = current+1;
            end
        end
        M = sort(janela);
        res(k,j) = M(5);
     end
end    
res=uint8(res)
figure
imshow(res)

%Part 2