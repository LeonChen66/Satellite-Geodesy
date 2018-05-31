clear
clc
data = textread('iluc1520.17o','%s','delimiter','\n','whitespace','','headerlines',33);
temp = 1;
test = {};
for i = 1:length(data)
    line = data{i};
    findstr(line,'17  6  1');
    i;
    if findstr(line,'17  6  1');
       head = strsplit(line);
       
       test(temp,1:6) = head(2:7);
       idx = findstr(head{9},'G');
       test(temp,7) = {head{9}(1:idx(1)-1)};
       S_number = str2num(head{9}(1:idx(1)-1));
       for j = 1:S_number
            test(temp,7+2*j-1) = {head{9}(idx(j):idx(j)+2)};
            pseudo_r = strsplit(data{i+2*j-1});
            if length(pseudo_r) == 7
                test(temp,7+2*j) = pseudo_r(6);
            elseif length(pseudo_r) == 5
                test(temp,7+2*j) = pseudo_r(5);
            else
                test(temp,7+2*j) = pseudo_r(4);
            end
       end
       
       temp = temp+1;
       
    end
end

test_temp = {};
temp = 1;
for i = 1:length(test)
    if mod(i,30)==1
        test_temp(temp,:) = test(i,:);
        temp = temp +1;
    end
end

temp = 1;
sp3 = textread('igr19514.sp3','%s','delimiter','\n','whitespace','','headerlines',22);
temp_2 = 1;
final = {};
for i = 1:length(sp3)
    if temp > 4
        break
    end
    date = sprintf('%s  %s  %s  %s  %s  %s',test_temp{temp,1},test_temp{temp,2},test_temp{temp,3},test_temp{temp,4},test_temp{temp,5},test_temp{temp,6});
    date_2 = sprintf('%s  %s  %s  %s %s  %s',test_temp{temp,1},test_temp{temp,2},test_temp{temp,3},test_temp{temp,4},test_temp{temp,5},test_temp{temp,6});
    line = sp3{i};
    if findstr(line,date)
        temp;
        S_number = str2num(test_temp{temp,7});
        for j = 1:S_number
            S_name = test_temp{temp,2*j-1+7};
            S_range = test_temp{temp,2*j+7};
            for k = 1:32
                if strfind(sp3{i+k},S_name);
                    final(temp_2,1) = {S_name};
                    final(temp_2,2) = {S_range};
                    sp3_line = strsplit(sp3{i+k});
                    final(temp_2,3) = sp3_line(2);
                    final(temp_2,4) = sp3_line(3);
                    final(temp_2,5) = sp3_line(4);
                    final(temp_2,6) = sp3_line(5);
                    temp_2 = temp_2+1;
                end
            end
        end
        temp = temp+1;
    end

    if findstr(line,date_2)
        temp;
        S_number = str2num(test_temp{temp,7});
        for j = 1:S_number
            S_name = test_temp{temp,2*j-1+7};
            S_range = test_temp{temp,2*j+7};
            for k = 1:32
                if strfind(sp3{i+k},S_name);
                    final(temp_2,1) = {S_name};
                    final(temp_2,2) = {S_range};
                    sp3_line = strsplit(sp3{i+k});
                    final(temp_2,3) = sp3_line(2);
                    final(temp_2,4) = sp3_line(3);
                    final(temp_2,5) = sp3_line(4);
                    final(temp_2,6) = sp3_line(5);
                    
                    temp_2 = temp_2+1;
                end
            end
        end
        temp = temp+1;
    end

end

Obs = [cellfun(@str2num,final(:,2:end),'un',0).'];
Obs = cell2mat(Obs)';

syms xr yr zr xs ys zs pr c delta_t
f = sqrt((xs-xr).^2+(ys-yr).^2+(zs-zr).^2)-c*delta_t-pr;
d_xr = diff(f,xr);
d_yr = diff(f,yr);
d_zr = diff(f,zr);
d_t = diff(f,delta_t);

inline_f = inline(f,'xr','yr','zr','xs','ys','zs','pr','c','delta_t');
inline_xr = inline(d_xr,'xr','yr','zr','xs','ys','zs','pr','c','delta_t');
inline_yr = inline(d_yr,'xr','yr','zr','xs','ys','zs','pr','c','delta_t');
inline_zr = inline(d_zr,'xr','yr','zr','xs','ys','zs','pr','c','delta_t');
inline_t = inline(d_t,'xr','yr','zr','xs','ys','zs','pr','c','delta_t');

c = 299792458;

range = Obs(:,1);
x_stallite = Obs(:,2)*1000;
y_stallite = Obs(:,3)*1000;
z_stallite = Obs(:,4)*1000;
t = Obs(:,5)*10^-6;
x_OL =151737.8850;
y_OL = -4883457.1360;
z_OL = 4086550.0170;

for i = 1:10 
    B(:,1) = inline_xr(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range,c,t);
    B(:,2) = inline_yr(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range,c,t);
    B(:,3) = inline_zr(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range,c,t);
    B(:,4) = zeros(length(range),1)+c;
    f = -inline_f(x_OL,y_OL,z_OL,x_stallite,y_stallite,z_stallite,range,c,t);
    %{
    B(:,1) = subs(d_xr);
    B(:,2) = subs(d_yr);
    B(:,3) = subs(d_zr);
    f = -(sqrt((xs-xr).^2+(ys-yr).^2+(zs-zr).^2)-pr);
%}    
    X = inv(B'*B)*B'*f;
    x_OL = X(1)+x_OL;
    y_OL = X(2)+y_OL;
    z_OL = X(3)+z_OL;
    t = X(4)+t;
    V = (f-B*X);
    %range = range_0 + V ;
end

lp = -88.2203;
pp = 40.0990;

sigma_0 = sqrt(V'*V/(40))
sigma_XX = sigma_0^2*inv(B'*B);
sigma_XX = sigma_XX(1:3,1:3)
J = [-sind(pp)*cosd(lp),-sind(pp)*sind(lp),cosd(pp);-sind(lp),cosd(lp),0;
    cosd(pp)*cosd(lp),cosd(pp)*sind(lp),sind(pp)];
sigma_enu = J*sigma_XX*J';
Q_enu = 1/(sigma_0)^2*(sigma_enu);
q_e2 = Q_enu(1,1);
q_n2 = Q_enu(2,2);
q_u2 = Q_enu(3,3);
PDOP = sqrt(q_e2+q_n2+q_u2)
VDOP = sqrt(q_u2)
HDOP = sqrt(q_e2+q_n2)
sigma = sigma_0*PDOP
