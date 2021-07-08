from alexmods.linelists import LineList
from astropy.table import vstack
import numpy as np
import time

ch_loggfmin = -6
outfname = "super_master_list.moog"

if __name__=="__main__":
    waves = [3000, 4000, 5000, 6000, 7000, 8000]
    fnames = [f"full_linemake{wave}.moog" for wave in waves]
    start = time.time()
    lls = [LineList.read(fn) for fn in fnames]
    print(f"Took {time.time()-start}s to read all linelists")
    
    # Cut CH
    print(f"Cutting CH at loggf >= {ch_loggfmin}")
    new_lls = []
    for ll,fn in zip(lls,fnames):
        ii1 = ll["element"] == "C-H"
        ii2 = ii1 & (ll["loggf"] < ch_loggfmin)
        print(f"{fn}: {len(ll)} total, {np.sum(ii1)} CH lines, {np.sum(ii2)} to cut")
        new_lls.append(ll[~ii2])
    
    new_ll = vstack(new_lls)
    new_ll.write_moog(outfname)
    print(f"Wrote to {outfname}")
    
