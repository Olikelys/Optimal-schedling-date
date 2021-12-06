function fv=f14(x) 
dim=length(x);
fv=0;
a=zeros(1,dim);
for i=1:dim
    fv=fv-sin(x(i))*(sin(i*x(i)^2/pi))^20;
end
