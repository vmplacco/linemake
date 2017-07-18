# LINEMAKE

The `linemake` code produces MOOG-compatible synthesis line list by starting 
with the Kurucz compendium and then substituting, adding, splitting, etc.
These lists to employ the excellent atomic data from the Wisconsin group
(Jim Lawler and associates) and excellent molecular data from the Old
Dominion group (Peter Bernath and associates).  The Fortran code and linelists 
were created by Chris Sneden.

The only manual steps in getting the code to work are editing lines 19-20 to 
put the code path into the code, and compiling with `f77`, `g77`, or `gfortran`.
Example: `gfortran -o lmake linemake.f`. Please read the "notes" section below for more details and references.

The `mooglists` folder contains the master lists, and the `linelists` folder contains
ready-to-use lists for specific transitions, which can be directly linked if
you clone this repository.

**The use of these data is free but we urge users to give credit to the laboratory groups 
that have generated these atomic/molecular data sets. See references below.**

## NOTES

Chris Sneden & Vini Placco, July 18 2017

### SOURCES OF GF'S, HFS/ISO, AND OTHER COMMENTS 

UPDATED JULY 2017; THESE LINE LISTS ARE CONSERVATIVE IN THE SENSE THAT THEY
     DO NOT INCLUDE DATA FOR SOME SPECIES THAT MIGHT BE PRETTY GOOD BUT ARE
     IN NEED OF NEW LAB WORK, SUCH AS NI II AND CO II.

NOTE THAT THE LINEMAKE COMMANDS ARE SET TO WORK ON THE DATA FILES INCLUDED HERE.
     IF YOU DESIRE TO ADD IN YOUR OWN CHOSEN LINE LISTS TO THIS MIX, THEN:
     (a) YOU ARE ON YOUR OWN (!); and (b) PLEASE CONTACT ONE OF US ON HOW TO
     CORRECTLY MERGE YOUR DATA SET WITH OURS.

### OPENING COMMENTS:

