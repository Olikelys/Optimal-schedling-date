function fv=f12(x) %[-1 1]
dim=length(x);
fv=0;
a=zeros(1,dim);
for i=1:dim
    fv=fv+abs(x(i))^(i+1);
end

