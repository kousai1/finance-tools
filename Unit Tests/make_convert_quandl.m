%% File and license information.
%**************************************************************************
%
%   File:           make_convert_quandl.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           30 July 2014
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

% This script produces the set of data that TEST_CONVERT_QUANDL uses as its
% reference.
current_path = pwd;
cd ../

document = xmlread('test_1_convert_quandl.xml');
test_1 = convert_quandl(document);

document = xmlread('test_2_convert_quandl.xml');
test_2 = convert_quandl(document);

cd(current_path);
save('test_convert_quandl', 'test_1', 'test_2');
clear all;