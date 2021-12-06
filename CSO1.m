% -------------------------------------------------------------------------
% Chicken Swarm Optimization (CSO) (demo)
% Programmed by Xian-Bing Meng
% Updated at Jun 21, 2015.    
% Email: x.b.meng12@gmail.com
%
% This is a simple demo version only implemented the basic idea of CSO for        
% solving the unconstrained problem, namely Sphere function.    
% The details about CSO are illustratred in the following paper.                                                
% Xian-Bing Meng, et al. A new bio-inspired algorithm: Chicken Swarm 
%    Optimization. The Fifth International Conference on Swarm Intelligence  
%
% The parameters in CSO are presented as follows.   CSO�Ĳ�������
% FitFunc    % The objective function    Ŀ�꺯��
% M          % Maxmimal generations (iterations)  ����ĺ����������
% pop        % Population size     �˿ڹ�ģ
% dim        % Dimension    ά��
% G          % How often the chicken swarm can be updated.  ��Ⱥ���Զ�ø���
% rPercent   % The population size of roosters accounts for "rPercent"      ����ռ��rpercent��ռ���˿ڹ�ģ�˿ڹ�ģ
%   percent of the total population size
% hPercent   % The population size of hens accounts for "hPercent" percent 
%  of the total population size
% mPercent   % The population size of mother hens accounts for "mPercent"   ��mpercent����ĸ��ĸ��ռ�˿ڹ�ģ�˿ڹ�ģ
%  percent of the population size of hens
%
% Using the default value,CSO can be executed using the following code.   ʹ��Ĭ��ֵ��CSO����ʹ������Ĵ���ִ��
% [ bestX, fMin ] = CSO
% -------------------------------------------------------------------------
 
%*************************************************************************
% Revision 1
% Revised at May 23, 2015
% 1.Note that the previous version of CSO doen't consider the situation 
%   that there maybe not exist hens in a group. 
%   We assume there exist at least one hen in each group.

% Revision 2
% Revised at Jun 24, 2015
% 1.Correct an error at line "100".
%*************************************************************************

% Main programs

function [ bestX, fMin ] = CSO( FitFunc, M, pop, dim, G, rPercent, hPercent, mPercent )
% Display help
help CSO.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the default parameters   ����Ĭ�ϲ���
if nargin < 1  
    FitFunc = @Sphere;
    M = 1000;  
    pop = 100;  
    dim = 20;  
    G = 10;       
    rPercent = 0.15; 
    hPercent = 0.7;  
    mPercent = 0.5;                  
end

rNum = round( pop * rPercent );    % The population size of roosters   ������������ģ
hNum = round( pop * hPercent );    % The population size of hens
cNum = pop - rNum - hNum;          % The population size of chicks
mNum = round( hNum * mPercent );   % The population size of mother hens

lb= -100*ones( 1,dim );   % Lower bounds  �½�
ub= 100*ones( 1,dim );    % Upper bounds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization  ��ʼ��
for i = 1 : pop  
    x( i, : ) = lb + (ub - lb) .* rand( 1, dim ); 
    fit( i ) = FitFunc( x( i, : ) ); 
end
pFit = fit; % The individual's best fitness value     ������ѽ����ֵ
pX = x;     % The individual's best position corresponding to the pFit     ���˵����λ�ö�ӦpFit

[ fMin, bestIndex ] = min( fit );        % fMin denotes the global optimum   fMin����ȫ������ֵ
% bestX denotes the position corresponding to fMin            bestX�����Ӧȫ������ֵ��λ�� 
bestX = x( bestIndex, : );   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start the iteration.  ��ʼ����
 
