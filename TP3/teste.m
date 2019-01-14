function [houghSpace,theta,rho] = teste(theImage,thetaSampleFrequency)
 
    %Define the hough space
    theImage = flipud(theImage);
    [width,height] = size(theImage);
 
    rhoLimit = norm([width height]);
    rho = (-rhoLimit:1:rhoLimit);          
    theta = (0:thetaSampleFrequency:pi);
 
    numThetas = numel(theta);
    houghSpace = zeros(numel(rho),numThetas);
 
    %Find the "edge" pixels
    [xIndicies,yIndicies] = find(theImage);
 
    %Preallocate space for the accumulator array
    numEdgePixels = numel(xIndicies);
    accumulator = zeros(numEdgePixels,numThetas);
 
    %Preallocate cosine and sine calculations to increase speed. In
    %addition to precallculating sine and cosine we are also multiplying
    %them by the proper pixel weights such that the rows will be indexed by 
    %the pixel number and the columns will be indexed by the thetas.
    %Example: cosine(3,:) is 2*cosine(0 to pi)
    %         cosine(:,1) is (0 to width of image)*cosine(0)
    cosine = (0:width-1)'*cos(theta); %Matrix Outerproduct  
    sine = (0:height-1)'*sin(theta); %Matrix Outerproduct
 
    accumulator((1:numEdgePixels),:) = cosine(xIndicies,:) + sine(yIndicies,:);
 
    %Scan over the thetas and bin the rhos 
    for i = (1:numThetas)
        houghSpace(:,i) = hist(accumulator(:,i),rho);
    end
 
    pcolor(theta,rho,houghSpace);
    shading flat;
    title('Hough Transform');
    xlabel('Theta (radians)');
    ylabel('Rho (pixels)');
    colormap('gray');
 
end