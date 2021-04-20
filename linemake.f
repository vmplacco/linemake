
      program explinemake
c*****this routine substitutes good gf, hfs, and isotopic line values for
c     the ones found in an input line list
 
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(1000000), idi(1000000), epi(1000000), loggfi(1000000),
     .       wavex(1000000), idx(1000000), epx(1000000), loggfx(1000000),
     .       strengthx(1000000),
     .       waveg(80000), idg(80000), epg(80000), loggfg(80000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(1000000), textg(80000), textgin, textkin, 
     .             testchars, textx(1000000)
      character*1 choice


c*****declare internally where the good gf lists and the Kurucz lists are
      linepath = 
     .          '/Users/alexji/Dropbox/S5/linelists/linemake/mooglists'
      call countline (linepath, nlp)
      if (linepath(nlp:nlp) .ne. '/') then
         nlp = nlp + 1
         linepath(nlp:nlp) = '/'
      endif

c*****define the wavelength limits
      write (*,*) 'starting wavelength: '
      read (*,*) wavelo
      write (*,*) 'ending wavelength: '
      read (*,*) wavehi
      if (int(wavelo/1000.)-int(wavehi/1000.) .ne. 0) then
         write (*,1016)
         stop
      endif

c*****open the unsorted output line list
      noutunit = 2
      open (noutunit,file='outlines')

c*****start with the atomic lines
      call atomics

c*****add in "standard" molecular lines as desired
      write (*,*) 'add in molecular lines (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'y') then
c*****hydrides [CH,NH,OH,HF,MgH,HCl]
         call hydrides
c*****CN blue and red systems
         call cn
c*****C2 Swan bands
         call c2
c*****CO in the 1.0-9.8 micron range
         call co

c*****add in some low-temperature molecules as desired
         write (*,*) 'other molecules (y/n)? '
         call makechoice (choice)                             
         if (choice .eq. 'y') then
c*****SiH
            call sih
c*****TiO
            call tio
c*****H2O
            call h2o
c*****FeH
            call feh
         endif
      endif

c*****add in Kurucz hfs/iso inormation for Sc I, Sc II, and Cu I, as desired
      call kurhfsiso
                                                               
c*****write out the new line list
      do i=1,itot
         if (idi(i) .gt. 100.) then
            if (dble(nint(idi(i))) .eq. idi(i)) then
               write (noutunit,1010) wavei(i), idi(i), epi(i), 
     .                               loggfi(i), texti(i)
            else
               write (noutunit,1011) wavei(i), idi(i), epi(i), 
     .                               loggfi(i), texti(i)
            endif
         else 
            if (dble(nint(10.*idi(i))) .eq. 10.*idi(i)) then
               write (noutunit,1008) wavei(i), idi(i), epi(i), 
     .                               loggfi(i), texti(i)
            else
               write (noutunit,1007) wavei(i), idi(i), epi(i), 
     .                               loggfi(i), texti(i)
            endif
         endif
      enddo
      close (unit=noutunit)


c*****now sort that list in wavelength order, and throw away the negative
c*****wavelengths
      call system ('sort -bn -o outtemp -k 1 outlines')
      nunit = 7
      open (nunit,file='outtemp')
      noutunit = 8
      open (noutunit,file='outsort')
      write (noutunit,1013) wavelo, wavehi
      do i=1,100000
         call blankstring (string)
         read (nunit,1014,end=60) string(1:80)
         read (string,*) wavegin
         if (wavegin .lt. 0.) cycle
         write (noutunit,1014) string(1:80)
      enddo


c*****end normally
60    close (unit=nunit)
      close (unit=noutunit)
      call system ('\rm outtemp')
      write (*,*) 'DONE!  CHECK THE LINE LIST CAREFULLY!'


c*****format statements
1007  format (f10.3, f10.4, f10.3, f10.3, a40)
1008  format (f10.3, f10.1, f10.3, f10.2, a40)
1010  format (f10.3, f10.1, f10.3, f10.3, a40)
1011  format (f10.3, f10.5, f10.3, f10.3, a40)
1013  format ('a line list in the range: ', 2f10.2)
1014  format (a80)
1016  format ('SORRY! linemake cannot handle beginning and ending '/
     .        'wavelengths that cross 1000-Angstrom divisions.'/
     .        'Please execute linemake twice, below and above the ',
     .        'divisions.'/
     .        'For example, if you want a list 5990-6010A,'/
     .        'merge lists 5990-5999.999A and 6000-6010A')
     .        

      end


                                                              
                                                              
                                                              
c***********************************************************************    
      subroutine atomics
c***********************************************************************    
c*****this routine combines information from the Kurucz atomic lines
c*****database with the improved (mostly lab experimental from U Wisconsin) 
c*****transition probabilities, hyperfine and isotopic substructure
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

c*****open the appropriate Kurucz atomic line file
      if (nint(wavelo).ge.100000 .or. nint(wavehi).ge.100000 .or.
     .    nint(wavelo).lt.  1200 .or. nint(wavehi).lt.  1200) then
         write (*,1010) wavelo, wavehi
         stop
      endif
      nlist = 13
      iwavelo1000 = 1000*int((wavelo+0.01)/1000.)
      if     (nint(wavelo) .lt. 10000) then
         write (inlist(1:nlist),1002) iwavelo1000
      elseif (nint(wavelo) .lt. 12000) then
         write (inlist(1:nlist),1014) iwavelo1000
      elseif (nint(wavelo) .lt. 30000) then
         inlist(1:nlist) = 'moogatom12000'
      else
         inlist(1:nlist) = 'moogatom30000'
      endif
      nunit = 1
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .                nunit)

