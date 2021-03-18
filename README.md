**`linemake`**

-----------------------------------------------------------------------------

- update Fe II files, add HCl, HF and SiO to hydride files, Septemper 2019
- corrected the Sc II files, November 12 2018
- corrected the Kurucz Co I hfs file, July 29, 2018
- added new Co II lab data, and published lab data for mostly neutron-capture 
    species lines (mostly in the UV) employed in recent papers by 
    Ian Roederer, March 17 2018
- update for Fe I, October 28 2017
- Vini Placco & Chris Sneden, July 18 2017
- Ian Roederer & Vini Placco, & Chris Sneden, Dec 7 2017

-----------------------------------------------------------------------------



SOURCES OF GF'S, HFS/ISO, AND OTHER COMMENTS 

UPDATED SEPTEMBER 2019:  ADDED HF and HCl FROM THE HITRAN DATABASE

UPDATED JUNE 2019:  ADDED FE II FROM THE NEW DEN HARTOG PAPER.

UPDATED MARCH 2018; THESE LINE LISTS ARE CONSERVATIVE IN THE SENSE THAT THEY
     DO NOT INCLUDE DATA FOR SOME SPECIES THAT MIGHT BE PRETTY GOOD BUT ARE
     IN NEED OF NEW LAB WORK, SUCH AS NI II AND CO II.

NOTE THAT THE LINEMAKE COMMANDS ARE SET TO WORK ON THE DATA FILES INCLUDED HERE.
     IF YOU DESIRE TO ADD IN YOUR OWN CHOSEN LINE LISTS TO THIS MIX, THEN:
     (a) YOU ARE ON YOUR OWN (!); and (b) PLEASE CONTACT ONE OF US ON HOW TO
     CORRECTLY MERGE YOUR DATA SET WITH OURS.

OPENING COMMENTS:

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
divide between two files of atomic line data, each of which covers 1000A.  
So if you have a desired line list from say 5990A to 6010A, the code screws up.  
The work-around simply is to run the code twice, in the example case from 
5990A to 5999.999A, and from 6000A to 6010A.




ATOMIC SPECIES: NEUTRON-CAPTURE ELEMENTS (LISTED IN ORDER OF ATOMIC NUMBER)

As I:   Roederer & Lawler (2012, ApJ, 750, 76)

Se I:   Roederer & Lawler (2012, ApJ, 750, 76)

Rb I:   NIST

Sr I:   NIST

Sr II:  NIST

Y II:   Hannaford et al. (1982, ApJ, 261, 736)
        Biemont et al. (2011, MNRAS, 414, 3350)

Zr II:  Ljung et al. (2006, A&A, 456, 1181); 
        Malcheva et al. 2006, MNRAS, 367, 754) for some lines

AgI:    Hansen et al. (2012, A&A, 545, 31)

CdI:    Morton (2000, ApJS, 130, 403)

Cd II:  Roederer & Lawler (2012, ApJ, 750, 76)

Te I:   Roederer et al. (2012, ApJL, 747, L8)

La II:  Lawler et al. (2001, ApJ, 556, 452)

Ce II:  Lawler et al. (2009, ApJS, 182, 51)

Pr II:  Sneden et al. (2009, ApJS, 182, 80)

Nd II:  Den Hartog et al. (2003, ApJS, 148, 543)
        Roederer et al. 2008, ApJ, 675, 723 for iso & hfs
        note that the 4314.50 A line has a solar-derived log(gf)

Sm II:  Lawler et al. (2006, ApJS, 162, 227);
        Roederer & Lawler (2012, ApJ, 750, 76)

Eu II:  Lawler et al. (2001, ApJ, 563, 1075)

Gd II:  Den Hartog et al. (2006, ApJS, 167, 292)

Tb II:  Lawler et al. (2001, ApJS, 137, 341)

Dy II:  Sneden et al. (2009, ApJS, 182, 80) 

Ho II:  Lawler et al. (2004, ApJ, 604, 850)

Er II:  Lawler et al. (2008, ApJS, 178, 71)

Tm II:  Sneden et al. (2009, ApJS, 182, 80) 

Yb II:  Sneden et al. (2009, ApJS, 182, 80); 
        DREAM (2116A); 
        Kedzierski et al. (2010, Spectrochem Acta B., 65, 248 2126A);
        Roederer & Lawler (2012, ApJ, 750, 76)

Lu II:  Sneden et al. (2009, ApJS, 182, 80); 
        Roederer et al. (2010, ApJL, 714, L123) for UV log(gf); 
        Roederer et al. (2012, ApJS, 203, 27) for UV hfs

Hf II:  Lawler et al. (2007, ApJS, 169, 120)

Pt I:   Den Hartog et al. (2005, ApJ, 619, 639);
        Roederer & Lawler (2012, ApJ, 750, 76)

Hg II:  Roederer & Lawler (2012, ApJ, 750, 76) for iso & hfs

Pb I:   Biemont et al. (2000, MNRAS, 312, 116) for log(gf);
        Roederer et al. (2012, ApJS, 203, 27) for iso & hfs



ATOMIC SPECIES: FE-GROUP ELEMENTS (LISTED IN ORDER OF ATOMIC NUMBER)

