function par = initialize_par_for_prox_gradient(par,call_fun)
%Input:
% par      - a struct which contains different values required for the operation of prox_gradient
% call_fun - the name of the calling function
% ====================================================
%Output
%par       - the struct with updated default values in all fields

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

%setting default values
if (~isfield (par,'eco_flag'))
    if ((~isfield (par,'print_flag')) || (par.print_flag))
        fprintf('Setting default eco_flag = false\n') ;
    end
    par.eco_flag = false ;
else
    if (par.eco_flag)
        par.print_flag = false ;
        par.const_flag = true ;
        if ( strcmp(call_fun,'fista') || strcmp(call_fun,'sfista') )
            par.monotone_flag = false ;
        end
    end
end

if (~isfield (par,'print_flag'))
    fprintf('Setting default print_flag = true\n') ;
    par.print_flag = true ;
end

if (~isfield (par,'max_iter'))
    if (par.print_flag)
        fprintf('setting defalut max_iter = 1000\n')
    end
    par.max_iter = 1000 ;
end

if (~isfield (par,'Lstart'))
    if (par.print_flag)
        fprintf('setting defalut Lstart = 1\n')
    end
    par.Lstart = 1 ;
end

if (~isfield (par,'const_flag'))
    if (par.print_flag)
        fprintf('setting defalut const_flag = false\n')
    end
    par.const_flag = false ;
end

if (~isfield (par,'regret_flag'))
    if (par.print_flag)
        fprintf('setting defalut regret_flag = false\n')
    end
    par.regret_flag = false ;
end

if (~isfield (par,'eta'))
    if (par.print_flag)
        fprintf('setting defalut eta = 2\n')
    end
    par.eta = 2 ;
end


if ( strcmp(call_fun,'fista') || strcmp(call_fun,'sfista') )
    if (~isfield (par,'monotone_flag'))
        if (par.print_flag)
            fprintf('setting defalut monotone_flag = false\n')
        end
        par.monotone_flag = false ;
    end
end

if (~isfield (par,'eps'))
    if ( strcmp (call_fun,'prox_gradient') ||  ...
       (( strcmp(call_fun,'fista') || strcmp(call_fun,'sfista')) &&  (~par.monotone_flag) ))
        if (par.print_flag)
            fprintf('setting defalut eps = 1e-5\n')
        end
        par.eps = 1e-5 ;
    end
end

if (strcmp(call_fun,'sfista'))
    if (~isfield (par,'continuation'))
        if (par.print_flag)
            fprintf('setting defalut continuation = false\n')
        end
        par.continuation = false ;
    end
    
    if (par.continuation)
        if (~isfield (par,'gamma'))
            if (par.print_flag)
                fprintf('setting defalut gamma = 5\n')
            end
            par.gamma = 5 ;
        end
        
        if (~isfield (par,'cont_cycles'))
            if (par.print_flag)
                fprintf('setting defalut cont_cycles = 5\n')
            end
            par.cont_cycles = 5 ;
        end
    end
end



    
