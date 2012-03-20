Code IBC Province
=================

**What**: Code that assigns the appropriate province for the Iraq Body Count events data set

**Date**: March 2012

**By**: Andreas Beger ([adbeger@gmail.com](mailto:adbeger@gmail.com))

Creative Commons BY-NC-SA 3.0 License. Attribution, Non-Commercial, Share Alike.

Data
----

Event data from [Iraq Body Count project](http://www.iraqbodycount.org/database/). Each event documents an incident of civilian deaths.

Description
-----------

The location variable in the IBC data has various types of location information. This script looks for known cities and provinces to assign each event to the province in which it occurred. It does this identifying a candidate word from the location string, removing things like "al-", "'s", and so on, and checking it against known places. The spreadsheet "citylist" contains the known places against which candidate value is checked.
    

