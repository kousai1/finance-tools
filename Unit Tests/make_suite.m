%% File and license information.
%**************************************************************************
%
%   File:           make_suite.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           31 July 2014
%
%**************************************************************************
%
%   Copyright:      (c) 2014 Rodney Elliott
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program. If not, see <http://www.gnu.org/licenses/>.
%
%**************************************************************************

% This script runs all make scripts. Before running the script, ensure that
% there is a valid global Quandl authentication token present in the MATLAB
% workspace.

make_get_data_yahoo;
make_convert_quandl;
make_search_quandl;