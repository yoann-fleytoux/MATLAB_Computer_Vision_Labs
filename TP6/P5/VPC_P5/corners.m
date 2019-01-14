% y=corners(I,n)  Recebe como parâmetros a imagem I e o inteiro n (Vizinhança nxn) e devolve
% os cantos na imagem I. n deve ser um número ímpar maior ou igual a 3.
%
function y=corners(I,n)

n2=floor(n/2);

sigma=100000;

MASKSOBEL=fspecial('sobel');

sobely=conv2(I,MASKSOBEL); %Gradiente que da enfase as arestas horizontais
sobelx=conv2(I,MASKSOBEL');%Gradiente que da enfase as arestas verticais

tamanho=size(I);

L=[];%inizialização da lista L


for i=n2+1:(tamanho(1,1)-(n2+1))%Percorre as linhas
    for j=n2+1:(tamanho(1,2)-(n2+1)) %Percorre as colunas

       Ix=sobelx(i-n2:i+n2,j-n2:j+n2);%Define a matriz da vizinhança nxn Ix, a partir da imagem do gradiente Sobelx
       Iy=sobely(i-n2:i+n2,j-n2:j+n2);%Define a matriz da vizinhança nxn Ix, a partir da imagem do gradiente Sobely
       
       
       %Criação da matriz C
     
       c11=sum(sum(Ix.^2));
       c22=sum(sum(Iy.^2));
       c=sum(sum(Ix.*Iy));
        
       C=[c11 c; c c22];
        %%%%%%%%%%%%%%%%%%%%
       
        E=eig(C);   %Valores proprios de C
   
        l2=min(E);%l2 é o minimo dos valores proprios de C
       
         if(l2>sigma)   
          L=[L; l2 j i]; %Se l2 for maior que o limiar os valores calculados passam a fazer parte da lista  
         end
        
    end
end
       

%Ordenar a lista L

         [Ls Index]=sort(L(:,1),1,'descend');
         Ln=[Ls, L(Index,2:3)];
               
 
%Vamos percorrer a lista no sentido descendente e eliminar os pontos na sua
%vizinhança
%Os pontos que não pertençam à vizinhança de qualquer ponto da lista de
%saida sao adicionados a lista de saida Lo

[s t]=size(L);

f=1; % garante a entrada no ciclo while
Lo=[];

     while(f<s) 
        Lo=[Lo; Ln(f,:)];
        Lx=Ln(:,2);
        Ly=Ln(:,3);
        x=Ln(f,2);
        y=Ln(f,3);

        ex=Lx<=x+n & Lx>=x-n;
        ey=Ly<=y+n & Ly>=y-n;
        e=ex & ey;    
        Ln(e,:)=[];

        if(e(f)==0)
            f=f+1;
        end

        s=size(Ln);
        s=s(1);

     end
 
  y=Lo;
end       

        