c*****read in the Kurucz lines
      i = 0
      do k=1,1000000
         write (textkin,1009)
         read (nunit,1001,end=10) wavekin, idkin, epkin, loggfkin, 
     .                            textkin
         if (wavekin .lt. wavelo) cycle
         if (wavekin .gt. wavehi) exit
         i = i + 1
         wavei(i) = wavekin                                   
         idi(i) = idkin                                       
         epi(i) = epkin                                       
         loggfi(i) = loggfkin                                  
         texti(i) = textkin
      enddo
10    itot = i
      close (unit=nunit)

c*****open the good gf list; read in its lines
      nlist = 6
      call blankstring (inlist)
      inlist(1:nlist) = 'goodgf'
      nunit = 3
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .               nunit)
      j = 0
      do k=1,400000
         write (textgin,1009)
         read (nunit,1001,end=15) wavegin, idgin, epgin, loggfgin, 
     .                            textgin
         if (wavegin .lt. wavelo) cycle
         if (wavegin .gt. wavehi) exit
         j = j + 1
         waveg(j) = wavegin
         idg(j) = idgin
         epg(j) = epgin
         loggfg(j) = loggfgin
         textg(j) = textgin
      enddo
15    ngood = j
      close (unit=nunit)

c*****use the good gf list to change gfs or add to Kurucz list
      if (j .eq. 0) then
         write (*,1004)
      else
         do j=1,ngood
            match = 0
            do i=1,itot
               if (dabs(wavei(i)-waveg(j)) .lt. 0.03 .and.
     .             dabs(idi(i)-idg(j)) .lt. 0.001 .and.
     .             dabs(epi(i)-epg(j)) .lt. 0.03) then
                  wavei(i) = waveg(j)
                  idi(i) = idg(j)
                  epi(i) = epg(j)
                  loggfi(i) = loggfg(j)
                  texti(i) = textg(j)
                  write (*,1005) wavei(i), idi(i)
                  match = 1
                  exit
               endif
            enddo
            if (match .eq. 0) then 
               itot = itot + 1
               if (itot .gt. 99999) call shutdown
               wavei(itot) = waveg(j)
               idi(itot) = idg(j)
               epi(itot) = epg(j)
               loggfi(itot) = loggfg(j)
               texti(itot) = textg(j)
               write (*,1005) wavei(itot), idi(itot)
            endif
         enddo
      endif
         
c*****open the file of good gfs with hyperfine/isotopic; read the data
      call blankstring (inlist)
      nlist = 9
      inlist(1:nlist) = 'goodgfhfs'
      nunit = 4
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .               nunit)
      j = 0
      do k=1,400000
         read (nunit,1001,end=20) wavegin, idgin, epgin, loggfgin, 
     .                            textgin
         if (dabs(wavegin).lt.wavelo .or.
     .       dabs(wavegin).gt.wavehi) cycle
         j = j + 1
         waveg(j) = wavegin
         idg(j) = idgin
         epg(j) = epgin
         loggfg(j) = loggfgin
         textg(j) = textgin
      enddo
20    close (unit=nunit)
      ngood = j

