function par = initialize_par_for_nested_fista(par)
%Input:
% par      - a struct which contains different values required for the operation of nested_fista
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

if (~isfield (par,'eta'))
    if (par.print_flag)
        fprintf('setting defalut eta = 2\n')
    end
    par.eta = 2 ;
end

if (~isfield (par,'stuck_iter'))
    if (par.print_flag)
        fprintf('setting defalut stuck_iter = 100\n')
    end
    par.stuck_iter = 100 ;
end

if (~isfield (par,'inner_eps'))
    if (par.print_flag)
        fprintf('setting defalut inner_eps = 1e-5\n')
    end
    par.inner_eps = 1e-5 ;
end

if (~isfield (par,'inner_max_iter'))
    if (par.print_flag)
        fprintf('setting defalut inner_max_iter = 50\n')
    end
    par.inner_max_iter = 50 ;
end

if (~isfield (par,'inner_Lstart'))
    if (par.print_flag)
        fprintf('setting defalut inner_Lstart = 1\n')
    end
    par.inner_Lstart = 1 ;
end
  