clc, clear all, close all
I=imread('hough_lines_circles.bmp');


display 'Tamanho da Matriz'
S=size(I);
Colunas=S(1); Linhas=S(2);

%rho
display 'Rho min/max'
rho_min=0;
rho_max=100

%th
display 'th min/max'
th_min=pi/4;
th_max=pi/2;

%Incremento
display 'Incremento'
th_d=0.01

%Contador
%A(th,rho)
Ax=ceil((pi/2)/0.01);
Ay=10*Ax;
A=zeros(Ax,Ay);

imshow(I)
hold on

for x=1:Colunas
    for y=1:Linhas
        if( I(x,y)==1)
            plot(x,y,'yo')
            hold on
            for th=th_min:(th_max-th_min)/Ax:th_max
                %Percorre th da matriz de acumulação
                
                rho=y*sin(th)+x*cos(th);
                
                
                
                if(rho<=rho_max && rho>=rho_min && th>=th_min && th<=th_max)
                    
                    ya=(Ay-1)*(rho-rho_min)/(rho_max-rho_min); xa=(Ax-1)*(th-th_min)/(th_max-th_min);
                    ya=round(ya); xa=round(xa);
                    A(xa+1, ya+1)=A(xa+1, ya+1)+1;
                    
                    
                end
            end
            end
        end
    end



N=20;%Garante a entrada no ciclo



rhoout=[];
thout=[];
a=[];
b=[];

A1=A;


%  for rho=1:roh_max
%  	for coluna=2:Ax-1
%        
%         if( A1(coluna,linha)>A1(coluna-1,linha-1) && A1(coluna,linha)>A1(coluna,linha-1) && A1(coluna,linha)>A1(coluna+1,linha+1) && A1(coluna,linha)>A1(coluna-1,linha) && A1(coluna,linha)>A1(coluna+1,linha) && A1(coluna,linha)>A1(coluna-1,linha+1) && A1(coluna,linha)>A1(coluna,linha+1) && A1(coluna,linha)>A1(coluna+1,linha+1) && A1(coluna,linha)>N)
%         
%             rho=(rho_max*coluna)/Ay;
%             th=th_d*linha;
%             
%               a=[a;-cos(th)/sin(th)];
%               b=[b;rho/sin(th)];
% 
%             rhoout=[rhoout; rho];
%             thout=[thout; th]; 
%         end
%     end
%        
%  end
 
% 
% Theta=0:th_d:pi/2;
% coseno=cosd(Theta);
% seno=sind(Theta);
% 
% for rho=1:round((Linhas^2+Colunas^2)) % Ró = Diagonal da Imagem
%     for theta=1:th_max/th_d;
%         if(A(rho,theta)>N)
%             %recta y=m*x+b
%              y=((rho-1)-x*coseno(theta))/seno(theta); %calcula y=[y1 y2]        
%              m2 = -(x(2)-x(1))/(y(2)-y(1)); %x=0;
%              m = [m m2];
%              b = [b x(1)-m2*y(1)];
% %              if y(2)>l
% %                  y(2)=l;
% %              end
%              
%              plot(y,x,'-r');
%         end
%     end
% end
%  
% x=1:Colunas;
% for R=1:Ay
%     for T=1:Ax
%         if(A1(T,R)>N)
%             
%             rho=(rho_max*R)/Ay;
%             theta=th_d*T;
%             
%             y=((rho-1)-x*cosd(theta))/sind(theta); 
%             plot(y,x,'-r');
%         end
%     end
% end


while(N>=20)
    
    [M, L]=max(A1);%Extrai um vector linha com as linhas em que o maximo ocorre em cada coluna
    [N, C]=max(M);%Extrai a coluna em que o maximo ocorre

    c=C; l=L(C);
    A1(l,c)=0;
%Definição da reta:
%Equações que converte os indices da matriz de acumulação para parametros
%de recta

rho=(rho_max*c)/Ay;

th=th_d*l;
x=1:200;
% y=((rho-1)-x*cosd(th))/sind(th); 

rhoout=[rhoout; rho];
thout=[thout; th];

%Mostrar a recta detectada sobreposta a imagem
a=-cos(th)/sin(th);
b=rho/sin(th);

x=1:200;

y=a*x+b;  

plot(x,y)
hold on



%pause


end
            
        
          