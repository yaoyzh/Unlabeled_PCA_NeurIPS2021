function par  = initialize_par_for_md(par,set,startx)
%Input:
% par      - a struct which contains different values required for the operation of COMD
% set      - an underlying set; allowed values: 'simplex', 'ball','box','spectahedron'
% startx   - a starting vector
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

%setting default general values

if (~isfield (par,'eco_flag'))
    if ((~isfield (par,'print_flag')) || (par.print_flag))
        fprintf('Setting default eco_flag = false\n') ;
    end
    par.eco_flag = false ;
else
    if (par.eco_flag)
%        fprintf('Since par.eco_flag is true, setting par,print_flag to false\n')
        par.print_flag = false ;
    end
end

if (~isfield (par,'print_flag'))
    fprintf('Setting default print_flag = true\n') ;
    par.print_flag = true ;
end

if (~isfield (par,'max_iter'))
    if (par.print_flag)
        fprintf('Setting default max_iter = 1000\n') ;
    end
    par.max_iter = 1e3 ;
end
if (~isfield (par,'print_flag'))
    if (par.print_flag)
        fprintf('Setting default print_flag = true\n') ;
    end
    par.print_flag = true ;
end
if (~isfield (par,'stuck_iter'))
    if (par.print_flag)
        fprintf('Setting default stuck_iter = 100000\n') ;
    end
    par.stuck_iter = 100000 ;
end
if (~isfield (par,'feas_eps'))
    if (par.print_flag)
        fprintf('Setting default feas_eps = 1e-5\n') ;
    end
    par.feas_eps = 1e-5 ;
end


%setting defalut values for simplex method
if (strcmp(set,'simplex') == 1)
    if (~isfield (par,'simplexR'))
        if (par.print_flag)
            fprintf('Setting default simplexR =1\n') ;
        end
        par.simplexR = 1;
    end
    if (~isfield (par,'isequal'))
        if (par.print_flag)
            fprintf('Setting default isequal = true\n') ;
        end
        par.isequal = true;
    end
    if (~isfield (par,'lowb'))
        if (par.print_flag)
            fprintf('Setting default lowb= 0\n') ;
        end
        par.lowb = 0;
    else
        %checking the size of lowb
        if (~(isscalar (par.lowb)) && (any(size(par.lowb) ~= size(startx))))
            error('When upb lowb not a scalar, it should be the same size as startx') ;
        end
    end
    if (~isfield (par,'upb'))
        if (par.print_flag)
            fprintf('Setting default upb= inf\n') ;
        end
        par.upb = inf;
    else
        %checking the size of upb
        if (~(isscalar (par.upb)) && (any(size(par.upb) ~= size(startx))))
            error('When upb is not a scalar, it should be the same size as startx') ;
        end
    end        
    
    if ( any (par.lowb > par.upb))
        error('The lower bound is bigger than the upper bound') ;
    end
  
end


%setting defalut values for spectahedron method
if (strcmp(set,'spectahedron') == 1)
    if (~isfield (par,'specR'))
        if (par.print_flag)
            fprintf('Setting default specR =1\n') ;
        end
        par.specR = 1;
    end
    if (~isfield (par,'isequal'))
        if (par.print_flag)
            fprintf('Setting default isequal = true\n') ;
        end
        par.isequal = true;
    end
    if (~isfield (par,'upb'))
        if (par.print_flag)
            fprintf('Setting default upb= inf\n') ;
        end
        par.upb = inf;
    end
end

%setting defalut values for ball method
if (strcmp(set,'ball') == 1)
    if (~isfield (par,'ballR'))
        if (par.print_flag)
            fprintf('Setting default ballR= 1\n') ;
        end
        par.ballR = 1;
    end
    if (~isfield (par,'ballCenter'))
        if (par.print_flag)
            fprintf('Setting default ballCenter= zeros(size(startx))\n')  ;
        end
        par.ballCenter = zeros(size(startx));
    else
        %make sure dimentions are correct
        if (any(size(par.ballCenter) ~= size(startx)))
            error('par.ballCenter should be the same size as startx') ;
        end
    end
end

%setting defalut values for box method
if (strcmp(set,'box') == 1)
    if (~isfield (par,'upb'))
        if (par.print_flag)
            fprintf('Setting default upb= 1\n') ;
        end
        par.upb = 1;
    else
        %checking the size of upb
        if (~(isscalar (par.upb)) && (any(size(par.upb) ~= size(startx))))
            error('When upb is not a scalar, it should be the same size as startx') ;
        end
    end
    if (~isfield (par,'lowb'))
        if (par.print_flag)
            fprintf('Setting default lowb= 0\n') ;
        end
        par.lowb = 0;
    else
        %checking the size of lowb
        if (~(isscalar (par.lowb)) && (any(size(par.lowb) ~= size(startx))))
            error('When lowb is not a scalar, it should be the same size as startx') ;
        end
        
    end
    if (any(par.lowb > par.upb))
        error('The lower bound is bigger than the upper bound') ;
    end
    
  
end

