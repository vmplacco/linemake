# `linemake` Atomic and Molecular Line List Generator

## About 

`linemake` is an open-source atomic and molecular line list generator. Rather than a replacement for a number of well-established atomic and molecular spectral databases, `linemake` aims to be a lightweight, easy-to-use tool to generate formatted and curated lists suitable for spectral synthesis work. We stress that the users of should be *in charge* of all of their transition data, and should cite the appropriate sources in their published work, given below.

## Citating `linemake` in your published work

If you use `linemake` in your work, please cite the presentation paper (TBD), this github repository, and the relevant articles listed below.

## Disclaimer

The choices of which lines of which species to include in `linemake` have often been driven by the authors' own spectroscopic interests (e.g., note the large number of entries for transitions of neutron-capture elements that can only be detected in vacuum-UV spectroscopy). However, we would welcome hearing from users who can suggest other strongly-sourced species (with recent reliable lab/theory results) that might be added to our database.

## Compiling the code and known idiosyncrasies

First, edit the `linemake.f` at the start of the program, to point the code to its species linelists `linepath='/pathto/mooglists'`. Then, compile the code:

    gfortran linemake.f -o linemake.go

There is one `linemake` oddity that we have no interest in addressing for the foreseeable future. The code will refuse to work (and will say so) when the requested beginning and ending wavelengths bridge the divide between two files of atomic line data, each of which covers 1000Å. As a result, if you have a desired line list from, e.g., 5990Å to 6010Å, the code would crash without the built-in exit. The simple work-around is to run the code twice, in the example case from 5990Å to 5999.999Å, and from 6000Å to 6010Å.

## Description of the database and current status

<object width="1050" height="850" type="text/html" data="http://vmplacco.github.io/files/linemake_ptable.html" align="middle"></object>

In succeeding sections we discuss first atomic and then molecular data sources. The Fe-group atomic species are considered first, followed by neutron-capture species, and finally a few other elements. The molecular species then are discussed in a bit more detail, because of the decisions needed to maximize the utility of their line lists for high-resolution spectroscopic studies.

---
### Atomic Species: Fe-group Elements

