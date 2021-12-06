function fv=f8(x) 
dim=length(x);
fv=0;
a=zeros(1,dim);
for i=1:dim
    a(i)=cos((x(i)-100)/sqrt(i));
end
fv=1/4000*sum((x-100).^2)-prod(a)+1;