c*****go through the good gf/hfs list, replacing the single lines in
c     the original list or adding in as necessary
      do k=1,ngood
         if (waveg(k) .lt. 0.) then
            do i=1,itot
               if (dabs(wavei(i)-dabs(waveg(k))) .lt. 0.10 .and.
     .             dabs(idi(i)-idg(k)) .lt. 0.001 .and.
     .             dabs(epi(i)-epg(k)) .lt. 0.03) then
                      wavei(i) = -wavei(i)
                      write (*,1006) -waveg(k), idg(k)
               endif
            enddo
         else
            itot = itot + 1
            if (itot .gt. 99999) call shutdown
            wavei(itot) = waveg(k)
            idi(itot) = idg(k)
            epi(itot) = epg(k)
            loggfi(itot) = loggfg(k)
            texti(itot) = textg(k)
         endif
      enddo
      return

1001  format (4f10.1, a40) 
1002  format ('moogatom0', i4)
1004  format ('no updated gf values to add in from good list')
1005  format ('replacing log(gf) from good list: ', f10.3, f10.1)
1006  format ('adding new line with hfs/iso components: ',
     .           f10.3, f10.1)
1009  format ('                                        ')
1010  format ('REQUESTED WAVELENGTH RANGE OUT OF BOUNDS: ', 2f9.1)
1014  format ('moogatom', i5)
     
      end





c***********************************************************************
      subroutine hydrides
c***********************************************************************
c*****including CH, NH, OH, HF, MgH, HCl
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'hydrides [CH,NH,OH,HF,MgH,HCl] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).lt.2040 .or. nint(wavehi).lt.2040) then
         write (*,1010)                                       
         nlist = -1                                           
         return                                               
      endif                                                   
      nlist = 12                                              
      if     (nint(wavelo) .lt.  3000) then                      
         inlist(1:nlist) = 'mooghyd02000'                      
      elseif (nint(wavelo) .lt.  4000) then                      
         inlist(1:nlist) = 'mooghyd03000'                      
      elseif (nint(wavelo) .lt.  6000) then                      
         inlist(1:nlist) = 'mooghyd04000'                      
      elseif (nint(wavelo) .lt. 10000) then                      
         inlist(1:nlist) = 'mooghyd06000'                      
      else                                                    
         inlist(1:nlist) = 'mooghyd10000'                     
      endif 
      nunit = 8
      call openfile (inlist, nlist, linepath, nlp, string,
     .               nstring, nunit)

      do k=1,1000000
         read (nunit,1001,end=10) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         intidg = int(100000.*idgin+0.001)
         if (intidg.eq.10700115 .or. intidg .eq.10800118) cycle
         intidg = int(idgin+0.001)
         if (intidg .eq. 108) then
            if (wavegin.gt.3400.0 .and. wavegin.lt.9999.0) cycle
         endif
         if (intidg .eq. 107 .and.  wavegin .gt. 3500.) cycle
         if (intidg .eq. 112 .and.  wavegin .lt. 4500.) cycle
         itot = itot + 1
         if (itot .gt. 99999) call shutdown
         wavei(itot) = wavegin
         idi(itot) = idgin
         epi(itot) = epgin
         loggfi(itot) = loggfgin
         texti(itot) = textgin
      enddo
10    close (unit=nunit)
      return

1001  format (4f10.1, a40)
1010  format (
     .     'IGNORING HYDRIDE REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')

      end

               

c***********************************************************************
      subroutine cn
c***********************************************************************
c*****CN blue and red systems
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'CN [blue and red systems] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).ge.30000 .or. nint(wavehi).ge.30000 .or.
     .    nint(wavelo).lt. 3000 .or. nint(wavehi).lt. 3000) then
         write (*,1010)
         return
      endif
      nlist = 11
      if     (nint(wavelo) .lt.  4000) then
         inlist(1:nlist) = 'moogcn02000'
      elseif (nint(wavelo) .lt.  5000) then
         inlist(1:nlist) = 'moogcn04000'
      elseif (nint(wavelo) .lt.  7000) then
         inlist(1:nlist) = 'moogcn05000'
      elseif (nint(wavelo) .lt. 10000) then
         inlist(1:nlist) = 'moogcn07000'
      else
         nlist = 11
         inlist(1:nlist) = 'moogcn10000'
      endif
      nunit = 9
      call openfile (inlist, nlist, linepath, nlp, string, 
     .               nstring, nunit)

      do k=1,1000000
         read (nunit,1001,end=10) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         intidg = int(100000.*idgin+0.001)
         if (epgin.le.4.5 .and. intidg .ne. 60701215) then
            itot = itot + 1
            if (itot .gt. 99999) call shutdown
            wavei(itot) = wavegin
            idi(itot) = idgin
            epi(itot) = epgin
            loggfi(itot) = loggfgin
            texti(itot) = textgin
         endif
      enddo
