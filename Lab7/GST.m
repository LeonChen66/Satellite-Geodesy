%GST function
function [GST_angle] = GST(hour,min,sec,t_t0)%initial GST hour min sec
    GST0 =(hour+min/60+sec/3600)*360/24*pi/180;
    we = 7292115.8553*10^-11;
    GST_test = GST0+t_t0*we;
    GST_angle = mod(GST_test,2*pi)*180/pi;