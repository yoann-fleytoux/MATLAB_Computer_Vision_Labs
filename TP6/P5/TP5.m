%Visão por Computador_Trabalho Prático5
clc,
clear all

%% ESTIMAÇÃO DA MATRIZ FUNDAMENTAL, DA MATRIZ ESSENCIAL
%% 1ªParte

%DETECÇÂO E VISUALIZAÇÂO DOS CANTOS NUMA IMAGEM REAL
Cam_dir_02=imread('Cam_dir_02.ppm');
Cam_esq_02=imread('Cam_esq_02.ppm');
Cam_dir_05=imread('Cam_dir_05.ppm');
Cam_esq_05=imread('Cam_esq_05.ppm');
% %Leitura da imagem e conversão em níveis de cinzento
Cam_dir_02_gray=rgb2gray(Cam_dir_02);
Cam_esq_02_gray=rgb2gray(Cam_esq_02);
% 
Cam_dir_05_gray=rgb2gray(Cam_dir_05);
Cam_esq_05_gray=rgb2gray(Cam_esq_05);
% 
%Conjuntos de cantos para vizinhanças  5x5 respectivamente.
[Pontos_dir2]=corners(Cam_dir_02_gray,5);
[Pontos_esq2]=corners(Cam_esq_02_gray,5);
[Pontos_dir5]=corners(Cam_dir_05_gray,5);
[Pontos_esq5]=corners(Cam_esq_05_gray,5);

%Visualização dos cantos para vizinhanças 5x5

figure('name','Cantos,imagem direita')
imshow(Cam_dir_02);         
hold on
plot(Pontos_dir2(:,2),Pontos_dir2(:,3),'red +');     
title('Imagem direita (2)');

figure('name','Cantos,imagem esquerda')
imshow(Cam_esq_02);         
hold on
plot(Pontos_esq2(:,2),Pontos_esq2(:,3),'red +');     
title('Imagem Esquerda (2)');

figure('name','Cantos,imagem direita')
imshow(Cam_dir_05);         
hold on
plot(Pontos_dir5(:,2),Pontos_dir5(:,3),'red +');     
title('Imagem direita (5)');

figure('name','Cantos,imagem esquerda')
imshow(Cam_esq_05);         
hold on
plot(Pontos_esq5(:,2),Pontos_esq5(:,3),'red +');     
title('Imagem Esquerda (5)');
%% IMAGEM 1
%%  Preparação
% %Leitura dos pontos
p=load('Ad_e.pts');
%pontos da esquerda
pleft=[p(:,3) p(:,4)]; 
yl=p(:,4);
xl=p(:,3);
%pontos da direita
pright=[p(:,1) p(:,2)]; 
yr=p(:,2);
xr=p(:,1);

[n s]=size(pleft);

figure('name','Pontos seleccionados,imagem direita2')
imshow(Cam_dir_02);         
hold on
plot(pright((n/2)+1:n,1),pright((n/2)+1:n,2),'red +');     
title('direita2');

figure('name','Pontos seleccionados,imagem esquerda2')
imshow(Cam_esq_02);         
hold on
plot(pleft((n/2)+1:n,1),pleft((n/2)+1:n,2),'red +');     
title('Esquerda2');

figure('name','Pontos seleccionados,imagem direita5')
imshow(Cam_dir_05);         
hold on
plot(pright(1:n/2,1),pright(1:n/2,2),'red +');     
title('direita5');

figure('name','Pontos seleccionados,imagem esquerda5')
imshow(Cam_esq_05);         
hold on
plot(pleft(1:n/2,1),pleft(1:n/2,2),'red +');     
title('Esquerda5');

% Matriz Fundamental
%% Normalizaçao
%% 1) Normalização das coordenadas
pe=[xl(:) yl(:) ones(n,1)];
pd=[xr(:) yr(:) ones(n,1)];

% centros de massa
cxe=sum(pe(:,1))/n
cye=sum(pe(:,2))/n
cxd=sum(pd(:,1))/n
cyd=sum(pd(:,2))/n

de=0;
dd=0;

% distancia ao centro de massa
for i=1:n
    de=de+sqrt((pe(i,1)-cxe)^2+(pe(i,2)-cye)^2);
    dd=dd+sqrt((pd(i,1)-cxd)^2+(pd(i,2)-cyd)^2); 
end
de=de/(n*sqrt(2))
dd=dd/(n*sqrt(2))

% normalização e centralização no centro de massa
Te=[1 0 -cxe
    0 1 -cye
    0 0  de];
Td=[1 0 -cxd
    0 1 -cyd
    0 0  dd];
