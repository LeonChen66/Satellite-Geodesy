%Lab 6_1 Leon
% Sort data into array
clear
clc
data = textread('igu19471_00.sp3','%s','delimiter','\n','whitespace','','headerlines',22);
count = 1;
for i = 1:length(data)
    temp_a = strsplit(data{i});
    if  strcmp(temp_a{1},'*')
        temp = [temp_a(1); cellfun(@str2num,temp_a(2:end),'un',1).'];
        time(count,1:6) = temp{2}';
        count =count + 1 ;
    end
end
count = 1;
for i = 1:length(data)
    temp_a = strsplit(data{i});
    if  strcmp(temp_a{1},'PG15')
        temp = [temp_a(1); cellfun(@str2num,temp_a(2:end),'un',0).'];
        test = temp(2:end);
        test = cell2mat(test);
        ecef(count,1:3) = test(1:3)';
        count =count + 1 ;
    end
end

GST_hour = 14;
GST_min = 32;
GST_sec = 31.195;

for i = 1:96
    t_t0 = (time(i,3)-time(1,3))*86400+(time(i,4)-time(1,4))*3600+(time(i,5)-time(1,5))*60;
    GST_angle = GST(GST_hour,GST_min,GST_sec,t_t0);
    [X,Y,Z] = corTrans(GST_angle,ecef(i,1),ecef(i,2),ecef(i,3));
    ini_frame(i,1:3) = [X,Y,Z];
end
%{
plot3(ecef(1:48,1),ecef(1:48,2),ecef(1:48,3),'o')
hold on;
plot3(ecef(49:96,1),ecef(49:96,2),ecef(49:96,3),'+')
hold on;
plot3(ecef(97:144,1),ecef(97:144,2),ecef(97:144,3),'*')
hold on;
plot3(ecef(145:192,1),ecef(145:192,2),ecef(145:192,3),'x')
title('ECEF Coordinate')
xlabel('X(km)');
ylabel('Y(km)');
zlabel('Z(km)');
legend('first 12 hours','second 12 hours','third 12 hours','fourth 12 hours')
figure;
plot3(ini_frame(1:48,1),ini_frame(1:48,2),ini_frame(1:48,3),'o')
hold on;
plot3(ini_frame(49:96,1),ini_frame(49:96,2),ini_frame(49:96,3),'+')
hold on;
plot3(ini_frame(97:144,1),ini_frame(97:144,2),ini_frame(97:144,3),'*')
hold on;
plot3(ini_frame(145:192,1),ini_frame(145:192,2),ini_frame(145:192,3),'x')
title('Quasi-inertial Frame')
xlabel('X(km)');
ylabel('Y(km)');
zlabel('Z(km)');
legend('first 12 hours','second 12 hours','third 12 hours','fourth 12 hours')
%}
fid = fopen('Lab6_1.txt','w') ;
for i = 1:96
    fprintf(fid,'%d/%d/%d %02d:%.02d\t %.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\r\n',...
        time(i,1),time(i,2),time(i,3),time(i,4),time(i,5),ini_frame(i,1),ini_frame(i,2),ini_frame(i,3),...
        ecef(i,1),ecef(i,2),ecef(i,3));
end
fclose(fid);
%Lab6_2 ECEF Cartesian to ECEF spherical frame

x = ecef(:,1);
y = ecef(:,2);
z = ecef(:,3);
% x y z to lat lon height
r = 6371;

for i = 1:96
    if x(i)<0 && y(i)<0
        lambda(i) = atand(y(i)/x(i))-180;
    elseif  x(i)<0
        lambda(i) = atand(y(i)/x(i))+180;
    else
        lambda(i) = atand(y(i)/x(i));
    end
end

%{
for i = 1:96
    lambda(i) = atand(y(i)/x(i));
    if x(i)<0
        lambda(i) = lambda(i)+180;
    end
end
%}
phi = atand(z./sqrt(x.^2+y.^2));
hs = sqrt(x.^2+y.^2+z.^2)-r;

lambda_d = fix(lambda);
lambda_m = fix((lambda-lambda_d)*60);
lambda_s = ((lambda-lambda_d)*60-lambda_m)*60;

phi_d = fix(phi);
phi_m = fix((phi-phi_d)*60);
phi_s = ((phi-phi_d)*60-phi_m)*60;

fid = fopen('Lab6_2.txt','w') ;
for i = 1:96
    fprintf(fid,'%d/%d/%d %02d:%.02d\t %.0f度%.0f分%.5f秒\t%.0f度%.0f分%.5f秒\t%.6f\r\n',...
        time(i,1),time(i,2),time(i,3),time(i,4),time(i,5),lambda_d(i),abs(lambda_m(i)),abs(lambda_s(i))....
        ,phi_d(i),abs(phi_m(i)),abs(phi_s(i)),hs(i));
end
fclose(fid);
%{
figure;
plot(linspace(1,2880,192),lambda,'--.')
title('Longitude')
xlabel('time(min)');
ylabel('Degree');
figure;

plot(linspace(1,2880,192),phi,'--')
title('Latitude')
xlabel('time(min)');
ylabel('Degree');

figure;
plot(linspace(1,2880,192),hs,'--')
title('Height')
xlabel('time(min)');
ylabel('Height(km)');
%}