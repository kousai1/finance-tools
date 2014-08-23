%% File and license information.
%**************************************************************************
%
%   File:           make_get_data_google.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           7 August 2014
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

% This script produces the set of data that TEST_GET_DATA_GOOGLE uses as
% its reference. Should GET_DATA_GOOGLE fail unit test, it is most likely
% due to Google Finance having revised its historic stock data. Should this
% occur, simply run this script to generate a new set of reference data,
% and rerun the test unit.
current_path = pwd;
cd ../

symbol = 'FNZ.NZ';
test_1 = get_data_google(symbol);
disp('Created test_1 dataset.')
pause(1)

symbol = 'VEU.AX';
test_2 = get_data_google(symbol, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy');
disp('Created test_2 dataset.')
pause(1)

symbol = 'VAP.AX';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_3 = get_data_google(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric');
disp('Created test_3 dataset.')
pause(1)

symbol = 'VAS.AX';
test_4 = get_data_google(symbol, ...
    'interval', 'd');
disp('Created test_4 dataset.')
pause(1)

symbol = 'VGB.AX';
test_5 = get_data_google(symbol, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w');
disp('Created test_5 dataset.')
pause(1)

symbol = 'VTS.AX';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_6 = get_data_google(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm');
disp('Created test_6 dataset.')
pause(1)

symbol = {'IBM', 'HPQ'};
test_7 = get_data_google(symbol);
disp('Created test_7 dataset.')
pause(1)

symbol = {'WAB', 'GE'};
test_8 = get_data_google(symbol, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy');
disp('Created test_8 dataset.')
pause(1)

symbol = {'MSFT', 'AAPL'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_9 = get_data_google(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric');
disp('Created test_9 dataset.')
pause(1)

symbol = {'GOOG', 'FB'};
test_10 = get_data_google(symbol, ...
    'interval', 'd');
disp('Created test_10 dataset.')
pause(1)

symbol = {'COKE', 'PEP'};
test_11 = get_data_google(symbol, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w');
disp('Created test_11 dataset.')
pause(1)

symbol = {'F', 'GM'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_12 = get_data_google(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm');
disp('Created test_12 dataset.')
pause(1)

symbol = 'BMW.BE';
test_13 = get_data_google(symbol);
disp('Created test_13 dataset.')
pause(1)

cd(current_path)
save('test_get_data_google', 'test_1', 'test_2', 'test_3', 'test_4', ...
    'test_5', 'test_6', 'test_7', 'test_8', 'test_9', 'test_10', ...
    'test_11', 'test_12', 'test_13')
clearvars -except token