pen=(Te*pe'/de)';
pdn=(Td*pd'/dd)';



xen=pen(:,1);
yen=pen(:,2);
xdn=pdn(:,1);
ydn=pdn(:,2);

%%
%% 2) Construção do sistema de equações homogéneo
um=ones(n,1);
display 'Matriz A'
A= [xen(:).*xdn(:) xdn(:).*yen(:) xdn(:) xen(:).*ydn(:) yen(:).*ydn(:) ydn(:) xen(:) yen(:) um(:)];
 % Decomposição em valores singulares
[U D V]=svd(A);

%% 3) Elementos de F^ (a menos de um factor de escala))
diagonal=diag(D);
[valor indice]=min(diagonal);
Fc=[V(1:3,indice)';V(4:6,indice)';V(7:9,indice)'];
%% 4) & 5) Restrição da característica ( car(F^)=2 )
[U D V]=svd(Fc);
diagonal=diag(D);
[valor indice]=min(diagonal);
D(indice,indice)=0;
%% 6) Cálculo da nova matriz F

Fl=U*D*V';
%% 7) Desnormalização
display 'Matriz Fundamental'
F=Td'*Fl*Te

%% epipolós
%% 1) Decomposição de F em valores singulares
[U D V]=svd(F);

diagonal=diag(D);
[valor indx]=min(diagonal);

%% 2) % Cálculo do epipólo esquerdo
epe=V(:,indx);
epe=epe/epe(3)

%% 3) % Cálculo do epipólo direito
epd=U(:,indx);
epd=epd/epd(3)



%% Representação dos epipólos e rectas epipolares nas imagens
figure('name','rectas epipolares e epipolos imagem1')
subplot(1,2,1) ,plot(epe(1),epe(2),'r.','MarkerSize',25)
hold on, imshow(Cam_esq_02), hold on
for i=36:n
    plot([epe(1) pe(i,1)],[epe(2) pe(i,2)])
    plot(pe(i,1),pe(i,2),'r.','MarkerSize',4)
end
title('Rectas epipolares e o epipólo esquerdo I1','Fontsize',20)

subplot(1,2,2) ,plot(epd(1),epd(2),'r.','MarkerSize',25)
hold on, imshow(Cam_dir_02), hold on
for i=36:n
    plot([epd(1) pd(i,1)],[epd(2) pd(i,2)])
    plot(pd(i,1),pd(i,2),'r.','MarkerSize',4)
end
title('Rectas epipolares e o epipólo direito I1','Fontsize',20)

figure('name','rectas epipolares e epipolos imagem2')
subplot(1,2,1) ,plot(epe(1),epe(2),'r.','MarkerSize',25)
hold on, imshow(Cam_esq_05), hold on
for i=1:35
    plot([epe(1) pe(i,1)],[epe(2) pe(i,2)])
    plot(pe(i,1),pe(i,2),'r.','MarkerSize',4)
end
title('Rectas epipolares e o epipólo esquerdo I2','Fontsize',20)

subplot(1,2,2) ,plot(epd(1),epd(2),'r.','MarkerSize',25)
hold on, imshow(Cam_dir_05), hold on
for i=1:35
    plot([epd(1) pd(i,1)],[epd(2) pd(i,2)])
    plot(pd(i,1),pd(i,2),'r.','MarkerSize',4)
end
title('Rectas epipolares e o epipólo direito I2','Fontsize',20)


%% PARTE 2

Kdir=[1312.94890 0 533.80481;0 1313.02652 397.59032;0 0 1;];
Kesq=[1317.24980 0 512.23259;0 1316.83041 413.07903;0 0 1;];

%Calculo da matriz essencial
%F=kd'^-1*E*ke^-1
display 'Matrix essencial'
E=(Kdir)'*F*(Kesq)

W=[0 -1 0;1 0 0;0 0 1];

% Calculo da Matriz rota?ao e transla?ao
[U S V]=svd(E);
W=[0 -1 0;1 0 0;0 0 1];
%Soluções admissiveis
RT_1=[U W V' U(:,3)]
RT_2=[U W V' -U(:,3)]
RT_3=[U W' V' U(:,3)]
RT_4=[U W' V' -U(:,3)]
display 'Matriz Rotação'
R=U*W*V'
T=U(:,3);

%% Reconstru?ao 3D

Pe_n=inv(Kesq)*pe';%normaliza?ao de coordenadas
Pd_n=inv(Kdir)*pd';
Z=zeros(n,1);

for i= 1 : n
    Z(i)=(T(1)-Pd_n(1,i)*T(3))/(Pe_n(1,i)*(Pd_n(1,i)*R(3,1)-R(1,1))+Pe_n(2,i)*(Pd_n(1,i)*R(3,2)-R(1,2))+R(3,3)*Pd_n(1,i)-R(1,3));
end
X=Z'.*Pe_n(1,:);
Y=Z'.*Pe_n(2,:);

figure('name','Reconstrução 3D imagem')
plot3(X(1:n/2),Y(1:n/2), Z(1:n/2), 'r+',X((n/2)+1:n),Y(((n/2)+1):n), Z(((n/2)+1):n), 'gx');
grid on
xlabel('X - s.c. da camara esquerda')
ylabel('Y - s.c. da camara esquerda')
zlabel('Z - s.c. da camara esquerda')