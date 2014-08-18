function data = get_data_quandl(symbol, varargin)
% GET_DATA_QUANDL Get historic stock data from Quandl.
%   DATA = GET_DATA_QUANDL(SYMBOL) gets historic stock data from Quandl for
%   one or more stock symbols. SYMBOL must be a character string, or a cell
%   array of character strings.
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
%   GET_DATA_QUANDL uses not-a-number (NaN) to indicate missing data.
%
%   When called without options, GET_DATA_QUANDL gets the complete set of
%   daily stock observations for each symbol. Stock prices are returned in
%   the currency used by the exchange on which the stock is listed.
%
%   DATA = GET_DATA_QUANDL(SYMBOL, NAME, VALUE) gets historic stock data
%   from Yahoo! Finance for one or more stock symbols, with additional
%   options specified by one or more name-value pair arguments:
%
%   'feed'          The Quandl data feed from which to get historic stock
%                   data. The value of 'feed' must be one of the following:
%
%                   'GOOG'      Google Finance
%                   'WIKI'      Quandl Open Data
%                   'YAHOO'     Yahoo! Finance
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
%                   'd'         Day
%                   'w'         Week
%                   'm'         Month
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
%       data = GET_DATA_QUANDL('IBM');
%
%   Example:
%       data = GET_DATA_QUANDL('FNZ.NZ', 'feed', 'GOOG', ...
%           'interval', 'w', 'token', 'dsahFHUiewjjd');
%
%   Example:
%       symbol = {'COKE', 'PEP'};
%       data = GET_DATA_QUANDL(symbol, 'feed', 'YAHOO', ...
%           'start', '27-01-2012', 'finish', '17-07-2014', ...
%           'format', 'dd-mm-yyyy', 'token', 'dsahFHUiewjjd');
%
%   Note that the value of 'token' in the example above is fake, and will
%   not work.
%
%   See also TEST_GET_DATA_QUANDL.

%% File and license information.
%**************************************************************************
%
%   File:           get_data_quandl.m
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

COLUMN_NAMES = {{'Date'}; ...
    {'Open'}; ...
    {'High'}; ...
    {'Low'}; ...
    {'Close'}; ...
    {'Volume'}; ...
    {'Dividend', 'Ex-Dividend'}; ...
    {'Split', 'Split Ratio'}};

%% Parse input.
% GET_DATA_QUANDL accepts one required input argument, and six optional
% name-value pair arguments. The easiest way to check these arguments is
% by using the 'inputParser' class and its associated methods.
p = inputParser;
addRequired(p, 'symbol', @check_symbol);
addParameter(p, 'feed', [], @check_feed);
addParameter(p, 'start', [], @check_date);
addParameter(p, 'finish', [], @check_date);
addParameter(p, 'format', [], @check_format);
addParameter(p, 'interval', [], @check_interval);
addParameter(p, 'token', [], @check_token);
parse(p, symbol, varargin{:});

feed = p.Results.feed;
start = p.Results.start;
finish = p.Results.finish;
format = p.Results.format;
interval = p.Results.interval;
token = p.Results.token;

if ischar(symbol)
    symbol = {symbol};
end

