# LINEMAKE

The `linemake` code produces MOOG-compatible synthesis line list by starting 
with the Kurucz compendium and then substituting, adding, splitting, etc.
These lists to employ the excellent atomic data from the Wisconsin group
(Jim Lawler and associates) and excellent molecular data from the Old
Dominion group (Peter Bernath and associates).  The Fortran code and linelists 
were created by Chris Sneden.

The only manual steps in getting the code to work are editing lines 19-20 to 
put the code path into the code, and compiling with `f77`, `g77`, or `gfortran`.
Example: `gfortran -o lmake linemake.f`. Please read file `notes.txt` for more details and references.

The `mooglists` folder contains the master lists, and the `linelists` folder contains
ready-to-use lists for specific transitions, which can be directly linked if
you clone this repository.

Please let us know if you find any problems/inconsistencies
