function data = get_data_yahoo(symbol, varargin)
% GET_DATA_YAHOO Get historic stock data from Yahoo! Finance.
%   DATA = GET_DATA_YAHOO(SYMBOL) gets historic stock data from Yahoo!
%   Finance for one or more stock symbols. SYMBOL may be a character
%   string, or a cell array of character strings.
%
%   Stock symbols must adhere to the Yahoo! Finance naming convention,
%   which places an exchange suffix after all foreign stock symbols. A
%   complete list of stock exchanges supported by Yahoo! Finance may be
%   found <a href="matlab:web('http://tinyurl.com/g2caw')">here</a>.
%
%   DATA is a NUMOBS-by-8-by-NUMSYM table, where NUMOBS is the number of
%   stock observations, and NUMSYM is the number of stock symbols.
%
%   DATA contains the following columns of data:
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
%   for dates on which a dividend or split action occurred. Should DATA
%   contain nothing but zeros in these two columns, it indicates that the
%   stock has never had a dividend or split action occur.
%
%   When called without options, GET_DATA_YAHOO gets the complete set of
%   daily stock observations for each symbol. Stock prices are returned in
%   the currency used by the exchange on which the stock is listed.
%
%   DATA = GET_DATA_YAHOO(SYMBOL, NAME, VALUE) gets historic stock data
%   from Yahoo! Finance for one or more stock symbols, with additional
%   options specified by one or more name-value pair arguments:
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
%   'interval'      The time period between successive historic stock
%                   observations. The value of 'interval' must be one of
%                   the following:
%
%                   'd'     Day
%                   'w'     Week
%                   'm'     Month
%
%   The 'start', 'finish', and 'format' name-value pair arguments form a
%   set, and must be used as such.
%
%   Example:
%       data = GET_DATA_YAHOO('FNZ.NZ');
%
%   Example:
%       data = GET_DATA_YAHOO('VAS.AX', 'interval', 'd');
%
%   Example:
%       symbol = {'WAB', 'GE'};
%       data = get_data_yahoo(symbol, 'start', '27-01-2012', ...
%           'finish', '17-07-2014', 'format', 'dd-mm-yyyy');
%
%   See also TEST_GET_DATA_YAHOO.

%% File and license information.
%**************************************************************************
%
%   File:           get_data_yahoo.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           28 July 2014
%
%**************************************************************************
%
%   Copyright:      (c) 2014 Michael Weidman, Rodney Elliott
%
%                   All rights reserved.
% 
%   Redistribution and use in source and binary forms, with or without
%   modification, are permitted provided that the following conditions are
%   met:
% 
%   * Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer.
%   * Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in
%     the documentation and/or other materials provided with the
%     distribution.
% 
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
%   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
%   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
%   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%**************************************************************************

%% Parse input.
% GET_DATA_YAHOO accepts one required input argument, and four optional
% name-value pair arguments. The easiest way to check these arguments is
% by using the 'inputParser' class and its associated methods.
p = inputParser;
addRequired(p, 'symbol', @check_symbol);
addParameter(p, 'start', [], @check_date);
addParameter(p, 'finish', [], @check_date);
addParameter(p, 'format', [], @check_format);
addParameter(p, 'interval', [], @check_interval);
parse(p, symbol, varargin{:});

start = p.Results.start;
finish = p.Results.finish;
format = p.Results.format;
interval = p.Results.interval;

if ischar(symbol)
    symbol = {symbol};
end

