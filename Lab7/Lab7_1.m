%GPS week 1947 or mod 1024 = 923
clear
clc
% Keplerian elements
e =0.9113788605E-002;
toA = 61440;
I =0.9296546754; %rad
a = 5153.722168^2/1000; % a (km)
omega = 0.3800122816E-002; % Upper omega
w = 0.580827070; % Lower omeagas
M_toA = -0.8981700943E+000; % rad
GM = 398600.4418; % (km^3/s^2)
we = 7292115.8553*10^-11; % (rad/s)
r = 6371; %(km)
n = sqrt(GM/a^3);
we = 7292115.8553*10^-11;
%sec_interval = (0:300:300*12*48)/3600*360/24*pi/180;
sec_interval = 0:300:300*12*48;
sec_interval = sec_interval-toA;
M = M_toA +n*sec_interval;

for i=1:length(M)
    E_temp = M(i);
    temp = 100000;
    j = 0;
    while abs(E_temp-temp)>0.00000001
        temp = E_temp;
        E_temp = E_temp-((E_temp-e*sin(E_temp)-M(i))/(1-e*cos(E_temp)));
        j = j+1;
    end
    E(i) = E_temp;
end

E = mod(E,2*pi);
theta_star = atan(sqrt((1+e)/(1-e))*tan(E/2))*2;

%v_xw = [a*cos(E)-a*e a*sqrt(1-e^2)-sin(E) zeros(1,length(E))];
%v_xw = reshape(v_xw,[length(M),3])';

to = 0;
GST_hour=7;
GST_min = 39;
GST_sec = 19.412;
omega_in = (omega+deg2rad(GST(GST_hour,GST_min,GST_sec,to-toA)));
%omega_in = omega;
%omega_in = deg2rad(220);

for i = 1:length(M)
    R_omega = [cos(-omega_in) sin(-omega_in) 0;-sin(-omega_in) cos(-omega_in) 0;0 0 1];
    R_I = [1 0 0;0 cos(-I) sin(-I);0 -sin(-I) cos(-I)];
    R_w = [cos(-w) sin(-w) 0;-sin(-w) cos(-w) 0;0 0 1];
    v_xw = [a*cos(E(i))-a*e a*sqrt(1-e^2)*sin(E(i)) 0]';
    X_In(:,i) = R_omega*R_I*R_w*v_xw;
end
X = X_In(1,:);
Y = X_In(2,:);
Z = X_In(3,:);
plot3(X,Y,Z,'.')
title('Quasi-inertial Frame')
xlabel('X(km)');
ylabel('Y(km)');
zlabel('Z(km)');

for i = 1:length(M)
    t_t0 = sec_interval(i);
    GST_angle = GST(GST_hour,GST_min,GST_sec,t_t0);
    %GST0 =(GST_hour+GST_min/60+GST_sec/3600)*360/24*pi/180;
    %GST = GST0+t_t0*we;
    %GST_angle = mod(GST,2*pi)*180/pi;
    [x,y,z] = Ini2ECEF(GST_angle,X(i),Y(i),Z(i));

    ecef(i,1:3) = [x,y,z];
end
x_ecef = ecef(:,1);
y_ecef = ecef(:,2);
z_ecef = ecef(:,3);

figure;
plot3(x_ecef,y_ecef,z_ecef,'.')
title('ECEF Coordinate');
xlabel('X(km)');
ylabel('Y(km)');
zlabel('Z(km)');

month = 4;
date = 30;
hour = 0;
min = 0;
sec = 0;
sec_interval = 0:300:300*12*48;

for i = 1:length(E)/2
    time(i,2) = date+fix((hour + fix((sec_interval(i))/3600))/24);
    time(i,1) = 4;
    time(i,3) = mod(hour + fix((sec_interval(i))/3600),24);
    time(i,4) = mod(mod(sec_interval(i)/60,60)+min,60);
    time(i,5) = 0;
end
date = 0;
for i = length(E)/2+0.5:length(E)
    time(i,2) = date+fix((hour + fix((sec_interval(i))/3600))/24);
    time(i,1) = 5;
    time(i,3) = mod(hour + fix((sec_interval(i))/3600),24);
    time(i,4) = mod(mod(sec_interval(i)/60,60)+min,60);
    time(i,5) = 0;
end


fid = fopen('Lab7_1.txt','w') ;
for i = 1:length(E)
    fprintf(fid,'2017/%d/%d %02d:%02d:%02d\t %.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\r\n',time(i,1),time(i,2),time(i,3),time(i,4),time(i,5),X(i),Y(i),Z(i),x_ecef(i),y_ecef(i),z_ecef(i));
end
fclose(fid);

x = x_ecef;
y = y_ecef;
z = z_ecef;

for i = 1:length(ecef)
    if x(i)<0 && y(i)<0
        lambda(i) = atand(y(i)/x(i))-180;
    elseif  x(i)<0
        lambda(i) = atand(y(i)/x(i))+180;
    else
        lambda(i) = atand(y(i)/x(i));
    end
end
phi = atand(z./sqrt(x.^2+y.^2));
hs = sqrt(x.^2+y.^2+z.^2)-r;

lambda_d = fix(lambda);
lambda_m = fix((lambda-lambda_d)*60);
lambda_s = ((lambda-lambda_d)*60-lambda_m)*60;

phi_d = fix(phi);
phi_m = fix((phi-phi_d)*60);
phi_s = ((phi-phi_d)*60-phi_m)*60;

fid = fopen('Lab7_2.txt','w') ;
for i = 1:length(time)
    fprintf(fid,'2017/%d/%d/ %02d:%.02d:%02d\t %.0f度%.0f分%.5f秒\t%.0f度%.0f分%.5f秒\t%.6f\r\n',...
        time(i,1),time(i,2),time(i,3),time(i,4),time(i,5),lambda_d(i),abs(lambda_m(i)),abs(lambda_s(i))....
        ,phi_d(i),abs(phi_m(i)),abs(phi_s(i)),hs(i));
end
fclose(fid);

figure;
plot(linspace(1,577*5,577),lambda,'--.')
title('Longitude')
xlabel('time(min)');
ylabel('Degree');
figure;

plot(linspace(1,577*5,577),phi,'--')
title('Latitude')
xlabel('time(min)');
ylabel('Degree');

figure;
plot(linspace(1,577*5,577),hs,'--')
title('Height')
xlabel('time(min)');
ylabel('Height(km)');