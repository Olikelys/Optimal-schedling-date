function fv=fc7(x)
v1=0;
v2=0;
for i=1:5
    v1=v1+i*cos((i+1)*x(1)+i);
end
for i=1:5
    v2=v2+i*cos((i+1)*x(2)+i);
end
fv=v1*v2+0.5*((x(1)+1.42513)^2+(x(2)+0.80032)^2);