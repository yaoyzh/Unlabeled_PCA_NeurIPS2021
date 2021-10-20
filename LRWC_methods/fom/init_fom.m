function init_fom()
%INIT_FOM Initialize the FOM software
%   Usage: init_fom()
%
%   Initialization script for the FOM software
%   This script adds the path needed to run FOM

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

fompath = fileparts(mfilename('fullpath'));
addpath(genpath(fompath));
status = savepath ;
if (status == 1)
    warning('This script tried to permanently save the path to include the fom directories, but failed.')
    warning('Probably because you do not have administrator access')
end

