function [C] = convolution(A,B)
C = 0;
lim = size(A,1);
for i=1:lim
    for j=1:lim
        xA = A(i,j);
        xB = B((lim-i+1),(lim-j+1));
        C = C + xA*xB;
    end
end
end

