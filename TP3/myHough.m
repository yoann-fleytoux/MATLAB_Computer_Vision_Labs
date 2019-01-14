function [hough,theta,rho] = myHough(I)
    %get the size
    [w,h] = size(I);
    %normalize
    rhoMax = sqrt(w^2+h^2);
    rho = (-rhoMax:1:rhoMax);
    theta = (0:pi/360:pi);
    thetaSize = length(theta);
    %prepare empty hough array
    hough = zeros(length(rho),length(thetaSize));
    %parameters for accumulator array
    [xI,yI] = find(I);
    accuSize = length(xI);
    accu = zeros(accuSize,thetaSize);
    
    cosine = (0:w-1)'*cos(theta);
    sine = (0:h-1)'*sin(theta); 
    accu((1:accuSize),:) = cosine(xI,:) + sine(yI,:);
    
    for i = (1:thetaSize)
        hough(:,i) = hist(accu(:,i),rho);
    end  
    
end
    
    