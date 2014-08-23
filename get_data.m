function data = get_data(symbol, varargin)
% GET_DATA Get historic stock data from various sources.
%   DATA = GET_DATA(SYMBOL) gets historic stock data from various sources
%   for one or more stock symbols. SYMBOL may be a character string, or a
%   cell array of character strings.
%
%   Stock symbols must comply with the Yahoo! Finance naming convention,
%   which gives all foreign (non-US) stock symbols an exchange suffix. A
%   complete list of stock exchanges supported by Yahoo! Finance may be
%   found <a href="matlab:web('http://tinyurl.com/g2caw')">here</a>.
%
%   DATA is a structure array containing NUMSYM fields, where NUMSYM is the
%   number of stock symbols. NUMSYM fields are structure arrays containing
%   NUMSOR fields, where NUMSOR is the number of data sources. Each NUMSOR
%   field contains a NUMOBS-by-8 table, where NUMOBS is the number of stock
%   stock observations. Each table contains the following columns of data:
%
%   Column | Description
%   ------ | -----------
%   1      | Date
%   2      | Open
%   3      | High
%   4      | Low
%   5      | Close
%   6      | Volume
%   7      | Dividend
%   8      | Split
%
%   The 'Date' column contains serial date numbers in ascending order (ie
%   oldest first). The 'Dividend' and 'Split' columns contain zeros except
%   for dates on which a dividend or split action occurred. Should a table
%   contain nothing but zeros in these two columns, it indicates that the
%   stock has never had a dividend or split action occur. Missing data is
%   indicated by not-a-number (NaN).
%
%   When called without options, GET_DATA gets the complete set of daily
%   stock observations from Yahoo! Finance for each symbol. Stock prices
%   are quoted in the currency used by the exchange on which the stock is
%   listed.
%
%   DATA = GET_DATA(SYMBOL, NAME, VALUE) gets historic stock data from
%   various sources for one or more stock symbols, with additional options
%   specified by one or more name-value pair arguments:
%
%   'source'        The source of historic stock data. The value of
%                   'source' must be one or more of the following:
%
%                   'google'            Google Finance
%                   'yahoo'             Yahoo! Finance
%                   'quandl_google'     Quandl Google Finance
%                   'quandl_wiki'       Quandl Open Data
%                   'quandl_yahoo'      Quandl Yahoo! Finance
%
%   'start'         The date of the least recent (ie oldest) historic stock
%                   observation. The value of 'start' may be a serial date
%                   number, or a date string.
%
%   'finish'        The date of the most recent (ie newest) historic stock
%                   observation. The value of 'finish' may be a serial date
%                   number, or a date string.
%
%   'format'        The format of the 'start' and 'finish' name-value pair
%                   arguments. The value of 'format' must be one of the
%                   following:
%
%                   'numeric'
%                   'dd-mm-yyyy'
%                   'mm-dd-yyyy'
%                   'yyyy-mm-dd'
%
%   'token'         Quandl authentication token. Unregistered Quandl users
%                   are limited to 50 API calls per day. Registered Quandl
%                   users are issued an authentication token that allows
%                   unlimited downloads and API access.
%
%   The 'start', 'finish', and 'format' name-value pair arguments form a
%   set, and must be used as such.
%
%   Example:
%       data = GET_DATA('FNZ.NZ');
%
%   Example:
%       data = GET_DATA('VAS.AX', 'source', 'quandl_google', ...
%           'token', 'dsahFHUiewjjd');
%
%   Example:
%       symbol = {'WAB', 'GE'};
%       source = {'google', 'quandl_wiki', 'yahoo'};
%       data = GET_DATA(symbol, 'source', source, ...
%           'start', '27-01-2012', 'finish', '17-07-2014', ...
%           'format', 'dd-mm-yyyy', 'token', 'dsahFHUiewjjd');
%
%   Note that the value of 'token' in the examples above is fake, and will
%   not work.
%
%   See also GET_DATA_GOOGLE, GET_DATA_QUANDL, GET_DATA_YAHOO.

%% File and license information.
%**************************************************************************
%
%   File:           get_data.m
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

