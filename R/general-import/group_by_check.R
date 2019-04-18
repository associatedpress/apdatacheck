# Group by names - do any show up more than once? Is that expected?

# group_by(x) combined with summarize() or mutate() does an operation on each group
# This can go mismatch expectations in two ways:

# - Some items were grouped that we didn't want to be grouped.
# - Some items weren't grouped that we wanted to be grouped.

# The way this happens is when x is misread by the person running the analysis
# For example, if the data has "1000" and "1O00", then it won't be grouped up


# For the case where things were grouped that we didn't want to be grouped:
# There's not really a way to check against this directly in R,
# since all of the filters will have the same flaw. The best we can do, maybe,
# is to produce a report on how big each group will be, for each key. This way
# it should be clear if one group is way too big (in the most common example,
# a code error makes "TRUE" and "FALSE" the only two groups; this should be
# very clear that the two groups are way too big for the 'intended' operation.
# Maybe we also render a histogram? (stretch goal)

# For the case where things aren't grouped that we wanted to be grouped,
# maybe this can be represented by checking for all the times where groups are
# really small (either in an absolute sense or as a % of the largest group?)


#
# Are there fuzzy matching/string distance ideas to flag groups that look similar to each other
#
# Both absolute and relative group size can be useful -- especially on the small end
# Groups with only 1 member are especially suspicious
#
# Can we identify if case-sensitiveness/insensitiveness is in the data, even when it shouldn't be


# Is this invoked on group_by or is this just a general check of the data file column integriy

# For checking the columns:
# - whitespace
# - case sensitiveness
# - accents
#
