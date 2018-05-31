%read last time data
clear
clc
data = textread('Lab7_2.txt','%s');

for i = 1:length(data)/5
    day(i) = data(5*i-4);
    time(i) = data(5*i-3);
    long(i) = data(5*i-2);
    lat(i) = data(5*i-1);
    hs(i) = data(5*i);
end

hs = str2double(hs)';
% convert txt to double
for i = 1:length(lat)
    temp_lat = strsplit(lat{i},'度');
    lat_deg(i) = str2double(temp_lat(1));
    if lat_deg(i)<0
        temp_lat = strsplit(temp_lat{2},'分');
        lat_min(i) = -str2double(temp_lat(1));
    else
        temp_lat = strsplit(temp_lat{2},'分');
        lat_min(i) = -str2double(temp_lat(1));
    end
    if lat_deg(i)<0
        temp_lat = strsplit(temp_lat{2},'秒');
        lat_sec(i) = -str2double(temp_lat(1));
    else
        temp_lat = strsplit(temp_lat{2},'秒');
        lat_sec(i) = str2double(temp_lat(1));
    end
    
    temp_long = strsplit(long{i},'度');
    long_deg(i) = str2double(temp_long(1));
    if long_deg(i)<0
        temp_long = strsplit(temp_long{2},'分');
        long_min(i) = -str2double(temp_long(1));
    else
        temp_long = strsplit(temp_long{2},'分');
        long_min(i) = str2double(temp_long(1));
    end
    if long_deg(i)<0
        temp_long = strsplit(temp_long{2},'秒');
        long_sec(i) = -str2double(temp_long(1));
    else
    temp_long = strsplit(temp_long{2},'秒');
    long_sec(i) = str2double(temp_long(1));
    end
end
long = (long_deg + long_min/60 + long_sec/3600)';
lat = (lat_deg + lat_min/60 + lat_sec/3600)';

%initial station  90W 15N
R = 6371000; %KM
% lambda phi h to e n u to El Az Sr
hs = hs*1000;

x_OL = R*cosd(15)*cosd(-90)+100;
y_OL = R*cosd(15)*sind(-90)+100;
z_OL = R*sind(15)+100;
lanbda_OL = -90;
phi_OL = 15;
R_phi = 90-phi_OL;
Ry = [cosd(R_phi) 0 -sind(R_phi);0 1 0;sind(R_phi) 0 cosd(R_phi)];
Rx = [1 0 0;0 cosd(lanbda_OL) sind(lanbda_OL);0 -sind(lanbda_OL) cosd(lanbda_OL)];
Rz = [cosd(lanbda_OL) sind(lanbda_OL) 0;-sind(lanbda_OL) cosd(lanbda_OL) 0;0 0 1];


xo = (R+hs).*cosd(lat).*cosd(long);
yo = (R+hs).*cosd(lat).*sind(long);
zo = (R+hs).*sind(lat);

for i = 1:length(xo)    
Local = Ry*Rz*[xo(i)-x_OL;yo(i)-y_OL;zo(i)-z_OL];
n(i) = -Local(1);
e(i) = Local(2);
u(i) = Local(3);
end

%local cartesian

%Az = atand(e./n);
%y = e x = n


for i = 1:length(n)
    if e(i)<0 && n(i)<0
        Az(i) = atand(e(i)/n(i))-180;
    elseif  n(i)<0 && e(i)>0
        Az(i) = atand(e(i)/n(i))+180;
    else
        Az(i) = atand(e(i)/n(i));
    end
end

El = atand(u./sqrt(e.^2+n.^2));
Sr = sqrt(e.^2+n.^2+u.^2);


r = 90-El;
theta =90- Az;
loc = find(r>0 & r<80);
format long g
syms xr yr zr xs ys zs pr
f = sqrt((xs-xr).^2+(ys-yr).^2+(zs-zr).^2)-pr;
d_xr = diff(f,xr);
d_yr = diff(f,yr);
d_zr = diff(f,zr);

inline_f = inline(f,'xr','yr','zr','xs','ys','zs','pr');
inline_xr = inline(d_xr,'xr','yr','zr','xs','ys','zs','pr');
inline_yr = inline(d_yr,'xr','yr','zr','xs','ys','zs','pr');
inline_zr = inline(d_zr,'xr','yr','zr','xs','ys','zs','pr');

range = sqrt((xo(loc)-x_OL).^2+(yo(loc)-y_OL).^2+(zo(loc)-z_OL).^2)+normrnd(0,0.2,length(loc),1);
range_0 = range;
x_stallite = xo(loc)+normrnd(0,1,length(loc),1);
y_stallite = yo(loc)+normrnd(0,1,length(loc),1);
z_stallite = zo(loc)+normrnd(0,1,length(loc),1);

for i = 1:15
    B(:,1) = inline_xr(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range);
    B(:,2) = inline_yr(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range);
    B(:,3) = inline_zr(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range);
    f = -inline_f(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range);
    X = inv(B'*B)*B'*f;
    x_OL = X(1)+x_OL;
    y_OL = X(2)+y_OL;
    z_OL = X(3)+z_OL;
    V = (f-B*X);
    %range = range_0 + V ;
end

sigma_0 = sqrt(V'*V/(length(loc)-4))
sigma_XX = sigma_0^2*inv(B'*B);
sigma_enu = Rz*Ry*sigma_XX*(Rz*Ry)';
Q_enu = 1/(sigma_0)^2*(sigma_enu);
q_e2 = Q_enu(1,1);
q_n2 = Q_enu(2,2);
q_u2 = Q_enu(3,3);
PDOP = sqrt(q_e2+q_n2+q_u2)
VDOP = sqrt(q_u2)
HDOP = sqrt(q_e2+q_n2)
sigma = sigma_0*PDOP
true_X = x_OL - R*cosd(15)*cosd(-90)
true_Y = y_OL - R*cosd(15)*sind(-90)
true_Z = z_OL - R*sind(15)
%{
fid = fopen('Lab_9_3.txt','w');
for i = 1:length(range)
    fprintf(fid,'Obs_%02.0f\t%.6f\t%.6f\t%.6f\t%.6f\r\n',...
        i,range(i),x_stallite(i),y_stallite(i),z_stallite(i));
end
fclose(fid);
%}