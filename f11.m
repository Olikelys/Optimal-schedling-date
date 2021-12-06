function fv=f11(x)%[-5.12, 5.15]
dim=length(x);
fv=0;
a=zeros(1,dim);
for i=1:dim
    fv=fv+i*(x(i)-3)^2;
end
