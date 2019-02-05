<<<<<<< HEAD
# AP Data Check

## Overview

This library implements some common data checking practices in R. Currently, the following tasks are our focus:

* Import

* Basic checks on due diligence

* Basic analytical steps

* Data loss or duplication from joins

* Geographical data

The checklist for data is available [here](https://docs.google.com/document/d/1qQ1uB8TSoeJym06dXGg1-rMU7RD6xTdFIiKMvBG9C_w/edit)

## Getting Started

Currently, the library only provides some functions defined in individual scripts for the task.

Import functions take in a filename and a data frame.

At present, all functions report results in the console.

## Project Notes

This project containes modules that can test different aspects of code we're running, to enforce AP standards around processing data. The modules are located in the R folder in this project, then each category of module we are running has a folder. Inside there, each module is in an R file.

As of writing this note, our scope is limited to tabular data, and assuming data is read in from Excel or a CSV (so not handling xml, HTML, PDF parsing or the like, at this point.)

We have sample data files we are testing with in the "testdata" folder. Within that, each module has a folder, with sample data sets.

Each module accepts a data frame (or for intial import, a filepath) and spits out warnings when a given data set does not comply with expectations.

Modules are able to be wrapped in a script calling all available ones, so all checks can be run with one command. (We plan to implement at some point, but haven't yet.)

## Feedback

We are soliciting feedback on method structure, signature and what we are testing. Let us know if you try it, have new sample data sets for us to test out, run into problems.

## Contributing

A basic guide on style and implementation details can be found in `./docs/contributing.md`
