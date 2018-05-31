clear
clc
hs = 0;

phi_O = 0;
a = 6378137 ;
lambda_O = 121;
f = 1/298.257222101;

e = sqrt(2*f-f^2);
R = a/sqrt(1-e^2*(sind(0))^2);

X_OL = (R+hs)*cosd(phi_O)*cosd(lambda_O);
Y_OL = (R+hs)*cosd(phi_O)*sind(lambda_O);
Z_OL = (R*(1-e^2)+hs)*sind(phi_O);

Ry_T = [cosd(phi_O-90) 0 -sind(phi_O-90);0 1 0;sind(phi_O-90) 0 cosd(phi_O-90)]';
Rz_T = [cosd(lambda_O-180) sind(lambda_O-180) 0;-sind(lambda_O-180) cosd(lambda_O-180) 0;0 0 1]';


NEU = csvread('test.csv');
NEU(:,1) = NEU(:,1);
NEU(:,2) = -(NEU(:,2)-250000);
for i = 1:length(NEU)
    XYZ(i,:) = Rz_T*Ry_T*NEU(i,:)'+[X_OL;Y_OL;Z_OL];
end

xo = XYZ(:,1);
yo = XYZ(:,2);
zo = XYZ(:,3);

for i = 1:length(NEU)
    if xo(i)<0 && yo(i)<0
        lambda(i) = atand(yo(i)/xo(i))-180;
    elseif  xo(i)<0
        lambda(i) = atand(yo(i)/xo(i))+180;
    else
        lambda(i) = atand(yo(i)/xo(i));
    end
end

temp = 100000;
crt = 0.00000001;

for i = 1:length(NEU)
    phi = atan(zo(i)/sqrt(xo(i)^2+yo(i)^2));
    j=0;
    while abs(phi-temp)>crt 
        temp = phi;
        N = a/sqrt(1-e^2*sin(phi)^2);
        phi = atan((zo(i)+N*e^2*sin(phi))/sqrt(xo(i)^2+yo(i)^2));
        j=j+1;
    end
    j
    N_test(i) = N;
    phi_final(i) = rad2deg(phi);
    he_teacher(i) = sqrt(xo(i)^2+yo(i)^2+(zo(i)+N*e^2*sin(phi))^2)-N;
    he(i) = sqrt(xo(i)^2+yo(i)^2)/cos(phi)-N;
    %he_test(i) = zo/sin(phi)-N*(1-e^2);
end

%=============other coordinate
lambda_d = fix(lambda);
lambda_m = fix((lambda-lambda_d)*60);
lambda_s = ((lambda-lambda_d)*60-lambda_m)*60;

phi_d = fix(phi_final);
phi_m = fix((phi_final-phi_d)*60);
phi_s = ((phi_final-phi_d)*60-phi_m)*60;
