close all
clear all
clc

K = [2071.82 0       688.18;
     0       2070.19 571.97;
     0       0       1     ];

Kinv = inv(K);
 
I{1} = imread('imagens/proj_image_5.jpg');
I{2} = imread('imagens/proj_image_6.jpg');
I{3} = imread('imagens/proj_image_7.jpg');

for i=1:3
    figure('Name', num2str(i+4));
    I{i} = imresize(I{i},0.4);
    [imP{i},boardSize{i}] = detectCheckerboardPoints(I{i});
    imshow(I{i}); hold on; 
    %We'll use 4 points even though we detected all
    plot(imP{i}(1,1), imP{i}(1,2), 'ro');
    plot(imP{i}(4,1), imP{i}(4,2), 'ro');
    plot(imP{i}(28,1), imP{i}(28,2), 'ro');
    plot(imP{i}(31,1), imP{i}(31,2), 'ro');
    imP{i}(:,3) = 1;
    norm{i} = imP{i}*Kinv;

%Compute homography between the pics and their normalized version
    
M1norm{i} = [imP{i}(1,1),imP{i}(1,2),1,0,0,0,-imP{i}(1,1)*norm{i}(1,1),-imP{i}(1,2)*norm{i}(1,1);
    0,0,0,imP{i}(1,1),imP{i}(1,2),1,-imP{i}(1,1)*norm{i}(1,2),-imP{i}(1,2)*norm{i}(1,2);
    imP{i}(4,1),imP{i}(4,2),1,0,0,0,-imP{i}(4,1)*norm{i}(4,1),-imP{i}(4,2)*norm{i}(4,1);
    0,0,0,imP{i}(4,1),imP{i}(4,2),1,-imP{i}(4,1)*norm{i}(4,2),-imP{i}(4,2)*norm{i}(4,2);
    imP{i}(28,1),imP{i}(28,2),1,0,0,0,-imP{i}(28,1)*norm{i}(28,1),-imP{i}(28,2)*norm{i}(28,1);
    0,0,0,imP{i}(28,1),imP{i}(28,2),1,-imP{i}(28,1)*norm{i}(28,2),-imP{i}(28,2)*norm{i}(28,2);
    imP{i}(31,1),imP{i}(31,2),1,0,0,0,-imP{i}(31,1)*norm{i}(31,1),-imP{i}(31,2)*norm{i}(31,1);
    0,0,0,imP{i}(31,1),imP{i}(31,2),1,-imP{i}(31,1)*norm{i}(31,2),-imP{i}(31,2)*norm{i}(31,2)];

M2norm{i} = [norm{i}(1,1);
    norm{i}(1,2);
    norm{i}(4,1);
    norm{i}(4,2);
    norm{i}(28,1);
    norm{i}(28,2);
    norm{i}(31,1);
    norm{i}(31,2)];

