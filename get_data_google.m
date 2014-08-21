function data = get_data_google(symbol, varargin)
% GET_DATA_GOOGLE Get historic stock data from Google Finance.
%   DATA = GET_DATA_GOOGLE(SYMBOL) gets historic stock data from Google
%   Finance for one or more stock symbols. SYMBOL may be a character
%   string, or a cell array of character strings.
%
%   Stock symbols must comply with the Yahoo! Finance naming convention,
%   which gives all foreign (non-US) stock symbols an exchange suffix. A
%   complete list of stock exchanges supported by Yahoo! Finance may be
%   found <a href="matlab:web('http://tinyurl.com/g2caw')">here</a>.
%
%   DATA is a structure array containing NUMSYM fields, where NUMSYM is the
%   number of stock symbols. Each field contains a NUMOBS-by-8 table, where
%   NUMOBS is the number of stock observations. Each table contains the
%   following columns of data:
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
%   When called without options, GET_DATA_GOOGLE gets one year's worth of
%   daily stock observations from Google Finance for each symbol. Stock
%   prices are quoted in the currency used by the exchange on which the
%   stock is listed.
%
%   DATA = GET_DATA_GOOGLE(SYMBOL, NAME, VALUE) gets historic stock data
%   from Google Finance for one or more stock symbols, with additional
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
%       data = GET_DATA_GOOGLE('FNZ.NZ');
%
%   Example:
%       data = GET_DATA_GOOGLE('VAS.AX', 'interval', 'w');
%
%   Example:
%       symbol = {'WAB', 'GE'};
%       data = GET_DATA_GOOGLE(symbol, 'start', '27-01-2012', ...
%           'finish', '17-07-2014', 'format', 'dd-mm-yyyy');
%
%   See also GET_DATA_GOOGLE, GET_DATA_YAHOO.

%% File and license information.
%**************************************************************************
%
%   File:           get_data_google.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           7 August 2014
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

EXCHANGE_CODES = { ...
    'N/A', '', 'American Stock Exchange'; ...
    'N/A', '', 'BATS Exchange'; ...
    'CBT', '', 'Chicago Board of Trade'; ...
    'CME', '', 'Chicago Mercantile Exchange'; ...
    'N/A', '', 'Dow Jones Indexes'; ...
    'N/A', 'NASDAQ', 'NASDAQ Stock Exchange'; ...
    'NYB', '', 'New York Board of Trade'; ...
    'CMX', '', 'New York Commodities Exchange'; ...
    'NYM', '', 'New York Mercantile Exchange'; ...
    'N/A', 'NYSE', 'New York Stock Exchange'; ...
    'OB', 'OTC', 'OTC Bulletin Board Market'; ...
    'PK', 'PINK', 'Pink Sheets'; ...
    'N/A', '', 'S & P Indices'; ...
    'BA', 'BCBA', 'Buenos Aires Stock Exchange'; ...
    'VI', 'VIE', 'Vienna Stock Exchange'; ...
    'AX', 'ASX', 'Australian Stock Exchange'; ...
    'SA', 'BOVESPA', 'Sao Paolo Stock Exchange'; ...
    'TO', 'TSE', 'Toronto Stock Exchange'; ...
    'V', 'CVE', 'TSX Venture Exchange'; ...
    'SN', '', 'Santiago Stock Exchange'; ...
    'SS', 'SHA', 'Shanghai Stock Exchange'; ...
    'SZ', 'SHE', 'Shenzhen Stock Exchange'; ...
    'CO', 'CPH', 'Copenhagen Stock Exchange'; ...
    'NX', '', 'Euronext'; ...
    'PA', 'EPA', 'Paris Stock Exchange'; ...
    'BE', '', 'Berlin Stock Exchange'; ...
    'BM', '', 'Bremen Stock Exchange'; ...
    'DU', '', 'Dusseldorf Stock Exchange'; ...
    'F', 'FRA', 'Frankfurt Stock Exchange'; ...
    'HM', '', 'Hamburg Stock Exchange'; ...
    'HA', '', 'Hanover Stock Exchange'; ...
    'MU', '', 'Munich Stock Exchange'; ...
    'SG', '', 'Stuttgart Stock Exchange'; ...
    'DE', 'ETR', 'XETRA Stock Exchange'; ...
    'HK', 'HKG', 'Hong Kong Stock Exchange'; ...
    'BO', 'BOM', 'Bombay Stock Exchange'; ...
    'NS', 'NSE', 'National Stock Exchange of India'; ...
    'JK', '', 'Jakarta Stock Exchange'; ...
    'TA', 'TLV', 'Tel Aviv Stock Exchange'; ...
    'MI', 'BIT', 'Milan Stock Exchange'; ...
    'N/A', 'INDEXNIKKEI', 'Nikkei Indices'; ...
    'MX', '', 'Mexico Stock Exchange'; ...
    'AS', 'AMS', 'Amsterdam Stock Exchange'; ...
    'NZ', 'NZE', 'New Zealand Stock Exchange'; ...
    'OL', '', 'Oslo Stock Exchange'; ...
    'SI', 'SGX', 'Singapore Stock Exchange'; ...
    'KS', 'KRX', 'Korea Stock Exchange'; ...
    'KQ', 'KOSDAQ', 'KOSDAQ'; ...
    'BC', '', 'Barcelona Stock Exchange'; ...
    'BI', '', 'Bilbao Stock Exchange'; ...
    'MF', '', 'Madrid Fixed Income Market'; ...
    'MC', '', 'Madrid SE C.A.T.S.'; ...
    'MA', '', 'Madrid Stock Exchange'; ...
    'ST', 'STO', 'Stockholm Stock Exchange'; ...
    'SW', 'SWX', 'Swiss Exchange'; ...
    'TWO', '', 'Taiwan OTC Exchange'; ...
    'TW', 'TPE', 'Taiwan Stock Exchange'; ...
    'N/A', '', 'FTSE Indices'; ...
    'L', 'LON', 'London Stock Exchange'};

