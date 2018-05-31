%Lab4_4
clc
clear
a = 6378137 ;
f = 1/298.257222101;
e = sqrt(2*f-f^2);
[pts,xo,yo,zo,phi_t,lambda_t,he,e_c,n,u,Az,El,Sr] = textread('Matrix_demical.txt','%s %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1','delimiter',',');
%==========test data=========
%xo = 318117.12;
%yo = -4879602.938;
%zo = 4081637.985;
%============================
crt = 0.000001;
for i = 1:10
    X = [lambda_t(i);phi_t(i);he(i)];
    X = deg2rad(X);
    l_0 = [xo(i);yo(i);zo(i)];
    l = l_0;
    V = 100;
    temp = 10;
    stop = 100;
    %while stop>crt
    for j = 1:3
        lambda = X(1);
        phi = X(2);
        h = X(3);
        temp = V;
        N = a/sqrt(1-e^2*sin(phi)^2);
        M = a*(1-e^2)/((1-e^2*sin(phi)^2)^1.5);
        f_l = -([(N+h)*cos(phi)*cos(lambda);(N+h)*cos(phi)*sin(lambda);(N*(1-e^2)+h)*sin(phi)]-l_0);
        %===============================================
        A = [-(N+h)*cos(phi)*sin(lambda) -(M+h)*sin(phi)*cos(lambda) cos(phi)*cos(lambda);
             (N+h)*cos(phi)*cos(lambda) -(M+h)*sin(phi)*sin(lambda) cos(phi)*sin(lambda);
              0 (M+h)*cos(phi) sin(phi);];
        delta_X = inv(A'*A)*(A'*f_l);
        X = X + delta_X; 
        V =(f_l-A*delta_X);
        stop = abs((V'*V/(temp'*temp))-1);
        l = l_0+V;
    end
    stop
    lambda_new(i) = rad2deg(X(1));
    phi_new(i) = rad2deg(X(2));
    h_new(i) =  X(3);
    i
end

lambda_d = fix(lambda_new);
lambda_m = fix((lambda_new-lambda_d)*60);
lambda_s = ((lambda_new-lambda_d)*60-lambda_m)*60;

phi_d = fix(phi_new);
phi_m = fix((phi_new-phi_d)*60);
phi_s = ((phi_new-phi_d)*60-phi_m)*60;

%{
fid = fopen('Lab4_4.txt','w') ;
fprintf(fid,'Pt_ID\txo\tyo\tzo\tlat(度分秒)\tlon(度分秒)\tht (Unit:M)\t\r\n');
for i = 1:50
    fprintf(fid,'Pt_%02.0f ,%.3f,%.3f,%.3f,%.0f度%.0f分%.5f秒,%.0f度%.0f分%.5f秒,%.3f, \r\n',...
        i,xo(i),yo(i),zo(i),phi_d(i),abs(phi_m(i)),abs(phi_s(i)),lambda_d(i),abs(lambda_m(i)),abs(lambda_s(i)),he(i));
end
fclose('all');
%}