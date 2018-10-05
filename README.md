This project containes modules that can test different aspects of code we're running, to enforce AP standards around processing data. The modules are located in the R folder in this project, then each category of module we are running has a folder. Inside there, each module is in an R file.

We have sample data files we are testing with in the "testdata" folder. Within that, each module has a folder, with sample data sets.

As of writing this note, our scope is limited to tabular data, and assuming data is read in from Excel or a CSV (so not handling xml, HTML, PDF parsing or the like, at this point.)

Each module accepts a data frame (or for intial import, a filepath) and spits out warnings when a given data set does not comply with expectations.

Each module has a test function with some sample data sets, to ensure that it works (and self document how it works) for different data types.

Modules should be able to be pipeable, so that you can call several of them in a row, passing via %>%.

Modules are able to be wrapped in a script calling all available ones, so all checks can be run with one command. (We plan to implement at some point, but haven't yet.)

In the docs folder, there are some not-totally-implemented notes on architecture questions around the project as a whole, as well as thoughts on standardizing errors/warnings when a data set doesn't quite pass muster, and fails the check.

HOW YOU CAN HELP:
We are soliciting feedback on method structure, signature and what we are testing. Let us know if you try it, have new sample data sets for us to test out, run into problems.

The checklist of data validation checks we are working from is here. Please add features you would like to see. https://docs.google.com/document/d/1qQ1uB8TSoeJym06dXGg1-rMU7RD6xTdFIiKMvBG9C_w/edit

We will start with modules that have to do with loading data, and testing ETL, but have modules for testing various analyses, basic and not, within the pipeline.