10    close (unit=nunit)
      return

1001  format (4f10.1, a40)
1010  format (
     .     'IGNORING CN REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')

      end



c***********************************************************************
      subroutine c2
c***********************************************************************
c*****C2 Swan bands with E.P < 4.5 eV
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'C2 [Swan bands] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).ge.5980 .or. nint(wavehi).ge.5980 .or.
     .    nint(wavelo).lt.3000 .or. nint(wavehi).lt.3000) then
         write (*,1010)
         return
      endif
      nlist = 11
      if     (nint(wavelo) .lt.  5000) then
         inlist(1:nlist) = 'moogc204000'
      else
         inlist(1:nlist) = 'moogc205000'
      endif
      nunit = 30
      call openfile (inlist, nlist, linepath, nlp, string,
     .               nstring, nunit)

      do k=1,1000000
         read (nunit,1001,end=10) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         if (epgin .lt. 4.5) then
            itot = itot + 1
            if (itot .gt. 99999) call shutdown
            wavei(itot) =  wavegin
            idi(itot) = idgin
            epi(itot) = epgin
            loggfi(itot) = loggfgin
            texti(itot) = textgin
         endif
      enddo
10    close (unit=nunit)
      return

1001  format (4f10.1, a40)
1010  format (
     .     'IGNORING C_2 REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')

      end



c***********************************************************************
      subroutine co
c***********************************************************************
c*****only included if wavelengths are between 1.0 and 9.8 microns
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'CO [1.0-9.8 microns] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).lt.10000 .or. nint(wavelo) .gt.97000) then
         write (*,1010)                                       
         return                                               
      endif                                                   
      nlist = 6                                               
      inlist(1:nlist) = 'moogco'                              
      nunit = 10
      call openfile (inlist, nlist, linepath, nlp, string,
     .               nstring, nunit)

      do k=1,1000000
         read (nunit,1001,end=10) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         itot = itot + 1
         if (itot .gt. 99999) call shutdown
         wavei(itot) = wavegin
         idi(itot) = idgin
         epi(itot) = epgin
         loggfi(itot) = loggfgin                     
         texti(itot) = textgin                       
      enddo                                          
10    close (unit=nunit)                             
      return                                                  
                                                              
1001  format (4f10.1, a40)                                    
1010  format (                                                
     .     'IGNORING CO REQUEST; BEGINNING WAVELENGTH OUT OF BOUNDS')
                                                              
      end 
                                       


*****************************************************************
      subroutine sih
c***********************************************************************    
c*****this routine simply makes the user select 'y' or 'n' 
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'SiH [solar isotopic mix] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).lt.3000 .or. nint(wavelo).gt.7000) then
         write (*,1010)
         return
      endif
      nlist = 7
      inlist(1:nlist) = 'moogsih'
      nunit = 10
      call openfile (inlist, nlist, linepath, nlp, string,
     .               nstring, nunit)

      strengthmax = -1000.
      ktotx = 0
      do k=1,1000000
         read (nunit,1001,end=91) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         ktotx = ktotx + 1
         wavex(ktotx) = wavegin
         idx(ktotx) = idgin
         epx(ktotx) = epgin
         idinteger = nint(1.0d5*idx(ktotx))
         if     (idinteger .eq. 11400128) then
            loggfx(ktotx) = dlog10(0.92223*10.**loggfgin)
         elseif (idinteger .eq. 11400129) then
            loggfx(ktotx) = dlog10(0.04685*10.**loggfgin)
         elseif (idinteger .eq. 11400130) then
            loggfx(ktotx) = dlog10(0.03092*10.**loggfgin)
         else
            write (*,*) 'something wrong with SiH; I QUIT!'
            stop
         endif
         strengthx(ktotx) = loggfx(ktotx) - 1.5*epx(ktotx)
            if (strengthx(ktotx) .gt. strengthmax)
     .          strengthmax = strengthx(ktotx)
         textx(ktotx) = textgin
      enddo

      do k=1,ktotx                                
         if (strengthx(k) .ge. strengthmax-1.) then
            itot = itot + 1                       
            if (itot .gt. 99999) call shutdown
            wavei(itot) = wavex(k)                
            idi(itot) = idx(k)                    
            epi(itot) = epx(k)                    
            loggfi(itot) = loggfx(k)              
            texti(itot) = textx(k)                
         endif                                    
      enddo                                       
