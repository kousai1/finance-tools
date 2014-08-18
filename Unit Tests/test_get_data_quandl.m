function tests = test_get_data_quandl
% TEST_GET_DATA_QUANDL Test unit for GET_DATA_QUANDL.
%   TESTS = TEST_GET_DATA_QUANDL creates an array of handles to local
%   GET_DATA_QUANDL test functions.
%
%   Use:
%       results = runtests('test_get_data_quandl.m')
%
%   See also GET_DATA_QUANDL.

%% File and license information.
%**************************************************************************
%
%   File:           test_get_data_quandl.m
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

%% Create test array.
% The following code is MATLAB test unit boilerplate, and should not be
% modified.
tests = functiontests(localfunctions);
end

%% Local functions.
% The first test function records the current directory, then moves up one
% level to where GET_DATA_QUANDL should be located.
function setupOnce(testCase)
testCase.TestData.origPath = pwd;
cd ../
end

%%
% The following group of test functions verify that GET_DATA_QUANDL throws
% the correct error when passed invalid input arguments.
function test_no_argument(testCase)
actual = @()get_data_quandl();
expected = 'MATLAB:minrhs';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_class(testCase)
actual = @()get_data_quandl(0);
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_char_row_attribute(testCase)
actual = @()get_data_quandl(('SYMBOL')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_cell_row_attribute(testCase)
actual = @()get_data_quandl({'SYMBOL'; 'SYMBOL'});
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_feed_no_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'feed');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_feed_invalid_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'feed', 'FEED');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_start_no_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'start');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_start_invalid_class(testCase)
actual = @()get_data_quandl('SYMBOL', 'start', {'START'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_start_invalid_numeric_scalar_attribute(testCase)
actual = @()get_data_quandl('SYMBOL', 'start', [0 0]);
expected = 'MATLAB:expectedScalar';
verifyError(testCase, actual, expected);
end

function test_start_invalid_numeric_positive_attribute(testCase)
actual = @()get_data_quandl('SYMBOL', 'start', -735790);
expected = 'MATLAB:expectedPositive';
verifyError(testCase, actual, expected);
end

function test_start_invalid_char_row_attribute(testCase)
actual = @()get_data_quandl('SYMBOL', 'start', ('START')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_start_no_parameter(testCase)
actual = @()get_data_quandl('SYMBOL', 'start', '01-01-2014');
expected = 'get_data_quandl:missing_parameter';
verifyError(testCase, actual, expected);
end

function test_start_invalid_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'start', '11-07-2014', ...
    'finish', '01-01-2014', 'format', 'dd-mm-yyyy');
expected = 'get_data_quandl:invalid_value';
verifyError(testCase, actual, expected);
end

function test_format_no_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'format');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_format_invalid_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'format', 'FORMAT');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_interval_no_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'interval');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_interval_invalid_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'interval', 'INTERVAL');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_token_invalid_class(testCase)
actual = @()get_data_quandl('SYMBOL', 'token', {'token'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_token_no_value(testCase)
actual = @()get_data_quandl('SYMBOL', 'token');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

%%
% The following group of test functions verify that GET_DATA_QUANDL returns
% the correct set of data when passed one of the various combinations of
% input arguments that it supports.
function test_1(testCase)
global token;
symbol = 'IBM';
actual = get_data_quandl(symbol, 'token', token);
expected = load('test_get_data_quandl.mat', 'test_1');
verifyTrue(testCase, isequaln(actual.IBM, expected.test_1.IBM));
end

function test_2(testCase)
global token;
symbol = 'HPQ';
actual = get_data_quandl(symbol, 'start', '27-01-2012', ...
    'finish', '17-07-2014', 'format', 'dd-mm-yyyy', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_2');
verifyTrue(testCase, isequaln(actual.HPQ, expected.test_2.HPQ));
end

function test_3(testCase)
global token;
symbol = 'WAB';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'start', start, 'finish', finish, ...
    'format', 'numeric', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_3');
verifyTrue(testCase, isequaln(actual.WAB, expected.test_3.WAB));
end

function test_4(testCase)
global token;
symbol = 'GE';
actual = get_data_quandl(symbol, 'interval', 'd', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_4');
verifyTrue(testCase, isequaln(actual.GE, expected.test_4.GE));
end

function test_5(testCase)
global token;
symbol = 'MSFT';
actual = get_data_quandl(symbol, 'start', '03-10-2012', ...
    'finish', '16-07-2014', 'format', 'dd-mm-yyyy', ...
    'interval', 'w', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_5');
verifyTrue(testCase, isequaln(actual.MSFT, expected.test_5.MSFT));
end

function test_6(testCase)
global token;
symbol = 'AAPL';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'start', start, 'finish', finish, ...
    'format', 'numeric', 'interval', 'm', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_6');
verifyTrue(testCase, isequaln(actual.AAPL, expected.test_6.AAPL));
end

function test_7(testCase)
global token;
symbol = {'GOOG', 'FB'};
actual = get_data_quandl(symbol, 'token', token);
expected = load('test_get_data_quandl.mat', 'test_7');
verifyTrue(testCase, isequaln(actual.GOOG, expected.test_7.GOOG));
verifyTrue(testCase, isequaln(actual.FB, expected.test_7.FB));
end

function test_8(testCase)
global token;
symbol = {'COKE', 'PEP'};
actual = get_data_quandl(symbol, 'start', '27-01-2012', ...
    'finish', '17-07-2014', 'format', 'dd-mm-yyyy', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_8');
verifyTrue(testCase, isequaln(actual.COKE, expected.test_8.COKE));
verifyTrue(testCase, isequaln(actual.PEP, expected.test_8.PEP));
end

function test_9(testCase)
global token;
symbol = {'F', 'GM'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'start', start, 'finish', finish, ...
    'format', 'numeric', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_9');
verifyTrue(testCase, isequaln(actual.F, expected.test_9.F));
verifyTrue(testCase, isequaln(actual.GM, expected.test_9.GM));
end

function test_10(testCase)
global token;
symbol = {'MCD', 'BKW'};
actual = get_data_quandl(symbol, 'interval', 'd', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_10');
verifyTrue(testCase, isequaln(actual.MCD, expected.test_10.MCD));
verifyTrue(testCase, isequaln(actual.BKW, expected.test_10.BKW));
end

function test_11(testCase)
global token;
symbol = {'AMZN', 'NFLX'};
actual = get_data_quandl(symbol, 'start', '03-10-2012', ...
    'finish', '16-07-2014', 'format', 'dd-mm-yyyy', ...
    'interval', 'w', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_11');
verifyTrue(testCase, isequaln(actual.AMZN, expected.test_11.AMZN));
verifyTrue(testCase, isequaln(actual.NFLX, expected.test_11.NFLX));
end

function test_12(testCase)
global token;
symbol = {'GS', 'MS'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'start', start, 'finish', finish, ...
    'format', 'numeric', 'interval', 'm', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_12');
verifyTrue(testCase, isequaln(actual.GS, expected.test_12.GS));
verifyTrue(testCase, isequaln(actual.MS, expected.test_12.MS));
end

function test_13(testCase)
global token;
symbol = 'FNZ.NZ';
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_13');
verifyTrue(testCase, isequaln(actual.NZE_FNZ, expected.test_13.NZE_FNZ));
end

function test_14(testCase)
global token;
symbol = 'VEU.AX';
actual = get_data_quandl(symbol, 'feed', 'GOOG', ...
    'start', '27-01-2012', 'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_14');
verifyTrue(testCase, isequaln(actual.ASX_VEU, expected.test_14.ASX_VEU));
end

function test_15(testCase)
global token;
symbol = 'VAP.AX';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_15');
verifyTrue(testCase, isequaln(actual.ASX_VAP, expected.test_15.ASX_VAP));
end

function test_16(testCase)
symbol = 'VAS.AX';
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'interval', 'd');
expected = load('test_get_data_quandl.mat', 'test_16');
verifyTrue(testCase, isequaln(actual.ASX_VAS, expected.test_16.ASX_VAS));
end

function test_17(testCase)
global token;
symbol = 'VGB.AX';
actual = get_data_quandl(symbol, 'feed', 'GOOG', ...
    'start', '03-10-2012', 'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', 'interval', 'w', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_17');
verifyTrue(testCase, isequaln(actual.ASX_VGB, expected.test_17.ASX_VGB));
end

function test_18(testCase)
global token;
symbol = 'VTS.AX';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm', ...
    'token', token);
expected = load('test_get_data_quandl.mat', 'test_18');
verifyTrue(testCase, isequaln(actual.ASX_VTS, expected.test_18.ASX_VTS));
end

function test_19(testCase)
global token;
symbol = {'IBM', 'HPQ'};
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_19');
verifyTrue(testCase, isequaln(actual.NYSE_IBM, expected.test_19.NYSE_IBM));
verifyTrue(testCase, isequaln(actual.NYSE_HPQ, expected.test_19.NYSE_HPQ));
end

function test_20(testCase)
global token;
symbol = {'WAB', 'GE'};
actual = get_data_quandl(symbol, 'feed', 'GOOG', ...
    'start', '27-01-2012', 'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_20');
verifyTrue(testCase, isequaln(actual.NYSE_WAB, expected.test_20.NYSE_WAB));
verifyTrue(testCase, isequaln(actual.NYSE_GE, expected.test_20.NYSE_GE));
end

function test_21(testCase)
global token;
symbol = {'MSFT', 'AAPL'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_21');
verifyTrue(testCase, isequaln(actual.NASDAQ_MSFT, expected.test_21.NASDAQ_MSFT));
verifyTrue(testCase, isequaln(actual.NASDAQ_AAPL, expected.test_21.NASDAQ_AAPL));
end

function test_22(testCase)
global token;
symbol = {'GOOG', 'FB'};
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'interval', 'd', ...
    'token', token);
expected = load('test_get_data_quandl.mat', 'test_22');
verifyTrue(testCase, isequaln(actual.NASDAQ_GOOG, expected.test_22.NASDAQ_GOOG));
verifyTrue(testCase, isequaln(actual.NASDAQ_FB, expected.test_22.NASDAQ_FB));
end

function test_23(testCase)
global token;
symbol = {'COKE', 'PEP'};
actual = get_data_quandl(symbol, 'feed', 'GOOG', ...
    'start', '03-10-2012', 'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', 'interval', 'w', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_23');
verifyTrue(testCase, isequaln(actual.NASDAQ_COKE, expected.test_23.NASDAQ_COKE));
verifyTrue(testCase, isequaln(actual.NYSE_PEP, expected.test_23.NYSE_PEP));
end

function test_24(testCase)
global token;
symbol = {'F', 'GM'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'GOOG', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm', ...
    'token', token);
expected = load('test_get_data_quandl.mat', 'test_24');
verifyTrue(testCase, isequaln(actual.NYSE_F, expected.test_24.NYSE_F));
verifyTrue(testCase, isequaln(actual.NYSE_GM, expected.test_24.NYSE_GM));
end

function test_25(testCase)
global token;
symbol = 'IBM';
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_25');
verifyTrue(testCase, isequaln(actual.IBM, expected.test_25.IBM));
end

function test_26(testCase)
global token;
symbol = 'HPQ';
actual = get_data_quandl(symbol, 'feed', 'YAHOO', ...
    'start', '27-01-2012', 'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_26');
verifyTrue(testCase, isequaln(actual.HPQ, expected.test_26.HPQ));
end

function test_27(testCase)
global token;
symbol = 'WAB';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_27');
verifyTrue(testCase, isequaln(actual.WAB, expected.test_27.WAB));
end

function test_28(testCase)
global token;
symbol = 'GE';
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'interval', 'd', ...
    'token', token);
expected = load('test_get_data_quandl.mat', 'test_28');
verifyTrue(testCase, isequaln(actual.GE, expected.test_28.GE));
end

function test_29(testCase)
global token;
symbol = 'MSFT';
actual = get_data_quandl(symbol, 'feed', 'YAHOO', ...
    'start', '03-10-2012', 'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', 'interval', 'w', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_29');
verifyTrue(testCase, isequaln(actual.MSFT, expected.test_29.MSFT));
end

function test_30(testCase)
global token;
symbol = 'AAPL';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm', ...
    'token', token);
expected = load('test_get_data_quandl.mat', 'test_30');
verifyTrue(testCase, isequaln(actual.AAPL, expected.test_30.AAPL));
end

function test_31(testCase)
global token;
symbol = {'GOOG', 'FB'};
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_31');
verifyTrue(testCase, isequaln(actual.GOOG, expected.test_31.GOOG));
verifyTrue(testCase, isequaln(actual.FB, expected.test_31.FB));
end

function test_32(testCase)
global token;
symbol = {'COKE', 'PEP'};
actual = get_data_quandl(symbol, 'feed', 'YAHOO', ...
    'start', '27-01-2012', 'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_32');
verifyTrue(testCase, isequaln(actual.COKE, expected.test_32.COKE));
verifyTrue(testCase, isequaln(actual.PEP, expected.test_32.PEP));
end

function test_33(testCase)
global token;
symbol = {'F', 'GM'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'start', start, ...
    'finish', finish, 'format', 'numeric', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_33');
verifyTrue(testCase, isequaln(actual.F, expected.test_33.F));
verifyTrue(testCase, isequaln(actual.GM, expected.test_33.GM));
end

function test_34(testCase)
global token;
symbol = {'MCD', 'BKW'};
actual = get_data_quandl(symbol, 'feed', 'YAHOO', 'interval', 'd', ...
    'token', token);
expected = load('test_get_data_quandl.mat', 'test_34');
verifyTrue(testCase, isequaln(actual.MCD, expected.test_34.MCD));
verifyTrue(testCase, isequaln(actual.BKW, expected.test_34.BKW));
end

function test_35(testCase)
global token;
symbol = {'AMZN', 'NFLX'};
actual = get_data_quandl(symbol, 'feed', 'YAHOO', ...
    'start', '03-10-2012', 'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', 'interval', 'w', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_35');
verifyTrue(testCase, isequaln(actual.AMZN, expected.test_35.AMZN));
verifyTrue(testCase, isequaln(actual.NFLX, expected.test_35.NFLX));
end

function test_36(testCase)
global token;
symbol = {'GS', 'MS'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_quandl(symbol, 'feed', 'YAHOO', ...
    'start', start, 'finish', finish, 'format', 'numeric', ...
    'interval', 'm', 'token', token);
expected = load('test_get_data_quandl.mat', 'test_36');
verifyTrue(testCase, isequaln(actual.GS, expected.test_36.GS));
verifyTrue(testCase, isequaln(actual.MS, expected.test_36.MS));
end

%%
% The last test function returns to what was the current directory, and
% removes all of the temporary variables used by the test unit from the
% MATLAB workspace.
function teardownOnce(testCase)
cd(testCase.TestData.origPath);
end