%%
% Whilst 'inputParser' is great for checking the class and attributes of
% input arguments, additional checks are still required. This is because
% the validation functions used by the 'addRequired' and 'addParameter'
% methods only accept a single input argument. As a result, checks that
% involve multiple input arguments must be performed separately. In the
% case of GET_DATA_YAHOO, this means checking that the name-value pair
% arguments 'start', 'finish', and 'format' have been supplied as a set,
% in addition to checking that the value of 'start' predates the value of
% 'finish'.
if ~isempty(start) || ~isempty(finish) || ~isempty(format)
    if ~(~isempty(start) && ~isempty(finish) && ~isempty(format))
        error('get_data_yahoo:missing_parameter', ...
            ['Missing parameter. The name-value pair arguments:\r\n' ...
            '''start'', ''finish'', ''format''\r\nform a set, and ' ...
            'must be used as such.']);
    end
end

if ~isempty(start)
    if ~strcmp(format, 'numeric')
        if datenum(start, format) > datenum(finish, format)
            error('get_data_yahoo:invalid_value', ...
                ['Invalid value. The value of ''start'' must predate ' ...
                'the value of ''finish''.']);
        end
    end
end

%%
% The last check that needs to be performed is to ensure that all stock
% symbols are valid. This is done using the Yahoo! Finance stock lookup
% service, which is a REST service that returns JSON data. Rather than
% deserialise the JSON data, it is simply parsed for the empty result
% string. Should this string be found, the stock symbol does not exist. To
% learn more about the Yahoo! Finance stock lookup service, please see the
% following <http://tinyurl.com/q9dgxg2 link>.
symbol_url = 'http://autoc.finance.yahoo.com/autoc?query=';
terminal_field = '&callback=YAHOO.Finance.SymbolSuggest.ssCallback';

for i = 1:length(symbol)
    symbol_field = symbol{i};

    try
        json_string = urlread([symbol_url symbol_field terminal_field], ...
            'Timeout', 10);
    catch
        error('get_data_yahoo:no_connection', ...
            ['No connection. Failed to get JSON data for symbol:' ...
            '\r\n''%s''\r\nCheck the network connection.'], symbol{i});
    end

    if ~isempty(strfind(json_string, '"Result":[]'))
        error('get_data_yahoo:invalid_value', ...
            ['Invalid value. The stock symbol:\r\n''%s''\r\n does ' ...
            'not exist.'], symbol{i});
    end
end

%% Prepare REST requests.
% Two REST requests are made to Yahoo! Finance for each stock symbol. The
% first returns price and volume data in CSV format, while the second
% returns dividend and split data, again in CSV format. Each request
% consists of a base URL, and a number of optional query parameters. Note
% that the value of 'start' used below has been chosen to ensure that
% GET_DATA_YAHOO returns the complete set of historic price and dividend
% data whenever it is called without options. To learn more about the
% Yahoo! Finance REST API, please see the following links:
% <http://tinyurl.com/mxe54fs one>, <http://tinyurl.com/n34obls two>, and
% <http://tinyurl.com/m3kbyn2 three>.
price_url = 'http://ichart.finance.yahoo.com/table.csv?s=';
dividend_url = 'http://ichart.finance.yahoo.com/x?s=';

if ~isempty(start)
    if strcmp(format, 'numeric')
        start_field = start;
        finish_field = finish;
    else
        start_field = datenum(start, format);
        finish_field = datenum(finish, format);
    end
else
    % Leonardo da Vinci's date of birth.
    start_field = datenum('15-04-1452', 'dd-mm-yyyy');
    finish_field = now;
end

[start_year, start_month, start_day] = datevec(start_field);
[finish_year, finish_month, finish_day] = datevec(finish_field);

date_field = ['&a=' num2str(start_month - 1) ...
    '&b=' num2str(start_day) '&c=' num2str(start_year) ...
    '&d=' num2str(finish_month - 1) ...
    '&e=' num2str(finish_day) '&f=' num2str(finish_year)];
    
if ~isempty(interval)
    interval_field = ['&g=' interval];
else
    interval_field = '&g=d';
end

%%
% The 'y' and 'z' parameters in the split field are not documented in any
% of the previous Yahoo! Finance links. A little experimentation reveals
% that the 'z' parameter specifies the total number of observations to
% return, starting with the most recent. In this context, an observation
% may be either a dividend or split action. The 'y' parameter specifies the
% number of observations to skip, again starting with the most recent. Thus
% a 'z' value of 20 and a 'y' value of 5 will result in the 5 most recent
% observations being skipped, and the next 20 being returned.
dividend_field = '&g=v&y=0&z=10000';
terminal_field = '&ignore=.csv';

%% Make REST requests.
% The price and volume data returned by Yahoo! Finance is homogeneous,
% whilst the dividend and split data is heterogeneous. As a result, they
% must be processed differently. Note that the following code assumes that
% dividend and split actions always occur on days for which stock data is
% available.
for i = 1:length(symbol)
    symbol_field = symbol{i};
    
    try
        price_string = urlread([price_url symbol_field date_field ...
            interval_field terminal_field], 'Timeout', 10);
    catch
        error('get_data_yahoo:no_connection', ...
            ['No connection. Failed to get price data for symbol:' ...
            '\r\n''%s''\r\nCheck the date range, and/or network ' ...
            'connection.'], symbol{i});
    end
    
    price_data = textscan(price_string, '%s%f%f%f%f%f%f', ...
        'HeaderLines', 1, 'Delimiter', ',');

    price_data{1} = datenum(price_data{1}, 'yyyy-mm-dd');

    data_array = [price_data{1} price_data{2} price_data{3} ...
        price_data{4} price_data{5} price_data{6} ...
        zeros(length(price_data{1}), 2)];
    
    try
        dividend_string = urlread([dividend_url symbol_field date_field ...
            dividend_field terminal_field], 'Timeout', 10);
    catch
        error('get_data_yahoo:no_connection', ...
            ['No connection. Failed to get dividend data for symbol:' ...
            '\r\n''%s''\r\nCheck the network connection.'], symbol{i});
    end

    mixed_data = textscan(dividend_string, '%s%s%s', ...
        'HeaderLines', 1, 'Delimiter', ',');
    
    % In addition to containing header information, 'dividend_string' also
    % contains footer information. The former is skipped by 'textscan',
    % whilst the later is ignored by the following loop.
    for j = 1:(length(mixed_data{1}) - 4)
        if strcmp(mixed_data{1}(j), 'DIVIDEND')
            date = datenum(mixed_data{2}(j), 'yyyymmdd');
            value = str2double(mixed_data{3}(j));

            row = data_array(:, 1) == date;
            data_array(row, 7) = value;

        elseif strcmp(mixed_data{1}(j), 'SPLIT')
            date = datenum(mixed_data{2}(j), 'yyyymmdd');
            ratio = regexp(mixed_data{3}(j), ':', 'split');
            value = str2double(ratio{1}(1)) / str2double(ratio{1}(2));

            row = data_array(:, 1) == date;
            data_array(row, 8) = value;
        end
    end

    data_array = flipud(data_array);

    data_table = array2table(data_array, 'VariableNames', ...
        {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', ...
        'Dividend', 'Split'});
    
    data.(matlab.lang.makeValidName(symbol{i})) = data_table;
end
end

%% Local functions.
function check_symbol(symbol)
validateattributes(symbol, {'char', 'cell'}, {'row', 'row'});
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

function check_interval(interval)
validatestring(interval, {'d', 'w', 'm'});
end