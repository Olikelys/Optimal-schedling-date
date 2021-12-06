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
% The parameters in CSO are presented as follows.   CSO的参数如下
% FitFunc    % The objective function    目标函数
% M          % Maxmimal generations (iterations)  极大的后代（迭代）
% pop        % Population size     人口规模
% dim        % Dimension    维数
% G          % How often the chicken swarm can be updated.  鸡群可以多久更新
% rPercent   % The population size of roosters accounts for "rPercent"      公鸡占“rpercent”占总人口规模人口规模
%   percent of the total population size
% hPercent   % The population size of hens accounts for "hPercent" percent 
%  of the total population size
% mPercent   % The population size of mother hens accounts for "mPercent"   “mpercent”成母鸡母鸡占人口规模人口规模
%  percent of the population size of hens
%
% Using the default value,CSO can be executed using the following code.   使用默认值，CSO可以使用下面的代码执行
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
% set the default parameters   设置默认参数
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

rNum = round( pop * rPercent );    % The population size of roosters   公鸡的数量规模
hNum = round( pop * hPercent );    % The population size of hens
cNum = pop - rNum - hNum;          % The population size of chicks
mNum = round( hNum * mPercent );   % The population size of mother hens

lb= -100*ones( 1,dim );   % Lower bounds  下界
ub= 100*ones( 1,dim );    % Upper bounds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization  初始化
for i = 1 : pop  
    x( i, : ) = lb + (ub - lb) .* rand( 1, dim ); 
    fit( i ) = FitFunc( x( i, : ) ); 
end
pFit = fit; % The individual's best fitness value     个人最佳健身价值
pX = x;     % The individual's best position corresponding to the pFit     个人的最佳位置对应pFit

[ fMin, bestIndex ] = min( fit );        % fMin denotes the global optimum   fMin代表全局最优值
% bestX denotes the position corresponding to fMin            bestX代表对应全局最优值的位置 
bestX = x( bestIndex, : );   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start the iteration.  开始迭代
 
for t = 1 : M
    
    % This parameter is to describe how closely the chicks would follow     这个参数是描述如何密切的小鸡会跟随他们的母亲寻找食物。事实上，存在cnum小鸡，因此只有cnum值FL会使用
    % their mother to forage for food. In fact, there exist cNum chicks, 
    % thus only cNum values of FL would be used. 
    FL = rand( pop, 1 ) .* 0.4 + 0.5;  
    
    % The chicken swarm'status about hierarchal order, dominance             关于等级秩序的鸡swarm'status，支配关系，母子关系，公鸡，母鸡和一群小鸡将在一段时间内保持稳定。
    % relationship, mother-child relationship, the roosters, hens and the 
    % chicks in a group will remain stable during a period of time. These    这些状态可以更新每一个时间步（G），G是用来模拟参数的情况下，鸡群已改变，
    % statuses can be updated every several (G) time steps.The parameter G 
    % is used to simulate the situation that the chicken swarm have been  
    % changed, including some chickens have died, or the chicks have grown   包括一些鸡死亡，或小鸡长大了，成了公鸡或者母鸡，一些母亲的母鸡孵出后代（小鸡）等。
    % up and became roosters or hens, some mother hens have hatched new
    % offspring (chicks) and so on.
   
   if mod( t, G ) == 1 || t == 1   
                
        [ ans, sortIndex ] = sort( pFit );   
        % How the chicken swarm can be divided into groups and the identity    如何在鸡群可分为组和鸡的身份（公鸡、母鸡和小鸡）可以确定取决于鸡本身的健身价值。
        % of the chickens (roosters, hens and chicks) can be determined all 
        % depend on the fitness values of the chickens themselves. Hence we     因此，我们使用sortindex（我）来描述鸡，不是我本身的指标。
        % use sortIndex(i) to describe the chicken, not the index i itself.
        
        motherLib = randperm( hNum, mNum ) + rNum;   
        % Randomly select mNum hens which would be the mother hens.          随机选择mnum母鸡都是母鸡。我们假设所有的公鸡比母鸡，更强，同样，母鸡比小鸡强。
        % We assume that all roosters are stronger than the hens, likewise, 
        % hens are stronger than the chicks.In CSO, the strong is reflected   在CSO，强是由良好的健身价值体现。在这里，优化问题是最小的，因此更强大的对应的低的健身值。
        % by the good fitness value. Here, the optimization problems is 
        % minimal ones, thus the more strong ones correspond to the ones  
        % with lower fitness values.
  
        % Given the fact the 1 : rNum chickens' fitness values maybe not      事实1：rnum鸡的健身价值也许不是最好的rnum。
        % the best rNum ones. Thus we use sortIndex( 1 : rNum ) to describe     因此，我们使用sortindex（1：rnum）来描述公鸡。反过来，sortindex（（rnum+1）：（1+rnum+hnum））来描述.....小鸡的母鸡。
        % the roosters. In turn, sortIndex( (rNum + 1) :(rNum + 1 + hNum ))
        % to describle the mother hens, .....chicks.

        % Here motherLib include all the mother hens.                        这里motherlib包括所有的母鸡 
      
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Randomly select each hen's mate, rooster. Hence we can determine    随机选择每一只母鸡的配偶，公鸡。因此，我们可以确定该组每只母鸡栖息的使用
        % which group each hen inhabits using "mate".Each rooster stands
        % for a group.For simplicity, we assume that there exist only one      为了简单起见，我们假设只有一个公鸡和至少一只母鸡在每个组。
        % rooster and at least one hen in each group.
        mate = randpermF( rNum, hNum );
        
        % Randomly select cNum chicks' mother hens                               随机选择cnum鸡母鸡
        mother = motherLib( randi( mNum, cNum, 1 ) );  
   end
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   for i = 1 : rNum                % Update the rNum roosters' values.      更新rnum公鸡的价值
        
        % randomly select another rooster different from the i (th) one.      随机选择另一只公鸡不同于我（第1）
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
        % randomly select another chicken different from the i (th)       随机选择另一个不同于我（鸡）鸡的配偶。请注意，“其他”鸡的健身价值应该优于我（第）鸡。这意味着，我（第）鸡可能会偷取“其他”（鸡）鸡的食物。
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
   % Update the individual's best fitness vlaue and the global best one      更新个人最好的健身价值和全球最好的之一 
 
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
  
  % Apply the upper bound vector  应用上限向量
  J = temp > Ub;
  temp(J) = Ub(J);
  % Update this new move  更新这个新的动作
  s = temp;

%--------------------------------------------------------------------------
% This function generate "dim" values, all of which are different from       这个函数生成的“模糊”值，所有这些都是不同的“禁忌”的价值
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
% The original function "randperm" in Matlab is only confined to the         原函数在Matlab randperm”只是局限于现状，尺寸比昏暗的大无。此功能适用于解决这种情况。
% situation that dimension is no bigger than dim. This function is 
% applied to solve that situation.

temp = randperm( range, range );
temp2 = randi( range, dim, 1 );
index = randperm( dim, ( dim - range ) );
result = [ temp, temp2( index )' ];