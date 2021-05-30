clear all
close all
clc


%%Please use the unit step reference signal in the simulation (i.e set the corresponding signal generator in the simulation connected to the system)

%G(s)=2*e^(-9.066s)/((0.21s+1)*(4s+1))
%da(t)=delta_a*E(t) where |delta_a|<=0.01

%%Design a cascade controller C(s) in order to meet the following
%%requirements.

%1. | (e^inf)r|=1 ,r(t)=tE(t)
%unitary slope
%2. |(Y^inf)da|<=0.001;
%3. S(overshoot value)<=10%;
%4. ts,2%(settling time)<=10s; 

s=tf('s');

% plant tf
G=(2*exp(-0.066*s))/((0.21*s+1)*(4*s+1));

% steady state controller
Kc=0.5;
C_ss = Kc;
L1=G*C_ss; % loop function update

% transient requirements
T_p=0.42; % !dB
S_p=2.60; % !dB
wc_des=0.479;

%nichols diagram for L1
figure(1)
nichols(L1,'b'),hold on
T_grid(T_p)
S_grid(S_p)

% lead network design
mD =8
wnorm =2;
wD = wc_des/wnorm
C_D = (1 +s/wD)/(1+s/(mD*wD));
L2 = C_D*L1;  % loop tf update
C = C_ss*C_D; % controller tf update
figure(1)
nichols(L2,'k')

% gain adjustment
K=10^(17/20)
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

%%%%y_dyinf
t_stop=20;
rho=1;
wy=0.08;
delta_a=0;
delta_y=0.5;
sim('feedback_system')
figure(3)
plot(y.time,y.data,'b','linewidth',1.5)
grid on


%%%% y_dainf

t_stop=20;
rho=1;
delta_a=0.001;
delta_y=0;
wy=0.08;
sim('feedback_system')
figure(2)
plot(u.time,u.data,'b','linewidth',1.5)
grid on

return
