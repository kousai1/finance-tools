function tests = test_get_data
% TEST_GET_DATA Test unit for GET_DATA.
%   TESTS = TEST_GET_DATA creates an array of handles to local GET_DATA
%   test functions.
%
%   Use:
%       results = runtests('test_get_data.m')
%
%   See also GET_DATA.

%% File and license information.
%**************************************************************************
%
%   File:           test_get_data.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           18 August 2014
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
% level to where GET_DATA should be located.
function setupOnce(testCase)
testCase.TestData.origPath = pwd;
cd ../
end

%%
% The following group of test functions verify that GET_DATA throws the
% correct error when passed invalid input arguments.
function test_no_argument(testCase)
actual = @()get_data();
expected = 'MATLAB:minrhs';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_class(testCase)
actual = @()get_data(0);
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_char_row_attribute(testCase)
actual = @()get_data(('SYMBOL')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_cell_row_attribute(testCase)
actual = @()get_data({'SYMBOL'; 'SYMBOL'});
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_source_no_value(testCase)
actual = @()get_data('SYMBOL', 'source');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_source_invalid_value(testCase)
actual = @()get_data('SYMBOL', 'source', 'SOURCE');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_start_no_value(testCase)
actual = @()get_data('SYMBOL', 'start');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_start_invalid_class(testCase)
actual = @()get_data('SYMBOL', 'start', {'START'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_start_invalid_numeric_scalar_attribute(testCase)
actual = @()get_data('SYMBOL', 'start', [0 0]);
expected = 'MATLAB:expectedScalar';
verifyError(testCase, actual, expected);
end

function test_start_invalid_numeric_positive_attribute(testCase)
actual = @()get_data('SYMBOL', 'start', -735790);
expected = 'MATLAB:expectedPositive';
verifyError(testCase, actual, expected);
end

function test_start_invalid_char_row_attribute(testCase)
actual = @()get_data('SYMBOL', 'start', ('START')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_format_no_value(testCase)
actual = @()get_data('SYMBOL', 'format');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_format_invalid_value(testCase)
actual = @()get_data('SYMBOL', 'format', 'FORMAT');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_token_invalid_class(testCase)
actual = @()get_data('SYMBOL', 'token', {'token'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_token_no_value(testCase)
actual = @()get_data('SYMBOL', 'token');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

%%
% The following group of test functions verify that GET_DATA returns the
% correct set of data when passed one of the various combinations of input
% arguments that it supports.

function test_1(testCase)
symbol = 'FNZ.NZ';
source = 'google';
actual = get_data(symbol, ...
    'source', source);
expected = load('test_get_data.mat', 'test_1');
verifyTrue(testCase, isequaln(actual.FNZ_NZ, expected.test_1.FNZ_NZ));
end

function test_2(testCase)
symbol = 'VEU.AX';
source = 'google';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy');
expected = load('test_get_data.mat', 'test_2');
verifyTrue(testCase, isequaln(actual.VEU_AX, expected.test_2.VEU_AX));
end

function test_3(testCase)
symbol = 'VAP.AX';
source = 'google';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric');
expected = load('test_get_data.mat', 'test_3');
verifyTrue(testCase, isequaln(actual.VAP_AX, expected.test_3.VAP_AX));
end

function test_4(testCase)
global token
symbol = 'VAS.AX';
source = 'quandl_google';
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_4');
verifyTrue(testCase, isequaln(actual.VAS_AX, expected.test_4.VAS_AX));
end

function test_5(testCase)
global token
symbol = 'VGB.AX';
source = 'quandl_google';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_5');
verifyTrue(testCase, isequaln(actual.VGB_AX, expected.test_5.VGB_AX));
end

function test_6(testCase)
global token
symbol = 'VTS.AX';
source = 'quandl_google';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_6');
verifyTrue(testCase, isequaln(actual.VTS_AX, expected.test_6.VTS_AX));
end

function test_7(testCase)
global token
symbol = 'IBM';
source = 'quandl_wiki';
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_7');
verifyTrue(testCase, isequaln(actual.IBM, expected.test_7.IBM));
end

function test_8(testCase)
global token
symbol = 'HPQ';
source = 'quandl_wiki';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_8');
verifyTrue(testCase, isequaln(actual.HPQ, expected.test_8.HPQ));
end

function test_9(testCase)
global token
symbol = 'WAB';
source = 'quandl_wiki';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_9');
verifyTrue(testCase, isequaln(actual.WAB, expected.test_9.WAB));
end

function test_10(testCase)
global token
symbol = 'GE';
source = 'quandl_yahoo';
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_10');
verifyTrue(testCase, isequaln(actual.GE, expected.test_10.GE));
end

function test_11(testCase)
global token
symbol = 'MSFT';
source = 'quandl_yahoo';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_11');
verifyTrue(testCase, isequaln(actual.MSFT, expected.test_11.MSFT));
end

function test_12(testCase)
global token
symbol = 'AAPL';
source = 'quandl_yahoo';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_12');
verifyTrue(testCase, isequaln(actual.AAPL, expected.test_12.AAPL));
end

function test_13(testCase)
symbol = 'IBM';
source = 'yahoo';
actual = get_data(symbol, ...
    'source', source);
expected = load('test_get_data.mat', 'test_13');
verifyTrue(testCase, isequaln(actual.IBM, expected.test_13.IBM));
end

function test_14(testCase)
symbol = 'HPQ';
source = 'yahoo';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy');
expected = load('test_get_data.mat', 'test_14');
verifyTrue(testCase, isequaln(actual.HPQ, expected.test_14.HPQ));
end

function test_15(testCase)
symbol = 'WAB';
source = 'yahoo';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric');
expected = load('test_get_data.mat', 'test_15');
verifyTrue(testCase, isequaln(actual.WAB, expected.test_15.WAB));
end

function test_16(testCase)
global token
symbol = 'GE';
source = {'google', 'quandl_google'};
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_16');
verifyTrue(testCase, isequaln(actual.GE, expected.test_16.GE));
end

function test_17(testCase)
global token
symbol = 'MSFT';
source = {'quandl_wiki', 'quandl_yahoo'};
actual = get_data(symbol, ...
    'source', source, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_17');
verifyTrue(testCase, isequaln(actual.MSFT, expected.test_17.MSFT));
end

function test_18(testCase)
global token
symbol = 'AAPL';
source = {'yahoo', 'google'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_18');
verifyTrue(testCase, isequaln(actual.AAPL, expected.test_18.AAPL));
end

function test_19(testCase)
symbol = {'IBM', 'HPQ'};
source = 'google';
actual = get_data(symbol, ...
    'source', source);
expected = load('test_get_data.mat', 'test_19');
verifyTrue(testCase, isequaln(actual.IBM, expected.test_19.IBM));
verifyTrue(testCase, isequaln(actual.HPQ, expected.test_19.HPQ));
end

function test_20(testCase)
symbol = {'WAB', 'GE'};
source = 'google';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy');
expected = load('test_get_data.mat', 'test_20');
verifyTrue(testCase, isequaln(actual.WAB, expected.test_20.WAB));
verifyTrue(testCase, isequaln(actual.GE, expected.test_20.GE));
end

function test_21(testCase)
symbol = {'MSFT', 'AAPL'};
source = 'google';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric');
expected = load('test_get_data.mat', 'test_21');
verifyTrue(testCase, isequaln(actual.MSFT, expected.test_21.MSFT));
verifyTrue(testCase, isequaln(actual.AAPL, expected.test_21.AAPL));
end

function test_22(testCase)
global token
symbol = {'GOOG', 'FB'};
source = 'quandl_google';
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_22');
verifyTrue(testCase, isequaln(actual.GOOG, expected.test_22.GOOG));
verifyTrue(testCase, isequaln(actual.FB, expected.test_22.FB));
end

function test_23(testCase)
global token
symbol = {'COKE', 'PEP'};
source = 'quandl_google';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_23');
verifyTrue(testCase, isequaln(actual.COKE, expected.test_23.COKE));
verifyTrue(testCase, isequaln(actual.PEP, expected.test_23.PEP));
end

function test_24(testCase)
global token
symbol = {'F', 'GM'};
source = 'quandl_google';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_24');
verifyTrue(testCase, isequaln(actual.F, expected.test_24.F));
verifyTrue(testCase, isequaln(actual.GM, expected.test_24.GM));
end

function test_25(testCase)
global token
symbol = {'GOOG', 'FB'};
actual = get_data(symbol, ...
    'token', token);
expected = load('test_get_data.mat', 'test_25');
verifyTrue(testCase, isequaln(actual.GOOG, expected.test_25.GOOG));
verifyTrue(testCase, isequaln(actual.FB, expected.test_25.FB));
end

function test_26(testCase)
global token
symbol = {'COKE', 'PEP'};
actual = get_data(symbol, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_26');
verifyTrue(testCase, isequaln(actual.COKE, expected.test_26.COKE));
verifyTrue(testCase, isequaln(actual.PEP, expected.test_26.PEP));
end

function test_27(testCase)
global token
symbol = {'F', 'GM'};
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_27');
verifyTrue(testCase, isequaln(actual.F, expected.test_27.F));
verifyTrue(testCase, isequaln(actual.GM, expected.test_27.GM));
end

function test_28(testCase)
global token
symbol = {'MCD', 'BKW'};
source = 'quandl_yahoo';
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_28');
verifyTrue(testCase, isequaln(actual.MCD, expected.test_28.MCD));
verifyTrue(testCase, isequaln(actual.BKW, expected.test_28.BKW));
end

function test_29(testCase)
global token
symbol = {'AMZN', 'NFLX'};
source = 'quandl_yahoo';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_29');
verifyTrue(testCase, isequaln(actual.AMZN, expected.test_29.AMZN));
verifyTrue(testCase, isequaln(actual.NFLX, expected.test_29.NFLX));
end

function test_30(testCase)
global token
symbol = {'GS', 'MS'};
source = 'quandl_yahoo';
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_30');
verifyTrue(testCase, isequaln(actual.GS, expected.test_30.GS));
verifyTrue(testCase, isequaln(actual.MS, expected.test_30.MS));
end

function test_31(testCase)
symbol = {'GOOG', 'FB'};
source = 'yahoo';
actual = get_data(symbol, ...
    'source', source);
expected = load('test_get_data.mat', 'test_31');
verifyTrue(testCase, isequaln(actual.GOOG, expected.test_31.GOOG));
verifyTrue(testCase, isequaln(actual.FB, expected.test_31.FB));
end

function test_32(testCase)
symbol = {'COKE', 'PEP'};
source = 'yahoo';
actual = get_data(symbol, ...
    'source', source, ...
    'start', '27-01-2012', ...
    'finish', '17-07-2014', ...
    'format', 'dd-mm-yyyy');
expected = load('test_get_data.mat', 'test_32');
verifyTrue(testCase, isequaln(actual.COKE, expected.test_32.COKE));
verifyTrue(testCase, isequaln(actual.PEP, expected.test_32.PEP));
end

function test_33(testCase)
symbol = {'F', 'GM'};
source = 'yahoo';
start = datenum('07-05-2012', 'dd-mm-yyyy');
finish = datenum('16-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric');
expected = load('test_get_data.mat', 'test_33');
verifyTrue(testCase, isequaln(actual.F, expected.test_33.F));
verifyTrue(testCase, isequaln(actual.GM, expected.test_33.GM));
end

function test_34(testCase)
global token
symbol = {'MCD', 'BKW'};
source = {'quandl_google', 'quandl_wiki'};
actual = get_data(symbol, ...
    'source', source, ...
    'token', token);
expected = load('test_get_data.mat', 'test_34');
verifyTrue(testCase, isequaln(actual.MCD, expected.test_34.MCD));
verifyTrue(testCase, isequaln(actual.BKW, expected.test_34.BKW));
end

function test_35(testCase)
global token
symbol = {'AMZN', 'NFLX'};
source = {'quandl_yahoo', 'yahoo'};
actual = get_data(symbol, ...
    'source', source, ...
    'start', '03-10-2012', ...
    'finish', '16-07-2014', ...
    'format', 'dd-mm-yyyy', ...
    'token', token);
expected = load('test_get_data.mat', 'test_35');
verifyTrue(testCase, isequaln(actual.AMZN, expected.test_35.AMZN));
verifyTrue(testCase, isequaln(actual.NFLX, expected.test_35.NFLX));
end

function test_36(testCase)
global token
symbol = {'GS', 'MS'};
source = {'google', 'quandl_google'};
start = datenum('14-10-2011', 'dd-mm-yyyy');
finish = datenum('17-07-2014', 'dd-mm-yyyy');
actual = get_data(symbol, ...
    'source', source, ...
    'start', start, ...
    'finish', finish, ...
    'format', 'numeric', ...
    'token', token);
expected = load('test_get_data.mat', 'test_36');
verifyTrue(testCase, isequaln(actual.GS, expected.test_36.GS));
verifyTrue(testCase, isequaln(actual.MS, expected.test_36.MS));
end

function test_37(testCase)
symbol = 'BMW.BE';
source = 'google';
actual = get_data(symbol, ...
    'source', source);
expected = load('test_get_data.mat', 'test_37');
verifyTrue(testCase, isequaln(actual, expected.test_37));
end

%%
% The last test function returns to what was the current directory, and
% removes all of the temporary variables used by the test unit from the
% MATLAB workspace.
function teardownOnce(testCase)
cd(testCase.TestData.origPath)
end