for t = 1 : M
    
    % This parameter is to describe how closely the chicks would follow     �������������������е�С����������ǵ�ĸ��Ѱ��ʳ���ʵ�ϣ�����cnumС�������ֻ��cnumֵFL��ʹ��
    % their mother to forage for food. In fact, there exist cNum chicks, 
    % thus only cNum values of FL would be used. 
    FL = rand( pop, 1 ) .* 0.4 + 0.5;  
    
    % The chicken swarm'status about hierarchal order, dominance             ���ڵȼ�����ļ�swarm'status��֧���ϵ��ĸ�ӹ�ϵ��������ĸ����һȺС������һ��ʱ���ڱ����ȶ���
    % relationship, mother-child relationship, the roosters, hens and the 
    % chicks in a group will remain stable during a period of time. These    ��Щ״̬���Ը���ÿһ��ʱ�䲽��G����G������ģ�����������£���Ⱥ�Ѹı䣬
    % statuses can be updated every several (G) time steps.The parameter G 
    % is used to simulate the situation that the chicken swarm have been  
    % changed, including some chickens have died, or the chicks have grown   ����һЩ����������С�������ˣ����˹�������ĸ����һЩĸ�׵�ĸ�����������С�����ȡ�
    % up and became roosters or hens, some mother hens have hatched new
    % offspring (chicks) and so on.
   
   if mod( t, G ) == 1 || t == 1   
                
        [ ans, sortIndex ] = sort( pFit );   
        % How the chicken swarm can be divided into groups and the identity    ����ڼ�Ⱥ�ɷ�Ϊ��ͼ�����ݣ�������ĸ����С��������ȷ��ȡ���ڼ�����Ľ����ֵ��
        % of the chickens (roosters, hens and chicks) can be determined all 
        % depend on the fitness values of the chickens themselves. Hence we     ��ˣ�����ʹ��sortindex���ң����������������ұ����ָ�ꡣ
        % use sortIndex(i) to describe the chicken, not the index i itself.
        
        motherLib = randperm( hNum, mNum ) + rNum;   
        % Randomly select mNum hens which would be the mother hens.          ���ѡ��mnumĸ������ĸ�������Ǽ������еĹ�����ĸ������ǿ��ͬ����ĸ����С��ǿ��
        % We assume that all roosters are stronger than the hens, likewise, 
        % hens are stronger than the chicks.In CSO, the strong is reflected   ��CSO��ǿ�������õĽ����ֵ���֡�������Ż���������С�ģ���˸�ǿ��Ķ�Ӧ�ĵ͵Ľ���ֵ��
        % by the good fitness value. Here, the optimization problems is 
        % minimal ones, thus the more strong ones correspond to the ones  
        % with lower fitness values.
  
        % Given the fact the 1 : rNum chickens' fitness values maybe not      ��ʵ1��rnum���Ľ����ֵҲ������õ�rnum��
        % the best rNum ones. Thus we use sortIndex( 1 : rNum ) to describe     ��ˣ�����ʹ��sortindex��1��rnum����������������������sortindex����rnum+1������1+rnum+hnum����������.....С����ĸ����
        % the roosters. In turn, sortIndex( (rNum + 1) :(rNum + 1 + hNum ))
        % to describle the mother hens, .....chicks.

        % Here motherLib include all the mother hens.                        ����motherlib�������е�ĸ�� 
      
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Randomly select each hen's mate, rooster. Hence we can determine    ���ѡ��ÿһֻĸ������ż����������ˣ����ǿ���ȷ������ÿֻĸ����Ϣ��ʹ��
        % which group each hen inhabits using "mate".Each rooster stands
        % for a group.For simplicity, we assume that there exist only one      Ϊ�˼���������Ǽ���ֻ��һ������������һֻĸ����ÿ���顣
        % rooster and at least one hen in each group.
        mate = randpermF( rNum, hNum );
        
        % Randomly select cNum chicks' mother hens                               ���ѡ��cnum��ĸ��
        mother = motherLib( randi( mNum, cNum, 1 ) );  
   end
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   for i = 1 : rNum                % Update the rNum roosters' values.      ����rnum�����ļ�ֵ
        
        % randomly select another rooster different from the i (th) one.      ���ѡ����һֻ������ͬ���ң���1��
        anotherRooster = randiTabu( 1, rNum, i, 1 );  
        if( pFit( sortIndex( i ) ) <= pFit( sortIndex( anotherRooster ) ) )
            tempSigma = 1;
        else
            tempSigma = exp( ( pFit( sortIndex( anotherRooster ) ) - ...
                pFit( sortIndex( i ) ) ) / ( abs( pFit( sortIndex(i) ) )...
                + realmin ) );
        end
        
        x( sortIndex( i ), : ) = pX( sortIndex( i ), : ) .* ( 1 + ...
            tempSigma .* randn( 1, dim ) );
        x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
        fit( sortIndex( i ) ) = FitFunc( x( sortIndex( i ), : ) );
    end
    
    for i = ( rNum + 1 ) : ( rNum + hNum )  % Update the hNum hens' values.
        
        other = randiTabu( 1,  i,  mate( i - rNum ), 1 );  
        % randomly select another chicken different from the i (th)       ���ѡ����һ����ͬ���ң�����������ż����ע�⣬�����������Ľ����ֵӦ�������ң��ڣ���������ζ�ţ��ң��ڣ������ܻ�͵ȡ������������������ʳ�
        % chicken's mate. Note that the "other" chicken's fitness value  
        % should be superior to that of the i (th) chicken. This means the   
        % i (th) chicken may steal the better food found by the "other" 
        % (th) chicken.
        
        c1 = exp( ( pFit( sortIndex( i ) ) - pFit( sortIndex( mate( i - ...
            rNum ) ) ) )/ ( abs( pFit( sortIndex(i) ) ) + realmin ) );
            
        c2 = exp( ( -pFit( sortIndex( i ) ) + pFit( sortIndex( other ) )));

        x( sortIndex( i ), : ) = pX( sortIndex( i ), : ) + ( pX(...
            sortIndex( mate( i - rNum ) ), : )- pX( sortIndex( i ), : ) )...
             .* c1 .* rand( 1, dim ) + ( pX( sortIndex( other ), : ) - ...
             pX( sortIndex( i ), : ) ) .* c2 .* rand( 1, dim ); 
        x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
        fit( sortIndex( i ) ) = FitFunc( x( sortIndex( i ), : ) );
    end
    
    for i = ( rNum + hNum + 1 ) : pop    % Update the cNum chicks' values.
        x( sortIndex( i ), : ) = pX( sortIndex( i ), : ) + ( pX( ...
            sortIndex( mother( i - rNum - hNum ) ), : ) - ...
            pX( sortIndex( i ), : ) ) .* FL( i );
        x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
        fit( sortIndex( i ) ) = FitFunc( x( sortIndex( i ), : ) );
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Update the individual's best fitness vlaue and the global best one      ���¸�����õĽ����ֵ��ȫ����õ�֮һ 
 
    for i = 1 : pop 
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end
        
        if( pFit( i ) < fMin )
            fMin = pFit( i );
            bestX = pX( i, : );
        end
    end
