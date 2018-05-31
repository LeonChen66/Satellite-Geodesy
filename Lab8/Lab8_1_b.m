% Lab 8-1.b
clc
clear
[c_s,c_lat,c_long] = textread('COAST4.dat.txt','%f %f %f');
[m_s,m_lat,m_long] = textread('MERIPAR5.txt','%f %f %f');

c_lat = c_lat/60;
c_long = c_long/60;

m_lat = m_lat/60;
m_long = m_long/60;

data = textread('Lab7_2.txt','%s');

for i = 1:length(data)/5
    day(i) = data(5*i-4);
    time(i) = data(5*i-3);
    long(i) = data(5*i-2);
    lat(i) = data(5*i-1);
    hs(i) = data(5*i);
end

hs = str2double(hs);
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

plot(c_long,c_lat,'.');
hold on;
axis equal;
set(gca,'xtick',[-180:15:180],'ytick',[-90:15:90]);
axis([-180,180,-90,90]);
plot(m_long,m_lat,'.','MarkerSize',5);
hold on;
plot(long,lat,'o');
xlabel('x (deg)');
ylabel('y (deg)');
title('Platte Carre Projection');

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
plot(X,Y,'o');
xlabel('x (deg)');
ylabel('y (deg)');
title('Mercator');