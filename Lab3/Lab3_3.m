%Leon Lab3-3
%GRS 67
a = 6378160;
f = 1/298.247167427;
b = a-(a*f);
L = deg2rad(42/60+30.9185/3600-10/60-20.0123/3600);
U1 = atan((1-f)*tand(23+11/60+30.3255/3600));
U2 = atan((1-f)*tand(24+3/60+10.1978/3600));
lambda = L;
lambda_p = 2*pi;

while abs(lambda-lambda_p)>10^-12
    sin_rho = sqrt((cos(U2)*sin(lambda))^2+(cos(U1)*sin(U2)-sin(U1)*cos(U2)*cos(lambda))^2);
    cos_rho = sin(U1)*sin(U2)+cos(U1)*cos(U2)*cos(lambda);
    rho = atan2(sin_rho,cos_rho);
    sin_alpha = cos(U1)*cos(U2)*sin(lambda)/sin_rho;
    cos_2_alpha2 = 1-sin_alpha^2;
    cos2_rho_m = cos_rho-2*sin(U1)*sin(U2)/cos_2_alpha2;
    C = f/16*cos_2_alpha2*(4+f*(4-3*cos_2_alpha2));
    lambda_p = lambda;
    lambda = L+(1-C)*f*sin_alpha*(rho+C*sin_rho*(cos2_rho_m+C*cos_rho*(-1+2*cos2_rho_m)));
end

u_2 = cos_2_alpha2*(a^2-b^2)/b^2;
A = 1+u_2/16384*(4096+u_2*(-768+u_2*(320-175*u_2)));
B = u_2/1024*(256+u_2*(-128+u_2*(74-47*u_2)));
delta_rho = B*sin_rho*(cos2_rho_m+B/4*(cos_rho*(-1+2*cos2_rho_m)-B/6*cos2_rho_m*(-3+4*sin_rho^2)*(-3+4*cos2_rho_m)));
s = b*A*(rho-delta_rho)

%====Lambert
%phi1 2 = U1 U2
P = (sin(U1)+sin(U2))^2;
Q = (sin(U1)-sin(U2))^2;

rho = acos(sin(U1)*sin(U2)+cos(U1)*cos(U2)*cos(L));

X = (rho-sin(rho))/(4*(1+cos(rho)));
Y = (rho+sin(rho))/(4*(1-cos(rho)));

d = a*(rho-f*(P*X+Q*Y))