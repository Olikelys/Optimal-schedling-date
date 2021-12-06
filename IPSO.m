function [xmin, fxmin, avgen,optimy]=IPSO(MaxIt,PS,dim,e,upbnd,lwbnd,FitFunc) 
iter = 1;% Iterations¡¯counter 
c1 = 2; % PSO parameter C1 
c2 = 2;      % PSO parameter C2
GM=0;          % Global minimum (used in the stopping criterion) 
pop=zeros(PS,dim+1);
s=zeros(1,dim);
optimy=ones(1,MaxIt);
avgen=zeros(1,MaxIt);
pop=rand(PS,dim+1)*(upbnd-lwbnd)+lwbnd; 
vel=rand(PS,dim+1)*(upbnd-lwbnd)+lwbnd;
B=rand(PS,dim+1)*(upbnd-lwbnd)+lwbnd;
A=zeros(PS,dim+1);
for i = 1:PS
    pop(i,dim+1)=FitFunc(pop(i,1:dim)); 
    avgen(iter)=avgen(iter)+pop(i,dim+1);
    optt(i)=pop(i,dim+1);
end
avgen(iter)=avgen(iter)/PS;
[fxmin,g] = min(optt);
optimy(1)=fxmin;
xmin=pop(g,:);
%vell=vel(g,:);
fbestpos=pop; 
for i=1:PS
    A(i,:) = xmin;
end 
while(iter < MaxIt)
    iter = iter + 1; 
    optimy(iter)=optimy(iter-1);
    for i=1:PS
        A(i,:) = xmin;
    end  
    R1 = rand(PS,dim+1);
    R2 = rand(PS,dim+1);
  %  a=rand(1,1)^iter;
    vel =e*vel +R1.*((1.005+1/(MaxIt+1-iter))*(fbestpos-pop)+(1.005-1/(MaxIt+1-iter))*(B-pop)) + c2*R2.*(A-pop);    %( +a*)+R3.*()+)
    pop =pop +vel;  
    % Evaluate the new swarm  
    for i = 1:PS       
        s=bound(pop(i,1:dim),upbnd,lwbnd);
        pop(i,dim+1) = FitFunc(s);                
        avgen(iter)=avgen(iter)+pop(i,dim+1);
        optt(i)=pop(i,dim+1);
        if pop(i,dim+1)<=optimy(iter)
           optimy(iter)=pop(i,dim+1);
           xmin=pop(i,:);
        end 
    end
    [fxmin,g] = min(optt);
    avgen(iter)=avgen(iter)/PS;
    
    % Updating the best position for each particle
    changeColumns =pop(:,dim+1)<fbestpos(:,dim+1);    
    fbestpos(find(changeColumns),:)=pop(find(changeColumns),:);  
       
    r=fix(rand(1,1)*PS)+1;
    pop(r,:)=xmin;
end 
xmin';
fxmin = optimy(iter);