91    close (unit=nunit)                             
      return                                                  
                                                              
1001  format (4f10.1, a40)                                    
1010  format (
     .     'IGNORING SiH REQUEST; BEGINNING WAVELENGTH OUT OF BOUNDS')
                                                              
      end



*****************************************************************
      subroutine kurhfsiso
c***********************************************************************
c*****put in Kurucz hfs/iso inormation for Sc I, Sc II, and Cu I;
c*****Kurucz has no hfs/iso info for the other odd-Z Fe-peak first ions; 
c*****the hfs for Mn I & Mn II are already done earlier because the lab 
c*****studies have put them into the googf and goodgfhfs lists
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

c*****find the possible Kurucz iso/hfs features in this region
      write (*,*) 'add Kurucz hfs for Fe-group lines without recent'
      write (*,*) 'lab studies, [Sc I, Sc II, & Cu I] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return
      call blankstring (inlist)
      nlist = 9
      inlist(1:nlist) = 'kurgfhfs'
      nunit = 4
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .               nunit)
      j = 0
      do k=1,400000
         read (nunit,1001,end=50) wavegin, idgin, epgin, loggfgin,
     .                            textgin
         if (dabs(wavegin).lt.wavelo .or.
     .       dabs(wavegin).gt.wavehi) cycle
         j = j + 1
         waveg(j) = wavegin
         idg(j) = idgin
         epg(j) = epgin
         loggfg(j) = loggfgin
         textg(j) = textgin
      enddo
50    close (unit=nunit)
      ngood = j

c*****go through this list, replacing the single lines in the original 
c*****list or adding in as necessary              
      do k=1,ngood
         if (waveg(k) .lt. 0.) then
            do i=1,itot
               if (dabs(wavei(i)-dabs(waveg(k))) .lt. 0.10 .and.
     .             dabs(idi(i)-idg(k)) .lt. 0.001 .and.
     .             dabs(epi(i)-epg(k)) .lt. 0.03) then
                   wavei(i) = -wavei(i)
                   write (*,1006) -waveg(k), idg(k)
               endif
            enddo
         else
            itot = itot + 1
            if (itot .gt. 99999) call shutdown
            wavei(itot) = waveg(k)
            idi(itot) = idg(k)
            epi(itot) = epg(k)
            loggfi(itot) = loggfg(k)
            texti(itot) = textg(k)
         endif
      enddo
      return

1001  format (4f10.1, a40)
1006  format ('adding new line with hfs/iso components: ',
     .           f10.3, f10.1)
      end




c***********************************************************************
      subroutine tio
c***********************************************************************
c*****including CH, NH, OH, HF, MgH, HCl
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'TiO (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return
      write (*,*) 'only do 48^TiO [that is, ignore ',
     .            '{46,47,49,50}^TiO] (y/n)? '
      call makechoice (choice)

c*****start with 48TiO
      if (nint(wavelo).lt.3000 .or. nint(wavehi).gt.49999) then
         write (*,1010)
         nlist = -1
         return
      endif
      nlist = 14
      if     (nint(wavelo) .lt.  10000) then
         nwave1000 = nint(wavelo)/1000
         write (inlist(1:nlist),1002) nwave1000
      elseif (nint(wavelo) .lt. 12000) then
         inlist(1:nlist) = 'moog48tio10000'
      elseif (nint(wavelo) .lt. 20000) then
         inlist(1:nlist) = 'moog48tio12000'
      elseif (nint(wavelo) .lt. 30000) then
         inlist(1:nlist) = 'moog48tio20000'
      elseif (nint(wavelo) .lt. 40000) then
         inlist(1:nlist) = 'moog48tio30000'
      elseif (nint(wavelo) .lt. 50000) then
         inlist(1:nlist) = 'moog48tio40000'
      endif                                                   
      nunit = 8                                               
      call openfile (inlist, nlist, linepath, nlp, string,    
     .               nstring, nunit)                          
                                                              
      do k=1,1000000                                          
         read (nunit,1001,end=10) wavegin, idgin, epgin,      
     .                            loggfgin, textgin           
         if (wavegin .gt. wavehi) exit                        
         if (wavegin .lt. wavelo) cycle                       
         itot = itot + 1                                      
         if (itot .gt. 99999) call shutdown
         wavei(itot) = wavegin                                
         idi(itot) = idgin                                    
         epi(itot) = epgin                                    
         loggfi(itot) = loggfgin                              
         texti(itot) = textgin                                
      enddo                                                   
