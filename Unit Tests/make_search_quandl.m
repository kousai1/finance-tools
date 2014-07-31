%% File and license information.
%**************************************************************************
%
%   File:           make_search_quandl.m
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

% This script produces the set of data that TEST_SEARCH_QUANDL uses as its
% reference. Before running the script, ensure that there is a valid global
% Quandl authentication token present in the MATLAB workspace.
global token;

current_path = pwd;
cd ../

test_1 = search_quandl('mUsNrbU&@I{W"UcsA"P', 'token', token);

test_2 = search_quandl('FNZ', 'token', token);

test_3 = search_quandl('IBM', 'count', 25, 'token', token);

test_4 = search_quandl('VEU', 'filter', 'GOOG', 'token', token);

test_5 = search_quandl('HPQ', 'count', 50, 'filter', 'GOOG', ...
    'token', token);

cd(current_path);
save('test_search_quandl', 'test_1', 'test_2', 'test_3', 'test_4', ...
    'test_5');
clear all;