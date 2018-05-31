r = 6371000; % Meter
x0 =0;
y0 = 0;
z0 = 0;
theta=0:0.1:2*pi; 
phi=0:0.1:pi; 
N = 50;

a=rand(N,1)*2*pi;
b=asin(rand(N,1)*2-1);
x=x0+r.*cos(a).*cos(b);
y=y0+r.*sin(a).*cos(b);
z=z0+r.*sin(b);

plot3(x,y,z,'o')

% x y z to lat lon height

for i = 1:50
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

%local
x_OL = x(1);
y_OL = y(1);
z_OL = z(1);
lanbda_OL = lambda(1);
phi_OL = phi(1);
R_phi = 90-phi_OL;
Ry = [cosd(R_phi) 0 -sind(R_phi);0 1 0;sind(R_phi) 0 cosd(R_phi)];
Rx = [1 0 0;0 cosd(lanbda_OL) sin(lanbda_OL);0 -sind(lanbda_OL) cos(lanbda_OL)];

for i = 1:50
Local = Ry*Rx*[x(i)-x_OL;y(i)-y_OL;z(i)-z_OL];
n(i) = -Local(1);
e(i) = Local(2);
u(i) = Local(3);
end

%local cartesian
Az = atand(e./n);

Az_d = fix(Az);
Az_m = fix((Az-Az_d)*60);
Az_s = ((Az-Az_d)*60-Az)*60;

El = atand(u./sqrt(e.^2+n.^2));

El_d = fix(El);
El_m = fix((El-El_d)*60);
El_s = ((El-El_d)*60-El)*60;

Sr = sqrt(e.^2+n.^2+u.^2);

fid = fopen('Matrix_dms.txt','w') ;
fprintf(fid,'Pt_ID\txo\tyo\tzo\tlat(度分秒)\tlon(度分秒)\tht\te\tn\tu\tAz(度分秒)\tEl(度分秒)\tSr (Unit:M)\t\r\n');
for i = 1:50
    fprintf(fid,'Pt_%02.0f ,%.3f,%.3f,%.3f,%.0f度%.0f分%.5f秒,%.0f度%.0f分%.5f秒,%.3f,%.3f,%.3f,%.3f,%.0f度%.0f分%.5f秒,%.0f度%.0f分%.5f秒,%.3f \r\n',...
        i,x(i),y(i),z(i),phi_d(i),abs(phi_m(i)),abs(phi_s(i)),lambda_d(i),abs(lambda_m(i)),abs(lambda_s(i)),hs(i),e(i),n(i),u(i),Az_d(i),abs(Az_m(i)),abs(Az_s(i)),El_d(i),abs(El_m(i)),abs(El_s(i)),Sr(i));
end
fclose('all');

fid = fopen('Matrix_demical.txt','w') ;
fprintf(fid,'Pt_ID\txo\tyo\tzo\tlat(度)\tlon(度)\tht\te\tn\tu\tAz(度)\tEl(度)\tSr (Unit:M)\t\r\n');
for i = 1:50
    fprintf(fid,'Pt_%02.0f ,%.3f,%.3f,%.3f,%.9f,%.9f,%.3f,%.3f,%.3f,%.3f,%.9f,%.9f,%.3f\r\n',...
        i,x(i),y(i),z(i),phi(i),lambda(i),hs(i),e(i),n(i),u(i),Az(i),El(i),Sr(i));
end
fclose(fid);

x = ecef(:,1);
y = ecef(:,2);
z = ecef(:,3);