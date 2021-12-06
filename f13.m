function fv=f13(x) 
dim=length(x);
fv=10^5*x(1);
a=zeros(1,dim);
for i=2:dim
    fv=fv+x(i)^2;
end