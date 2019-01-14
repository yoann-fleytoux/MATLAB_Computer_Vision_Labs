clc
clear all




%%


pe = importdata('Cam_dir_02.ppm');
pd = importdata('Cam_esq_02.ppm');


Pd_02=[90 123; 160 112;130 163;195 154]%;169 205;225 111];
Pe_02=[256 115;337 111;427 112;304 159]%;381 159;339 199];
Pd_05=[88 120;160 114;131 165;198 153]%;173 502;232 502];
Pe_05=[116 163;239 155;343 145;180 217]%;178 330;240 237];

pontos_e=[Pe_02;Pe_05];
pontos_e(:,3)=1
pontos_d=[Pd_02;Pd_05];
pontos_d(:,3)=1

%%
% %Mostrar pontos na imagem direita
% 
 A=imread('Cam_dir_02.ppm');
 A=rgb2gray(A);
% figure(1)
 imshow(A)
% hold on;
% axis image;
% scatter(gca,Pd_02(:,1),Pd_02(:,2));% Cria circulos coloridos nas coordenadas x e y
% set(gcf,'Color','g');
% 
 C=imread('Cam_dir_05.ppm');
 C=rgb2gray(C);
% figure(1)
 imshow(C)
% hold on;
% axis image;
% scatter(gca,Pd_05(:,1),Pd_05(:,2));% Cria circulos coloridos nas coordenadas x e y
% set(gcf,'Color','g');


%%
% %Mostrar pontos na imagem esquerda 
% 
B=imread('Cam_esq_02.ppm');
B=rgb2gray(B);
% figure(2)
imshow(B)
% hold on;
% axis image;
% scatter(gca, Pe_02(:,1), Pe_02(:,2));
% set(gcf,'Color','g');
NO=imread('Cam_esq_05.ppm');
NO=rgb2gray(NO);
% figure(2)
imshow(NO)
% hold on;
% axis image;
% scatter(gca, Pe_02(:,1), Pe_02(:,2));
% set(gcf,'Color','g');

%%
%Calculo dos centro de massa e a sua normalizaçao 
%Calculo das Medias x e y como o se

Centro_dir_02=[mean(Pd_02(:,1)) mean(Pd_02(:,2))];%Calculo das Medias x e y direito

Centro_esq_02=[mean(Pe_02(:,1)) mean(Pe_02(:,2))];%Calculo das Medias x e y esquerdo

Centro_esq_05=[mean(Pe_05(:,1)) mean(Pe_05(:,2))];

Centro_dir_05=[mean(Pd_05(:,1)) mean(Pd_05(:,2))];
%Distancia dos pontos ao centro

dist_med_dir_02 = mean(sqrt((Pd_02(:,1)-Centro_dir_02(1)).^2 + (Pd_02(:,2)-Centro_dir_02(2)).^2)) / sqrt(2);

dist_med_esq_02 = mean(sqrt((Pe_02(:,1)-Centro_esq_02(1)).^2 + (Pe_02(:,2)-Centro_esq_02(2)).^2)) / sqrt(2);

dist_med_dir_05 = mean(sqrt((Pd_05(:,1)-Centro_dir_05(1)).^2 + (Pd_05(:,2)-Centro_dir_05(2)).^2)) / sqrt(2);

dist_med_esq_05 = mean(sqrt((Pe_05(:,1)-Centro_esq_05(1)).^2 + (Pe_05(:,2)-Centro_esq_05(2)).^2)) / sqrt(2);
%%
%Obtençao das Transformaçoes 



Td_02=[1/dist_med_dir_02 0 -Centro_dir_02(1)/dist_med_dir_02;
    0 1/dist_med_dir_02 -Centro_dir_02(2)/dist_med_dir_02;
    0 0 1];

Te_02=[1/dist_med_esq_02 0 -Centro_esq_02(1)/dist_med_esq_02;
    0 1/dist_med_esq_02 -Centro_esq_02(2)/dist_med_esq_02;
    0 0 1];

Td_05=[1/dist_med_dir_05 0 -Centro_dir_05(1)/dist_med_dir_05;
    0 1/dist_med_dir_05 -Centro_dir_05(2)/dist_med_dir_05;
    0 0 1];

Te_05=[1/dist_med_esq_05 0 -Centro_esq_05(1)/dist_med_esq_05;
    0 1/dist_med_esq_05 -Centro_esq_05(2)/dist_med_esq_05;
    0 0 1];

%Acrescentar coluna de 1s (coordenadas homogeneas) e transformar

