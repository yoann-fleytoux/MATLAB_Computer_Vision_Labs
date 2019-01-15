function [Ix,Iy,It] = partialDerivatives(Img1, Img2)

for i = 1:size(Img1,1)-1
    for j = 1:size(Img1,2)-1
        Ix(i,j) = 0.25*(Img1(i+1,j)+Img2(i+1,j)+Img1(i+1,j+1)+Img2(i+1,j+1))...
            -0.25*(Img1(i,j)+Img2(i,j)+Img1(i,j+1)+Img2(i,j+1));
        
        Iy(i,j) = 0.25*(Img1(i,j+1)+Img2(i,j+1)+Img1(i+1,j+1)+Img2(i+1,j+1))...
            -0.25*(Img1(i,j)+Img2(i,j)+Img1(i+1,j)+Img2(i+1,j));
        
        It(i,j) = 0.25*(Img2(i,j)+Img2(i,j+1)+Img2(i+1,j)+Img2(i+1,j+1))...
            -0.25*(Img1(i,j)+Img1(i,j+1)+Img1(i+1,j)+Img1(i+1,j+1));
    end
end

end