%% Parse input.
% GET_DATA_GOOGLE accepts one required input argument, and four optional
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
% case of GET_DATA_GOOGLE, this means checking that the name-value pair
% arguments 'start', 'finish', and 'format' have been supplied as a set,
% in addition to checking that the value of 'start' predates the value of
% 'finish'.
if ~isempty(start) || ~isempty(finish) || ~isempty(format)
    if ~(~isempty(start) && ~isempty(finish) && ~isempty(format))
        error('get_data_google:missing_parameter', ...
            ['Missing parameter. The name-value pair arguments:\r\n' ...
            '''start'', ''finish'', ''format''\r\nform a set, and ' ...
            'must be used as such.']);
    end
end

if ~isempty(start)
    if ~strcmp(format, 'numeric')
        if datenum(start, format) > datenum(finish, format)
            error('get_data_google:invalid_value', ...
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
        error('get_data_google:no_connection', ...
            ['No connection. Failed to get JSON data for symbol:' ...
            '\r\n''%s''\r\nCheck the network connection.'], symbol{i});
    end

    if ~isempty(strfind(json_string, '"Result":[]'))
        error('get_data_google:invalid_value', ...
            ['Invalid value. The stock symbol:\r\n''%s''\r\n does ' ...
            'not exist.'], symbol{i});
    end
end

%% Process input.
% At this point, all stock symbols comply with the Yahoo! Finance naming
% convention. The next step is to modify the stock symbols so that they
% comply with the Google Finance naming convention. For foreign stocks,
% this involves replacing the Yahoo! Finance exchange suffix with the
% corresponding Google Finance exchange prefix. For US stocks, the
% situation is more complex. Because Yahoo! Finance does not assign US
% stocks an exchange suffix, it is not possible to determine the correct
% Google Finance exchange prefix without further information. The simplest
% way to obtain the necessary information is to send the stock symbol in a
% query to Google Finance, and parse the result.
finance_url = 'https://www.google.com/finance?q=';
good_symbol = {};

for i = 1:length(symbol)
    split = regexp(symbol{i}, '\.', 'split');
    
    if length(split) == 1
        % US stock symbol.
        try
            html_string = urlread([finance_url symbol{i}], 'Timeout', 10);
        catch
            error('get_data_google:no_connection', ...
                ['No connection. Failed to get HTML data for symbol:' ...
                '\r\n''%s''\r\nCheck the network connection.'], symbol{i});
        end
        
        expression = ['(\w*:' symbol{i} ')'];
        
        match = regexp(html_string, expression, 'once', 'match');
        
        if isempty(match)
            warning('get_data_google:invalid_value', ...
                ['Invalid value. The stock symbol:\r\n''%s''\r\n does ' ...
                'not exist.'], symbol{i});
        else
            good_symbol = [good_symbol, match];
        end
        
    else
        % Foreign stock symbol.
        row = strcmp(EXCHANGE_CODES(:, 1), split{2});
        prefix = EXCHANGE_CODES(row, 2);

        if ~isempty(prefix{1})
            this_symbol = [prefix{1} ':' char(split{1})];
            good_symbol = [good_symbol, this_symbol];
        else
            warning('get_data_google:invalid_value', ...
                ['Invalid value. The exchange:\r\n%s\r\nis not ' ...
                'supported by Google Finance.'], ...
                char(EXCHANGE_CODES(row, 3)));
        end
    end
end

%% Prepare REST requests.
% Google Finance does not make its historic stock data available for
% download in CSV format as Yahoo! Finance does. Instead, stock data
% must be scraped from a series of HTML tables. Each table can hold up to
% 200 price daily observations.
price_url = 'http://www.google.com/finance/historical?q=';

if ~isempty(start)
    if strcmp(format, 'numeric')
        start_field = start;
        finish_field = finish;
    else
        start_field = datenum(start, format);
        finish_field = datenum(finish, format);
    end
else    
    % One year after the start of the Unix epoch. Experimentation reveals
    % that using this as the 'start' date ensures that the complete set of
    % historic price data is returned.
    start_field = datenum('01-01-1971', 'dd-mm-yyyy');
    finish_field = now;
end

date_field = ['&startdate=' datestr(start_field, 'yyyy-mm-dd') ...
    '&enddate=' datestr(finish_field, 'yyyy-mm-dd') '&num=200'];

%% Make REST requests.
% Because the interval of the HTML table data is fixed, any necessary
% changes are made after the HTML tables for each symbol have been
% collated.
for i = 1:length(good_symbol)
    is_complete = false;
    data_array = [];
    table_row = 0;
        
    while ~is_complete
        try
            price_string = urlread([price_url good_symbol{i} date_field ...
                '&start=' num2str(table_row)]);
        catch
            error('get_data_google:no_connection', ...
                ['No connection. Failed to get price data for symbol:' ...
                '\r\n''%s''\r\nCheck the date range, and/or network ' ...
                'connection.'], good_symbol{i});
        end
        
        price_string = regexp(price_string, ...
            '(?<=>Volume\n<tr>\n).*(?=</table>)', 'match', 'once');
        
        price_data = reshape(regexp(price_string, ...
            '(?<=>)[-a-zA-Z0-9,. ]+(?=\n)', 'match'), 6, [])';
        
        if ~isempty(price_data)
            data_array = [data_array; price_data];
            table_row = table_row + 200;
        else
            is_complete = true;
        end
    end
    
    data_array = flipud(data_array);
    date_array = datenum(data_array(:, 1), 'mmm dd, yyyy');
    
    % A three-point local minima is used to identify Mondays (the day used
    % for weekly intervals), and the first of the month (the day used for
    % monthly intervals).
    if strcmp(interval, 'w')
        day_number = weekday(date_array);
        index = [];
        
        if day_number(1) == 2
            index = 1;
        end
        
        for j = 2:length(date_array) - 1
            if day_number(j) < day_number(j - 1) && ...
                    day_number(j) < day_number(j + 1)
                index = [index; j];
            end
        end
        
        if day_number(end) == 2
            index = [index; length(date_array)];
        end
        
        data_array = data_array(index, :);
        
    elseif strcmp(interval, 'm')
        [~, ~, day_number, ~, ~, ~] = datevec(date_array);
        index = [];
        
        if day_number(1) == 2
            index = 1;
        end
        
        for j = 2:length(date_array) - 1
            if day_number(j) < day_number(j - 1) && ...
                    day_number(j) < day_number(j + 1)
                index = [index; j];
            end
        end
        
        if day_number(end) == 2
            index = [index; length(date_array)];
        end
       
        data_array = data_array(index, :);
    end
    
    data_table = table(datenum(data_array(:, 1), 'mmm dd, yyyy'), ...
        str2double(data_array(:, 2)), str2double(data_array(:, 3)), ...
        str2double(data_array(:, 4)), str2double(data_array(:, 5)), ...
        str2double(data_array(:, 6)), NaN(length(data_array(:, 1)), 1), ...
        NaN(length(data_array(:, 1)), 1), 'VariableNames', ...
        {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', ...
        'Dividend', 'Split'});
        
    data.(matlab.lang.makeValidName(good_symbol{i})) = data_table;
end

if isempty(good_symbol)
    data = [];
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