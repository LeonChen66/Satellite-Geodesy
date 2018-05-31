function[x,y,z] = Ini2ECEF(GST_angle,X,Y,Z)  %function ini2ECEF
    Rz = [cosd(GST_angle) sind(GST_angle) 0;
        -sind(GST_angle) cosd(GST_angle) 0;
        0 0 1];
    xyz = Rz*[X;Y;Z];
    x = xyz(1);
    y = xyz(2);
    z = xyz(3);