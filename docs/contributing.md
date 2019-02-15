# Contribution guide

## Architecture

Data check is being implemented as a series of single functions that accomplish a single item on the checklist.

Each function is contained in a file which is the same name. That file also contains the test function to test the implementation.

Where relevant, functions are written with the data frame being tested as the first argument. The return value of a check function should also be the original data frame. This makes them conform to the 'pipe' (`%>%`) operator from `magrittr`. Messages are sent to the user via `message(...)` or `warnings(...)`, detailed below.

### Folder structure

`./docs/` - contains additional documentation such as this architecture note
`./R/<heading>`/ - scripts are organized based on the headings from the checklist
`./testdata/<function_name>/` - data used to test implementations is put here

## Script implementation

Ideally, excluding comments, each script file only has three parts. For example, looking at `./R/general-import/content_spot_check.R`:

* Loading necessary libraries

* The functions: `content_spot_check(...)`; in this file there are no helper functions but they might be here too.

* A testing function: `test_content_spot_check(...)`

### Function arguments

Where possible, try to imitate the function arguments and style of the original functions being tested. For example, an import check function should require a `file` argument, in addition to some optional arguments: `header`, `sep`, `col.names`, `skip`; these are all defined in `read_csv` or `read.csv`

## Output formatting

We currently use the console to report errors. R has a few built-in functions for this purpose:

* `warnings(message)`: This does not stop execution; it prints the message, and adds the message to a list of warnings (which can be accessed with `warnings()`).

* `message(message)`: This does not stop execution, and prints the message.

Our style for messages looks like this in the console:

```
<function_name>: <filename>
    Warning message text here with relevant info
    If necessary, use additional lines, but try not to
    If relevant, mention row numbers of offending data
```
