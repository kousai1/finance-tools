Introduction
============
Finance Tools is a loose collection of finance-related MATLAB scripts and
functions. These m-files fall into groups, often with a single, high-level
function as the focus of the group.

The first group consists of the m-files used to get historic stock data,
and is exemplified by the function GET_DATA.

GET_DATA
========
GET_DATA may be used to get historic stock data from one or more of the
following data sources:

1.  Google Finance
2.  Yahoo! Finance
3.  Quandl

Whilst the first two need no introduction, not everyone is familiar with
Quandl. Quandl is a data platform that provides access to a wide range of
financial, economic, and other data for through an easy-to-use API. Three
of Quandl's data feeds are available from within GET_DATA:

3a. Google Finance
3b. Yahoo! Finance
3c. Quandl Open Data

Note that Quandl does not source its Google or Yahoo! data feeds directly
from Google Finance or Yahoo! Finance. As a result, there may be occasions
when the Quandl data feeds differ from the original sources.

GET_DATA uses specialist functions to get data from the three supported
data sources. These functions are GET_DATA_GOOGLE, GET_DATA_YAHOO, and
GET_DATA_QUANDL.

Naming Convention
-----------------
Because each data source has its own stock symbol naming convention, the
decision was made early on to use the Yahoo! Finance naming convention as
the default. This is due to the fact that of the three data sources, Yahoo!
Finance has the biggest collection of historic stock data - both in terms
of depth, and breadth.

This naming convention is strictly enforced by GET_DATA_GOOGLE etc. Should
any of these functions be passed a symbol whose name does not comply with
the naming convention, a fatal error will occur. This also applies to any
symbol that meets the naming convention, but which does not correspond to
an actual traded stock.

Note that because Yahoo! Finance has a larger collection of historic stock
data than Google Finance or the Quandl data feeds, it is highly likely that
at some point, historic stock data for particular symbols will unavailable
from these two sources. When this occurs, GET_DATA will display a warning
message, and the offending stock symbol will be ignored by GET_DATA_GOOGLE
and GET_DATA_QUANDL.

Note also that the Yahoo! Finance stock lookup service is often unreliable,
so users may wish to comment-out the code segments of GET_DATA_GOOGLE etc
that follow the comment "The last check that needs to be performed...".

Date Range
----------
GET_DATA allows users to limit the range of dates for which historic stock
data will be returned. If no date range is specified, GET_DATA will get the
complete set of historic stock data from each of the selected data sources.

Note that the historic stock data of the three data sources does not cover
the same date range.

Quandl Token
------------
If the user intends to employ the Quandl data source, it is first necessary
to register with Quandl. The reason for this is that anonymous Quandl users
are restricted to making 50 API calls per day - a number that a single call
to GET_DATA may exceed. Registration gives the user an authentication token
that permits unlimited access to the Quandl API. The token should be passed
to GET_DATA. Note that registration is free.

Code Modification
-----------------
Before making any changes to the codebase, the user is strongly advised to
generate a set of reference data using MAKE_SUITE, which is located in the
'Test Units' directory. After changes have been made, the user should call
the function TEST_SUITE, which will run a series of test units to ensure
that the changes that were made did not break the codebase.

Note that TEST_SUITE can take several minutes to run, and test units may
fail if a sources historic stock data has been updated since the reference
dataset was generated.