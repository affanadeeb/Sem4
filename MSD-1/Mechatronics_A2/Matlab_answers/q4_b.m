%%MSD Course - Simulating Fourbar Mechanism with coupler curves. 
%%Help sheet
clear all;
clc

%%link lengths
r1=15;r2=5;r3=8;r4=13;

r5 = input('Enter length of r5: '); 
alpha = input('Enter value of alpha in radians: ');

%%input angles
theta2 = 0:0.01:2*pi;
theta1 = 0;

Ax=zeros(length(theta2));
Ay=zeros(length(theta2));

k2 = r1/r4;
k1 = r1/r2;
k4 = r1/r3;
k3 = (r2^2 - r3^2 + r4^2 + r1^2)/(2*r2*r4);
k5 = (r4^2 - r3^2 - r2^2 - r1^2)/(2*r2*r3);

A = cos(theta2) - k1 - k2*cos(theta2) + k3;
C = k1 - (k2+1)*cos(theta2) + k3;
B = -2*sin(theta2);
F = k1 + (k4-1)*cos(theta2) + k5;
D = cos(theta2) - k1 + k4*cos(theta2) + k5;



for i=1:length(theta2)

%%write the mathematical equations here    
theta3(i) = 2 * atan((-B(i) - sqrt(B(i)^2 - 4 * D(i) * F(i))) / (2 * D(i)));
theta4(i) = 2 * atan((-B(i) + sqrt(B(i)^2 - 4 * A(i) * C(i))) / (2 * A(i)));


%%Compute the coordinates and simulate the motion here

Ax(i) = r2*cos(theta2(i));   %coordinates of A
Ay(i) = r2*sin(theta2(i));

Bx(i) = r2*cos(theta2(i))+r3*cos(theta3(i)); %coordinates of B (moving pivot)
By(i) = r2*sin(theta2(i))+r3*sin(theta3(i));

Box(i) = r1*cos(theta1); %coordinates of OB (fixed pivot)
Boy(i) = r1*sin(theta1);

Px1(i) = r2*cos(theta2(i))+(r5)*cos(theta3(i)+alpha); %coordinates of P (moving pivot) - A trivial coupler curve. 
Py1(i) = r2*sin(theta2(i))+(r5)*sin(theta3(i)+alpha);

plot([0 Ax(i)], [0 Ay(i)],'ro-','LineWidth',5);hold on;     %r2
plot([Ax(i) Bx(i)], [Ay(i) By(i)], 'go-','LineWidth',5);    %r3
plot([Bx(i) Box(i)], [By(i) Boy(i)], 'bo-','LineWidth',5);  %r4
plot([Box(i) 0], [Boy(i) 0], 'co-','LineWidth',5);          %r1


plot([Ax(i) Px1(i)], [Ay(i) Py1(i)], 'go-','LineWidth',5);  %r5
plot([Bx(i) Px1(i)], [By(i) Py1(i)], 'go-','LineWidth',5);  %r6
plot(Px1,Py1, '-','LineWidth',2);                             %Draw coupler curve               


hold off
grid on

axis([-40 40 -40 40]);
%axis equal
pbaspect([1 1 1])
pause(0.001);
end