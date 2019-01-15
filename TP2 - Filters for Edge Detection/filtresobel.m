function [Gligne,Gcolonne,G] = filtreSobel(I,T)
filtreLigne = [-1 0 1;-2 0 2;-1 0 1];
filtreColonne = [-1 -2 -1;0 0 0;1 2 1];
Gligne = [];
Gcolonne = [];
for i=2:size(I,1)-1
    for j=2:size(I,2)-1
        partI = I(i-1:i+1,j-1:j+1);
        Gligne(i-1,j-1) = convolution(partI,filtreLigne);
        Gcolonne(i-1,j-1) = convolution(partI,filtreColonne);
    end
end
G = abs(Gligne)+abs(Gcolonne);

Sobel = edge(imbinarize(G,T),'Sobel')
imshow(Sobel)

end



