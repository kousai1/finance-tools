%% File and license information.
%**************************************************************************
%
%   File:           make_get_data_quandl.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           2 August 2014
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

% This script produces the set of data that TEST_GET_DATA_QUANDL uses as
% its reference. Should GET_DATA_QUANDL fail unit test, it is most likely
% due to Quandl having revised its historic stock data. Should this occur,
% simply run this script to generate a new set of reference data, and rerun
% the test unit.
current_path = pwd;
cd ../

symbol = 'FNZ.NZ';
test_1 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'token', token);
disp('Created test_1 dataset.')
pause(1)

symbol = 'VEU.AX';
test_2 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
disp('Created test_2 dataset.')
pause(1)

symbol = 'VAP.AX';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_3 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
disp('Created test_3 dataset.')
pause(1)

symbol = 'VAS.AX';
test_4 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'interval', 'd', ...
    'token', token);
disp('Created test_4 dataset.')
pause(1)

symbol = 'VGB.AX';
test_5 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w', ...
    'token', token);
disp('Created test_5 dataset.')
pause(1)

symbol = 'VTS.AX';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_6 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm', ...
    'token', token);
disp('Created test_6 dataset.')
pause(1)

symbol = 'IBM';
test_7 = get_data_quandl(symbol, ...
    'feed', 'WIKI', ...
    'token', token);
disp('Created test_7 dataset.')
pause(1)

symbol = 'HPQ';
test_8 = get_data_quandl(symbol, ...
    'feed', 'WIKI', ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
disp('Created test_8 dataset.')
pause(1)

symbol = 'WAB';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_9 = get_data_quandl(symbol, ...
    'feed', 'WIKI', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
disp('Created test_9 dataset.')
pause(1)

symbol = 'GE';
test_10 = get_data_quandl(symbol, ...
    'feed', 'WIKI', ...
    'interval', 'd', ...
    'token', token);
disp('Created test_10 dataset.')
pause(1)

symbol = 'MSFT';
test_11 = get_data_quandl(symbol, ...
    'feed', 'WIKI', ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w', ...
    'token', token);
disp('Created test_11 dataset.')
pause(1)

symbol = 'AAPL';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_12 = get_data_quandl(symbol, ...
    'feed', 'WIKI', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm', ...
    'token', token);
disp('Created test_12 dataset.')
pause(1)

symbol = 'IBM';
test_13 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'token', token);
disp('Created test_13 dataset.')
pause(1)

symbol = 'HPQ';
test_14 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
disp('Created test_14 dataset.')
pause(1)

symbol = 'WAB';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_15 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
disp('Created test_15 dataset.')
pause(1)

symbol = 'GE';
test_16 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'interval', 'd', ...
    'token', token);
disp('Created test_16 dataset.')
pause(1)

symbol = 'MSFT';
test_17 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w', ...
    'token', token);
disp('Created test_17 dataset.')
pause(1)

symbol = 'AAPL';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_18 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm', ...
    'token', token);
disp('Created test_18 dataset.')
pause(1)

symbol = {'IBM', 'HPQ'};
test_19 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'token', token);
disp('Created test_19 dataset.')
pause(1)

symbol = {'WAB', 'GE'};
test_20 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
disp('Created test_20 dataset.')
pause(1)

symbol = {'MSFT', 'AAPL'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_21 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
disp('Created test_21 dataset.')
pause(1)

symbol = {'GOOG', 'FB'};
test_22 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'interval', 'd', ...
    'token', token);
disp('Created test_22 dataset.')
pause(1)

symbol = {'COKE', 'PEP'};
test_23 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w', ...
    'token', token);
disp('Created test_23 dataset.')
pause(1)

symbol = {'F', 'GM'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_24 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm', ...
    'token', token);
disp('Created test_24 dataset.')
pause(1)

symbol = {'GOOG', 'FB'};
test_25 = get_data_quandl(symbol, ...
    'token', token);
disp('Created test_25 dataset.')
pause(1)

symbol = {'COKE', 'PEP'};
test_26 = get_data_quandl(symbol, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
disp('Created test_26 dataset.')
pause(1)

symbol = {'F', 'GM'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_27 = get_data_quandl(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
disp('Created test_27 dataset.')
pause(1)

symbol = {'MCD', 'BKW'};
test_28 = get_data_quandl(symbol, ...
    'interval', 'd', ...
    'token', token);
disp('Created test_28 dataset.')
pause(1)

symbol = {'AMZN', 'NFLX'};
test_29 = get_data_quandl(symbol, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w', ...
    'token', token);
disp('Created test_29 dataset.')
pause(1)

symbol = {'GS', 'MS'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_30 = get_data_quandl(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm', ...
    'token', token);
disp('Created test_30 dataset.')
pause(1)

symbol = {'GOOG', 'FB'};
test_31 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'token', token);
disp('Created test_31 dataset.')
pause(1)

symbol = {'COKE', 'PEP'};
test_32 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
disp('Created test_32 dataset.')
pause(1)

symbol = {'F', 'GM'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
test_33 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
disp('Created test_33 dataset.')
pause(1)

symbol = {'MCD', 'BKW'};
test_34 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'interval', 'd', ...
    'token', token);
disp('Created test_34 dataset.')
pause(1)

symbol = {'AMZN', 'NFLX'};
test_35 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'interval', 'w', ...
    'token', token);
disp('Created test_35 dataset.')
pause(1)

symbol = {'GS', 'MS'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
test_36 = get_data_quandl(symbol, ...
    'feed', 'YAHOO', ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'interval', 'm', ...
    'token', token);
disp('Created test_36 dataset.')
pause(1)

symbol = 'BMW.BE';
test_37 = get_data_quandl(symbol, ...
    'feed', 'GOOG', ...
    'token', token);
disp('Created test_37 dataset.')
pause(1)

cd(current_path)
save('test_get_data_quandl', 'test_1', 'test_2', 'test_3', 'test_4', ...
    'test_5', 'test_6', 'test_7', 'test_8', 'test_9', 'test_10', ...
    'test_11', 'test_12', 'test_13', 'test_14', 'test_15', 'test_16', ...
    'test_17', 'test_18', 'test_19', 'test_20', 'test_21', 'test_22', ...
    'test_23', 'test_24', 'test_25', 'test_26', 'test_27', 'test_28', ...
    'test_29', 'test_30', 'test_31', 'test_32', 'test_33', 'test_34', ...
    'test_35', 'test_36', 'test_37')
clearvars -except token