clear all
close all
clc

%%Please use the ramp reference signal in the simulation(i.e set the corresponding signal generator in the simulation connected to the system)

%G(s)=10/(s*(s+5)*(s+10))
%da(t)=delta_a*E(t) where |delta_a|<=0.3

%%Design a cascade controller C(s) in order to meet the following
%%requirements.

%1. | (e^inf)r|<=1 in the presence of a linear ramp reference signal with
%unitary slope
%2. |(Y^inf)da|<=0.1;
%3. S(overshoot value)<=5%;
%4. ts,2%(settling time)<=2s; 

s=tf('s');

% plant tf
G=10/(s*(s+5)*(s+10));

% steady state controller
Kc=5;
C_ss = Kc;
L1=G*C_ss; % loop function update
%transient requirements
T_p=0.010 ; % dB !!
S_p=2.14; % dB !!
wc_des=1.85;
figure(1)
nichols(L1,'r')
hold on
T_grid(T_p)
S_grid(S_p)

%return

% lead network design
mD =18
wnorm =4;
wD = wc_des/wnorm
C_D = (1 +s/wD)/(1+s/(mD*wD));
L2 = C_D*L1;  % loop tf update
C = C_ss*C_D; % controller tf update
figure(1)
nichols(L2,'b')



% gain adjustment
K=10^(4.2/20)
L3=K*L2; % loop tf update
C_ss=C_ss*K; % controller tf update
figure(1)
nichols(L3,'k')


% lag network
mI= 10;
alpha =wnorm/mI;
wI = wc_des/(alpha*mI)
C_I = (1+s/(mI*wI))/(1+s/(wI))
L4 = C_I*L3; %LOOP TF UPDATE
C = C*C_I; % controller tf update
figure(1)
nichols(L4,'m')


%y_inf

t_stop=10;
rho=1;
delta_a=0.1;
delta_y=0;
wy=0.08;
sim('feedback_system')
figure(2)
plot(y.time,y.data,'b','linewidth',1.5)
grid on


%y_dainf

t_stop=10;
rho=1;
delta_a=0;
delta_y=0;
wy=0.08
sim('feedback_system')
figure(3)
plot(u.time,u.data,'b','linewidth',1.5)
grid on
return
