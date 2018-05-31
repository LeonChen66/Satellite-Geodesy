%Leon
%GRS 67
phi = -90:1:90;
a = 6378160;
f = 1/298.247167427;
e = sqrt(2*f-f^2);

M_67 = a*(1-e.^2)./(1-e.^2*sind(phi).^2).^1.5;
N_67 = a./sqrt(1-e.^2*sind(phi).^2);
R_avg_67 =1./(0.5.*(1./M_67+1./N_67));
R_g_67 = 1./(sqrt(1./(M_67.*N_67)));

plot(phi,M_67,'.');
hold on;
plot(phi,N_67,'o');
hold on;
plot(phi,R_avg_67,'r*');
hold on;
plot(phi,R_g_67,'kdiamond');

title('GRS 67 \phi -90~90 degree');
xlabel('degree of \phi');
ylabel('M¡BN¡BRadius Unit(meter)');

legend('M','N','R_avg','R_G');
%============GRS 80 ===========
phi = -90:1:90;
a = 6378137 ;
f = 1/298.257222101;
e = sqrt(2*f-f^2);

M_80 = a*(1-e.^2)./(1-e.^2*sind(phi).^2).^1.5;
N_80 = a./sqrt(1-e.^2*sind(phi).^2);
R_avg_80 =1./(0.5.*(1./M_80+1./N_80));
R_g_80 = 1./(sqrt(1./(M_80.*N_80)));
figure;
plot(phi,M_80,'.');
hold on;
plot(phi,N_80,'o');
hold on;
plot(phi,R_avg_80,'r*');
hold on;
plot(phi,R_g_80,'kdiamond');

title('GRS 80 \phi -90~90 degree');
xlabel('degree of \phi');
ylabel('M¡BN¡BRadius Unit(meter)');

legend('M','N','R_avg','R_G');
%======================
fid = fopen('1.txt','w');
fprintf(fid,'latitude\tM_67\tN_67\tR_avg,67\tR_G,67\tM_80\tN80\tR_avg,80\tR_G,80\t\r\n');
for i = 1:length(phi)
fprintf(fid,'%.0f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t\r\n',phi(i),M_67(i),N_67(i),R_avg_67(i),R_g_67(i),M_80(i),N_80(i),R_avg_80(i),R_g_80(i));
end
fclose(fid);