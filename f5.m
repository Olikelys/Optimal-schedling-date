function fv=f5(x) 
dim=length(x);
fv=0;
for i=1:dim
    fv=fv-x(i)*sin(sqrt(abs(x(i))));
end