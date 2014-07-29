%% File and license information.
%**************************************************************************
%
%   File:           make_get_data_yahoo.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           28 July 2014
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

% This script produces the set of data that TEST_GET_DATA_YAHOO uses as its
% reference. Should GET_DATA_YAHOO fail unit test, it is most likely due to
% Yahoo! Finance having revised its historic stock data. Should this occur,
% simply run this script to generate a new set of reference data, and rerun
% the test unit.
current_path = pwd;
cd ../

symbol = 'FNZ.NZ';
test_1 = get_data_yahoo(symbol);

symbol = 'VEU.AX';
test_2 = get_data_yahoo(symbol, 'start', '27-01-2012', ...
    'finish', '17-07-2014', 'format', 'dd-mm-yyyy');

symbol = 'VAP.AX';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_3 = get_data_yahoo(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric');

symbol = 'VAS.AX';
test_4 = get_data_yahoo(symbol, 'interval', 'd');

symbol = 'VGB.AX';
test_5 = get_data_yahoo(symbol, 'start', '03-10-2012', ...
    'finish', '16-07-2014', 'format', 'dd-mm-yyyy', 'interval', 'w');

symbol = 'VTS.AX';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_6 = get_data_yahoo(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm');

symbol = {'IBM', 'HPQ'};
test_7 = get_data_yahoo(symbol);

symbol = {'WAB', 'GE'};
test_8 = get_data_yahoo(symbol, 'start', '27-01-2012', ...
    'finish', '17-07-2014', 'format', 'dd-mm-yyyy');

symbol = {'MSFT', 'AAPL'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_9 = get_data_yahoo(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric');

symbol = {'GOOG', 'FB'};
test_10 = get_data_yahoo(symbol, 'interval', 'd');

symbol = {'COKE', 'PEP'};
test_11 = get_data_yahoo(symbol, 'start', '03-10-2012', ...
    'finish', '16-07-2014', 'format', 'dd-mm-yyyy', 'interval', 'w');

symbol = {'F', 'TM'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_12 = get_data_yahoo(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm');

cd(current_path);
save('test_get_data_yahoo', 'test_1', 'test_2', 'test_3', 'test_4', ...
    'test_5', 'test_6', 'test_7', 'test_8', 'test_9', 'test_10', ...
    'test_11', 'test_12');
clear all;