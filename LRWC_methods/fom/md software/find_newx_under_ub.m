function newx = find_newx_under_ub(a, nub,isequal)
%Input:
%a       - the vector calculated by a=gama*ftag-omega;
%nub     - the upper bound, a vector or scalar
%isequal - a flag indicating whether the sum of vecotr should be one (true) or no bigger then (false)

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

labmda_eps=1e-8 ; % level of acurracy in finding the lambda
lambda = 0 ; % starting value for the labmda, will search for a better one, one necessary
sumy=sum(min(exp(-a-lambda-1),nub)) ;

if (sumy > 1)
    %starting value was too small
    lblambda=lambda;
    while (sumy > 1)
        lblambda=lambda;
        lambda = lambda+1;
        sumy= sum(min(exp(-a-lambda-1),nub));
    end
    uplambda=lambda;
else
    if (isequal == true)
        %starting value was too big and we need to get exactly to one
        uplambda=lambda;
        while (sumy <1)
            uplambda=lambda;
            lambda = lambda-1;
            sumy= sum(min(exp(-a-lambda-1),nub));
        end
        lblambda=lambda;
    end
end

%finding good enough lambda
%if the sum < 1 and isequal is false, then the vector sum is
% smaller then one, and we can use this vector

if ((sumy > 1) ||  ( isequal == true) )
    while ( abs(uplambda-lblambda) >labmda_eps)
        lambda=(uplambda+lblambda)/2;
        sumy=sum(min(exp(-a-lambda-1),nub));
        if (sumy > 1)
            lblambda = lambda;
        else
            uplambda = lambda;
        end
    end
end
newx = min(exp(-a-lambda-1),nub);