Sc I:   Lawler et al. (2019, ApJS, 241, 21); includes hfs

Sc II:  Lawler et al. (2019, ApJS, 241, 21); includes hfs

Ti I:   Lawler et al. (2013, ApJS, 205, 11)

Ti II:  Wood et al. (2013, ApJS, 208, 27) 

V I:    Wood et al. (2018, ApJS, 234, 25); Lawler et al. (2014, ApjS, 215, 20); 
Holmes, C. E. et al. 2016, ApJS, 224, 35 suggested some problems
with these transition probabilities in the wavelength range >9000 A,
but Wood et al. showed that the Lawler et al. gf's are correct;  Wood
et al. also has extensive new hfs data.

V II:   Wood et al. (2014, ApJS, 214, 18); there is additionaal hfs
information in the Kurucz database, collected in vI.kurhfs

Cr I:   Sobeck et al. (2007, ApJ, 667, 1267); the line wavelengths have
been adjusted to conform to those given at the NIST website

Cr II:  Lawler et al. (2017, ApJS, 228, 10).

Mn I:   Den Hartog et al. (2011, ApJS, 194, 35); there is additionaal hfs
information in the Kurucz database, collected in scI.kurhfs

Mn II:  Den Hartog et al. (2011, ApJS, 194, 35); there is no additionl
hfs information in the Kurucz database

Fe I:   recent lab studies are by Ruffoni et al. (2014, MNRAS, 441, 3127)
Den Hartog (2014, ApJS, 215, 23), and Belmonte et al. (2017, ApJ, 848, 126).  
Thefirst two of these papers deal with lines arising (in absorption) from 
levels with E.P. >~ 2.3 eV.  One of the good things about the last paper
is that it overlaps the older-but-still-mostly-reliable study of O'Brian 
et al. (1991, JOSAB, 8, 1185) for lower-excitation transitions.  
Here I have chosen to adopt the new lab values, and have added in the
O'Brian values not included in the Belmonte paper AND with E.P < 2.2 eV.
I consider this list to be as close to an "internally consistent single
source" as we are likely to get for a while.

Fe II:  Den Hartog et al. (2019, ApJS, 243, 33); most of the new lab data
are for UV lines, but enough blue lines (10 of them) are included that
it is clear that the Melendez & Barbuy (2009, A&A, 497, 611) empirical
values wre more reliable than those at the NIST website.  Our choice here
is to use the Den Hartog values when available, otherwise to use the 
Melendez & Barbuy values.

Co I:   Lawler et al. (2015, ApJS, 220, 13); Co I with and without hfs
are in different files here.

Co II:  Lawler et al. (2018, ApJS, 238, 7); there are 12 lines in this paper
with good lab hfs patterns.  To these we have added another 4 lines with new
gf values but approximate hfs patters from the Co I paper; these appear
with the notations LAW??? in a linelist generated by linemake.

Ni I:   Wood et al. (2014, ApJS, 211, 20); there is isotopic information 
in the file niI.moogiso, but this is not part of the autometed linemake 
procedure; one can manually substitute in the relevant structures into 
a line list.

Ni II:  discussed in the Ni I paper, but awaits a fresh study; not included
here; this will be the subject of a future Wisconsin lab effort; note that
Co II lines in the Kurucz database have no hfs information.

Cu I:  not done recently, so any hfs information is not to be trusted much,
although for Cu I it is collected in cuI.kurhfs

Zn I:  Roederer & Lawler (2012, ApJ, 750, 7Z)

Zn II: Bergeson & Lawler (1993, ApJ, 408, 382)




ATOMIC SPECIES: OTHER ELEMENTS

Li I resonance line:  nothing special needs to be done here to get the
full isotopic and hyperfine substructure.  The total gf from Kurucz, 
has been adopted; it is close to that recommended by NIST.



MOLECULAR SPECIES:

MgH:  Hinkle et al. (2013, ApJS, 207, 26)

C2 Swan:  Ram et al. (2014, ApJS, 211, 5); note that 0.089eV has been added
to all of the excitation energies to account for the fact that the lower
vibrational level of the Swan system is not exactly at the lowest possible
vibrational state.

CN violet and red:  Sneden et al. (2014, ApJS, 214, 26)

CO:   Pretty much the relatively simply CO parameters in the IR ro-vibrational
bands have been known for a couple of decades.  However, in trial syntheses
conducted by Chris Sneden and Melike Afsar it was noticed that that K-band 
elta-v = 2 "first overtone" band strengths were too strong for the C and O 
abundances derived from optical data.  But they also clashed with the H-band
delta-v = 3 "second overtone" bands in similar fashion.  Therefore we decided
to raise the gf-values of the delta-v = 2 lines by 0.15 dex, and leave the
delta-v = 3 lines alone.  This small alteration is in the CO line list here.

OH ro-vibrational bands:  Brooke et al. (2015, JQSRT, 168, 142)

HCl: HITRAN database (https://hitran.org/lbl/); IR transitions only

HF: HITRAN database (https://hitran.org/lbl/); IR transitions only

SiO: I added in the Kurucz data for SiO in the IR


