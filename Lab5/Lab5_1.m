%Lab 5_1
%{
==========JD Approach
JD = 2454374.5;
Tu = (JD-2451545.0)./36525;
a = 100.4606184;
b = 36000.77004;
c = 0.000387933;
d =- 2.583e-8;
GST0  = a+b*Tu+c*Tu^2+d*Tu^3;
GST0 = mod(GST0, 360);
GST_time = GST0*24/360;

GST_hour = fix(GST_time)
GST_minute = fix((GST_time-GST_hour)*60)
GST_second = ((GST_time-GST_hour)*60-GST_minute)*60
%}

%{
Verify the program
GST0 = (1+32/60+35.7372/3600)*360/24*pi/180;
tt0 = 86400*7292115.8553*10^-11;
GST = GST0+tt0;
%GST = GST*180/pi
GST = mod(GST,2*pi)*180/pi*24/360;
GST_hour = fix(GST)
GST_minute = fix((GST-GST_hour)*60)
GST_second = ((GST-GST_hour)*60-GST_minute)*60
%}

GST0 =(9+40/60+46.098/3600)*360/24*pi/180;
we = 7292115.8553*10^-11;
t = [0:600:86400*3];
GST = GST0+t*we;
GST_angle = mod(GST,2*pi)*180/pi;
GST_time = mod(GST,2*pi)*180/pi*24/360;
GST_hour = fix(GST_time);
GST_minute = fix((GST_time-GST_hour)*60);
GST_second = ((GST_time-GST_hour)*60-GST_minute)*60;

GST_d = fix(GST_angle);
GST_m = fix((GST_angle-GST_d)*60);
GST_s = ((GST_angle-GST_d)*60-GST_m)*60;

num = linspace(0,144*3,144*3+1);
axis equal;
test = 1:3;
plot(GST_time,'-g.');
set(gca,'XTick',0:145:144*3);
set(gca,'XTickLabel',{'2/15','2/16','2/17'});
hold on;
plot(num(1),GST_time(1),'o','markers',12);
hold on;
plot(num(145),GST_time(145),'o','markers',12);
hold on;
plot(num(289),GST_time(289),'o','markers',12)

title('GST');
xlabel('solar time(date)');
ylabel('GST');
legend('every 10 min','first day');

fid = fopen('Lab5.txt','w') ;
for i = 1:433
    i
    fprintf(fid,'%04d\t %d %d %.4f\t %d %d %.4f\r\n',(i-1)*10,GST_d(i),GST_m(i),GST_s(i),GST_hour(i),GST_minute(i),GST_second(i));
end
fclose(fid);