The linemake code produces MOOG-compatible synthesis line list by starting 
with the Kurucz compendium (http://kurucz.harvard.edu/linelists.html)
and then substituting, adding, splitting, etc., these lists to employ 
the excellent atomic data from the Wisconsin group (Jim Lawler 
and associates) and excellent molecular data from the Old Dominion 
group (Peter Bernath and associates).  The only manual steps
in getting the code to work are editing lines 19-20 to put the code path
into the code, and compiling with f77, g77, or gfortran.

The maximum ionization state is the first ion, and the maximum lower
excitation enrgy is 7.5eV except for some light neutral species (neuatrals
and ions of these atoms: H, C, N, O, Mg, Al, Si, P, S) for which higher 
excitation species are considered, and for Fe II, where 8.5eV is the maximum 
lower energy.

Obvious warnings should be given about the output line lists:  we think that
they are correct but there is no substitute for you having a close look to
assure yourself of their quality.  One thing you can do if you are unsure
about a line list is to look at the individual files for different species
that are sitting in the mooglists subdirectory.

Be really careful about saying yes to the last question when running linemake.
This question asks whether or not to add in Kurucz hfs data for transitions of
Fe-group elements not done, or yet to be done, by the Wisconsin group.
You'll probably get a lot of stuff added into the output line lists, and
the pedigrees of these things are not guaranteed.

One oddity that we don't think is worth fixing at the moment:  the code does 
not work properly when the requested beginning and ending wavelengths bridge the 
divide between two files of atomic line data, each of which covers 1000A. So 
if you have a desired line list from say 5990A to 6010A, the code screws up.  
The work-around simply is to run the code twice, in the example case from 
5990A to 5999.999A, and from 6000A to 6010A.


### ATOMIC SPECIES: NEUTRON-CAPTURE ELEMENTS (LISTED IN ORDER OF ATOMIC NUMBER)

* La II:  Lawler et al. (2001, ApJ, 556, 452)

* Ce II:  Lawler et al. (2009, ApJS, 182, 51)

* Pr II:  Sneden et al. (2009, ApJS, 182, 80)

* Nd II:  Den Hartog et al. (2003, ApJS, 148, 543)

* Sm II:  Lawler et al. (2006, ApJS, 162, 227)

* Eu II:  Lawler et al. (2001, ApJ, 563, 1075)

* Gd II:  Den Hartog et al. (2006, ApJS, 167, 292)

* Tb II:  Lawler et al. (2001, ApJS, 137, 341)

* Dy II:  Sneden et al. (2009, ApJS, 182, 80) 

* Ho II:  Lawler et al. (2004, ApJ, 604, 850)

* Er II:  Lawler et al. (2008, ApJS, 178, 71)

* Tm II:  Sneden et al. (2009, ApJS, 182, 80) 

* Yb II:  Sneden et al. (2009, ApJS, 182, 80) 

* Lu II:  Sneden et al. (2009, ApJS, 182, 80) 

* Hf II:  Lawler et al. (2007, ApJS, 169, 120)

* Pt I:   Den Hartog et al. (2005, ApJ, 619, 639)


### ATOMIC SPECIES: FE-GROUP ELEMENTS (LISTED IN ORDER OF ATOMIC NUMBER)

* Sc I:   to be done, so any hfs information is not to be trusted much,
although it is collected in scI.kurhfs and scII.kurhfs; the gf's when
possible are from Lawler & Dakin 1991

* ScII:  to be done, so any hfs information is not to be trusted much,
although it is collected in scI.kurhfs and scII.kurhfs; the gf's when
possible are from Lawler & Dakin 1991

* Ti I:   Lawler et al. (2013, ApJS, 205, 11)

* Ti II:  Wood et al. (2013, ApJS, 208, 27) 

* V I:    Lawler et al. (2014, ApjS, 215, 20); there is additionaal hfs
information in the Kurucz database, collected in vI.kurhfs. A paper by 
Holmes, C. E. et al. 2016, ApJS, 224, 35 suggests some problems
with these transition probabilits in the wavelength range >9000 A.
A new paper by Wood et al. has been submitted to ApJS that demonstrates 
that the Lawler et al. data are healthy.

* V II:   Wood et al. (2014, ApJS, 214, 18); there is additionaal hfs
information in the Kurucz database, collected in vI.kurhfs

* Cr I:   Sobeck et al. (2007, ApJ, 667, 1267); the line wavelengths have
been adjusted to conform to those given at the NIST website

* Cr II:  Lawler et al. (2017, ApJS, 228, 10).

* Mn I:   Den Hartog et al. (2011, ApJS, 194, 35); there is additionaal hfs
information in the Kurucz database, collected in scI.kurhfs

* Mn II:  Den Hartog et al. (2011, ApJS, 194, 35); there is no additionl
hfs information in the Kurucz database

* Fe I:   recent lab studies are by Ruffoni et al. (2014, MNRAS, 441, 3127)
and Den Hartog (2014, ApJS, 215, 23).  These papers deal with lines
arising (in absorption) from levels with E.P. >~ 2.3 eV.  These have
been combined with older-but-still-reliable gf values from
O'Brian et al. (1991, JOSAB, 8, 1185) for lower-excitation transitions.  
The Wisconsin group is completing another Fe I paper and results will 
be public in a few months.

* Fe II:  There is no comprehensive single-source list of gf-values;
therefore the NIST database values are adopted here.  At the end of each
line the NIST quality rating, e.g., NISTC+ appears. 

* Co I:   Lawler et al. (2015, ApJS, 220, 13); Co I with and without hfs
are in different files here.

* Co II:  discussed in the Co I paper, but awaits completion as of March 2017;
the gf's are in hand but better hfs is being worked on now; expect 
journal submission summer 2017.

* Ni I:   Wood et al. (2014, ApJS, 211, 20); there is isotopic information 
in the file niI.moogiso, but this is not part of the autometed linemake 
procedure; one can manually substitute in the relevant structures into 
a line list.

* Ni II:  discussed in the Ni I paper, but awaits a fresh study; not included
here; this will be the subject of a future Wisconsin lab effort; note that
Co II lines in the Kurucz database have no hfs information.

* Cu I:  not done recently, so any hfs information is not to be trusted much,
although for Cu I it is collected in cuI.kurhfs


### ATOMIC SPECIES: OTHER ELEMENTS

Li I resonance line:  nothing special needs to be done here to get the
full isotopic and hyperfine substructure.  The total gf from Kurucz, 
has been adopted; it is close to that recommended by NIST.


### MOLECULAR SPECIES:

* HF: Sauval (gotta track this down)

* MgH:  Hinkle et al. (2013, ApJS, 207, 26)

* C2 Swan:  Ram et al. (2014, ApJS, 211, 5); note that 0.089eV has been added
to all of the excitation energies to account for the fact that the lower
vibrational level of the Swan system is not exactly at the lowest possible
vibrational state.

* CN violet and red:  Sneden et al. (2014, ApJS, 214, 26)

* CO:   Pretty much the relatively simply CO parameters in the IR ro-vibrational
bands have been known for a couple of decades.  However, in trial syntheses
conducted by Chris Sneden and Melike Afsar it was noticed that that K-band 
elta-v = 2 "first overtone" band strengths were too strong for the C and O 
abundances derived from optical data.  But they also clashed with the H-band
delta-v = 3 "second overtone" bands in similar fashion.  Therefore we decided
to raise the gf-values of the delta-v = 2 lines by 0.15 dex, and leave the
delta-v = 3 lines alone.  This small alteration is in the CO line list here.

* OH ro-vibrational bands:  Brooke et al. (2015, JQSRT, 168, 142)