Hnormtemp{i} = inv(M1norm{i}'*M1norm{i})*(M1norm{i}'*M2norm{i});
Hnorm{i} = [Hnormtemp{i}(1:3)';
            Hnormtemp{i}(4:6)';
            Hnormtemp{i}(7:8)' 1];
           
end

%Compute homography between 5&6, 6&7, 5&7
%5&6
M1{1} = [imP{1}(1,1),imP{1}(1,2),1,0,0,0,-imP{1}(1,1)*imP{2}(1,1),-imP{1}(1,2)*imP{2}(1,1);
    0,0,0,imP{1}(1,1),imP{1}(1,2),1,-imP{1}(1,1)*imP{2}(1,2),-imP{1}(1,2)*imP{2}(1,2);
    imP{1}(4,1),imP{1}(4,2),1,0,0,0,-imP{1}(4,1)*imP{2}(4,1),-imP{1}(4,2)*imP{2}(4,1);
    0,0,0,imP{1}(4,1),imP{1}(4,2),1,-imP{1}(4,1)*imP{2}(4,2),-imP{1}(4,2)*imP{2}(4,2);
    imP{1}(28,1),imP{1}(28,2),1,0,0,0,-imP{1}(28,1)*imP{2}(28,1),-imP{1}(28,2)*imP{2}(28,1);
    0,0,0,imP{1}(28,1),imP{1}(28,2),1,-imP{1}(28,1)*imP{2}(28,2),-imP{1}(28,2)*imP{2}(28,2);
    imP{1}(31,1),imP{1}(31,2),1,0,0,0,-imP{1}(31,1)*imP{2}(31,1),-imP{1}(31,2)*imP{2}(31,1);
    0,0,0,imP{1}(31,1),imP{1}(31,2),1,-imP{1}(31,1)*imP{2}(31,2),-imP{1}(31,2)*imP{2}(31,2)];

M2{1} = [imP{2}(1,1);
    imP{2}(1,2);
    imP{2}(4,1);
    imP{2}(4,2);
    imP{2}(28,1);
    imP{2}(28,2);
    imP{2}(31,1);
    imP{2}(31,2)];

Htemp{1} = inv(M1{1}'*M1{1})*(M1{1}'*M2{1});
H{1} = [Htemp{1}(1:3)';
        Htemp{1}(4:6)';
        Htemp{1}(7:8)' 1];
%6&7
M1{2} = [imP{2}(1,1),imP{2}(1,2),1,0,0,0,-imP{2}(1,1)*imP{3}(1,1),-imP{2}(1,2)*imP{3}(1,1);
    0,0,0,imP{2}(1,1),imP{2}(1,2),1,-imP{2}(1,1)*imP{3}(1,2),-imP{2}(1,2)*imP{3}(1,2);
    imP{2}(4,1),imP{2}(4,2),1,0,0,0,-imP{2}(4,1)*imP{3}(4,1),-imP{2}(4,2)*imP{3}(4,1);
    0,0,0,imP{2}(4,1),imP{2}(4,2),1,-imP{2}(4,1)*imP{3}(4,2),-imP{2}(4,2)*imP{3}(4,2);
    imP{2}(28,1),imP{2}(28,2),1,0,0,0,-imP{2}(28,1)*imP{3}(28,1),-imP{2}(28,2)*imP{3}(28,1);
    0,0,0,imP{2}(28,1),imP{2}(28,2),1,-imP{2}(28,1)*imP{3}(28,2),-imP{2}(28,2)*imP{3}(28,2);
    imP{2}(31,1),imP{2}(31,2),1,0,0,0,-imP{2}(31,1)*imP{3}(31,1),-imP{2}(31,2)*imP{3}(31,1);
    0,0,0,imP{2}(31,1),imP{2}(31,2),1,-imP{2}(31,1)*imP{3}(31,2),-imP{2}(31,2)*imP{3}(31,2)];

M2{2} = [imP{3}(1,1);
    imP{3}(1,2);
    imP{3}(4,1);
    imP{3}(4,2);
    imP{3}(28,1);
    imP{3}(28,2);
    imP{3}(31,1);
    imP{3}(31,2)];

Htemp{2} = inv(M1{2}'*M1{2})*(M1{2}'*M2{2});
H{2} = [Htemp{2}(1:3)';
        Htemp{2}(4:6)';
        Htemp{2}(7:8)' 1];

%5&7
M1{3} = [imP{1}(1,1),imP{1}(1,2),1,0,0,0,-imP{1}(1,1)*imP{3}(1,1),-imP{1}(1,2)*imP{3}(1,1);
    0,0,0,imP{1}(1,1),imP{1}(1,2),1,-imP{1}(1,1)*imP{3}(1,2),-imP{1}(1,2)*imP{3}(1,2);
    imP{1}(4,1),imP{1}(4,2),1,0,0,0,-imP{1}(4,1)*imP{3}(4,1),-imP{1}(4,2)*imP{3}(4,1);
    0,0,0,imP{1}(4,1),imP{1}(4,2),1,-imP{1}(4,1)*imP{3}(4,2),-imP{1}(4,2)*imP{3}(4,2);
    imP{1}(28,1),imP{1}(28,2),1,0,0,0,-imP{1}(28,1)*imP{3}(28,1),-imP{1}(28,2)*imP{3}(28,1);
    0,0,0,imP{1}(28,1),imP{1}(28,2),1,-imP{1}(28,1)*imP{3}(28,2),-imP{1}(28,2)*imP{3}(28,2);
    imP{1}(31,1),imP{1}(31,2),1,0,0,0,-imP{1}(31,1)*imP{3}(31,1),-imP{1}(31,2)*imP{3}(31,1);
    0,0,0,imP{1}(31,1),imP{1}(31,2),1,-imP{1}(31,1)*imP{3}(31,2),-imP{1}(31,2)*imP{3}(31,2)];

M2{3} = [imP{3}(1,1);
    imP{3}(1,2);
    imP{3}(4,1);
    imP{3}(4,2);
    imP{3}(28,1);
    imP{3}(28,2);
    imP{3}(31,1);
    imP{3}(31,2)];

Htemp{3} = inv(M1{3}'*M1{3})*(M1{3}'*M2{3});
H{3} = [Htemp{3}(1:3)';
        Htemp{3}(4:6)';
        Htemp{3}(7:8)' 1];
    
%Verification
%a)
Hnorm{2}*inv(Hnorm{1});%=H{1}
%b)
Hnorm{3}*inv(Hnorm{2});%=H{2}
%c)
H{2}*H{1};%=H{3}

%The normalized ones seem wrong

%Single value decompositions
for i=1:3
    s{i} = svd(H{i});
    sNorm{i} = svd(Hnorm{i});
    H{i} = H{i}./s{i}(2);
    Hnorm{i} = Hnorm{i}./sNorm{i}(2);
end

%Singular value decompositions of normalized homographs
for i=1:3
    [U{i} S{i} V{i}] = svd(H{i});
    sLine{i} = diag(S{i});
    [Un{i} Sn{i} Vn{i}] = svd(Hnorm{i});
    sLineN{i} = diag(Sn{i});

    u1{i} = ((sqrt(1-sLine{i}(3))*V{i}(:,1))+sqrt(sLine{i}(1)-1)*V{i}(:,3))/sqrt(sLine{i}(1)-sLine{i}(3));
    u2{i} = ((sqrt(1-sLine{i}(3))*V{i}(:,1))-sqrt(sLine{i}(1)-1)*V{i}(:,3))/sqrt(sLine{i}(1)-sLine{i}(3));
    
    u1N{i} = ((sqrt(1-sLineN{i}(3))*Vn{i}(:,1))+sqrt(sLineN{i}(1)-1)*Vn{i}(:,3))/sqrt(sLineN{i}(1)-sLineN{i}(3));
    u2N{i} = ((sqrt(1-sLineN{i}(3))*Vn{i}(:,1))-sqrt(sLineN{i}(1)-1)*Vn{i}(:,3))/sqrt(sLineN{i}(1)-sLineN{i}(3));
    
    U1{i} = [V{i}(:,2) u1{i} V{i}(:,2) u1{i}];
    U2{i} = [V{i}(:,2) u2{i} V{i}(:,2) u2{i}];
    U1N{i} = [Vn{i}(:,2) u1N{i} Vn{i}(:,2) u1N{i}];
    U2N{i} = [Vn{i}(:,2) u2N{i} Vn{i}(:,2) u2N{i}];
    W1{i} = [H{i}*V{i}(:,2) H{i}*u1{i} H{i}*V{i}(:,2) H{i}*u1{i}];
    W2{i} = [H{i}*V{i}(:,2) H{i}*u2{i} H{i}*V{i}(:,2) H{i}*u2{i}];
    W1N{i} = [Hnorm{i}*Vn{i}(:,2) Hnorm{i}*u1N{i} Hnorm{i}*Vn{i}(:,2) Hnorm{i}*u1N{i}];
    W2N{i} = [Hnorm{i}*Vn{i}(:,2) Hnorm{i}*u2N{i} Hnorm{i}*Vn{i}(:,2) Hnorm{i}*u2N{i}];
end

%Four solutions
for i=1:3

end