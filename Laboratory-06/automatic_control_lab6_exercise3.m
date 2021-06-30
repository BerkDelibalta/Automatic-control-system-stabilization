close all
clear all
clc

T=1;

z=tf('z',T);

A=[-0.2 0 0;0 1 0;0 0 1];
x0=[0;0;0];

H=minreal(zpk(z*inv(z*eye(3)-A))*x0,1e-3)
disp('the eigen value of the tf')
eig(H)
disp('the information related to the natural modes')
[zH,pH,kH]=zpkdata(H,'v')

