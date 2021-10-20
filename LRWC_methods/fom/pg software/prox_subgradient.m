function [out,fmin,parout] = prox_subgradient(Ffun,Ffun_sgrad,Gfun,Gfun_prox,lambda,startx,par)
%PROX_SUBGRADIENT employs the proximal subgradient method for solving the problem min{f(x) + lambda* g(x)}
%
% Underlying assumptions:
% All functions are convex
% f is Lipschitz 
% g is proper closed and proximable
% lambda is a positive scalar
% ====================================================
% Usage:
% out               = PROX_SUBGRADIENT(Ffun,Ffun_sgrad,Gfun,Gfun_prox,lambda,startx,[par])
% [out,fmin]        = PROX_SUBGRADIENT(Ffun,Ffun_sgrad,Gfun,Gfun_prox,lambda,startx,[par])
% [out,fmin,parout] = PROX_SUBGRADIENT(Ffun,Ffun_sgrad,Gfun,Gfun_prox,lambda,startx,[par])
% ====================================================
% Input:
% Ffun        - function handle for the function f
% Ffun_sgrad  - function handle for the subgradient of the function f
% Gfun        - function handle for the function g
% Gfun_prox   - function handle for the proximal mapping of g times a postive constant
% lambda      - positive scalar penalty for the function g
% startx      - starting vector
% par         - struct which contains different values required for the operation of PROX_SUBGRADIENT
% Fields of par:
%       max_iter   - maximal number of iterations [default: 1000]
%       eco_flag   - true if economic version (without calculating objective function
%                              values) should run, otherwise false [default: false]
%       print_flag - true if internal printing should take place, otherwise false [default: true]
%       alpha      - positive constant determining the stepsize of the method
%                    (which is alpha/sqrt(iternu+1) [default: 1]
%       eps        - stopping criteria tolerance (the method stops when the
%                    norm of the difference between consecutive iterates is < eps) [default: 1e-5]
% ====================================================
% Output:
% out    - optimal solution (up to a tolerance)
% fmin   - optimal value (up to a tolerance)
% parout - a struct containing additional information related to the convergence. The fields of parout are:
%    iterNum   - number of performed iterations
%    funValVec - vector of all function values generated by the method

% This file is part of the FOM package - a collection of first order methods for solving convex optimization problems
% Copyright (C) 2017 Amir and Nili Beck
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

if ((nargin < 6) ||  ( ~isa (Ffun_sgrad,'function_handle')) || ( ~isa (Gfun_prox,'function_handle')))
    error ('usage: prox_subgradient(Ffun,Ffun_sgrad,Gfun,Gfun_prox,lambda,startx,[par])') ;
end

%setting default values
if (nargin < 7)
    par = struct() ;
end

if ( isempty(Ffun) || isempty(Gfun) || ~isa(Ffun,'function_handle') || ~isa(Gfun,'function_handle') )
    if (nargout > 1)
        error('When FFun or Gfun is not a function handle usage: out = prox_subgradient([],Ffun_sgrad,[],Gfun_prox,lambda,startx,[par])')
    else
        if ( ~isfield (par,'eco_flag') || (~par.eco_flag))
            fprintf('Ffun or Gfun is not a function handle, changing to economical mode\n') ;
            par.eco_flag = true ;
            par.print_flag = false ;
        end
    end
end


par = initialize_par_for_prox_subgradient(par) ;

%values from par
max_iter = par.max_iter ;
eco_flag = par.eco_flag ;
print_flag = par.print_flag ;
alpha = par.alpha ;
eps = par.eps ;


if (nargout == 3)
    parout = struct ;
    parout.iterNum = 0 ;
    parout.funValVec = [] ;
end

%Make first vector feasible
startx = Gfun_prox(startx,1e-4);

%Starting values
iternu=0; %iteration number
newx = startx ;
done = false ;
bestx = newx ;
if (~eco_flag)
    newFvalue = Ffun(newx) ;
    bestValue = newFvalue+ lambda * Gfun(newx) ;
end


%First printing
if(print_flag)
    fprintf('*********************\n');
    fprintf('prox_subgradient\n') ;
    fprintf('*********************\n')
    fprintf('#iter       \tfun. val.\n');
    
end

%the iterations
while( (iternu < max_iter) && (~done))
    iternu = iternu + 1;
    currentx = newx ;
    grad = Ffun_sgrad(currentx) ;
   
    if (~eco_flag)
        Fvalue = newFvalue ;
        Gvalue = Gfun (currentx) ;
        FGvalue = Fvalue+lambda*Gvalue ;
        
        if (nargout  == 3)
            %updating parout
            parout.funValVec = [ parout.funValVec ; FGvalue] ;
        end
        if (bestValue > FGvalue)
            bestValue = FGvalue ;
            bestx = currentx ;
            if (print_flag)
                fprintf('%6d \t    %12f \n',iternu,FGvalue);
            end         
        end
        

    end
    
    newt = alpha /( sqrt(iternu + 1));
    newx = Gfun_prox(currentx - newt*grad,newt*lambda) ;
    
    if (~eco_flag)
        newFvalue = Ffun(newx) ;
    end
    
    if (norm(currentx - newx,'fro') < eps)
        if (print_flag)
            fprintf('Stopping because the norm of the difference between consecutive iterates is too small\n')
        end
        done = true ;
    end
end

if (~eco_flag)
    out = bestx ;
else
    out = currentx ;
end

if (nargout == 3)
    %updating parout.iterNum
    parout.iterNum = iternu ;
end

if ((nargout >1) || (print_flag))
    if (~eco_flag)
        fmin = bestValue ;
    else
        fmin = Ffun(out)+lambda*Gfun(out) ;
    end     
end

if (print_flag)
    fprintf('----------------------------------\n') ;
    fprintf('Optimal value = %15f \n',fmin) ;
end