10    close (unit=nunit)                                      
      if (choice .eq. 'y') return

c*****then add in minor istopic lines if the user is a masochist;
c*****the gf-values of the minor isotopes ^[46,47,49,50]TiO
c*****will be multiplied by the solar isotopic abundance ratios with
c*****respect to ^48Ti:
c*****^46TiO: 0.0825/0.7372 = 0.1119     log = -0.951
c*****^47TiO: 0.0744/0.7372 = 0.1009     log = -0.996
c*****^49TiO: 0.0541/0.7372 = 0.0734     log = -1.134
c*****^50TiO: 0.0518/0.7372 = 0.0702     log = -1.153
      string(1:4) = inlist(1:4)
      string(5:7) = 'min'
      string(8:15) = inlist(7:14)
      nlist = 15
      inlist(1:nlist) = string(1:nlist)
      nunit = 9
      call openfile (inlist, nlist, linepath, nlp, string,
     .               nstring, nunit)
      do k=1,1000000
         read (nunit,1001,end=20) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         itot = itot + 1
         if (itot .gt. 99999) call shutdown
         wavei(itot) = wavegin
         idi(itot) = idgin
         epi(itot) = epgin
         iso = nint(100000.*idgin) - 82200000
         if (iso .eq. 1646) loggfi(itot) = loggfgin - 0.951
         if (iso .eq. 1647) loggfi(itot) = loggfgin - 0.996
         if (iso .eq. 1649) loggfi(itot) = loggfgin - 1.134
         if (iso .eq. 1650) loggfi(itot) = loggfgin - 1.153
         texti(itot) = textgin
      enddo
20    close (unit=nunit)                                      




      return                                                  
                                                              
1001  format (4f10.1, a40)                                    
1002  format ('moog48tio0', i1, '000')
1010  format (                                                
     .     'IGNORING TiO REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')      
                                                              
      end                                                     
                                                              
                                                              
                       
c***********************************************************************
      subroutine h2o
c***********************************************************************
c*****when finished, will include lots of HiTRAN lines
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'H2O [0.8-5.0 microns] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).lt.8000 .or. nint(wavehi).gt.49999) then
         write (*,1010)
         nlist = -1
         return
      endif
      nlist = 12
      if     (nint(wavelo) .lt.  10000) then
         nwave1000 = nint(wavelo)/1000                        
         write (inlist(1:nlist),1002) nwave1000               
      elseif (nint(wavelo) .lt. 12000) then                   
         inlist(1:nlist) = 'moogh2o10000'                     
      elseif (nint(wavelo) .lt. 20000) then                   
         inlist(1:nlist) = 'moogh2o12000'                     
      elseif (nint(wavelo) .lt. 30000) then                   
         inlist(1:nlist) = 'moogh2o20000'                     
      elseif (nint(wavelo) .lt. 40000) then                   
         inlist(1:nlist) = 'moogh2o30000'                     
      elseif (nint(wavelo) .lt. 50000) then                   
         inlist(1:nlist) = 'moogh2o40000'                     
      endif                                                   
      nunit = 9
      call openfile (inlist, nlist, linepath, nlp, string,
     .               nstring, nunit)

      do k=1,1000000
         read (nunit,1001,end=10) wavegin, idgin, epgin,
     .                            loggfgin, textgin
         if (wavegin .gt. wavehi) exit
         if (wavegin .lt. wavelo) cycle
         itot = itot + 1
         if (itot .gt. 99999) call shutdown
         wavei(itot) = wavegin
         idi(itot) = idgin
         epi(itot) = epgin
         loggfi(itot) = loggfgin
         texti(itot) = textgin
      enddo
10    close (unit=nunit)
      return

1001  format (4f10.1, a40)
1002  format ('moogh2o0', i1, '000') 
1010  format (
     .     'IGNORING H2O REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')

      end



c***********************************************************************
      subroutine feh
