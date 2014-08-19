%% File and license information.
%**************************************************************************
%
%   File:           test_suite.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           29 July 2014
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

% This script calls all test units. It should be run after making changes
% to the codebase. Its purpose is to verify that none of the changes that
% were made have broken the codebase. Before making any changes, the make
% suite should first be called to generate a set of reference data. Before
% running this script, make sure there is a valid Quandl authentication
% token present in the MATLAB workspace.

addpath(pwd);

results = runtests(pwd, 'Recursively', true);

rmpath(pwd);