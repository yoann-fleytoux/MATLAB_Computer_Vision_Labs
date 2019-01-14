%% Trabalho Pratico 5 visao por computador
%  Trabalho realizado por: Hugo Andr? Domingues Paiva 2008119774
%                          Jo?o Francisco Miraldo G?is 2008111452 
clc, clear all, close all



Iesq_02=imread('Cam_esq_02.ppm');
Idir_02=imread('Cam_dir_02.ppm');
Iesq_05=imread('Cam_esq_05.ppm');
Idir_05=imread('Cam_dir_05.ppm');


%% Retirar novos Pontos
%%%%%%%%%%%%% Imagem 02


imshow(Iesq_02);
title('Imagem camera esquerda 02')
[xesq_02, yesq_02]=getpts;
Pesq_02=[xesq_02, yesq_02];
figure;
imshow(Idir_02);
title('Imagem camera direita 02')
[xdir_02, ydir_02]=getpts;
Pdir_02=[xdir_02, ydir_02];

%%%%%%%%%%% Imagem 05:

imshow(Iesq_05);
title('Imagem camera esquerda 05')
[xesq_05, yesq_05]=getpts;
pesq_05=[xesq_05, yesq_05];
figure;

imshow(Idir_05);
title('Imagem camera direita 05')
[xdir_05, ydir_05]=getpts;
pdir_05=[xdir_05, ydir_05];

Pdir=[Pdir_02; pdir_05];
Pesq=[Pesq_02; pesq_05];
% save('Pdir.txt','Pdir','-ASCII');
% save('Pesq.txt','Pesq', '-ASCII');

%% Pontos retirados anteriormente em cada imagem
        
Pdir_02=load('Pdir_02.txt');
pdir_05=load('pdir_05.txt');
Pesq_02=load('Pesq_02.txt');
pesq_05=load('pesq_05.txt');
Pdir=[Pdir_02; pdir_05];
Pesq=[Pesq_02; pesq_05];

%%
%considerando os pontos de uma imagem pi=[xi yi 1]
Pdir(:,3)=1;
Pesq(:,3)=1;

%%%% Pontos escolhidos na imagem 02(pontos a azul) e na imagem 05 (pontos a vermelho)
figure
imshow(Idir_02)
title('Imagem camera 2 lado direito')
hold
plot(Pdir_02(:,1),Pdir_02(:,2),'bs');
figure
imshow(Iesq_02)
title('Imagem camera 2 lado esquerdo')
hold on
plot(Pesq_02(:,1), Pesq_02(:,2), 'bs');

figure
imshow(Idir_05)
title('Imagem camera 5 lado direito')
hold
plot(pdir_05(:,1),pdir_05(:,2),'rs');
figure
imshow(Iesq_05)
title('Imagem camera 5 lado esquerdo')
hold on
plot(pesq_05(:,1), pesq_05(:,2), 'rs');


%% Exercicio 1, Estimar a Matriz Fundamental atravez do algoritmo dos 8 pontos
close all;
% 1? ponto normalizar coordenadas

% Para os pontos escolhidos na imagem esquerda  e calculado o centro de
% massa


[Pdir_norm, Pesq_norm,Te,Td]=normaliza(Pdir, Pesq);
[lesq cesq]=size(Pesq);;

%% Calculo da Matriz Fundamental
F=Fundamental(Pdir_norm, Pesq_norm, Te, Td)

% Matriz fica assim com car=2 como pretendido
car=rank(F)

%% Exercicio 2
% Determina?ao dos Epipolos: epipolo esquerdo corresponde ao espa?o nulo da
% MAtriz F e o epipolo direito corresponde ao espa?o nulo da Matriz F'