pdch=(Td_02*[Pd_02 ones(size(Pd_02,1),1)]')';
pech=(Te_02*[Pe_02 ones(size(Pe_02,1),1)]')';
pdch_05=(Td_05*[Pd_05 ones(size(Pd_02,1),1)]')';
pech_05=(Te_05*[Pe_05 ones(size(Pd_02,1),1)]')';

%%
%Matriz fundamental
%sistema de equaçoes  A=UDV'
%construir a matriz A



for i = 1 : length(pech)
    
   K(i,:) = [pech(i,1)*pdch(i,1) pdch(i,1)*pech(i,2) pdch(i,1) pdch(i,2)*pech(i,1) pdch(i,2)*pech(i,2) pdch(i,2) pech(i,1) pech(i,2) 1 ];
   
end


[U,D,V] = svd(K);% decompor K

[Value index]=min(sum(D));

Fc=reshape(V(:,index),3,3);

%%
%Fc=Uc.Dc.Vc'

[U D V]=svd(Fc);

%%
%Coluna do Menor valor de D=0;
[Value index]=min(sum(D));
Dc(:,index)=0;

%%
%Fn=UDV
Fn=U*D*V';

%%
%F " desnormalizada"

F=Td_02*Fn*Te_02


%%
%PARTE 1
%EPIPOLOS

[U D V]=svd(F);
[values index]=min(sum(D));

%%
%Epipolo Direito

Epipolo_d=U(:,index);
Epipolo_d=Epipolo_d./Epipolo_d(3);


Epipolo_e=V(:,index);
Epipolo_e=Epipolo_e./Epipolo_e(3);


%% 3 - Representacao das rectas epipolares

%Direita 02
figure
imshow(A);
hold;
plot(pontos_d(1:4,1),pontos_d(1:4,2),'b+');
plot([Epipolo_d(1); pontos_d(1,1)],[Epipolo_d(2); pontos_d(1,2)],'g-');
plot([Epipolo_d(1); pontos_d(2,1)],[Epipolo_d(2); pontos_d(2,2)],'g-');
plot([Epipolo_d(1); pontos_d(3,1)],[Epipolo_d(2); pontos_d(3,2)],'g-');
plot([Epipolo_d(1); pontos_d(4,1)],[Epipolo_d(2); pontos_d(4,2)],'g-');
plot(Epipolo_d(1),Epipolo_d(2),'rx');
title('Direita_02');

%Direita 05
figure
imshow(C);
hold;
plot(pontos_d(5:8,1),pontos_d(5:8,2),'b+');
plot([Epipolo_d(1); pontos_d(5,1)],[Epipolo_d(2); pontos_d(5,2)],'g-');
plot([Epipolo_d(1); pontos_d(6,1)],[Epipolo_d(2); pontos_d(6,2)],'g-');
plot([Epipolo_d(1); pontos_d(7,1)],[Epipolo_d(2); pontos_d(7,2)],'g-');
plot([Epipolo_d(1); pontos_d(8,1)],[Epipolo_d(2); pontos_d(8,2)],'g-');
plot(Epipolo_d(1),Epipolo_d(2),'rx');
title('Direita_05');

%Esquerda 02
figure
imshow(B);
hold;
plot(pontos_e(1:4,1),pontos_e(1:4,2),'b+');
plot([Epipolo_e(1); pontos_e(1,1)],[Epipolo_e(2); pontos_e(1,2)],'g-');
plot([Epipolo_e(1); pontos_e(2,1)],[Epipolo_e(2); pontos_e(2,2)],'g-');
plot([Epipolo_e(1); pontos_e(3,1)],[Epipolo_e(2); pontos_e(3,2)],'g-');
plot([Epipolo_e(1); pontos_e(4,1)],[Epipolo_e(2); pontos_e(4,2)],'g-');
plot(Epipolo_e(1),Epipolo_e(2),'rx');
title('Esquerda_02');

%Esquerda 05

figure
imshow(NO);
hold;
plot(pontos_e(5:8,1),pontos_e(5:8,2),'b+');
plot([Epipolo_e(1); pontos_e(5,1)],[Epipolo_e(2); pontos_e(5,2)],'g-');
plot([Epipolo_e(1); pontos_e(6,1)],[Epipolo_e(2); pontos_e(6,2)],'g-');
plot([Epipolo_e(1); pontos_e(7,1)],[Epipolo_e(2); pontos_e(7,2)],'g-');
plot([Epipolo_e(1); pontos_e(8,1)],[Epipolo_e(2); pontos_e(8,2)],'g-');
plot(Epipolo_e(1),Epipolo_e(2),'rx');
title('Esquerda_05');




%% Parte 2
%% 
%Determinacao da matriz essencial
K_esq=[1317.2498 0 512.23259; 0 1316.83041 413.07903; 0 0 1];
K_dir=[1312.9489 0 533.80481; 0 1313.02652 397.59032; 0 0 1];
E=K_dir'*F*K_esq;

%% 
%Determinacao das matrizes de rotacao e translacao
W=[0 1 0; -1 0 0;0 0 1];

[Ue,De,Ve] = svd(E);

Aux=[0 -1 0; 1 0 0;0 0 0];

Trans=Ve*Aux*Ve';

Rot = Ue*W*Ve';

%%
%Determinacao das coordenadas 3D dos pontos escolhidos

c_direita=inv(K_esq)*pontos_e';
c_esquerda=inv(K_dir)*pontos_d';

Ze=zeros(8,1);

for n= 1 : 8
    Ze(n)=(Trans(1)-c_direita(1,n)*Trans(3))/(c_esquerda(1,n)*(c_direita(1,n)*Rot(3,1)-Rot(1,1))+  c_esquerda(2,n)*(c_direita(1,n)*Rot(3,2)-Rot(1,2))+Rot(3,3)*c_direita(1,n)-Rot(1,3));
end

Xe=Ze'.*c_esquerda(1,:);
Ye=Ze'.*c_esquerda(2,:);

figure
plot3(Xe(1:4),Ye(1:4), Ze(1:4), 'rx',Xe(5:8),Ye(5:8), Ze(5:8), 'bo');
grid on
xlabel('X - s.c. da camara esquerda')
ylabel('Y - s.c. da camara esquerda')
zlabel('Z - s.c. da camara esquerda')

