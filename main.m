clear;
w=2;
genn=200;
PS=100;
dim=3;
e=0.25;
rP=0.15; %rPercent
hP=0.75;
mP=0.5;
FitFunc = @f1;

upbnd = 100;  % Upper bounds    
lwbnd = -100;  % Lower bounds 
G=10;

IPSOm=zeros(1,w);
CSOm=zeros(1,w);
ICSOm=zeros(1,w);


IPSOAvgen=cell(w,1);
CSOAvgen=cell(w,1);
ICSOAvgen=cell(w,1);

IPSOoptimy=cell(w,1);
CSOoptimy=cell(w,1);
ICSOoptimy=cell(w,1);


CSSE=cell(w,1);
NCSNSE=cell(w,1);
ICSOSE=cell(w,1);
HPCSE=cell(w,1);

global v
tic;
tpstart=clock;
for v=1:w
    [IPSOse,IPSOms,IPSOavgen,optimy]=IPSO(genn,PS,dim,e,upbnd,lwbnd,FitFunc);
    IPSOm(v)=IPSOms;
    IPSOSE{v,1}=IPSOse;
    IPSOAvgen{v,1}=IPSOavgen;
    IPSOoptimy{v,1}=optimy;
end
toc;
tpend=clock;

tic;
tcstart=clock;
for v=1:w    
    [CSOse,CSOms,avgen,optimyg]=CSO(genn,PS,dim,upbnd,lwbnd,rP,hP,mP,FitFunc,G);
    CSOm(v)=CSOms;
    CSOSE{v,1}=CSOse;
    CSOAvgen{v,1}=avgen;
    CSOoptimy{v,1}=optimyg;
end
toc;
tcend=clock;

tic;
ticstart=clock;
for v=1:w
    [ICSOse,ICSOms,ICSOavgen,optimy]=ICSO(genn,PS,dim,upbnd,lwbnd,rP,hP,mP,FitFunc,G);
    ICSOm(v)=ICSOms;
    ICSOSE{v,1}=ICSOse;
    ICSOAvgen{v,1}=ICSOavgen;
    ICSOoptimy{v,1}=optimy;
end
toc;
ticend=clock;

diary data1.m
IPSOtime=tpend-tpstart
CSOtime=tcend-tcstart
ICSOtime=ticend-ticstart

IPSOm
CSOm
ICSOm

IPSOstd=std(IPSOm)
CSOstd=std(CSOm)
ICSOstd=std(ICSOm)

IPSOminm=min(IPSOm)  
CSOminm=min(CSOm) 
ICSOminm=min(ICSOm) 

IPSOaverage=mean(IPSOm)
CSOaverage=mean(CSOm)
ICSOaverage=mean(ICSOm)

IPSOh=find(IPSOm==IPSOminm);
CSOh=find(CSOm==CSOminm);
ICSOh=find(ICSOm==ICSOminm);
diary off


IPSOop=IPSOoptimy{IPSOh(1),1};
CSOop=CSOoptimy{CSOh(1),1};
ICSOop=ICSOoptimy{ICSOh(1),1};

figure(1);
plot(1:genn,IPSOop(1:genn),'k:',1:genn,CSOop(1:genn),'b--',1:genn,ICSOop(1:genn),'r');
ylabel('Mini fitness value','FontSize',8,'Color','b');
xlabel('Evolvement generation','FontSize',8,'Color','b');
title('The Convergence Curve','FontSize',12,'Color','r');
legend('IPSO','CSO','ICSO',1); 

zd=zeros(1,4);
zd(1)=max(IPSOm);
zd(2)=max(CSOm);
zd(3)=max(ICSOm);
YV=max(zd);

figure(2);
plot(1:w,IPSOm,'k-*',1:w,CSOm,'g-x',1:w,ICSOm,'r-pentagram'); 
ylabel('Fitness value','FontSize',8,'Color','b');
xlabel('Times','FontSize',8,'Color','b');
title('The Distribution Curve','FontSize',12,'Color','r');
axis([1 w -100 YV+100]);
legend('IPSO','CSO','ICSO',1); 

saveas(figure(1),'Convergence.fig');
saveas(figure(2),'Distribution.fig')