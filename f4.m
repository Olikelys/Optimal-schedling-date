function fv=f4(x) 
dim=length(x);
fv=0;
for i=1:dim-1
    fv=fv+100*(200+x(i+1)-(x(i))^2)^2+(x(i)-50)^2;
end