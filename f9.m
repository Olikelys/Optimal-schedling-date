function fv=f9(x) 
dim=length(x);
fv=0;
y=zeros(1,dim);
u=y;
for i=1:dim
    y(i)=1+1/4*(x(i)+1);
    if x(i)>10
        u(i)=100*(x(i)-10)^4;
    elseif -10<=x(i)
        u(i)=0;
    else
        u(i)=100*(-x(i)-10)^4;
    end
end
for i=1:dim-1
    fv=fv+(y(i)-1)^2*(1+10*(sin(pi*y(i+1)))^2);
end
fv=pi/dim*(10*(sin(pi*y(1)))^2+fv+(y(dim)-1)^2)+sum(u);