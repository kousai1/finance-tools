function tests = test_search_quandl
% TEST_SEARCH_QUANDL Test unit for SEARCH_QUANDL.
%   TESTS = TEST_SEARCH_QUANDL creates an array of handles to local
%   SEARCH_QUANDL test functions.
%
%   Use:
%       results = runtests('test_search_quandl.m')
%
%   Before running the test unit, ensure that there is a valid global
%   Quandl authentication token present in the MATLAB workspace.
%
%   Example:
%       global token;
%       token = 'dsahFHUiewjjd';
%
%   Note that the value of 'token' in the example above is fake, and will
%   not work.
%
%   See also SEARCH_QUANDL.

%% File and license information.
%**************************************************************************
%
%   File:           test_search_quandl.m
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

%% Create test array.
% The following code is MATLAB test unit boilerplate, and should not be
% modified.
tests = functiontests(localfunctions);
end

%% Local functions.
% The first test function records the current directory, then moves up one
% level to where SEARCH_QUANDL should be located.
function setupOnce(testCase)
testCase.TestData.origPath = pwd;
cd ../
end

%%
% The following group of test functions verify that SEARCH_QUANDL throws
% the correct error when passed invalid input arguments.
function test_no_argument(testCase)
actual = @()search_quandl();
expected = 'MATLAB:minrhs';
verifyError(testCase, actual, expected);
end

function test_query_invalid_class(testCase)
actual = @()search_quandl(0);
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_query_invalid_char_row_attribute(testCase)
actual = @()search_quandl(('QUERY')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_count_no_value(testCase)
actual = @()search_quandl('QUERY', 'count');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_count_invalid_class(testCase)
actual = @()search_quandl('QUERY', 'count', {'COUNT'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_count_invalid_numeric_scalar_attribute(testCase)
actual = @()search_quandl('QUERY', 'count', [0 0]);
expected = 'MATLAB:expectedScalar';
verifyError(testCase, actual, expected);
end

function test_count_invalid_numeric_positive_attribute(testCase)
actual = @()search_quandl('QUERY', 'count', -20);
expected = 'MATLAB:expectedPositive';
verifyError(testCase, actual, expected);
end

function test_count_invalid_numeric_integer_attribute(testCase)
actual = @()search_quandl('QUERY', 'count', 3.141);
expected = 'MATLAB:expectedInteger';
verifyError(testCase, actual, expected);
end

function test_count_invalid_char_row_attribute(testCase)
actual = @()search_quandl('QUERY', 'count', ('COUNT')');
expected = 'MATLAB:expectedRow';
verifyError(testCase, actual, expected);
end

function test_count_invalid_value(testCase)
actual = @()search_quandl('QUERY', 'count', 'COUNT');
expected = 'MATLAB:unrecognizedStringChoice';
verifyError(testCase, actual, expected);
end

function test_filter_invalid_class(testCase)
actual = @()search_quandl('QUERY', 'filter', {'FILTER'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_filter_no_value(testCase)
actual = @()search_quandl('QUERY', 'filter');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

function test_token_invalid_class(testCase)
actual = @()search_quandl('QUERY', 'token', {'token'});
expected = 'MATLAB:invalidType';
verifyError(testCase, actual, expected);
end

function test_token_no_value(testCase)
actual = @()search_quandl('QUERY', 'token');
expected = 'MATLAB:InputParser:ParamMissingValue';
verifyError(testCase, actual, expected);
end

%%
% The following group of test functions verify that SEARCH_QUANDL returns
% the correct set of data when passed one of the various combinations of
% input arguments that it supports.
function test_1(testCase)
global token;
actual = search_quandl('mUsNrbU&@I{W"UcsA"P', 'token', token);
expected = load('test_search_quandl.mat', 'test_1');
verifyEqual(testCase, actual, expected.test_1);
end

function test_2(testCase)
global token;
actual = search_quandl('FNZ', 'token', token);
expected = load('test_search_quandl.mat', 'test_2');

for i = 1:length(actual)
    verifyEqual(testCase, actual(i), expected.test_2(i));
end
end

function test_3(testCase)
global token;
actual = search_quandl('IBM', 'count', 25, 'token', token);
expected = load('test_search_quandl.mat', 'test_3');

for i = 1:length(actual)
    verifyEqual(testCase, actual(i), expected.test_3(i));
end
end

function test_4(testCase)
global token;
actual = search_quandl('VEU', 'filter', 'GOOG', 'token', token);
expected = load('test_search_quandl.mat', 'test_4');

for i = 1:length(actual)
    verifyEqual(testCase, actual(i), expected.test_4(i));
end
end

function test_5(testCase)
global token;
actual = search_quandl('HPQ', 'count', 25, 'filter', 'GOOG', ...
    'token', token);
expected = load('test_search_quandl.mat', 'test_5');

for i = 1:length(actual)
    verifyEqual(testCase, actual(i), expected.test_5(i));
end
end

%%
% The last test function returns to what was the current directory, and
% removes all of the temporary variables used by the test unit from the
% MATLAB workspace.
function teardownOnce(testCase)
cd(testCase.TestData.origPath);
clear all;
end