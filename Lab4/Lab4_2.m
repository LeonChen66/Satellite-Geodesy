[pts,xo,yo,zo,phi,lambda,he,e_c,n,u,Az,El,Sr] = textread('Matrix_demical.txt','%s %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',1','delimiter',',');

a = 6378137 ;
f = 1/298.257222101;
e = sqrt(2*f-f^2);

x = (N_test+he').*cosd(phi_final).*cosd(lambda');
y = (N_test+he').*cosd(phi_final).*sind(lambda');
z = (N_test*(1-e.^2)+he').*sind(phi_final);

fid = fopen('2_a.txt','w') ;
fprintf(fid,'Pt_ID\t\txo\t\tyo\t\tzo\t\tx\t\ty\t\tz\r\n');
for i = 1:50
    fprintf(fid,'Pt_%02.0f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\r\n',i,xo(i),yo(i),zo(i),x(i),y(i),z(i));
end
fclose('all');
x_error = x'-xo;
y_error = y'-yo;
z_error = z'-zo;
fid = fopen('error.txt','w');
fprintf(fid,'Pt_ID\tx_error\ty_error\tz_error\r\n');
for i =1:50
    fprintf(fid,'Pt_%02.0f\t%.8f\t%.8f\t%.8f\r\n',i,x_error(i),y_error(i),z_error(i));
end
fclose('all');