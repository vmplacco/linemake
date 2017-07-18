# LINEMAKE

The `linemake` code produces MOOG-compatible synthesis line list by starting 
with the Kurucz compendium and then substituting, adding, splitting, etc.
These lists to employ the excellent atomic data from the Wisconsin group
(Jim Lawler and associates) and excellent molecular data from the Old
Dominion group (Peter Bernath and associates).  The only manual steps in 
getting the code to work are editing lines 19-20 to put the code path into 
the code, and compiling with f77, g77, or gfortran.

Installation: `gfortran -o lmake linemake.f`

Please read file `notes.txt` for more details and references.

Fortran code and linelists created by Chris Sneden.
