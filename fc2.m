function fv=f11(x)
fv=sin(sqrt((x(1)-50)^2+(x(2)-50)^2)+exp(1))/(sqrt((x(1)-50)^2+(x(2)-50)^2)+exp(1))+1;
fv=-fv;