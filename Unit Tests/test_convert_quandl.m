function tests = test_convert_quandl
% TEST_CONVERT_QUANDL Test unit for CONVERT_QUANDL.
%   TESTS = TEST_CONVERT_QUANDL creates an array of handles to local
%   CONVERT_QUANDL test functions.
%
%   Use:
%       results = runtests('test_convert_quandl.m')
%
%   See also CONVERT_QUANDL.

%% File and license information.
%**************************************************************************
%
%   File:           test_convert_quandl.m
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
% level to where CONVERT_QUANDL should be located.
function setupOnce(testCase)
testCase.TestData.origPath = pwd;
cd ../
end

%%
% The following group of test functions verify that CONVERT_QUANDL throws
% the correct error when passed invalid input arguments.
function test_no_argument(testCase)
actual = @()convert_quandl();
expected = 'MATLAB:minrhs';
verifyError(testCase, actual, expected);
end

function test_symbol_invalid_class(testCase)
actual = @()convert_quandl(0);
expected = 'convert_quandl:invalid_type';
verifyError(testCase, actual, expected);
end

%%
% The following group of test functions verify that CONVERT_QUANDL returns
% the correct set of data.
function test_1(testCase)
document = xmlread('test_1_convert_quandl.xml');
actual = convert_quandl(document);
expected = load('test_convert_quandl.mat', 'test_1');
verifyEqual(testCase, actual, expected.test_1);
end

function test_2(testCase)
document = xmlread('test_2_convert_quandl.xml');
actual = convert_quandl(document);
expected = load('test_convert_quandl.mat', 'test_2');
verifyEqual(testCase, actual, expected.test_2);
end

%%
% The last test function returns to what was the current directory, and
% removes all of the temporary variables used by the test unit from the
% MATLAB workspace.
function teardownOnce(testCase)
cd(testCase.TestData.origPath);
clear all;
end