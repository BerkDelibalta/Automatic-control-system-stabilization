%%Z-domain solution of discrete time LTI systems

close all
clear all
clc

%%The matrix system domains
A=[0 1;0.1 -0.3];B=[0;1];
C=[7 7];D=0;x0=[0;0];

%%Introduction of the z-transform domain
%% 1 is the sampling time in the tf function which provides the z transform infrastructure

z=tf('z',1);

%%the E
E=(z)/(z-1);

%%X_zi calculation

X_i_1=minreal(zpk((z*inv(z*eye(2)-A)*x0)),1e-3);

%%'V' represents the vector format

disp('The initial state')
[num_Xi_1,den_Xi_1]=tfdata(X_i_1(1),'v');
[r1,p1,k1]=residuez(num_Xi_1,den_Xi_1)

[num_Xi_2,den_Xi_2]=tfdata(X_i_1(2),'v');
[r2,p2,k2]=residuez(num_Xi_2,den_Xi_2)


%%X_zs calculation

X_i_2=minreal(zpk((inv(z*eye(2)-A)*B*E)),1e-3);


%%'V' represents the vector format

disp('The zero state')
[num_Xi_1,den_Xi_1]=tfdata(X_i_2(1),'v');
[r1,p1,k1]=residuez(num_Xi_1,den_Xi_1)

[num_Xi_2,den_Xi_2]=tfdata(X_i_2(2),'v');
[r2,p2,k2]=residuez(num_Xi_2,den_Xi_2)

%%Y_ss calculation
disp('Y_ss')
Y_ss=C * [X_i_1   X_i_2]
