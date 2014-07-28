About
=====
Finance tools is a loose collection of finance-related MATLAB scripts and
functions. Its primary objectives are:

1.  To provide investors with a set of command-line tools that may be used
    to optimise portfolio return.
2.  To explore the axioms of good investment, and either prove or disprove
    their existence.

Further objectives may be added as time and/or enthusiasm permit.

The first set of m-files to be made available are part of a continuing
effort to understand the theory and practice of mean-variance portfolio
optimisation. This mathematical technique is better known in the world of
finance as modern portfolio theory (MPT).

No matter what the field of study, in order to be able to use the output
of an analysis with confidence, two conditions must first be met:

1.  The input data must be of known quality.
2.  The analysis must be performed carefully, with strict attention being
    paid to its limitations, and the effect of any assumptions that were
    made.

Clearly, the quality of any analysis and its subsequent outputs depends
heavily on the quality of its inputs. This raises the following question:

>   How do I assess the quality of my input data?

When it comes to financial information, there are several data feeds that
may be accessed for free by the general public. There are also a number of
subscription-only data feeds that remain the preserve of institutional
investors on account of the cost.

Whilst the premium data feeds usually provide a qualitative measure of the
accuracy of their information, no such metric is available for the free
data feeds. This is a deficiency that Finance Tools aims to rectify. How?

By comparing data from multiple free feeds, thereby establishing a set of
confidence intervals that may be used to assess the quality of financial
information obtained by combining the data feeds.

Installation
============
To begin using Finance Tools, either:

1.  Clone the repository to your local machine using git, or
2.  Download the repository as a zip file and unpack it.

With this accomplished, verify that everything is present and correct by
running the Finance Tools test suite, which is located in the project root
directory.

If the test suite fail to complete successfully, do not despair. It may be
that one of the data feeds has updated their financial information, and it
no longer matches the reference set of data that the test suite uses as a
comparison. Should this situation occur, refer to the test unit containing
the failed test for information on how to go about generating a new set of
reference data.

Compatibility
=============
Finance Tools has been written using the following software:

* MATLAB R2014a
* git 1.9.4

License
=======
Finance Tools is released under the [GNU General Public License][gpl],
with the following exceptions:

* *get_data_yahoo.m*, which is released under the [BSD 2-Clause License][bsd].

Authors
=======
Code by Rodney Elliott, <rodney.elliott@gmail.com>.

Acknowledgements
================
Finance Tools has been inspired by the following:

* [dailyDataSuite][dds] by Michael Weidman.
* [Quandl's MATLAB Package][quandl], author unknown.

[gpl]: http://www.gnu.org/licenses/gpl.html
[bsd]: http://opensource.org/licenses/BSD-2-Clause
[dds]: http://www.mathworks.com/matlabcentral/fileexchange/43627-download-daily-data-from-google-and-yahoo--finance
[quandl]: https://github.com/quandl/Matlab 