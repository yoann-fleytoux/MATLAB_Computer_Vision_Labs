function[H,teta,rho] = rHough(BW)
%Iniciar o array acumulador
s = size(BW);
xMax = s(2);
yMax = s(1);
d = sqrt(yMax^2 + xMax^2);
rho = zeros([1 round(d)]);
teta = 0:1:179;
H = zeros([length(rho),length(teta)]);
%examinar cada ponto (xi,yi) da imagem e determinar cada P e teta que esse
%ponto pode ter

I = edge(BW,'canny'); %edge detection

for i = 1:yMax
    for j = 1:xMax
        if(I(i,j)~= 0)
        %calcular r
            r = sqrt(i^2 + j^2);
            %calcular Ró
            rho = abs(r*cos((atan(i/j)-deg2rad(teta))));  %calcular os valores de Ró
            rho = round(rho);
            for k = 1:length(rho);
                if rho(k) == 0    %é necessário porque o MATLAB não aceita índices iguais a zero
                    rho(k) = 1;
                end
                H(rho(k),teta(k)+1) = H(rho(k),teta(k)+1)+1; %votação
            end
        end
    end
end