%%
% Whilst 'inputParser' is great for checking the class and attributes of
% input arguments, additional checks are still required. This is because
% the validation functions used by the 'addRequired' and 'addParameter'
% methods only accept a single input argument. As a result, checks that
% involve multiple input arguments must be performed separately. In the
% case of GET_DATA_QUANDL, this means checking that the name-value pair
% arguments 'start', 'finish', and 'format' have been supplied as a set,
% in addition to checking that the value of 'start' predates the value of
% 'finish'.
if ~isempty(start) || ~isempty(finish) || ~isempty(format)
    if ~(~isempty(start) && ~isempty(finish) && ~isempty(format))
        error('get_data_quandl:missing_parameter', ...
            ['Missing parameter. The name-value pair arguments:\r\n' ...
            '''start'', ''finish'', ''format''\r\nform a set, and ' ...
            'must be used as such.']);
    end
end

if ~isempty(start)
    if ~strcmp(format, 'numeric')
        if datenum(start, format) > datenum(finish, format)
            error('get_data_quandl:invalid_value', ...
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
        error('get_data_quandl:no_connection', ...
            ['No connection. Failed to get JSON data for symbol:' ...
            '\r\n''%s''\r\nCheck the network connection.'], symbol{i});
    end

    if ~isempty(strfind(json_string, '"Result":[]'))
        error('get_data_quandl:invalid_value', ...
            ['Invalid value. The stock symbol:\r\n''%s''\r\n does ' ...
            'not exist.'], symbol{i});
    end
end

%% Process input.
% At this point, all stock symbols comply with the Yahoo! Finance naming
% convention. If the user has selected Yahoo! Finance as the data feed,
% then no further checks of the stock symbols are required. If the user has
% selected a different data feed however, then the stock symbols will need 
% to undergo further checks.
good_symbol = {};

if strcmp(feed, 'YAHOO')
    good_symbol = symbol;
end

%%
% In the case of the Quandl open data feed, this involves checking that
% none of the symbols has an exchange suffix. This is because the Quandl
% open data feed supports the AMEX, NASDAQ, and NYSE exchanges only, and
% Yahoo! Finance does not assign North American stocks an exchange suffix.
if isempty(feed) || strcmp(feed, 'WIKI')
    for i = 1:length(symbol)
        if ~isempty(strfind(symbol{i}, '.'))
            warning('get_data_quandl:invalid_value', ...
                ['Invalid value. The stock symbol:\r\n''%s''\r\n' ...
                'contains an unsupported exchange code.'], symbol{i});
        else
            good_symbol = [good_symbol, symbol{i}];
        end
    end
end

%%
% In the case of the Google Finance data feed, it is necessary to convert
% symbols from the Yahoo! Finance naming convention to the Google Finance
% naming convention. For foreign stocks, all that is required is to swap
% the Yahoo! Finance exchange suffix for the appropriate Google Finance
% exchange prefix - providing that Google Finance supports the exchange in
% question that is. The situation with North American stocks is more
% complex however. Because Yahoo! Finance does not assign North American
% stocks an exchange suffix, it is not possible to determine which Google
% Finance exchange prefix to apply without further information. The
% simplest way to obtain the required information is to send the stock
% symbol in a query to Google Finance, then parse the result.
finance_url = 'https://www.google.com/finance?q=';

if strcmp(feed, 'GOOG')
    for i = 1:length(symbol)
        split = regexp(symbol{i}, '\.', 'split');

        if length(split) == 1
            % North American stock symbol.
            try
                html_string = urlread([finance_url symbol{i}], ...
                    'Timeout', 10);
            catch
                error('get_data_quandl:no_connection', ...
                    ['No connection. Failed to get HTML data for ' ...
                    'symbol:\r\n''%s''\r\nCheck the network ' ...
                    'connection.'], symbol{i});
            end

            expression = ['(\w*:' symbol{i} ')'];

            match = regexp(html_string, expression, 'once', 'match');

            if isempty(match)
                warning('get_data_quandl:invalid_value', ...
                    ['Invalid value. The stock symbol:' ...
                    '\r\n''%s''\r\n does not exist.'], symbol{i});
            else
                match = regexprep(match, ':', '_');
                good_symbol = [good_symbol, match];
            end

        else
            % Foreign stock symbol.
            row = strcmp(EXCHANGE_CODES(:, 1), split{2});
            prefix = EXCHANGE_CODES(row, 2);

            if ~isempty(prefix{1})
                this_symbol = [prefix{1} '_' char(split{1})];
                good_symbol = [good_symbol, this_symbol];
            else
                warning('get_data_quandl:invalid_value', ...
                    ['Invalid value. The exchange:\r\n%s\r\nis not ' ...
                    'supported by Google Finance.'], ...
                    char(EXCHANGE_CODES(row, 3)));
            end
        end
    end
end

%% Prepare REST requests.
% A single REST request is made to Quandl for each stock symbol, with data
% being returned in CSV format. Each request consists of a base URL, and a
% number of optional query parameters.
price_url = 'http://www.quandl.com/api/v1/datasets/';

if ~isempty(feed)
    feed_field = [feed '/'];
else
    feed_field = 'WIKI/';
end

if ~isempty(token)
    token_field = ['&auth_token=' token];
else
    token_field = '';
end

if ~isempty(start)
    if strcmp(format, 'numeric')
        start_field = start;
        finish_field = finish;
    else
        start_field = datenum(start, format);
        finish_field = datenum(finish, format);
    end
    
    date_field = ['&trim_start=' datestr(start_field, 'yyyy-mm-dd') ...
    '&trim_end=' datestr(finish_field, 'yyyy-mm-dd')];
else
    date_field = '';
end

if ~isempty(interval)
    if strcmp(interval, 'w')
        interval_field = '&collapse=weekly';
    elseif strcmp(interval, 'm')
        interval_field = '&collapse=monthly';
    else
        interval_field = '&collapse=daily';
    end
else
    interval_field = '&collapse=daily';
end

%% Make REST requests.
% At this point, all stock symbols comply with the naming convention of the
% chosen data feed. There are however two further issues that must be dealt
% with before historic stock data can be retrieved. The first issue is that
% Quandl does not obtain its Yahoo! Finance or Google Finance data directly
% from the source. As a result, Quandl's Yahoo! Finance and Google Finance
% datasets are incomplete. What this means is that before historic stock
% data can be retrieved from Quandl, it is necessary to confirm that the
% chosen data feed actually contains data for each stock symbol. This is
% done by submitting a request to Quandl for the dataset metadata. The
% second issue is that the number of columns of data available from Quandl
% for a particular stock symbol varies by data feed, along with the column
% names. This is handled by comparing the name of each column of data with
% a list of alternative, acceptable names.
for i = 1:length(good_symbol)
    symbol_field = [good_symbol{i} '.xml?exclude_data=true'];
    
    try
        document = xmlread([price_url feed_field symbol_field ...
            token_field], 'Timeout', 10);
    catch
        error('get_data_quandl:no_connection', ...
            ['No connection. Failed to get DOM node for symbol:\r\n' ...
            '''%s''\r\nCheck the network connection.'], good_symbol{i});
    end
    
    datasets = convert_quandl(document);
    column_count = length(datasets.column_names);
    
    symbol_field = [good_symbol{i} '.csv?'];
    
    try
        price_string = urlread([price_url feed_field symbol_field ...
            token_field date_field interval_field], 'Timeout', 10);
    catch
        error('get_data_quandl:no_connection', ...
            ['No connection. Failed to get price data for symbol:' ...
            '\r\n''%s''\r\nCheck the date range, and/or network ' ...
            'connection.'], good_symbol{i});
    end
    
    format_specification = '%s';
    
    for j = 1:column_count - 1
        format_specification = [format_specification '%f'];
    end
    
    price_data = textscan(price_string, format_specification, ...
        'HeaderLines', 1, 'Delimiter', ',');
    
    % The following code assumes that all Quandl data feeds store their
    % date information in the first column of data.
    data_array = datenum(price_data{1}, 'yyyy-mm-dd');
    is_column = false;
     
    for j = 2:8
        for k = 2:column_count
            if any(strcmp(COLUMN_NAMES{j}, ...
                    datasets.column_names(k).column_name))
                data_array = [data_array price_data{k}];
                is_column = true;
            end
        end
        
        if is_column
            is_column = false;
        else
            data_array = [data_array NaN(length(data_array), 1)];
        end
    end
    
    % Quandl open data feed fills the split column with ones on days that
    % no split action takes place. This differs from the zero fill used by
    % GET_DATA_YAHOO, and so it is changed here for consistency.
    unity_rows = data_array(:, 8) == 1;
    data_array(unity_rows, 8) = 0;
    
    data_array = flipud(data_array);
    
    data_table = array2table(data_array, 'VariableNames', ...
        {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', ...
        'Dividend', 'Split'});
    
    data.(matlab.lang.makeValidName(good_symbol{i})) = data_table;
end
end

%% Local functions.
function check_symbol(symbol)
validateattributes(symbol, {'char', 'cell'}, {'row', 'row'});
end

function check_feed(feed)
validatestring(feed, {'GOOG', 'WIKI', 'YAHOO'});
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

function check_token(token)
validateattributes(token, {'char'}, {'row'});
end