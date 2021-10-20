function par = initialize_par_for_adlpmm(par)
%Input:
% par      - a struct which contains different values required for the operation of adlpmn
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

if (isfield (par,'eps') ~= 1)
    if (par.print_flag)
        fprintf('setting defalut eps = 1e-10\n')
    end
    par.eps = 1e-10 ;
end

if (isfield (par,'rho') ~= 1)
    if (par.print_flag)
        fprintf('setting defalut rho = 1\n')
    end
    par.rho = 1 ;
end

if (~isfield (par,'real_valued_flag'))
    if (par.print_flag)
        fprintf('setting defalut real_valued_flag = false\n')
    end
    par.real_valued_flag = false ;
end

if (~isfield (par,'feas_check_flag'))
    if (par.real_valued_flag)
        if (par.print_flag)
            fprintf('real_valued_flag is true, setting feas_check_flag = false\n')
        end
        par.feas_check_flag = false ;
    else
        if (par.print_flag)
            fprintf('setting defalut feas_check_flag = true\n')
        end
        par.feas_check_flag = true ;
    end
else
    if (par.real_valued_flag && par.feas_check_flag)
        if (par.print_flag)
            fprintf('When real_valued_flag is set to true, feas_check_flag must be set to false\n')
        end
        par.feas_check_flag = false ;
    end
    
end


end