end
% End of the main program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following functions are associated with the main program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is the objective function
function y = Sphere( x )
y = sum( x .^ 2 );

% Application of simple limits/bounds
function s = Bounds( s, Lb, Ub)
  % Apply the lower bound vector
  temp = s;
  I = temp < Lb;
  temp(I) = Lb(I);
  
  % Apply the upper bound vector  Ӧ����������
  J = temp > Ub;
  temp(J) = Ub(J);
  % Update this new move  ��������µĶ���
  s = temp;

%--------------------------------------------------------------------------
% This function generate "dim" values, all of which are different from       ����������ɵġ�ģ����ֵ��������Щ���ǲ�ͬ�ġ����ɡ��ļ�ֵ
%  the value of "tabu"
function value = randiTabu( min, max, tabu, dim )
value = ones( dim, 1 ) .* max .* 2;
num = 1;
while ( num <= dim )
    temp = randi( [min, max], 1, 1 );
    if( length( find( value ~= temp ) ) == dim && temp ~= tabu )
        value( num ) = temp;
        num = num + 1;
    end
end

%--------------------------------------------------------------------------
function result = randpermF( range, dim )
% The original function "randperm" in Matlab is only confined to the         ԭ������Matlab randperm��ֻ�Ǿ�������״���ߴ�Ȼ谵�Ĵ��ޡ��˹��������ڽ�����������
% situation that dimension is no bigger than dim. This function is 
% applied to solve that situation.

temp = randperm( range, range );
temp2 = randi( range, dim, 1 );
index = randperm( dim, ( dim - range ) );
result = [ temp, temp2( index )' ];