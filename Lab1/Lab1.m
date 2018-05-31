r = 26371.000; %KM
x0 =0;
y0 = 0;
z0 = 0;
theta=0:0.1:2*pi; 
phi=0:0.1:pi; 
N = 50;
%{
for k=1:length(theta), 
for j=1:length(phi), 
x(k,j)=x0+r*cos(theta(k))*sin(phi(j)); 
y(k,j)=y0+r*sin(theta(k))*sin(phi(j)); 
z(k,j)=z0+r*cos(phi(j)); 
end, 
end
 %}
%mesh(x,y,z);
a=rand(N,1)*2*pi;
b=asin(rand(N,1)*2-1);
x=x0+r.*cos(a).*cos(b);
y=y0+r.*sin(a).*cos(b);
z=z0+r.*sin(b);
plot3(0,0,0,'.','MarkerSize',30)
hold on;
plot3(x,y,z,'o')
title('simulating 3D points on earth¡¦s surface ')
xlabel('X coordinate');
ylabel('Y coordinate');
zlabel('Zcoordinate');


x_error = 0.025*randn(50,1);
y_error = 0.025*randn(50,1);
z_error = 0.025*randn(50,1);
xr = x+x_error;
yr = y+y_error;
zr = z+z_error;
hold on;
plot3(xr,yr,zr,'k*');
legend('Center','o','error')
So = sqrt(x(:).^2+y(:).^2+z(:).^2);
Sr =sqrt(xr(:).^2+yr(:).^2+zr(:).^2);
hold on;
quiver3(x,y,z,x_error,y_error,z_error)
fid = fopen('Matrix_M_test.txt','w') ;
fprintf(fid,'Pt_ID\txo\tyo\tzo\tSo\txr\tyr\tzr\tSr\tex\tey\tez (Unit:KM)\t\r\n');
for i =1:50
   fprintf(fid,'Pt_%02.0f ,%.3f,%.3f,%.3f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f \r\n',i,x(i),y(i),...
       z(i),So(i),xr(i),yr(i),zr(i),Sr(i),x_error(i),y_error(i),z_error(i));
end
fprintf(fid,'Mean ,%.3f,%.3f,%.3f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f \r\n',sum(x)/50,sum(y)/50,...
       sum(z)/50,sum(So)/50,sum(xr)/50,sum(yr)/50,sum(zr)/50,sum(Sr)/50,sum(x_error)/50,sum(y_error)/50,sum(z_error)/50);
fprintf(fid,'Std ,%.3f,%.3f,%.3f,%.0f,%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f \r\n',std(x),std(y),...
       std(z),std(So),std(xr),std(yr),std(zr),std(Sr),std(x_error),std(y_error),std(z_error));
   
fclose(fid);



