# `linemake` Atomic and Molecular Line List Generator

## About 

`linemake` is an open-source atomic and molecular line list generator. Rather than a replacement for a number of well-established atomic and molecular spectral databases, `linemake` aims to be a lightweight, easy-to-use tool to generate formatted and curated lists suitable for spectral synthesis work. We stress that the users of should be *in charge* of all of their transition data, and should cite the appropriate sources in their published work, given below.

## Contributors

* Chris Sneden - Department of Astronomy and McDonald Observatory, The University of Texas, Austin, TX
* [Vini Placco](http://vmplacco.github.io/) - Community Science and Data Center/NSF’s NOIRLab, Tucson, AZ
* Ian Roederer - Department of Astronomy, University of Michigan, Ann Arbor, MI
* James E. Lawler - Department of Physics, University of Wisconsin-Madison, Madison, WI
* Elizabeth A. Den Hartog - Department of Physics, University of Wisconsin-Madison, Madison, WI
* Neda Hejazi - Department of Physics and Astronomy, Georgia State University, Atlanta, GA
* Zachary Maas - Department of Astronomy and McDonald Observatory, The University of Texas, Austin, TX
* Peter Bernath - Department of Physics and Department of Chemistry and Biochemistry, Old Dominion University, Norfolk, VA


## Citing `linemake` in your published work

* If you use `linemake` in your work, please cite the presentation paper [Placco et al. (2021, Res. Notes AAS, 5, 92)](https://ui.adsabs.harvard.edu/abs/2021RNAAS...5...92P), this github repository (as a footnote), and the relevant articles listed below.

* `linemake` is also on the [Astrophysics Source Code Libray](https://ascl.net/2104.027) <a href="https://ascl.net/2104.027"><img src="https://img.shields.io/badge/ascl-2104.027-blue.svg?colorB=262255" alt="ascl:2104.027" /></a>

## Disclaimer

The choices of which lines of which species to include in `linemake` have often been driven by the authors' own spectroscopic interests (e.g., note the large number of entries for transitions of neutron-capture elements that can only be detected in vacuum-UV spectroscopy). However, we would welcome hearing from users who can suggest other strongly-sourced species (with recent reliable lab/theory results) that might be added to our database.

## Downloading `linemake`

* For non-git users, click on the green `Code` button on the top right then "Download ZIP". Unzip the file in your folder of choice and follow the installation instructions below.

* For `git` users, `git clone https://github.com/vmplacco/linemake.git` will set up the repository locally, so you can then follow the instructions below.

If you have any issues, send an email to vmplacco@gmail.com or file an issue on this repository.

## Compiling the code and known idiosyncrasies

First, edit the [`linemake.f`](linemake.f) file (line 34) at the start of the program, to point the code to its species linelists `linepath='/path/to/linemake/mooglists'`. Then, compile the code:

    gfortran linemake.f -o linemake.go

There is one `linemake` oddity that we have no interest in addressing for the foreseeable future. The code will refuse to work (and will say so) when the requested beginning and ending wavelengths bridge the divide between two files of atomic line data, each of which covers 1000 Å. As a result, if you have a desired line list from, e.g., 5990 Å to 6010 Å, the code would crash without the built-in exit. The simple work-around is to run the code twice, in the example case from 5990 Å to 5999.999 Å, and from 6000 Å to 6010 Å.

## Running `linemake`

To run the code, navigate to the installation directory and execute the binary file generated after the compilation:

    cd /path/to/linemake/
    ./linemake.go

Then follow the prompts. After the program is executed, two new files will be generated (`outlines` and `outsort`).

## Description of the database and current status

The periodic table below shows a summary of the current **curated** transitions available in the `linemake` database. Click [here](http://vmplacco.github.io/files/linemake_ptable.html) for an interactive version. A substantial number of additional transitions can be found in the `mooglists/moogatom*` files.

![http://vmplacco.github.io/files/linemake_ptable.html](http://vmplacco.github.io/files/linemake_ptable.svg)

In succeeding sections we discuss first atomic and then molecular data sources. The Fe-group atomic species are considered first, followed by neutron-capture species, and finally a few other elements. The molecular species then are discussed in a bit more detail, because of the decisions needed to maximize the utility of their line lists for high-resolution spectroscopic studies.

---
### Atomic Species: Fe-group Elements

Species|References & Notes
-------|-----
`Sc I` | [Lawler et al. (2019, ApJS, 241, 21)](https://ui.adsabs.harvard.edu/abs/2019ApJS..241...21L/); includes HFS
`Sc II`| [Lawler et al. (2019, ApJS, 241, 21)](https://ui.adsabs.harvard.edu/abs/2019ApJS..241...21L/); includes HFS
`Ti I` | [Lawler et al. (2013, ApJS, 205, 11)](https://ui.adsabs.harvard.edu/abs/2013ApJS..205...11L/)
`Ti II`| [Wood et al. (2013, ApJS, 208, 27)](https://ui.adsabs.harvard.edu/abs/2013ApJS..208...27W/)
`V I`  | [Lawler et al. (2014, ApJS, 215, 20)](https://ui.adsabs.harvard.edu/abs/2014ApJS..215...20L/) and [Wood et al. (2018, ApJS, 234, 25)](https://ui.adsabs.harvard.edu/abs/2018ApJS..234...25W/). [Holmes et al. (2016, ApJS, 224, 35)](https://ui.adsabs.harvard.edu/abs/2016ApJS..224...35H/) suggested some problems with the Lawler et al. transition probabilities in the wavelength range > 9000 Å, but Wood et al. showed that the Lawler et al. *gf*'s are correct;  Wood et al. also has extensive new HFS data
`V II` | [Wood et al. (2014, ApJS, 214, 18)](https://ui.adsabs.harvard.edu/abs/2014ApJS..214...18W); there is additional HFS information in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database, collected in `vI.kurhfs`
`Cr I` | [Sobeck et al. (2007, ApJ, 667, 1267)](https://ui.adsabs.harvard.edu/abs/2007ApJ...667.1267S); the line wavelengths have been adjusted to conform to those given at the [NIST](https://www.nist.gov/pml/atomic-spectra-database) website
`Cr II`| The most current and tested  transition probabilities are from [Lawler et al. (2017, ApJS, 228, 10)](https://ui.adsabs.harvard.edu/abs/2017ApJS..228...10L). We added in earlier good results from [Nilsson et al. (2006, A&A, 445, 1165)](https://ui.adsabs.harvard.edu/abs/2006A%26A...445.1165N) and [Gurell et al. (2010, A&A, 511, A68)](https://ui.adsabs.harvard.edu/abs/2010A%26A...511A..68G), but adjusted their  wavelengths to agree with NIST values (which are in better agreement with those seen in solar/stellar spectra)
`Mn I` | [Den Hartog et al. (2011, ApJS, 194, 35)](https://ui.adsabs.harvard.edu/abs/2011ApJS..194...35D); there is additional HFS information in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database, collected in `mnI.kurhfs`
`Mn II`| [Den Hartog et al. (2011, ApJS, 194, 35)](https://ui.adsabs.harvard.edu/abs/2011ApJS..194...35D); there is no additional HFS information in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database
`Fe I` | Recent laboratory studies are by [Ruffoni et al. (2014, MNRAS, 441, 3127)](https://ui.adsabs.harvard.edu/abs/2014MNRAS.441.3127R), [Den Hartog (2014, ApJS, 215, 23)](https://ui.adsabs.harvard.edu/abs/2014ApJS..215...23D), and [Belmonte et al. (2017, ApJ, 848, 126)](https://ui.adsabs.harvard.edu/abs/2017ApJ...848..125B). The first two of these papers deal with lines arising (in absorption) from levels with E.P. > 2.3 eV.  One of the good things about the last paper is that it overlaps the older-but-still-mostly-reliable study of [O'Brian et al. (1991, JOSAB, 8, 1185)](https://www.osapublishing.org/josab/abstract.cfm?uri=josab-8-6-1185) for lower-excitation transitions. Here we have chosen to adopt the new lab values, and have added in the O'Brian values not included in the Belmonte paper *AND* with E.P < 2.2 eV. We consider this list to be as close to an "internally consistent single source" as we are likely to get for a while.                                                              
`Fe II`| [Den Hartog et al. (2019, ApJS, 243, 33)](https://ui.adsabs.harvard.edu/abs/2019ApJS..243...33D); most of the new laboratory data are for UV lines, but enough blue lines (10 of them) are included that it is clear that the [Meléndez & Barbuy (2009, A&A, 497, 611)](https://ui.adsabs.harvard.edu/abs/2009A%26A...497..611M) empirical values were more reliable than those at the NIST website.  Our choice here is to use the Den Hartog values when available, otherwise to use the Meléndez & Barbuy values
`Co I` | [Lawler et al. (2015, ApJS, 220, 13)](https://ui.adsabs.harvard.edu/abs/2015ApJS..220...13L); `Co I` with and without HFS are in different files here
`Co II`| [Lawler et al. (2018, ApJS, 238, 7)](https://ui.adsabs.harvard.edu/abs/2018ApJS..238....7L); there are 12 lines in this paper  with good laboratory HFS patterns. To these we have added another 4 lines with new *gf* values but approximate HFS patters from the `Co I` paper; these appear with the notations `LAW???` in a linelist generated by `linemake`. Added Co II HFS for 9 UV lines, computed using HFS A constants from [Lawler et al. (2018, ApJS, 238, 7)](https://ui.adsabs.harvard.edu/abs/2018ApJS..238....7L) and [Ding & Pickering (2020, ApJS, 251, 24)](https://ui.adsabs.harvard.edu/abs/2020ApJS..251...24D/abstract).  Most levels appeared in both references, and the "A" values were averaged together.  In a few cases, only the Ding & Pickering reference had an "A" value, which was then used without change.  Three of these lines overlapped with the Co II lines already present in `linemake`, and the new lines supersede the old ones, although the changes are negligible and limited to the wavelengths of components.  (Reference: [Roederer et al. 2022, ApJS, 260, 27](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R))
`Ni I` | [Wood et al. (2014, ApJS, 211, 20)](https://ui.adsabs.harvard.edu/abs/2014ApJS..211...20W); there is isotopic information in the file `niI.moogiso`, but this is not part of the automated `linemake` procedure; one can manually substitute in the relevant structures into a line list
`Ni II`| Discussed in the `Ni I` paper, but awaits a fresh study; not included here; this will be the subject of a future Wisconsin laboratory effort; note that `Ni II` lines in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database have no HFS information.     
`Cu I` | Not done recently, so [Kurucz](http://kurucz.harvard.edu/atoms.html) log(*gf*) and HFS information should be treated with caution. We have assembled these data in `cuI.kurhfs` for convenience, and that is what the user will get in `linemake`
`Cu II`| [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R) for UV lines, and [NIST](https://www.nist.gov/pml/atomic-spectra-database) for optical lines
`Zn I` | [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R)
`Zn II`| [Bergeson & Lawler (1993, ApJ, 408, 382)](https://ui.adsabs.harvard.edu/abs/1993ApJ...408..382B)

---
### Atomic Species: Neutron-Capture Elements

Species|References & Notes
-------|-----
`Ga II`| Added HFS for 2090 Å line using HFS+IS directly from [Karlsson et al. (2000, J Phys B, 33, 2929)](https://ui.adsabs.harvard.edu/abs/2000JPhB...33.2929K/abstract). (Reference: [Roederer et al. 2022, ApJS, 260, 27](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R))
`Ge I`| [Li et al. (1999, PRA, 60, 198)](https://journals.aps.org/pra/abstract/10.1103/PhysRevA.60.198). These nearly exactly match the ones from [Biémont et al (1999, MNRAS, 303, 721)](https://ui.adsabs.harvard.edu/abs/1999MNRAS.303..721B), and Biémont is an author on both papers
`As I`| [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R); [Roederer et al. (2022, ApJS, 260, 27)](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R) with HFS
`Se I`| [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R)                  
`Rb I`| [NIST](https://www.nist.gov/pml/atomic-spectra-database)                                                    
`Sr I`| [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`Sr II`| [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`Y II`| [Hannaford et al. (1982, ApJ, 261, 736)](https://ui.adsabs.harvard.edu/abs/1982ApJ...261..736H) and [Biémont et al. (2011, MNRAS, 414, 3350)](https://ui.adsabs.harvard.edu/abs/2011MNRAS.414.3350B)
`Zr II`| [Ljung et al. (2006, A&A, 456, 1181)](https://ui.adsabs.harvard.edu/abs/2006A%26A...456.1181L); [Malcheva et al. (2006, MNRAS, 367, 754)](https://ui.adsabs.harvard.edu/abs/2006MNRAS.367..754M) for some lines   
`Nb II`| [Nilsson et al. (2010, A&A, 511, A16)](https://ui.adsabs.harvard.edu/abs/2010A%26A...511A..16N); including HFS
`Ru II`| [Johansson et al. 1994, ApJ, 421, 809)](https://ui.adsabs.harvard.edu/abs/1994ApJ...421..809J) for UV lines
`Ag I`| [Hansen et al. (2012, A&A, 545, 31)](https://ui.adsabs.harvard.edu/abs/2012A%26A...545A..31H)                      
`Cd I`| [Morton (2000, ApJS, 130, 403)](https://ui.adsabs.harvard.edu/abs/2000ApJS..130..403M)
`Cd II`| [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R)
`In II`| In Added new HFS+ISO for 1 UV line ([Roederer et al. 2022, ApJS, 260, 27](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R)).  The log(*gf*) value is from [Curtis et al. (2000, PRA, 62, 052513)](https://journals.aps.org/pra/abstract/10.1103/PhysRevA.62.052513).  The HFS is from new calculations based on [Larkin & Hannaford (1993, Z. Phys. D., 27, 313)](https://ui.adsabs.harvard.edu/abs/1993ZPhyD..27..313L).  The ISO is from [Wang et al. (2007, Euro. Phys. J. D, 44, 307)](https://link.springer.com/article/10.1140/epjd/e2007-00171-0)
`Sn II`| Added 2151 Å line with log(*gf*) value from [Oliver & Hibbert (2010, J Phys B, 43, 074013)](https://ui.adsabs.harvard.edu/abs/2010JPhB...43g4013O/abstract)
`Sb I`| [Roederer et al. (2022, ApJS, 260, 27)](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R) for two UV lines
`Te I`| [Roederer et al. (2012, ApJL, 747, L8)](https://ui.adsabs.harvard.edu/abs/2012ApJ...747L...8R). Added line at 2002 Å using the transition probability from [Ubelis & Berzinsh (1991, PhyS, 43, 162)](https://ui.adsabs.harvard.edu/abs/1991PhyS...43..162U/abstract), with uncertainty 0.17 dex.  Also added line at 2259 Å using the transition probability recommended by [Morton (2000, ApJS, 130, 403)](https://ui.adsabs.harvard.edu/abs/2000ApJS..130..403M/abstract)
`La II`| [Lawler et al. (2001, ApJ, 556, 452)](https://ui.adsabs.harvard.edu/abs/2001ApJ...556..452L). One line from Shah et al. (2023, submitted)
`Ce II`| [Lawler et al. (2009, ApJS, 182, 51)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...51L)
`Pr II`| [Sneden et al. (2009, ApJS, 182, 80)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...80S)
`Nd II`| [Den Hartog et al. (2003, ApJS, 148, 543)](https://ui.adsabs.harvard.edu/abs/2003ApJS..148..543D) and [Roederer et al. (2008, ApJ, 675, 723)](https://ui.adsabs.harvard.edu/abs/2008ApJ...675..723R) for ISO & HFS. Note that the 4314.50Å line has a solar-derived log(*gf*)
`Sm II`| [Lawler et al. (2006, ApJS, 162, 227)](https://ui.adsabs.harvard.edu/abs/2006ApJS..162..227L) and [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R)
`Eu II`| [Lawler et al. (2001, ApJ, 563, 1075)](https://ui.adsabs.harvard.edu/abs/2001ApJ...563.1075L)
`Gd II`| [Den Hartog et al. (2006, ApJS, 167, 292)](https://ui.adsabs.harvard.edu/abs/2006ApJS..167..292D)
`Tb II`| [Lawler et al. (2001, ApJS, 137, 341)](https://ui.adsabs.harvard.edu/abs/2001ApJS..137..341L)
`Dy II`| [Sneden et al. (2009, ApJS, 182, 80)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...80S)
`Ho II`| [Lawler et al. (2004, ApJ, 604, 850)](https://ui.adsabs.harvard.edu/abs/2004ApJ...604..850L)
`Er II`| [Lawler et al. (2008, ApJS, 178, 71)](https://ui.adsabs.harvard.edu/abs/2008ApJS..178...71L)
`Tm II`| [Sneden et al. (2009, ApJS, 182, 80)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...80S)
`Yb II`| [Sneden et al. (2009, ApJS, 182, 80)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...80S); [DREAM database](https://hosting.umons.ac.be/html/agif/databases/dream.html) (2016A); [Kedzierski et al. (2010, Spectrochimica Acta B, 65, 248)](https://www.sciencedirect.com/science/article/abs/pii/S0584854710000522)
`Lu II`| Several HFS sources put together by Ian:  [Sneden et al. (2009, ApJS, 182, 80)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...80S); [Roederer et al. (2010, ApJL, 714, L123)](https://ui.adsabs.harvard.edu/abs/2010ApJ...714L.123R); [Roederer et al. (2012, ApJS, 203, 27)](https://ui.adsabs.harvard.edu/abs/2012ApJS..203...27R); [Den Hartog et al. (2020, ApJS, 248, 10)](https://ui.adsabs.harvard.edu/abs/2020ApJS..248...10D). Likewise for *gf* values there are values from [Sneden et al. (2009, ApJS, 182, 80)](https://ui.adsabs.harvard.edu/abs/2009ApJS..182...80S); [Roederer et al. (2010, ApJL, 714, L123)](https://ui.adsabs.harvard.edu/abs/2010ApJ...714L.123R); [Quinet et al. (1999, MNRAS, 307, 934)](https://ui.adsabs.harvard.edu/abs/1999MNRAS.307..934Q)
`Ta II`|  *gf* values computed by Ian from data in [Quinet et al. (2009, A&A, 493, 711)](https://ui.adsabs.harvard.edu/abs/2009A%26A...493..711Q), with wavelengths adopted from [Kurucz](http://kurucz.harvard.edu/atoms.html). These were supplemented by some values from [Morton (2000, ApJS, 130, 403)](https://ui.adsabs.harvard.edu/abs/2000ApJS..130..403M)
`W II`| [Roederer et al. (2022, ApJS, 260, 27)](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R) for UV lines
`Re II`| [Roederer et al. (2022, ApJS, 260, 27)](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R) for UV lines
`Os I`| [Quinet et al. (2006, A&A, 448, 1207)](https://ui.adsabs.harvard.edu/abs/2006A%26A...448.1207Q) for *gf* values
`Os II`| [Quinet et al. (2006, A&A, 448, 1207)](https://ui.adsabs.harvard.edu/abs/2006A%26A...448.1207Q) for *gf* values
`Ir I`| Added HFS/IS for the line at 2924 Å, using the transition probability from [Xu et al. (2007, JQSRT, 104, 52)](https://www.sciencedirect.com/science/article/abs/pii/S0022407306002172?via%3Dihub) - (Reference: [Roederer et al. 2022, ApJS, 260, 27](https://ui.adsabs.harvard.edu/abs/2022ApJS..260...27R)); including HFS/IS from [Cowan et al. (2005, ApJ, 627, 238)](https://ui.adsabs.harvard.edu/abs/2005ApJ...627..238C)
`Ir II`| [Ivarsson et al. (2004, A&A, 425, 353)](https://ui.adsabs.harvard.edu/abs/2004A%26A...425..353I), supplemented with a few lines from [Xu et al. (2007, JQSRT, 104, 52)](https://www.sciencedirect.com/science/article/abs/pii/S0022407306002172?via%3Dihub) - values taken via [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`Pt I`| [Den Hartog et al. (2005, ApJ, 619, 639)](https://ui.adsabs.harvard.edu/abs/2005ApJ...619..639D); HFS and isotopic substructure included for many lines
`Pt II`| [Quinet et al. (2008, PRA, 77, 022501)](https://portal.research.lu.se/portal/en/publications/laserinducedfluorescence-lifetime-measurements-and-relativistic-hartreefock-oscillator-strength-calculations-in-singly-ionized-platinum(76f6fe83-0510-4a79-ba1c-10a6b7a72672).html) for selected strong UV lines
`Au I`| [Fivet et al. (2006, J. Phys. B: At. Mol. Opt. Phys., 39, 3587)](https://iopscience.iop.org/article/10.1088/0953-4075/39/17/015) and [NIST](https://www.nist.gov/pml/atomic-spectra-database) for strong UV lines
`Pb I`| [Roederer & Lawler (2012, ApJ, 750, 76)](https://ui.adsabs.harvard.edu/abs/2012ApJ...750...76R)
`Pb II`| [Roederer et al. (2020, ApJL, 902, L24)](https://ui.adsabs.harvard.edu/abs/2020ApJ...902L..24R) for one UV line
`Th II`| [Nilsson et al. (2002, A&A, 382, 368)](https://ui.adsabs.harvard.edu/abs/2002A%26A...382..368N)
`U II`| [Nilsson et al. (2002, A&A, 381, 1090)](https://ui.adsabs.harvard.edu/abs/2002A%26A...381.1090N)

---
### Atomic Species: Other Elements

Species|References & Notes
-------|-----
`Li I`| Resonance line. Nothing special needs to be done here to get the full isotopic and hyperfine substructure. The total *gf* from [Kurucz](http://kurucz.harvard.edu/atoms.html), has been adopted; it is close to that recommended by [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`O I` | A mix of NIST/B+ values and measurements by [Magg et al. (2022, A&A, 661, 140)](https://ui.adsabs.harvard.edu/abs/2022A%26A...661A.140M/)
`Al II`| [Roederer & Lawler (2021, ApJ, 912, 119)](https://ui.adsabs.harvard.edu/abs/2021ApJ...912..119R). This is the HFS for one UV resonance line
`Si I` | A mix of NIST values and updates based on new branching fraction measurements by [Den Hartog et al. (2023, ApJS, 265, 42)](https://ui.adsabs.harvard.edu/abs/2023arXiv230111391D)
`Si II`| Two UV lines with updates from new branching fraction measurements by [Den Hartog et al. (2023, ApJS, 265, 42)](https://ui.adsabs.harvard.edu/abs/2023arXiv230111391D)
`Ca I`| [Den Hartog et al. (2021, ApJS, 255, 227)](https://ui.adsabs.harvard.edu/abs/2021ApJS..255...27D). This is a combined lab and theoretical study, and the included transitions have transition probabilities now with very small uncertainties
`Ca II`| [Den Hartog et al. (2021, ApJS, 255, 227)](https://ui.adsabs.harvard.edu/abs/2021ApJS..255...27D). No new lab data here, but Ca II is a well-studied single electron species

---
### Molecular (mostly diatomic) Species

Species|References & Notes
-------|-----
`MgH`| [Hinkle et al. (2013, ApJS, 207, 26)](https://ui.adsabs.harvard.edu/abs/2013ApJS..207...26H)
<code>C<sub>2</sub></code> | Swan bands.  [Ram et al. (2014, ApJS, 211, 5)](https://ui.adsabs.harvard.edu/abs/2014ApJS..211....5R); note that 0.089 eV has been added to all of the excitation energies to account for the fact that the lower level of the Swan system is not exactly at the lowest possible vibrational state
`CH`| [Masseron et al. (2014, A&A, 571, 47)](https://ui.adsabs.harvard.edu/abs/2014A%26A...571A..47M); files obtained from Bertrand Plez
`CN`| [Sneden et al. (2014, ApJS, 214, 26)](https://ui.adsabs.harvard.edu/abs/2014ApJS..214...26S); violet and red         
`CO`| Pretty much the relatively simply CO parameters in the IR ro-vibrational bands have been known for a couple of decades. However, in trial syntheses conducted by Chris Sneden and Melike Afsar it was noticed that that K-band &Delta;v = 2 first overtone band strengths were too strong for the C and O abundances derived from optical data. But they also clashed with the H-band &Delta;v = 3 "second overtone" bands in similar fashion.  Therefore we decided to raise the *gf*-values of the &Delta;v = 2 lines by 0.15 dex, and leave the &Delta;v = 3 lines alone.  This small pragmatic alteration is in the CO line list here; users need to be aware of this if CO is used for abundance determinations. To be updated with [HITRAN](https://hitran.org/lbl/) line parameters from [Li et al. (2015, ApJS, 216, 15)](https://ui.adsabs.harvard.edu/abs/2015ApJS..216...15L)
`OH`| Ro-vibrational bands:  [Brooke et al. (2016, JQSRT, 168, 142)](https://www.sciencedirect.com/science/article/abs/pii/S0022407315002721?via%3Dihub); these are only for the IR transitions             
`HCl`| [HITRAN](https://hitran.org/lbl/); IR transitions only
`HF`| [HITRAN](https://hitran.org/lbl/); IR transitions only
`SiO`| [Kurucz database](http://kurucz.harvard.edu/molecules/sio/); IR transitions only
`SiH`| [Kurucz database](http://kurucz.harvard.edu/molecules/sih/); in earlier `linemake` versions SiH was lumped in with the other hydrides but this is unsatisfactory. Now it will be included only if the user desires it. Since the solar isotopic fractions are <sup>28,29,30</sup>Si = 92.22%, 4.69%, and 3.09%, in other words dominated by a single isotope, the solar isotopic fractions are included in the effective *gf* values of SiH lines
<code>H<sub>2</sub>O</code>| [HITRAN](https://hitran.org/lbl/); the whole list has 84K lines, so to limit that a bit we include here only those in the 1-5&mu;m wavelength regime. It would be easy to add optical-region lines if a need arises. Note that the [MOOG](https://www.as.utexas.edu/~chris/moog.html) version from November 2019 has the ability to do triatomic molecules; earlier versions cannot work on H<sub>2</sub>O
`TiO`| [ExoMol](http://www.exomol.com/data/molecules/). This molecule has many electronic-vabrational-rotational band systems, leading to nearly 8 million transitions cataloged in HITRAN. Additionally, Ti has 5 isotopes with substantial contributions to the solar-system Ti elemental abundance. The major isotope is <sup>48</sup>Ti, with 72.73% of the fractional contribution, and <sup>46,47,49,50</sup>Ti isotopes have 8.25%, 7.44%, 5.41%, and 5.18% fractions, respectively. Briefly we outline our line cut-down procedures here. We define a species-specific relative strength as log(*gf*) - &theta;&chi;, where &chi; is the excitation energy in eV, and &theta; = 5040/T. We choose &theta; = 1.5 (T = 3600K) as a representative very cool stellar temperature. Then for <sup>48</sup>TiO we retained all lines whose strengths were predicted to be >0.1% of the strongest line in a 10 Å wavelength interval, thus cutting out a large number of extremely weak TiO lines. This reduced the original 8 x 10<sup>6</sup> list to about 1.7 x 10<sup>6</sup>, still large but manageable. For the other isotopes we used the same procedure, but cut individual line strengths down by the additional factor of the isotopic ratio with respect to <sup>48</sup>Ti. In `linemake` for TiO the user has options of including only <sup>48</sup>TiO or adding in the other isotopic lines also. For now we have cut down the *gf*'s of the minor isotopic lines by their solar-system abundance ratios. This may be revisited in the future it is not satisfactory to users
`FeH`| There appear to be two sources for FeH line data that can be used in synthesis lists. First, the [Kuruz website](http://kurucz.harvard.edu/molecules/feh/) has lines from [Dulick et al. (2003, ApJ, 594, 651)](https://ui.adsabs.harvard.edu/abs/2003ApJ...594..651D). These were translated into [MOOG](https://www.as.utexas.edu/~chris/moog.html) style in a straightforward manner. Second, [Hargreaves et al. (2010, AJ, 140, 919)](https://ui.adsabs.harvard.edu/abs/2010AJ....140..919H) studied a different `FeH` electronic band system, creating a list of about 6300 lines with wavelengths, measured intensities, and excitation energies. For a small subset of about 260 lines they computed transition probabilities. We combined the Kurucz/Dulick and Hargreaves lines. After examining the relative strengths of the total FeH line list, we elected to eliminate those lines that were ≃10<sup>-7</sup> weaker than the maximum FeH line strengths. Fe exists predominantly as <sup>56</sup>Fe (91.7%) and the minor isotopes have not gotten much attention, so they were ignored. The data sources tabulate `FeH` lines from \~ 6200 Å to far into the IR, but there are relatively few lines beyond 5&mu;, and we ignored them
`MgO`| Probably in the near future from [ExoMol](http://www.exomol.com/data/molecules/)

## Acknowledgements

Our development of `linemake` has benefitted from many sources of support over the years, including:

* The work of V.M.P. is supported by NOIRLab, which is managed by the Association of Universities for Research in Astronomy (AURA) under a cooperative agreement with the National Science Foundation (NSF).

* I.U.R. acknowledges financial support from NASA (HST-GO-12268, HST-GO-12976, HST-AR-13246, HST-AR-13879, HST-AR-13884, HST-GO-14151, HST-GO-14231, HST-GO-14232, HST-GO-14765, HST-AR-15051, HST-GO-15657) and NSF (AST-1815403).
