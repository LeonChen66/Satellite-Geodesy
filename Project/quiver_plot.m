day = [304385.5945	2768092.346
304078.5735	2767927.437
304525.7702	2767795.983
304404.3343	2767811.054
304307.5358	2767534.227
304258.6017	2767589.75
];
night = [304385.5803	2768092.33
304078.598	2767927.451
304525.7791	2767795.991
304404.3461	2767811.053
304307.5331	2767534.227
304258.6084	2767589.736
];

plot(day(:,1),day(:,2),'ks');
hold on;
plot(night(:,1),night(:,2),'ro');

text(day(1,1),day(1,2),'  GCP1')
text(day(2,1),day(2,2),'  GCP10')
text(day(3,1),day(3,2),'  GCP5')
text(day(4,1),day(4,2),'  GCP6')
text(day(5,1),day(5,2),'  GCP7')
text(day(6,1),day(6,2),'  GCP8')



d = day-night;
quiver(day(:,1),day(:,2),d(:,1),d(:,2),0.5)

title('2D Quiver');
xlabel('E (m)')
ylabel('N (m)')
legend('day','night');
%{
day_RMSE = [0.025048524	0.027994897	0.035310864
0.030835972	0.019885386	0.029384155
0.024692393	0.023470346	0.041029606
0.02648989	0.020445048	0.027044936
0.028193211	0.018314709	0.026795522
0.026495283	0.03186579	0.048925599
];

night_RMSE = [0.013223356	0.051727307	0.092083813
0.011735173	0.018700649	0.080891462
0.014101672	0.049068465	0.093399296
0.009985704	0.018322508	0.080049984
0.010378549	0.016995798	0.081433584
0.012873006	0.0518597	0.092083813
];

day_RMSE_all = sqrt((day_RMSE(:,1).^2+day_RMSE(:,2).^2+day_RMSE(:,3).^2)/3);
night_RMSE_all = sqrt((night_RMSE(:,1).^2+night_RMSE(:,2).^2+night_RMSE(:,3).^2)/3);
figure;
bar([1,2,3,4,5,6], [day_RMSE_all,night_RMSE_all], 'grouped')
set(gca,'xticklabel',{'GCP1','GCP10','GCP5','GCP6','GCP7','GCP8'})
legend('day','night');
title('RMSE(ENU)')
xlabel('Station')
ylabel('RMSE (m)')


figure;
bar([1,2,3,4,5,6], [day_RMSE(:,1),night_RMSE(:,1)], 'grouped')
set(gca,'xticklabel',{'GCP1','GCP10','GCP5','GCP6','GCP7','GCP8'})
legend('day','night');
title('RMSE (E)')
xlabel('Station')
ylabel('RMSE (m)')

figure;
bar([1,2,3,4,5,6], [day_RMSE(:,2),night_RMSE(:,2)], 'grouped')
set(gca,'xticklabel',{'GCP1','GCP10','GCP5','GCP6','GCP7','GCP8'})
legend('day','night');
title('RMSE (N)')
xlabel('Station')
ylabel('RMSE (m)')

figure;
bar([1,2,3,4,5,6], [day_RMSE(:,3),night_RMSE(:,3)], 'grouped')
set(gca,'xticklabel',{'GCP1','GCP10','GCP5','GCP6','GCP7','GCP8'})
legend('day','night');
title('RMSE (U vertical)')
xlabel('Station')
ylabel('RMSE (m)')

day_RMSE_hori = sqrt((day_RMSE(:,1).^2+day_RMSE(:,2).^2)/2);
night_RMSE_hori = sqrt((night_RMSE(:,1).^2+night_RMSE(:,2).^2)/2);

figure;
bar([1,2,3,4,5,6], [day_RMSE_hori(:),night_RMSE_hori(:)], 'grouped')
set(gca,'xticklabel',{'GCP1','GCP10','GCP5','GCP6','GCP7','GCP8'})
legend('day','night');
title('RMSE (Horizotal)')
xlabel('Station')
ylabel('RMSE (m)')
%}