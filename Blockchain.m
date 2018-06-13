clc;
clear;
close all;
% tic
X=imread('Baboon.tiff');
if size(X,3)>1
    X=rgb2gray(X);
end
figure,imshow(X); title('Input Image');
figure,imhist(X); title('Input Image Histogram');
% x=uint8(0.*zeros(512,512));
[m,n]=size(X);
Gb=uint8([30, 14, 36, 213, 65, 49, 153, 42, 140, 13, 254,  116,  179,  201,...
    185, 204, 15,  147,  210,  147,  229,  148,  117,  100,  128,   26, ...
    249, 48, 63, 65, 47, 130]); %Genesis Block
Gb1=Gb;
sha256hasher = System.Security.Cryptography.SHA256Managed;
%sha256 = uint8(sha256hasher.ComputeHash(uint8(string))); %consider the string as 8-bit characters
%dec2hex(sha256) %display as hex:
y=uint8(zeros(m,n));
k=1;
% Shuffling stage
sh=rand(1,512*512);
[t, Ind]=sort(sh);
x1=X(:);
x2=x1(Ind);
x=reshape(x2,512,512);
figure,imshow(x); title('Shuffled Image');
figure,imhist(x); title('Shuffled Image Histogram');
for i=1:m
    for j=1:32:n
%         temp=x(i,j:j+31);
%         temp1=bitxor(Gb(k,:),temp);
%         Gb(k+1,:) = uint8(sha256hasher.ComputeHash(temp1));k=k+1;
%         y(i,j:j+31)=temp1;
        temp=x(i,j:j+31);
        y(i,j:j+31)=bitxor(Gb(k,:),x(i,j:j+31));
        Gb(k+1,:) = uint8(sha256hasher.ComputeHash(y(i,j:j+31)));k=k+1;
    end
end
% toc
figure,imshow(y); title('Encrypted Image');
figure,imhist(y); title('Encrypted Image Histogram');
% % Decryption Process
% tic
Gb1(1)=Gb(1)+10;
y(1,1)=y(1,1)+7;
z=uint8(zeros(m,n));
k=1;
for i=1:m
    for j=1:32:n
%         temp=y(i,j:j+31);
%         Gb1(k+1,:) = uint8(sha256hasher.ComputeHash(temp));
%         temp1=bitxor(Gb1(k,:),temp);k=k+1;
%         z(i,j:j+31)=temp1;
        Gb1(k+1,:) = uint8(sha256hasher.ComputeHash(y(i,j:j+31)));
        z(i,j:j+31)=bitxor(Gb1(k,:),y(i,j:j+31));k=k+1;
    end
end
% toc
figure,imshow(z); title('Blockchain Decreypted Image');
figure,imhist(z); title('Blcokchain Decrypted Image Histogram');
z1=z(:);
z2(Ind)=z1;
Z=reshape(z2,m,n);
isequal(X,Z)
figure,imshow(Z); title('Decreypted Image');
figure,imhist(Z); title('Decrypted Image Histogram');

