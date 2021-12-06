function fv=f6(x) 
dim=length(x);
fv=0;
for i=1:dim
    fv=fv+(x(i)-3)^2-10*cos(2*pi*(x(i)-3))+10;
end