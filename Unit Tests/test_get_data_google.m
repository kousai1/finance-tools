function tests = test_get_data_google
% TEST_GET_DATA_GOOGLE Test unit for GET_DATA_GOOGLE.
%   TESTS = TEST_GET_DATA_GOOGLE creates an array of handles to local
%   GET_DATA_GOOGLE test functions.
%
%   Use:
%       results = runtests('test_get_data_google.m')
%
%   See also GET_DATA_GOOGLE.

%% File and license information.
%**************************************************************************
%
%   File:           test_get_data_google.m
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

%% Create test array.
% The following code is MATLAB test unit boilerplate, and should not be
% modified.
tests = functiontests(localfunctions);
end

%% Local functions.
% The first test function records the current directory, then moves up one
% level to where GET_DATA_GOOGLE should be located.
function setupOnce(testCase)
testCase.TestData.origPath = pwd;
cd ../
end

%%
% The following group of test functions verify that GET_DATA_GOOGLE throws
% the correct error when passed invalid input arguments.
function test_no_argument(testCase)
actual = @()get_data_google();
expected = 'MATLAB:minrhs';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_class(testCase)
actual = @()get_data_google(0);
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_char_row_attribute(testCase)
actual = @()get_data_google(('SYMBOL')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_cell_row_attribute(testCase)
actual = @()get_data_google({'SYMBOL'; 'SYMBOL'});
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

% Because the Yahoo! Finance stock lookup service returns a result string
% for the fictional stock symbol 'SYMBOL', its reflection is used in the
% following test function instead.
function test_symbol_invalid_value_1(testCase)
actual = @()get_data_google('LOBMYS');
expected = 'get_data_google:invalid_value';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_value_2(testCase)
actual = @()get_data_google('BMW.BE');
expected = 'get_data_google:invalid_value';
verifyError(testCase, actual, expected);
end

function test_start_no_value(testCase)
actual = @()get_data_google('SYMBOL', 'start');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_start_invalid_class(testCase)
actual = @()get_data_google('SYMBOL', 'start', {'START'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_start_invalid_numeric_scalar_attribute(testCase)
actual = @()get_data_google('SYMBOL', 'start', [0 0]);
expected = 'MATLAB:expectedScalar';
verifyError(testCase, actual, expected);
end

function test_start_invalid_numeric_positive_attribute(testCase)
actual = @()get_data_google('SYMBOL', 'start', -735790);
expected = 'MATLAB:expectedPositive';
verifyError(testCase, actual, expected);
end

function test_start_invalid_char_row_attribute(testCase)
actual = @()get_data_google('SYMBOL', 'start', ('START')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_start_no_parameter(testCase)
actual = @()get_data_google('SYMBOL', 'start', '01-01-2014');
expected = 'get_data_google:missing_parameter';
verifyError(testCase, actual, expected);
end

function test_start_invalid_value(testCase)
actual = @()get_data_google('SYMBOL', 'start', '11-07-2014', ...
    'finish', '01-01-2014', 'format', 'dd-mm-yyyy');
expected = 'get_data_google:invalid_value';
verifyError(testCase, actual, expected);
end

function test_format_no_value(testCase)
actual = @()get_data_google('SYMBOL', 'format');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_format_invalid_value(testCase)
actual = @()get_data_google('SYMBOL', 'format', 'FORMAT');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_interval_no_value(testCase)
actual = @()get_data_google('SYMBOL', 'interval');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_interval_invalid_value(testCase)
actual = @()get_data_google('SYMBOL', 'interval', 'INTERVAL');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

%%
% The following group of test functions verify that GET_DATA_GOOGLE returns
% the correct set of data when passed one of the various combinations of
% input arguments that it supports.
function test_1(testCase)
symbol = 'FNZ.NZ';
actual = get_data_google(symbol);
expected = load('test_get_data_google.mat', 'test_1');
verifyEqual(testCase, actual.NZE_FNZ, expected.test_1.NZE_FNZ);
end

function test_2(testCase)
symbol = 'VEU.AX';
actual = get_data_google(symbol, 'start', '27-01-2012', ...
    'finish', '17-07-2014', 'format', 'dd-mm-yyyy');
expected = load('test_get_data_google.mat', 'test_2');
verifyEqual(testCase, actual.ASX_VEU, expected.test_2.ASX_VEU);
end

function test_3(testCase)
symbol = 'VAP.AX';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_google(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric');
expected = load('test_get_data_google.mat', 'test_3');
verifyEqual(testCase, actual.ASX_VAP, expected.test_3.ASX_VAP);
end

function test_4(testCase)
symbol = 'VAS.AX';
actual = get_data_google(symbol, 'interval', 'd');
expected = load('test_get_data_google.mat', 'test_4');
verifyEqual(testCase, actual.ASX_VAS, expected.test_4.ASX_VAS);
end

function test_5(testCase)
symbol = 'VGB.AX';
actual = get_data_google(symbol, 'start', '03-10-2012', ...
    'finish', '16-07-2014', 'format', 'dd-mm-yyyy', 'interval', 'w');
expected = load('test_get_data_google.mat', 'test_5');
verifyEqual(testCase, actual.ASX_VGB, expected.test_5.ASX_VGB);
end

function test_6(testCase)
symbol = 'VTS.AX';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_google(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm');
expected = load('test_get_data_google.mat', 'test_6');
verifyEqual(testCase, actual.ASX_VTS, expected.test_6.ASX_VTS);
end

function test_7(testCase)
symbol = {'IBM', 'HPQ'};
actual = get_data_google(symbol);
expected = load('test_get_data_google.mat', 'test_7');
verifyEqual(testCase, actual.NYSE_IBM, expected.test_7.NYSE_IBM);
verifyEqual(testCase, actual.NYSE_HPQ, expected.test_7.NYSE_HPQ);
end

function test_8(testCase)
symbol = {'WAB', 'GE'};
actual = get_data_google(symbol, 'start', '27-01-2012', ...
    'finish', '17-07-2014', 'format', 'dd-mm-yyyy');
expected = load('test_get_data_google.mat', 'test_8');
verifyEqual(testCase, actual.NYSE_WAB, expected.test_8.NYSE_WAB);
verifyEqual(testCase, actual.NYSE_GE, expected.test_8.NYSE_GE);
end

function test_9(testCase)
symbol = {'MSFT', 'AAPL'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data_google(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric');
expected = load('test_get_data_google.mat', 'test_9');
verifyEqual(testCase, actual.NASDAQ_MSFT, expected.test_9.NASDAQ_MSFT);
verifyEqual(testCase, actual.NASDAQ_AAPL, expected.test_9.NASDAQ_AAPL);
end

function test_10(testCase)
symbol = {'GOOG', 'FB'};
actual = get_data_google(symbol, 'interval', 'd');
expected = load('test_get_data_google.mat', 'test_10');
verifyEqual(testCase, actual.NASDAQ_GOOG, expected.test_10.NASDAQ_GOOG);
verifyEqual(testCase, actual.NASDAQ_FB, expected.test_10.NASDAQ_FB);
end

function test_11(testCase)
symbol = {'COKE', 'PEP'};
actual = get_data_google(symbol, 'start', '03-10-2012', ...
    'finish', '16-07-2014', 'format', 'dd-mm-yyyy', 'interval', 'w');
expected = load('test_get_data_google.mat', 'test_11');
verifyEqual(testCase, actual.NASDAQ_COKE, expected.test_11.NASDAQ_COKE);
verifyEqual(testCase, actual.NYSE_PEP, expected.test_11.NYSE_PEP);
end

function test_12(testCase)
symbol = {'F', 'TM'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data_google(symbol, 'start', start, ...
    'finish', finish, 'format', 'numeric', 'interval', 'm');
expected = load('test_get_data_google.mat', 'test_12');
verifyEqual(testCase, actual.NYSE_F, expected.test_12.NYSE_F);
verifyEqual(testCase, actual.NYSE_TM, expected.test_12.NYSE_TM);
end

%%
% The last test function returns to what was the current directory, and
% removes all of the temporary variables used by the test unit from the
% MATLAB workspace.
function teardownOnce(testCase)
cd(testCase.TestData.origPath);
end