c***********************************************************************
c*****two sources: Kurucz and Hargreaves et al. (2010); see code
c*****writeup for explanation.
      common /values/ wavei, idi, epi, loggfi,
     .       wavex, idx, epx, loggfx,
     .       strengthx,
     .       waveg, idg, epg, loggfg,
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi,
     .       molatom, nlist, itot, nlp, nstring, nunit, noutunit
      common /chars/ inlist, outlist, linepath, string,
     .       texti, textg, textgin, textkin,
     .       testchars, textx,
     .       choice
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000),
     .       wavex(100000), idx(100000), epx(100000), loggfx(100000),
     .       strengthx(100000),
     .       waveg(40000), idg(40000), epg(40000), loggfg(40000),
     .       wavegin, idgin, epgin, loggfgin,
     .       wavekin, idkin, epkin, loggfkin,
     .       wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin,
     .             testchars, textx(100000)
      character*1 choice

      write (*,*) 'FeH [0.6-5.0 microns] (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'n') return

      if (nint(wavelo).lt.6000 .or. nint(wavehi).gt.49999) then
         write (*,1010)
         nlist = -1
         return
      endif
      nlist = 12
      if     (nint(wavelo) .lt.  10000) then                  
         inlist(1:nlist) = 'moogfeh06000'
      elseif (nint(wavelo) .lt. 15000) then                   
         inlist(1:nlist) = 'moogfeh10000'                     
      elseif (nint(wavelo) .lt. 50000) then                   
         inlist(1:nlist) = 'moogfeh15000'                     
      endif                                                   
      nunit = 16
      call openfile (inlist, nlist, linepath, nlp, string,    
     .               nstring, nunit)                          
                                                              
      do k=1,1000000                                          
         read (nunit,1001,end=10) wavegin, idgin, epgin,      
     .                            loggfgin, textgin           
         if (wavegin .gt. wavehi) exit                        
         if (wavegin .lt. wavelo) cycle                       
         itot = itot + 1                                      
         if (itot .gt. 99999) call shutdown
         wavei(itot) = wavegin                                
         idi(itot) = idgin                                    
         epi(itot) = epgin                                    
         loggfi(itot) = loggfgin                              
         texti(itot) = textgin                                
      enddo                                                   
10    close (unit=nunit)                                      
      return                                                  
                                                              
1001  format (4f10.1, a40)                                    
1010  format (                                                
     .     'IGNORING FeH REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')
                                                              
      end



                    
*****************************************************************
      subroutine makechoice (choice)
c***********************************************************************
c*****this routine simply makes the user select 'y' or 'n'
      character*1 choice

1     read (*,*) choice
      if (choice.ne.'y' .and. choice.ne.'n') go to 1
      return

      end





c***********************************************************************
      subroutine openfile (wantfile, nwant, path, npath, 
     .                     string, nstring, nunit)
c***********************************************************************
c     this routine concatenates the line file "wantfile" name with 
c     the path name to that file "path", calls the result "string",
c     and opens up the string as unit "nunit"

      integer nwant, npath, nstring, nunit
      character*80 wantfile, path, string

      write (string,1020)
1020  format (80(' '))

      nstring = nwant + npath
      string(1:npath) = path(1:npath)
      string(npath+1:nstring) = wantfile(1:nwant)
      open (nunit,file=string(1:nstring))

      return
      end




c***********************************************************************
      subroutine countline (string, numchar)
c***********************************************************************
c     this routine figures out how many characters a line of text has;
c     the string is presumed to have a max of 80 characters

      integer numchar
      character*80 string

      do i=80,1,-1
         if (string(i:i) .ne. ' ') then
            numchar = i
            return
         endif
      enddo
      write (*,*) 'empty string, I quit!'
      stop

      end



c***********************************************************************
      subroutine blankstring (string)
c***********************************************************************
c     this routine simply makes an 80-character string all blanks

      implicit real*8 (a-h,o-z)
      character*80 string


      do i=1,80
         string(i:i) = ' '
      enddo
      return


      end



c***********************************************************************
      subroutine shutdown
c***********************************************************************
c     this routine calls a halt to the code if the number of lines
c     exceeds 99,999; the arrays have space for "only" 100,000 lines

      write (*,1001)
      
1001  format (' '/
     .        '-----------------------------------------------------'/
     .        '# of lines in the output list exceeds 100,000;'/
     .        'maybe reduce the wavelength range?'/
     .        'UNTIL THEN, I QUIT!'/
     .        '-----------------------------------------------------')

      stop

      end
     .        






