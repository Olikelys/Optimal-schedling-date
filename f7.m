function fv=f7(x) 
dim=length(x);
fv=0;
fv=-20*exp(-0.2*sqrt(1/dim*sum(x.^2)))-exp(1/dim*sum(cos(2*pi*x)))+20+exp(1);