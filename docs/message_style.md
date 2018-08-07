- Come up with a standardized error message/warning message/diagnostic message/success message format


- Filename
- Function name
- Terse description of the thing the function is testing
- Relevant numbers (line number, row numbers, etc.)



stop (creates Errors, immediately halts the program)
message (prints it but in a special way)
warnings (adds all warning messages to a warning message list, prints that list at the end of execution, list is also accessible with warnings())


- by default, warnings are indented one level
- %function_name%: %filename%
- indent two levels:
-- terse description
-- numbers
