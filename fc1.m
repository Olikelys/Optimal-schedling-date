function fv=fc1(x)
P=3.14159265;
fv=21.5+x(1)*sin(4*P*x(1))+x(2)*sin(20*P*x(2));
fv=-fv;