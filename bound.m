% Application of simple constraints
function s=bound(s,Lb,Ub)
  % Apply the lower bound
  ns_tmp=s;
  
  II=ns_tmp<Lb;
  if rand()<0.618
      ns_tmp(II)=Lb+(Ub-Lb)*rand();
  else
      ns_tmp(II)=Lb;
  end
      
    
  % Apply the upper bounds 
  JJ=ns_tmp>Ub;
  if rand()<0.618
      ns_tmp(JJ)=Lb+(Ub-Lb)*rand();
  else
      ns_tmp(JJ)=Ub;
  end
 
  % Update this new move 
  s=ns_tmp;  