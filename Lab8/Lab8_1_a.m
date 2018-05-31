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
R = 6371; %KM
% lambda phi h to e n u to El Az Sr
hs = hs;

x_OL = R*cosd(15)*cosd(-90);
y_OL = R*cosd(15)*sind(-90);
z_OL = R*sind(15);
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
% polar
loc2 = find(r<0 | r>80);
polar(deg2rad(theta(loc)),r(loc),'.');
title('Skyplot PRN15 at 15N 90W')
%polar(theta,r.*180/pi,'.');
%plot ground track
[c_s,c_lat,c_long] = textread('COAST4.dat.txt','%f %f %f');
[m_s,m_lat,m_long] = textread('MERIPAR5.txt','%f %f %f');

c_lat = c_lat/60;
c_long = c_long/60;

m_lat = m_lat/60;
m_long = m_long/60;

plot(c_long,c_lat,'.');
hold on;
axis equal;
set(gca,'xtick',[-180:15:180],'ytick',[-90:15:90]);
axis([-180,180,-90,90]);
plot(m_long,m_lat,'.','MarkerSize',5);
hold on;
plot(long(loc),lat(loc),'--rs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
xlabel('x (deg)');
ylabel('y (deg)');
title('Platte Carre Projection');
hold on;
plot(long(loc2),lat(loc2),'*');

c_X = c_long;
c_Y = 180/pi*log(tand(c_lat/2+45));
m_X = m_long;
m_Y = 180/pi*log(tand(m_lat/2+45));
X = long;
Y = 180/pi*log(tand(lat/2+45));

figure;
plot(c_X,c_Y,'.');
hold on;
axis equal;
set(gca,'xtick',[-180:15:180]);
set(gca,'ytick',[])
axis([-180,180,-120,120]);
plot(m_X,m_Y,'.','MarkerSize',5);
hold on;
plot(X(loc),Y(loc),'--rs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
hold on;
plot(X(loc2),Y(loc2),'*');
xlabel('x (deg)');
ylabel('y (deg)');
title('Mercator');

figure;
plot(e(loc),n(loc),'--k.')
hold on;
grid on;
plot(0,0,'bo');
title('visibility map at 2017/4/30');
xlabel('E(km)')
ylabel('N(km)')
legend('Satilite','Staion');
text(e(49),n(49),'---->4:00 AM');
text(e(61),n(61),'---->5:00 AM');
text(e(73),n(73),'---->6:00 AM');
text(e(85),n(85),'---->7:00 AM');
text(e(97),n(97),'---->8:00 AM');
text(e(109),n(109),'---->9:00 AM');

figure;
plot3(e(loc),n(loc),u(loc),'--k.')
hold on;
grid on;
plot(0,0,'bo');
title('3D visibility map at 2017/4/30');
xlabel('E(km)')
ylabel('N(km)')
zlabel('u(km)')
legend('Satilite','Staion');
text(e(49),n(49),u(49),'---->4:00 AM');
text(e(61),n(61),u(61),'---->5:00 AM');
text(e(73),n(73),u(73),'---->6:00 AM');
text(e(85),n(85),u(85),'---->7:00 AM');
text(e(97),n(97),u(97),'---->8:00 AM');
text(e(109),n(109),u(109),'---->9:00 AM');