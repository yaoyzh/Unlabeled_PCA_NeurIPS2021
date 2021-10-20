function [out,fmin,parout]=comirror_specta_formd(Ffun,Ffun_sgrad,Gfun,Gfun_sgrad,startx,feas_eps,specR,maxiter,isequal,upb,ecoflag,printflag,printcon,stuckiter)
% COMIRROR_SPECTA_FORMD employs the co-mirror descent method inside the md software. 
% It is used when the underlying set is a spectahedron.
% ====================================================
% Usage:
% out               = COMIRROR_SPECTA_FORMD(Ffun,Ffun_sgrad,Gfun,Gfun_sgrad,startx,feas_eps,specR,maxiter,isequal,upb,ecoflag,printflag,printcon,stuckiter)
% [out,fmin]        = COMIRROR_SPECTA_FORMD(Ffun,Ffun_sgrad,Gfun,Gfun_sgrad,startx,feas_eps,specR,maxiter,isequal,upb,ecoflag,printflag,printcon,stuckiter)
% [out,fmin,parout] = COMIRROR_SPECTA_FORMD(Ffun,Ffun_sgrad,Gfun,Gfun_sgrad,startx,feas_eps,specR,maxiter,isequal,upb,ecoflag,printflag,printcon,stuckiter)
% ====================================================
% Input:
% Ffun        - function handle for the objective function f
% Ffun_sgrad  - function handle for the subgradient of the objective function f
% Gfun        - function handle for the constraint function g
% Gfun_sgrad  - function handle for the subgradients of the components of the constraint function (arranged in columns)
% startx      - a starting vector
% feas_eps    - feasibility tolerance
% specR       - value of required trace 
% maxiter     - maximal number of iterations
% isequal     - true if equality is imposed, otherwise false
% upb         - upper bound on the variables
% ecoflag     - true if economic version (without calculating objective function
%                              values) should run, otherwise false
% printflag   - true if internal printing should take place, otherwise false
% printcon    - true if constraint value should be printed, otherwise false
% stuckiter   - maximal allowed number of iterations without improvement
% ====================================================
% Output:
% out    - optimal solution (up to a tolerance)
% fmin   - optimal value (up to a tolerance)
% parout - a struct containing additional information related to the convergence. The fields of parout are:
%    iterNum   - number of performed iterations
%    funValVec - vector of all function values generated by the method
%    consVec   - vector containing all the constraints violations quantities (when relevant)

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

%constant values:
delta=1e-13;
alpha=1;
n = length(startx) ;
theta=log(n);
startfmin = inf ;

eps = 1e-5 ; %for inner calculations


%starting values
iternu=0; 
newx = startx ;


%Make our initial vector feasible
if (norm( newx - newx') > eps)
    fprintf('Your starting point is not symmetric, changing it.\n') ;
end
newx = 0.5 * (newx + newx');
if (isequal)
    newx =  proj_spectahedron_box(newx,specR,0,upb,'eq') ;
else
    newx =  proj_spectahedron_box(newx,specR,0,upb,'ineq') ;
end

out = newx ; 

%move the point to the 1 simplex
newx=newx/trace(newx) ;


derf= CoverF_objder(Ffun_sgrad,newx,specR) ;
[newg,derg] = CoverF_con(Gfun,Gfun_sgrad,newx,specR) ;
fmin = startfmin ;
savediter=-1; % to indicate that we haven't found any feasible solution so far
%starting parout, when necessary
if (nargout  == 3)
    parout = struct ;
    parout.iterNum = 0 ;
    parout.funValVec = [] ;
    if (printcon)
        parout.consVec  = [] ;
    end
end


%the iterations
while( (iternu < maxiter))
    iternu=iternu+1;
    xiter=newx ;
    if (newg < feas_eps)
        ftag = derf; %subgradient for objective function
    else
        ftag = derg ;%subgradient for constraint function
    end
    gama = sqrt(theta*alpha)/(norm(ftag,2)*sqrt(iternu)); 
    
    xiter  = (xiter  + xiter') / 2; %making sure xiter is symmetric
    if (min(eig(xiter)) < eps) %and positive definite
        xiter = xiter + delta * eye(n) ;
    end
 
    
    omega=logm(xiter)+eye(n) ;
    A=gama*ftag-omega;
    A= (A + A') / 2 ; %making sure A is symmetric
    [U,D] = eig(A) ; 
    a = diag(D) ;
    
    %checking whether the sum is smaller than sumx when it is necessary
    p=-a ;
    newxvec = exp(p-1) ;
    %since we are using coverF, sumx here is exchanged for 1
    if ((sum(newxvec) > 1) || (isequal == true))
        phat=p-max(p) ;
        ep=exp(phat) ;
        newxvec = 1*ep/sum(ep) ;
    end
    
    if (~all(newxvec < upb))
        newxvec =find_newx_under_ub(a,upb,isequal) ;
    end
    
    newx = U * diag(newxvec) * U' ;
    derf = CoverF_objder(Ffun_sgrad,newx,specR) ;
    [newg,derg] = CoverF_con(Gfun,Gfun_sgrad,newx,specR) ;
  
    if (~ecoflag)
         if (iternu - savediter > stuckiter)
            fprintf('Stopping because of %d iterations with no improvement\n',stuckiter) ;
            break
        end
        
        newf = CoverF_objval(Ffun,newx,specR) ;
        if (nargout  == 3)
            %updating parout
            parout.funValVec = [ parout.funValVec ; newf] ;
            if (printcon)
                parout.consVec = [ parout.consVec ; newg] ;
            end
        end
        if ( (newf < fmin ) && (newg < feas_eps)  )
            fmin = newf ;
            out = newx ;
            if (printflag)
                if (printcon)
                    fprintf('%6d \t    %12f\t %12f\n',iternu,fmin,newg);
                else
                    fprintf('%6d \t    %12f \n',iternu,fmin);
                end
            end
            savediter=iternu ;
        end
    else %ecoflag = true, just looking for a feasible solution
        if (newg < feas_eps)
            out = newx ;
            savediter=iternu ;
        end
    end
    
end

if (savediter ~= -1)
    %found a feasible solution
    %moving the result vector back
    out = specR*out ;
else %never set a value to savediter, no feasible solution found
    fprintf('No feasible solution found\n') ;
    out = zeros(size(startx)) ;
    fmin = startfmin ;
end

if (nargout == 3)
    %updating parout.iterNum
    parout.iterNum = iternu ;
end



    function [val]=CoverF_objval(fun,x,R)
        %to be used for the objective function value
        val = fun(R*x);
    end


    function der=CoverF_objder(fun_sgrad,x,R)
        %to be used for the objective function subgradient
        der = R*fun_sgrad(R*x);
    end


    function [val,der]=CoverF_con(fun,fun_sgrad,x,R)
        %to be used for the constrains
        fun_val = fun(R*x);
        fun_der = R*fun_sgrad(R*x);
        
        %these lines handle the case when the constraint function returns
        %a vector or a matrix, because there is more than one constraint
        [val,pl] = max(fun_val) ;
        num_col = size(x,2) ;
        der = fun_der(:,(pl-1)*num_col+1:pl*num_col) ;      
    end

end

