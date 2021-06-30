close all
clear all
clc

%%Define the matrix parameters
A=[0.5 -1;0 1];
B=[2;0];
C=[2 4];

%% intial zero state
x0=[2;1];

z=tf('z',1);

%%define the input state
u=z/(z-0.9);



%%X_zi calculation

X_i_1=minreal(zpk((z*inv(z*eye(2)-A)*x0)),1e-3);

%%'V' represents the vector format

disp('The initial state')
[num_Xi_1,den_Xi_1]=tfdata(X_i_1(1),'v');
[r1,p1,k1]=residuez(num_Xi_1,den_Xi_1)

[num_Xi_2,den_Xi_2]=tfdata(X_i_1(2),'v');
[r2,p2,k2]=residuez(num_Xi_2,den_Xi_2)


%%X_zs calculation

X_i_2=minreal(zpk((inv(z*eye(2)-A)*B*u)),1e-3);


%%'V' represents the vector format

disp('The zero state')
[num_Xi_1,den_Xi_1]=tfdata(X_i_2(1),'v');
[r1,p1,k1]=residuez(num_Xi_1,den_Xi_1)

[num_Xi_2,den_Xi_2]=tfdata(X_i_2(2),'v');
[r2,p2,k2]=residuez(num_Xi_2,den_Xi_2)

%%Y_ss calculation
disp('Y_ss')
Y_ss=C * [X_i_1   X_i_2]


%%System stability control through the eigen values

%%laplace domain
s=tf('s');

sys=ss(A,B,C,0);

A1=minreal(zpk(inv(s*eye(2)-sys.A)),1e-3)

eig(A1)