%% Parse input.
% GET_DATA accepts one required input argument, and five optional
% name-value pair arguments. The easiest way to check these arguments is by
% using the 'inputParser' class and its associated methods.
p = inputParser;
addRequired(p, 'symbol', @check_symbol);
addParameter(p, 'source', [], @check_source);
addParameter(p, 'start', [], @check_date);
addParameter(p, 'finish', [], @check_date);
addParameter(p, 'format', [], @check_format);
addParameter(p, 'token', [], @check_token);
parse(p, symbol, varargin{:});

source = p.Results.source;
start = p.Results.start;
finish = p.Results.finish;
format = p.Results.format;
token = p.Results.token;

if ischar(symbol)
    symbol = {symbol};
end

if ischar(source)
    source = {source};
end

%% Get data.
% Get historic stock data from each source, then rearrange it to make the
% layout more intuitive.
if ~isempty(source)
    for i = 1:length(source)
        if strcmp(source{i}, 'google')
            if isempty(start)
                result = get_data_google(symbol);
            else
                result = get_data_google(symbol, 'start', start, ...
                    'finish', finish, 'format', format);
            end
        elseif strcmp(source{i}, 'yahoo')
            if isempty(start)
                result = get_data_yahoo(symbol);
            else
                result = get_data_yahoo(symbol, 'start', start, ...
                    'finish', finish, 'format', format);
            end
        elseif strcmp(source{i}, 'quandl_google')
            if isempty(start)
                result = get_data_quandl(symbol, 'feed', 'GOOG', ...
                    'token', token);
            else
                result = get_data_quandl(symbol, 'feed', 'GOOG', ...
                'start', start, 'finish', finish, 'format', format, ...
                'token', token);
            end
        elseif strcmp(source{i}, 'quandl_wiki')
            if isempty(start)
                result = get_data_quandl(symbol, 'feed', 'WIKI', ...
                'token', token);
            else
                result = get_data_quandl(symbol, 'feed', 'WIKI', ...
                'start', start, 'finish', finish, 'format', format, ...
                'token', token);
            end
        elseif strcmp(source{i}, 'quandl_yahoo')
            if isempty(start)
                result = get_data_quandl(symbol, 'feed', 'YAHOO', ...
                'token', token);
            else
                result = get_data_quandl(symbol, 'feed', 'YAHOO', ...
                'start', start, 'finish', finish, 'format', format, ...
                'token', token);
            end
        end
        
        if ~isempty(result)
            fields = fieldnames(result)';

            for j = 1:length(symbol)
                split = regexp(symbol{j}, '\.', 'split');
                expression = ['\w*' split{1} '\w*'];
                match = regexp(fields, expression, 'once', 'match');

                for k = 1:length(match)
                    if ~isempty(match{k})
                        string = matlab.lang.makeValidName(symbol{j});
                        data.(string).(source{i}) = result.(match{k});
                        break
                    end
                end
            end
        end
    end
else
    if isempty(start)
        result = get_data_yahoo(symbol);
    else
        result = get_data_yahoo(symbol, 'start', start, ...
            'finish', finish, 'format', format);
    end
    
    for i = 1:length(symbol)
        string = matlab.lang.makeValidName(symbol{i});
        data.(string).yahoo = result.(string);
    end
end

if ~exist('data', 'var')
        data = [];
end
end

%% Local functions.
function check_symbol(symbol)
validateattributes(symbol, {'char', 'cell'}, {'row', 'row'});
end

function check_source(source)
validateattributes(source, {'char', 'cell'}, {'row', 'row'});

if ~iscell(source)
    validatestring(source, {'google', 'quandl_google', 'quandl_wiki', ...
        'quandl_yahoo', 'yahoo'});
end
end

function check_date(date)
if isnumeric(date)
    validateattributes(date, {'numeric'}, {'scalar', 'positive'});
else
    validateattributes(date, {'char'}, {'row'});
end
end

function check_format(format)
validatestring(format, {'numeric', 'dd-mm-yyyy', 'mm-dd-yyyy', ...
    'yyyy-mm-dd'});
end

function check_token(token)
validateattributes(token, {'char'}, {'row'});
end