epipolo_esq=null(F,'r')
epipolo_dir=null(F','r')


%%%% Epipolos e retas epipolares correspondentes  imagem 2 camera direita
figure
plot(epipolo_dir(1), epipolo_dir(2),'b*')
hold
imshow(Idir_02);
title('Imagem 2 camera direita')
hold on
for i=1:(lesq/2)
    
    plot(Pdir(i,1),Pdir(i,2),'ro');
      retaepipolar_dir_02=line([epipolo_dir(1) Pdir(i,1)],[epipolo_dir(2) Pdir(i,2)]);
        set(retaepipolar_dir_02,'Color','b');
end

%%%% Epipolos e retas epipolares corresnpodentes imagem 2 camera esquerda
figure
plot(epipolo_esq(1), epipolo_esq(2), 'b*')
hold
imshow(Iesq_02);
title('Imagem 2 camera esquerda')
hold on

for i=1:(lesq/2)
    plot(Pesq(i,1), Pesq(i,2) ,'ro')
    retaepipolar_esq_02=line([epipolo_esq(1) Pesq(i,1)],[epipolo_esq(2) Pesq(i,2)]);
    set(retaepipolar_esq_02, 'color', 'b');
    
end


%%%%%% Epipolos e retas epipolares correspondentes imagem 5 camera esquerda
figure
plot(epipolo_esq(1), epipolo_esq(2), 'b*')
hold
imshow(Iesq_05);
title('Imagem 5 camera esquerda')
hold on

for i=(floor(lesq/2)+1):lesq
    plot(Pesq(i,1), Pesq(i,2) ,'ro')
    retaepipolar_esq_05=line([epipolo_esq(1) Pesq(i,1)],[epipolo_esq(2) Pesq(i,2)]);
    set(retaepipolar_esq_05, 'color', 'b');
    
end
%%%%%% Epipolos e retas epipolares correspondentes imagem 5 camera direita
figure
plot(epipolo_dir(1), epipolo_dir(2), 'b*')
hold
imshow(Idir_05);
title('Imagem 5 camera direita')
hold on

for i=(floor(lesq/2)+1):lesq
    plot(Pdir(i,1), Pdir(i,2) ,'ro')
    retaepipolar_dir_05=line([epipolo_dir(1) Pdir(i,1)],[epipolo_dir(2) Pdir(i,2)]);
    set(retaepipolar_dir_05, 'color', 'b');
    
end


for i=1:lesq
    Precisao(i)=Pesq_norm(i,:)*F*Pdir_norm(i,:)';
end

Max=max(Precisao);
Min=min(Precisao);
Media=mean(Precisao);

PrecisaoFundamental=max(Media-Min, Max-Media);
disp('Precis?o da matriz fundamental:');
disp(PrecisaoFundamental);

%% Parte 2

Kesq=[1317.24980 0 512.23259; 0 1316.83041 413.07903; 0 0 1];

Kdir=[1312.94890 0 533.80481; 0 1313.02652 397.59032; 0 0 1];


%Ponto 5: Determinar a Matriz essencial

% Como F=(Kd^-T)*E*Ke^1, a Matriz essencial e dada por E=(Kd^T)*F*Ke

E=Kdir'*F*Kesq

% Calculo da Matriz rota?ao e transla?ao
[U S V]=svd(E);
W=[0 -1 0;1 0 0;0 0 1];
R=U*W*V'
R_linha=U*W'*V'

Cdir_1=[R +U(:,3)];
Cdir_2=[R -U(:,3)];
Cdir_3=[R_linha +U(:,3)];
Cdir_4=[R_linha -U(:,3)];

% Transla?ao e angulos que caracterizam o movimento da Camera
t=Cdir_2(:,4) 

[alfa,beta,gama]=RollPichYawinverse(R);


%% Reconstru?ao 3D

Pesq_n=inv(Kesq)*Pesq';%normaliza?ao de coordenadas
Pdir_n=inv(Kdir)*Pdir';
Z=zeros(lesq,1);

for n= 1 : lesq
    Z(n)=(t(1)-Pdir_n(1,n)*t(3))/(Pesq_n(1,n)*(Pdir_n(1,n)*R(3,1)-R(1,1))+Pesq_n(2,n)*(Pdir_n(1,n)*R(3,2)-R(1,2))+R(3,3)*Pdir_n(1,n)-R(1,3));
end
X=Z'.*Pesq_n(1,:);
Y=Z'.*Pesq_n(2,:);
figure
plot3(X(1:lesq/2),Z(1:lesq/2),Y(1:lesq/2),'x',X((lesq/2)+1:lesq),Z((lesq/2)+1:lesq),Y((lesq/2)+1:lesq),'rx');





