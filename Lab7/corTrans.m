function[X,Y,Z] = corTrans(GST_angle,x,y,z)  %function ECEF2iniFrame
    Rz_T = [cosd(GST_angle) sind(GST_angle) 0;
        -sind(GST_angle) cosd(GST_angle) 0;
        0 0 1]';
    XYZ = Rz_T*[x;y;z];
    X = XYZ(1);
    Y = XYZ(2);
    Z = XYZ(3);