%Lab5_2 Leon
GST0 =(9+40/60+46.098/3600)*360/24*pi/180;
we = 7292115.8553*10^-11;
t = [0:600:86400];
GST = GST0+t*we;
GST_angle = mod(GST,2*pi)*180/pi;
GST_time = mod(GST,2*pi)*180/pi*24/360;
GST_hour = fix(GST_time);
GST_minute = fix((GST_time-GST_hour)*60);
GST_second = ((GST_time-GST_hour)*60-GST_minute)*60;

GST_d = fix(GST_angle);
GST_m = fix((GST_angle-GST_d)*60);
GST_s = ((GST_angle-GST_d)*60-GST_m)*60;

x = -5756029.090;
y = -136762.372;
z = -2727465.155;
for i=1:length(GST_angle)
    Rz_T = [cosd(GST_angle(i)) sind(GST_angle(i)) 0;-sind(GST_angle(i)) cosd(GST_angle(i)) 0;0 0 1]';
    XYZ = Rz_T*[x;y;z];
    X(i) = XYZ(1);
    Y(i) = XYZ(2);
    Z(i) = XYZ(3);
end

plot3(X,Y,Z,'o');
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
title('quasi-inertial frames');
legend('every ten mins')

figure;
plot3(x,y,z,'o')
xlabel('x(m)');
ylabel('y(m)');
zlabel('z(m)');
title('ECEF');
legend('ECEF coordinate')

fid = fopen('Lab5_2.txt','w') ;
for i=1:length(GST_angle)
    fprintf(fid,'%02.0f %02.0f %02.4f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\r\n',GST_hour(i),GST_minute(i),...
        GST_second(i),x,y,z,X(i),Y(i),Z(i));
end
fclose(fid);