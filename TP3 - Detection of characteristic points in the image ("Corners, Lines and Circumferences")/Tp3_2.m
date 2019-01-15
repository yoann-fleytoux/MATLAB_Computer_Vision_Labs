I = imread('lines_circles_2.jpg');
IG = rgb2gray(I);
Ismall = imresize(IG,0.5);

imshow(Ismall); hold on; 

[houghArray,theta,rho] = myHough(Ismall);
peaks = houghpeaks(houghArray,100);
lines = houghlines(Ismall,theta,rho,peaks);

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

figure;
IChess = imread('chess_2.png');
IChessG = rgb2gray(IChess);
%IChessBW = imbinarize(IChessG);
IChessSmall = imresize(IChessG, 0.25);
imshow(IChessSmall); hold on; 
[chessHough,chessTheta,chessRho] = hough(IChessSmall);
chessPeaks = houghpeaks(chessHough,30);
chessLines = houghlines(IChessSmall,chessTheta,chessRho,chessPeaks);

for k = 1:length(chessLines)
   xyChess = [chessLines(k).point1; chessLines(k).point2];
   plot(xyChess(:,1),xyChess(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xyChess(1,1),xyChess(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xyChess(2,1),xyChess(2,2),'x','LineWidth',2,'Color','red');
end