close all
clear all
clc


s=tf('s');

G=40/(s^2+4*s-9.81);%%Plant function
Ts=0.02; %%Sampling period
C_ss=1.96/s; %%Steady state controller
w_c=8.8; %%Desired frequency
G_ZOH=1/(1+s*Ts/2) %% Zero order hold controller
L1=C_ss*G_ZOH*G; %%preliminary definition

%%Limits
M_T_HF=-20; 
T_p=1.93;
S_p=3.75;


% Nichols for L1
figure(1)
nichols(L1,'b')
hold on
T_grid(T_p)
S_grid(S_p)
T_grid(M_T_HF)
axis([-360 -90 -150 150])

% double zero design
wnorm=4.5;
wz=w_c/wnorm
C_Z=(1+s/wz)^2
L2=C_Z*L1;
C0=C_ss*C_Z;
figure(1)
nichols(L2,'r')


%closure pole design
wp=100;
wp1=1.5*wp; %%second closure pole
C_P=1/(1+s/wp)*1/(1+s/wp1) %% multiply the closure poles
L3=C_P*L2;
C0=C0*C_P;
figure(1)
nichols(L3,'m')



%Analog signal discretization
Cd=c2d(C0,Ts,'tustin')

% run simulation
rho=2; %
delta_a=0; %
delta_t=0; %
delta_y=0; %
w_t=90;
w_y=0;
t_stop=10;
sim('feedback_control_digital')
%plot results
figure(2)
hold on
plot(y.time,y.data,'b')
plot(r.time,r.data,'k')
grid on
xlabel('t (s) ')
ylabel('y(t),r(t)')

figure(3)
hold on
plot(u.time,0.2*u.data,'b')
grid on
xlabel('t (s) ')
ylabel('u(t)')
