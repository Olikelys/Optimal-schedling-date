function fv=f2(x)
dim=length(x);
fv=0;
for j=1:dim
    fv=fv+(sum(x(1:j)-50))^2;
end