Species|References & Notes
-------|-----
`Sc I` | [Lawler et al. (2019, ApJS, 241, 21)](https://ui.adsabs.harvard.edu/abs/2019ApJS..241...21L/); includes HFS
`Sc II`| [Lawler et al. (2019, ApJS, 241, 21)](https://ui.adsabs.harvard.edu/abs/2019ApJS..241...21L/); includes HFS
`Ti I` | [Lawler et al. (2013, ApJS, 205, 11)](https://ui.adsabs.harvard.edu/abs/2013ApJS..205...11L/)
`Ti II`| [Wood et al. (2013, ApJS, 208, 27)](https://ui.adsabs.harvard.edu/abs/2013ApJS..208...27W/)
`V I`  | [Lawler et al. (2014, ApJS, 215, 20)](https://ui.adsabs.harvard.edu/abs/2014ApJS..215...20L/) and [Wood et al. (2018, ApJS, 234, 25)](https://ui.adsabs.harvard.edu/abs/2018ApJS..234...25W/). [Holmes et al. (2016, ApJS, 224, 35)](https://ui.adsabs.harvard.edu/abs/2016ApJS..224...35H/) suggested some problems with the Lawler et al. transition probabilities in the wavelength range >9000 Å, but Wood et al. showed that the Lawler et al. *gf*'s are correct;  Wood et al. also has extensive new HFS data
`V II` | Wood et al. (2014, ApJS, 214, 18); there is additional HFS information in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database, collected in `vI.kurhfs`
`Cr I` | Sobeck et al. (2007, ApJ, 667, 1267); the line wavelengths have been adjusted to conform to those given at the NIST website
`Cr II`| The most current and tested  transition probabilities are from Lawler et al. (2017, ApJS, 228, 10). We added in earlier good results from Nilsson et al. (2006, A&A, 445, 1165) and Gurell et al. (2010, A&A, 511, A68), but adjusted their  wavelengths to agree with NIST values (which are in better agreement with those seen in solar/stellar spectra)
`Mn I` | Den Hartog et al. (2011, ApJS, 194, 35); there is additional HFS information in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database, collected in `scI.kurhfs`
`Mn II`| Den Hartog et al. (2011, ApJS, 194, 35); there is no additional HFS information in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database
`Fe I` | Recent laboratory studies are by Ruffoni et al. (2014, MNRAS, 441, 3127), Den Hartog (2014, ApJS, 215, 23), and Belmonte et al. (2017, ApJ, 848, 126). The first two of these papers deal with lines arising (in absorption) from levels with E.P. > 2.3 eV.  One of the good things about the last paper is that it overlaps the older-but-still-mostly-reliable study of O'Brian et al. (1991, JOSAB, 8, 1185) for lower-excitation transitions. Here we have chosen to adopt the new lab values, and have added in the O'Brian values not included in the Belmonte paper *AND* with E.P < 2.2 eV. We consider this list to be as close to an "internally consistent single source" as we are likely to get for a while.                                                              
`Fe II`| Den Hartog et al. (2019, ApJS, 243, 33); most of the new laboratory data are for UV lines, but enough blue lines (10 of them) are included that it is clear that the Meléndez & Barbuy (2009, A&A, 497, 611) empirical values were more reliable than those at the NIST website.  Our choice here is to use the Den Hartog values when available, otherwise to use the Melendez & Barbuy values
`Co I` | Lawler et al. (2015, ApJS, 220, 13); `Co I` with and without HFS are in different files here
`Co II`| Lawler et al. (2018, ApJS, 238, 7); there are 12 lines in this paper  with good lab hfs patterns. To these we have added another 4 lines with new *gf* values but approximate HFS patters from the `Co I` paper; these appear with the notations `LAW???` in a linelist generated by `linemake`
`Ni I` | Wood et al. (2014, ApJS, 211, 20); there is isotopic information in the file `niI.moogiso`, but this is not part of the automated `linemake` procedure; one can manually substitute in the relevant structures into a line list
`Ni II`| Discussed in the `Ni I` paper, but awaits a fresh study; not included here; this will be the subject of a future Wisconsin laboratory effort; note that `Co II` lines in the [Kurucz](http://kurucz.harvard.edu/atoms.html) database have no HFS information.     
`Cu I` | Not done recently, so [Kurucz](http://kurucz.harvard.edu/atoms.html) log(*gf*) and HFS information should be treated with caution. We have assembled these data in `cuI.kurhfs` for convenience, and that is what the user will get in `linemake`
`Cu II`| Roederer & Lawler (2012, ApJ, 750, 76) for UV lines, and NIST for optical lines
`Zn I` | Roederer & Lawler (2012, ApJ, 750, 7Z)                                                     
`Zn II`| Bergeson & Lawler (1993, ApJ, 408, 382)

---
### Atomic Species: Neutron-Capture Elements

Species|References & Notes
-------|-----
`Ge I`| Li et al. (1999, PRA, 60, 198). These nearly exactly match the ones from Biemont et al (1999, MN RAS, 303, 721), and Biemont is an author on both papers
`As I`| Roederer & Lawler (2012, ApJ, 750, 76); Roederer et al., in preparation) with HFS
`Se I`| Roederer & Lawler (2012, ApJ, 750, 76)                  
`Rb I`| [NIST](https://www.nist.gov/pml/atomic-spectra-database)                                                    
`Sr I`| [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`Sr II`| [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`Y II`| Hannaford et al. (1982, ApJ, 261, 736) and Biemont et al. (2011, MNRAS, 414, 3350)
`Zr II`| Ljung et al. (2006, A\&A, 456, 1181); Malcheva et al. (2006, MNRAS, 367, 754) for some lines   
`Ru II`| Johansson et al. 1994, ApJ, 421, 809) for UV lines
`Ag I`| Hansen et al. (2012, A\&A, 545, 31)                      
`Cd I`| Morton (2000, ApJS, 130, 403)                           
`Cd II`| Roederer & Lawler (2012, ApJ, 750, 76)
`Ru II`| Roederer et al. (2021, in preparation) for one UV line
`Sb I`| Roederer et al. (2021, in preparation) for two UV lines
`Te I`| Roederer et al. (2012, ApJL, 747, L8)                   
`La II`| Lawler et al. (2001, ApJ, 556, 452)                     
`Ce II`| Lawler et al. (2009, ApJS, 182, 51)                     
`Pr II`| Sneden et al. (2009, ApJS, 182, 80)                                                                
`Nd II`| Den Hartog et al. (2003, ApJS, 148, 543) and Roederer et al. (2008, ApJ, 675, 723) for ISO & HFS. Note that the 4314.50 Å line has a solar-derived log(*gf*)
`Sm II`| Lawler et al. (2006, ApJS, 162, 227) and Roederer & Lawler (2012, ApJ, 750, 76)                  
`Eu II`| Lawler et al. (2001, ApJ, 563, 1075)                    
`Gd II`| Den Hartog et al. (2006, ApJS, 167, 292)                
`Tb II`| Lawler et al. (2001, ApJS, 137, 341)                    
`Dy II`| Sneden et al. (2009, ApJS, 182, 80)                     
`Ho II`| Lawler et al. (2004, ApJ, 604, 850)                     
`Er II`| Lawler et al. (2008, ApJS, 178, 71)                     
`Tm II`| Sneden et al. (2009, ApJS, 182, 80)
`Yb II`| Sneden et al. (2009, ApJS, 182, 80); [DREAM database](https://hosting.umons.ac.be/html/agif/databases/dream.html) (2016A); Kedzierski et al. (2010, Spectrochem Acta B., 65, 248 2126A)
`Lu II`| Several HFS sources put together by Ian:  Sneden et al. (2009, ApJS, 182, 80); Roederer et al. (2010, ApJL, 714, L123); Roederer et al. (2012, ApJS, 203, 27); Den Hartog et al. (2020, ApJS, 248, 10. Likewise for *gf* values there are values from Sneden et al. (2009, ApJS, 182, 80); Roederer et al. (2010, ApJL, 714, L123): Quinet et al. (1999, MNRAS, 307, 934)
`Ta II`|  *gf* values computed by Ian from data in Quinet et al. (2009, A&A, 493, 711), with wavelengths adopted from [Kurucz](http://kurucz.harvard.edu/atoms.html). These were supplemented by some values from Morton (2000, ApJS, 130, 403)
`W II`| Roederer et al. (2021, in preparation) for UV lines
`Re II`| Roederer et al. (2021, in preparation) for UV lines
`Os I`| Quinet et al. (2006, A&A, 448, 1207) for *gf* values
`Os II`| Quinet et al. (2006, A&A, 448, 1207) for *gf* values
`Ir II`| Ivarsson et al. (2004, A&A, 425, 353) and Xu et al. (2007, JQSRT, 104, 52, values from NIST) for UV lines
`Pt I`| Den Hartog et al. (2005, ApJ, 619, 639); HFS and isotopic substructure included for many lines
`Pt II`| Quinet et al. (2008, PRA, 77, 022501) for selected strong UV lines
`Au I`| Fivet et al. (2006, J. Phys. B: At. Mol. Opt. Phys., 39, 3587) and NIST for strong UV lines
`Pb I`| Roederer et al. (2012, ApJ, 750, 76)
`Pb II`| Roederer et al. (2020, ApJL, 902, L24) for one UV line

---
### Atomic Species: Other Elements

Species|References & Notes
-------|-----
`Li I`| Resonance line. Nothing special needs to be done here to get the full isotopic and hyperfine substructure. The total *gf* from [Kurucz](http://kurucz.harvard.edu/atoms.html), has been adopted; it is close to that recommended by [NIST](https://www.nist.gov/pml/atomic-spectra-database)
`Al II`| Roederer & Lawler (2021, in preparation). This is the HFS for one UV resonance line
`Ca I`| Den Hartog et al. (2021, ApJS, submitted). This is a combined lab and theoretical study, and the included transitions have transition probabilities now with very small uncertainties
`Ca II`| Den Hartog et al. (2021, ApJS, submitted). No new lab data here, but Ca II is a well-studied single electron species

---
### Molecular (mostly diatomic) Species

Species|References & Notes
-------|-----
`MgH`| Hinkle et al. (2013, ApJS, 207, 26)
<code>C<sub>2</sub></code> | Swan bands.  Ram et al. (2014, ApJS, 211, 5); note that 0.089eV has been added to all of the excitation energies to account for the fact that the lower level of the Swan system is not exactly at the lowest possible vibrational state.                                              
`CH`| Masseron et al. (2014, A&A, 571, 47; files obtained from Bertrand Plez
`CN`| (violet and red)  Sneden et al. (2014, ApJS, 214, 26)         
`CO`| Pretty much the relatively simply CO parameters in the IR ro-vibrational bands have been known for a couple of decades. However, in trial syntheses conducted by Chris Sneden and Melike Afsar it was noticed that that K-band &Delta;v = 2 first overtone band strengths were too strong for the C and O abundances derived from optical data. But they also clashed with the H-band &Delta;v = 3 "second overtone" bands in similar fashion.  Therefore we decided to raise the *gf*-values of the &Delta;v = 2 lines by 0.15 dex, and leave the &Delta;v = 3 lines alone.  This small pragmatic alteration is in the CO line list here; users need to be aware of this if CO is used for abundance determinations.  
`OH`| Ro-vibrational bands:  Brooke et al. (2015, JQSRT, 168, 142); these are only for the IR transitions             
`HCl`| [HITRAN](https://hitran.org/lbl/); IR transitions only
`HF`| [HITRAN](https://hitran.org/lbl/); IR transitions only
`SiO`| [Kurucz database](http://kurucz.harvard.edu/molecules/sio/); IR transitions only
`SiH`| [Kurucz database](http://kurucz.harvard.edu/molecules/sih/); in earlier `linemake` versions SiH was lumped in with the other hydrides but this is unsatisfactory. Now it will be included only if the user desires it. Since the solar isotopic fractions are <sup>28,29,30</sup>Si = 92.22%, 4.69%, and 3.09%, in other words dominated by a single isotope, the solar isotopic fractions are included in the effective *gf* values of SiH lines
<code>H<sub>2</sub>O</code>| [HITRAN](https://hitran.org/lbl/); the whole list has 84K lines, so to limit that a bit we include here only those in the 1-5&mu;m wavelength regime. It would be easy to add optical-region lines if a need arises. Note that the [MOOG](https://www.as.utexas.edu/~chris/moog.html) version from November 2019 has the ability to do triatomic molecules; earlier versions cannot work on H<sub>2</sub>O
`TiO`|  [HITRAN](https://hitran.org/lbl/). This molecule has many electronic-vabrational-rotational band systems, leading to nearly 8 million transitions cataloged in HITRAN. Additionally, Ti has 5 isotopes with substantial contributions to the solar-system Ti elemental abundance. The major isotope is <sup>48</sup>Ti, with 72.73% of the fractional contribution, and <sup>46,47,49,50</sup>Ti isotopes have 8.25%, 7.44%, 5.41%, and 5.18% fractions, respectively. Briefly we outline our line cut-down procedures here. We define a species-specific relative strength as log(*gf*) - &theta;&chi;, where &chi; is the excitation energy in eV, and &theta; = 5040/T. We choose &theta; = 1.5 (T = 3600K) as a representative very cool stellar temperature. Then for <sup>48</sup>TiO we retained all lines whose strengths were predicted to be >0.1% of the strongest line in a 10 Å wavelength interval, thus cutting out a large number of extremely weak TiO lines. This reduced the original 8 x 10<sup>6</sup> list to about 1.7 x 10<sup>6</sup>, still large but manageable. For the other isotopes we used the same procedure, but cut individual line strengths down by the additional factor of the isotopic ratio with respect to <sup>48</sup>Ti. In `linemake` for TiO the user has options of including only <sup>48</sup>TiO or adding in the other isotopic lines also. For now we have cut down the *gf*'s of the minor isotopic lines by their solar-system abundance ratios. This may be revisited in the future it is not satisfactory to users
`FeH`| There appear to be two sources for FeH line data that can be used in synthesis lists. First, the [Kuruz website](http://kurucz.harvard.edu/molecules/feh/) has lines from Dulick et al. (2003, ApJ, 594, 651). These were translated into [MOOG](https://www.as.utexas.edu/~chris/moog.html) style in a straightforward manner. Second, Hargreaves et al. (2010, AJ, 140, 919) studied a different `FeH` electronic band system, creating a list of about 6300 lines with wavelengths, measured intensities, and excitation energies. For a small subset of about 260 lines they computed transition probabilities. We combined the Kurucz/Dulick and Hargreaves lines. After examining the relative strengths of the total FeH line list, we elected to eliminate those lines that were ≃10<sup>-7</sup> weaker than the maximum FeH line strengths. Fe exists predominantly as <sup>56</sup>Fe (91.7%) and the minor isotopes have not gotten much attention, so they were ignored. The data sources tabulate `FeH` lines from \~ 6200 Å to far into the IR, but there are relatively few lines beyond 5&mu;, and we ignored them
`MgO`| Probably in the near future from [ExoMol](http://www.exomol.com/data/molecules/)

## Author acknowledgements

* The work of V.M.P. is supported by NOIRLab, which is managed by the Association of Universities for Research in Astronomy (AURA) under a cooperative agreement with the National Science Foundation (NSF).

* I.U.R. acknowledges financial support from NASA (HST-GO-12268, HST-GO-12976, HST-AR-13246, HST-AR-13879, HST-AR-13884, HST-GO-14151, HST-GO-14231, HST-GO-14232, HST-GO-14765, HST-AR-15051, HST-GO-15657) and NSF (AST-1815403).
