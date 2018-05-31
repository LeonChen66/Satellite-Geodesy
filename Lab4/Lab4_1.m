[pts,xo,yo,zo,phi,lambda,hs,e,n,u,Az,El,Sr] = textread('Matrix_xoyozo.txt','%s %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1','delimiter',',');
a = 6378137 ;
f = 1/298.257222101;
e = sqrt(2*f-f^2);
%==========test data=========
%xo = 318117.12;
%yo = -4879602.938;
%zo = 4081637.985;
%============================
crt = 0.00000000001;

for i = 1:50
    if xo(i)<0 && yo(i)<0
        lambda(i) = atand(yo(i)/xo(i))-180;
    elseif  xo(i)<0
        lambda(i) = atand(yo(i)/xo(i))+180;
    else
        lambda(i) = atand(yo(i)/xo(i));
    end
end

temp = 100000;

for i = 1:50
    phi = atan(zo(i)/sqrt(xo(i)^2+yo(i)^2));
    j=0;
    while abs(phi-temp)>crt 
        temp = phi;
        N = a/sqrt(1-e^2*sin(phi)^2);
        phi = atan((zo(i)+N*e^2*sin(phi))/sqrt(xo(i)^2+yo(i)^2));
        j=j+1;
    end
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

%local
x_OL = xo(1);
y_OL = yo(1);
z_OL = zo(1);
lanbda_OL = lambda(1);
phi_OL = phi_final(1);
R_phi = 90-phi_OL;
Ry = [cosd(R_phi) 0 -sind(R_phi);0 1 0;sind(R_phi) 0 cosd(R_phi)];
Rx = [1 0 0;0 cosd(lanbda_OL) sin(lanbda_OL);0 -sind(lanbda_OL) cos(lanbda_OL)];

for i = 1:50
Local = Ry*Rx*[xo(i)-x_OL;yo(i)-y_OL;zo(i)-z_OL];
n(i) = -Local(1);
e(i) = Local(2);
u(i) = Local(3);
end

e = e';
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
        i,xo(i),yo(i),zo(i),phi_d(i),abs(phi_m(i)),abs(phi_s(i)),lambda_d(i),abs(lambda_m(i)),abs(lambda_s(i)),he(i),e(i),n(i),u(i),Az_d(i),abs(Az_m(i)),abs(Az_s(i)),El_d(i),abs(El_m(i)),abs(El_s(i)),Sr(i));
end
fclose('all');

fid = fopen('Matrix_demical.txt','w') ;
fprintf(fid,'Pt_ID\txo\tyo\tzo\tlat(度)\tlon(度)\tht\te\tn\tu\tAz(度)\tEl(度)\tSr (Unit:M)\t\r\n');
for i = 1:50
    fprintf(fid,'Pt_%02.0f ,%.3f,%.3f,%.3f,%.9f,%.9f,%.3f,%.3f,%.3f,%.3f,%.9f,%.9f,%.3f\r\n',...
        i,xo(i),yo(i),zo(i),phi_final(i),lambda(i),he(i),e(i),n(i),u(i),Az(i),El(i),Sr(i));
end
fclose(fid);
