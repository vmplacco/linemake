from alexmods.linelists import LineList
import numpy as np
from astropy import table

linemake_dir = "/Users/alexji/S5/linelists/linemake"
linemake_files = linemake_dir + '/mooglists'
masseron_file = "/Users/alexji/Dropbox/Alex_Hires/linelists_master/CH_lines/masseron_all.txt"

all_masseron = LineList.read(masseron_file)

masseron = all_masseron[all_masseron['loggf'] > -6]

print(len(masseron), np.min(masseron['loggf']))
print("Removed",len(all_masseron) - len(masseron),"lines")
assert np.all(np.logical_and(masseron["elem1"]=="H",masseron["elem2"]=="C"))

# Comment with Masseron14; fix dissoc_E
masseron.remove_column("comments")
masseron.remove_column("dissoc_E")
#masseron.add_column(Column(["MASSERON14" for x in range(len(masseron))],name="comments"))
masseron["dissoc_E"] = 3.464 # from mooghyd
masseron["comments"] = "MASSERON14"

mooghydfiles = ["mooghyd2000","mooghyd3000","mooghyd4000",\
                "mooghyd6000","mooghyd10000"]
wl_ranges = [(2000,3000),(3000,4000),(4000,6000),(6000,10000),(10000,1000000)]
ncomment_masseron = int(masseron['comments'].dtype.str[2:])
for snefile, wl_range in zip(mooghydfiles,wl_ranges):
    print(snefile)
    # Strip CH lines
    ll = LineList.read(linemake_files+'/'+snefile+'_oldCH')
    ii = ~np.logical_and(ll["elem1"]=="H", ll["elem2"]=="C")
    print("{} CH lines being removed".format(np.sum(ii)))
    ll = ll[ii]
    
    # Have to match comment sizes...
    comments = ll['comments']
    ll.remove_column('comments')
    ncomment_sneden = int(comments.dtype.str[2:])
    ncomment = max(ncomment_masseron,ncomment_sneden)
    resized_comments = LineList.Column(comments, dtype=np.dtype("|S{}".format(ncomment)),
                                       name="comments")
    ll.add_column(resized_comments)
    
    # Cut Masseron to wl range
    ii = np.logical_and(masseron["wavelength"] >= wl_range[0], masseron["wavelength"] < wl_range[1])
    _masseron = masseron[ii]
    
    # Combine lines (NOT merge, don't want to check for conflicts)
    print("{} CH lines being added".format(len(_masseron)))
    new_ll = table.vstack([ll, _masseron])
    new_ll.sort('wavelength')
    print("Writing to",linemake_files+'/'+snefile)
    new_ll.write_moog(linemake_files+'/'+snefile)

    
