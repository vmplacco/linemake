
      program linemake
c*****this routine substitutes good gf, hfs, and isotopic line values for
c     the ones found in an input line list
 
      real*8 wavei(100000), idi(100000), epi(100000), loggfi(100000)
      real*8 waveg(40000), idg(40000), epg(40000), loggfg(40000) 
      real*8 wavegin, idgin, epgin, loggfgin
      real*8 wavekin, idkin, epkin, loggfkin
      real*8 wavelo, wavehi
      integer molatom, nlist, itot, nlp, nstring, nunit, noutunit
      character*80 inlist, outlist, linepath, string
      character*40 texti(100000), textg(40000), textgin, textkin, 
     .             testchars
      character*1 choice


c*****declare internally where the good gf lists and the Kurucz lists are
      linepath = 
     .          '/Users/vplacco/posdoc/linemake/mooglists'
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


c*****name and open the output line list
      noutunit = 2
      open (noutunit,file='outlines')


c*****choose and open the input atomic line file
      molatom = 1
      call whichfile (molatom, wavelo, wavehi, inlist, nlist)
      nunit = 1
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .                nunit)


c*****read in the Kurucz database lines for this wavelength region
      i = 0
      do k=1,1000000
         write (textkin,1009)
         read (nunit,1012,end=10) wavekin, idkin, epkin, loggfkin, 
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


c*****read in lines from the good gf list
      nlist = 6
      call blankstring (inlist)
      inlist(1:nlist) = 'goodgf'
      nunit = 3
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .               nunit)
      j = 0
      do k=1,400000
         write (textgin,1009)
         read (nunit,1012,end=15) wavegin, idgin, epgin, loggfgin, 
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
                  write (*,1001) wavei(i), idi(i)
                  match = 1
                  exit
               endif
            enddo
            if (match .eq. 0) then 
               itot = itot + 1
               wavei(itot) = waveg(j)
               idi(itot) = idg(j)
               epi(itot) = epg(j)
               loggfi(itot) = loggfg(j)
               texti(itot) = textg(j)
               write (*,1003) wavei(itot), idi(itot)
            endif
         enddo
      endif

         
c*****open the file of good gfs with hyperfine/isotopic, read the data
      call blankstring (inlist)
      nlist = 9
      inlist(1:nlist) = 'goodgfhfs'
      nunit = 4
      call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .               nunit)
      j = 0
      do k=1,400000
         read (nunit,1012,end=20) wavegin, idgin, epgin, loggfgin, 
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
            wavei(itot) = waveg(k)
            idi(itot) = idg(k)
            epi(itot) = epg(k)
            loggfi(itot) = loggfg(k)
            texti(itot) = textg(k)
         endif
      enddo


c*****if desired, add in molecular lines
      write (*,*) 'add in molecular lines (y/n)? '
      call makechoice (choice)
      if (choice .eq. 'y') then


c*****first add the hydrides
         write (*,*) 'hydrides (y/n)? '
         call makechoice (choice)
         if (choice .eq. 'y') then
            molatom = 2
            call whichfile (molatom, wavelo, wavehi, inlist, nlist)
            if (nlist .gt. 0) then
               nunit = 8
               call openfile (inlist, nlist, linepath, nlp, string, 
     .                        nstring, nunit)
               do k=1,1000000
                  read (nunit,1012,end=25) wavegin, idgin, epgin, 
     .                                     loggfgin, textgin
                  if (wavegin .gt. wavehi) exit
                  if (wavegin .lt. wavelo) cycle
                  intidg = int(100000.*idgin+0.001)
                  if (intidg .eq. 10700115 .or. 
     .                intidg .eq. 10800118) cycle
                  intidg = int(idgin+0.001)
                  if (intidg .eq. 114) cycle
                  if (intidg .eq. 108) then
                     if (wavegin .gt.3400.0 .and.
     .                   wavegin .lt.9999.0) cycle
                     endif
                  if (intidg .eq. 107 .and. 
     .                wavegin .gt. 3500.) cycle
                  if (intidg .eq. 112 .and. 
     .                wavegin .lt. 4950.) cycle
                  itot = itot + 1
                  wavei(itot) = wavegin
                  idi(itot) = idgin
                  epi(itot) = epgin
                  loggfi(itot) = loggfgin
                  texti(itot) = textgin
               enddo
25             close (unit=nunit)
            endif
         endif


c*****then CN
         write (*,*) 'CN (y/n)? '
         call makechoice (choice)
         if (choice .eq. 'y') then
            molatom = 3
            call whichfile (molatom, wavelo, wavehi, inlist, nlist)
            if (nlist .gt. 0) then
               nunit = 9
               call openfile (inlist, nlist, linepath, nlp, string, 
     .                        nstring, nunit)
               do k=1,1000000
                  read (nunit,1012,end=30) wavegin, idgin, epgin, 
     .                                     loggfgin, textgin
                  if (wavegin .gt. wavehi) exit              
                  if (wavegin .lt. wavelo) cycle
                  intidg = int(100000.*idgin+0.001)
                  if (epgin.le.4.5 .and. intidg .ne. 60701215) then
                     itot = itot + 1
                     wavei(itot) = wavegin
                     idi(itot) = idgin 
                     epi(itot) = epgin 
                     loggfi(itot) = loggfgin
                     texti(itot) = textgin
                  endif
               enddo
30             close (unit=nunit)
            endif
         endif


c*****then C2
         write (*,*) 'C2 (y/n)? '
         call makechoice (choice)
         if (choice .eq. 'y') then
            molatom = 4
            call whichfile (molatom, wavelo, wavehi, inlist, nlist)
            if (nlist .gt. 0) then
               nunit = 30
               call openfile (inlist, nlist, linepath, nlp, string, 
     .                        nstring, nunit)
               do k=1,1000000
                  read (nunit,1012,end=35) wavegin, idgin, epgin, 
     .                                     loggfgin, textgin
                  if (wavegin .gt. wavehi) exit
                  if (wavegin .lt. wavelo) cycle
                  if (epgin .lt. 4.5) then
                     itot = itot + 1
                     wavei(itot) =  wavegin
                     idi(itot) = idgin
                     epi(itot) = epgin
                     loggfi(itot) = loggfgin
                     texti(itot) = textgin
                  endif
               enddo
35             close (unit=nunit)
            endif
         endif


c*****then CO if beyond 1 micron
         write (*,*) 'CO (y/n)? '
         call makechoice (choice)
         if (choice .eq. 'y') then
            molatom = 5
            call whichfile (molatom, wavelo, wavehi, inlist, nlist)
            if (nlist .gt. 0) then
               nunit = 10
               call openfile (inlist, nlist, linepath, nlp, string, 
     .                        nstring, nunit)
               do k=1,1000000
                  read (nunit,1012,end=40) wavegin, idgin, epgin, 
     .                                     loggfgin, textgin
                  if (wavegin .gt. wavehi) exit
                  if (wavegin .lt. wavelo) cycle
                  itot = itot + 1
                  wavei(itot) = wavegin
                  idi(itot) = idgin
                  epi(itot) = epgin
                  loggfi(itot) = loggfgin
                  texti(itot) = textgin
               enddo
40             close (unit=nunit)
            endif
         endif
      endif


c*****put in Kurucz hfs/iso inormation for Sc I, Sc II,
c     and Cu I, if desired (Kurucz has no hfs/iso info for 
c     the other odd-Z Fe-peak first ions); the hfs for Mn I & Mn II are
c     already done earlier because the lab studies have put them
c     into the googf and goodgfhfs lists
      write (*,*) 'add Kurucz hfs for Fe-group lines without recent'
      write (*,*) 'lab studies, including lines of Sc I, Sc II,',
     .            ' & Cu I (y/n)? '
      call makechoice (choice)                             
      if (choice .eq. 'y') then
         call blankstring (inlist)                                
         nlist = 9                                                
         inlist(1:nlist) = 'kurgfhfs'                            
         nunit = 4                                                
         call openfile (inlist, nlist, linepath, nlp, string, nstring,
     .                  nunit)                                    
         j = 0                                                    
         do k=1,400000                                            
            read (nunit,1012,end=50) wavegin, idgin, epgin, loggfgin, 
     .                               textgin                      
            if (dabs(wavegin).lt.wavelo .or.                      
     .          dabs(wavegin).gt.wavehi) cycle                    
            j = j + 1                                             
            waveg(j) = wavegin                                    
            idg(j) = idgin                                        
            epg(j) = epgin                                        
            loggfg(j) = loggfgin                                  
            textg(j) = textgin                                    
         enddo                                                    
50       close (unit=nunit)                                       
         ngood = j                                                
                                                               
                                                               
c*****go through the good gf/hfs list, replacing the single lines in
c     the original list or adding in as necessary              
         do k=1,ngood                                             
            if (waveg(k) .lt. 0.) then                            
               do i=1,itot                                        
                  if (dabs(wavei(i)-dabs(waveg(k))) .lt. 0.10 .and.
     .                dabs(idi(i)-idg(k)) .lt. 0.001 .and.        
     .                dabs(epi(i)-epg(k)) .lt. 0.03) then         
                         wavei(i) = -wavei(i)                     
                         write (*,1006) -waveg(k), idg(k)         
                  endif                                           
               enddo                                              
            else                                                  
               itot = itot + 1                                    
               wavei(itot) = waveg(k)                             
               idi(itot) = idg(k)                                 
               epi(itot) = epg(k)                                 
               loggfi(itot) = loggfg(k)                           
               texti(itot) = textg(k)                             
            endif                                                 
         enddo                                                    
      endif


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
1001  format ('replacing log(gf) from good list: ', f10.3, f10.1)
1002  format ('input starting wavelength too long for good gf list')
1003  format ('adding new line from good list: ', f10.3, f10.1)
1004  format ('no updated gf values to add in from good list')
1006  format ('adding new line with hfs/iso components: ', 
     .           f10.3, f10.1)
1007  format (f10.3, f10.4, f10.3, f10.3, a40)
1008  format (f10.3, f10.1, f10.3, f10.2, a40)
1009  format ('                                        ')
1010  format (f10.3, f10.1, f10.3, f10.3, a40)
1011  format (f10.3, f10.5, f10.3, f10.3, a40)
1012  format (4f10.1, a40) 
1013  format ('a line list in the range: ', 2f10.2)
1014  format (a80)
1015  format (a12)
1016  format ('SORRY! linemake cannot handle beginning and ending '/
     .        'wavelengths that cross 1000-Angstrom divisions.'/
     .        'Please execute linemake twice, below and above the ',
     .        'divisions.'/
     .        'For example, if you want a list 5990-6010A,'/
     .        'merge lists 5990-5999.999A and 6000-6010A')
     .        


      end




c***********************************************************************
      subroutine makechoice (choice)
c***********************************************************************
c*****this routine simply makes the user select 'y' or 'n'
      character*1 choice

1     read (*,*) choice
      if (choice.ne.'y' .and. choice.ne.'n') go to 1
      return

      end




c***********************************************************************
      subroutine whichfile (molatom, wavelo, wavehi, inlist, nlist)
c***********************************************************************
c     this routine looks at files containing atomic and molecular 
c     line lists (mostly from the Kurucz database); "linetype" 
c     tells which type of line file to choose from

      real*8 wavelo, wavehi
      integer molatom, nlist
      integer intwavelo, lowave, lowave1000, hiwave
      character*80 inlist

      lowave = int(wavelo + 0.0001) + 20
      lowave1000 = lowave/1000
      intwavelo = 1000*lowave1000
      hiwave = int(wavehi + 0.0001)
      write (inlist,1020) 

      go to (1,2,3,4,5,6), molatom


c*****identify the proper Kurucz atomic line file; if the wavelengths
c*****are < 1200A or >99999A then stop the program
1     if (lowave.ge.100000 .or. hiwave.ge.100000 .or.
     .    lowave.lt.  1200 .or. hiwave.lt.  1200) then
         write (*,1001) wavelo, wavehi
         stop
      endif
      if     (intwavelo .lt. 10000) then
         nlist = 12
         write (inlist(1:nlist),1002) intwavelo
         return
      elseif (intwavelo .lt. 12000) then
         nlist = 13
         write (inlist(1:nlist),1014) intwavelo
         return
      elseif (intwavelo .lt. 30000) then
         nlist = 13
         inlist(1:nlist) = 'moogatom12000'
         return
      else
         nlist = 13
         inlist(1:nlist) = 'moogatom30000'
         return
      endif

c*****identify the proper hydride line file
2     if (lowave.lt.2040 .or. hiwave.lt.2040) then
         write (*,1003)
         nlist = -1
         return
      endif
      nlist = 11
      if     (intwavelo .lt.  3000) then
         inlist(1:nlist) = 'mooghyd2000'
      elseif (intwavelo .lt.  4000) then
         inlist(1:nlist) = 'mooghyd3000'
      elseif (intwavelo .lt.  6000) then
         inlist(1:nlist) = 'mooghyd4000'
      elseif (intwavelo .lt. 10000) then
         inlist(1:nlist) = 'mooghyd6000'
      else
         nlist = 12
         inlist(1:nlist) = 'mooghyd10000'
      endif
      return

c*****identify the proper CN line file
3     if (lowave.ge.30000 .or. hiwave.ge.30000 .or.
     .    lowave.lt. 3000 .or. hiwave.lt. 3000) then
         write (*,1005)
         nlist = -1
         return
      endif
      nlist = 10
      if     (intwavelo .lt.  4000) then
         inlist(1:nlist) = 'moogcn2000'
      elseif (intwavelo .lt.  5000) then
         inlist(1:nlist) = 'moogcn4000'
      elseif (intwavelo .lt.  7000) then
         inlist(1:nlist) = 'moogcn5000'
      elseif (intwavelo .lt. 10000) then
         inlist(1:nlist) = 'moogcn7000'
      else   
         nlist = 11
         inlist(1:nlist) = 'moogcn10000'
      endif
      return

c*****identify the proper C_2 line file
4     if (lowave.ge.5980 .or. hiwave.ge.5980 .or.
     .    lowave.lt.3000 .or. hiwave.lt.3000) then
         write (*,1008)
         nlist = -1
         return
      endif
      nlist = 10
      if     (intwavelo .lt.  5000) then
         inlist(1:nlist) = 'moogc24000'
      else
         inlist(1:nlist) = 'moogc25000'
      endif
      return

c*****identify the proper Kurucz CO line file
5     if (lowave.lt.10000 .or. lowave.gt.97000) then
         write (*,1010)
         nlist = -1
         return
      endif
      nlist = 6
      inlist(1:nlist) = 'moogco'
      return

6     return

c*****format statements
1001  format ('REQUESTED WAVELENGTH RANGE OUT OF BOUNDS: ', 2f9.1)
1002  format ('moogatom', i4)
1003  format (
     .     'IGNORING HYDRIDE REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')
1004  format ('mooghyd', i4)
1005  format (
     .     'IGNORING CN REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')
1006  format ('moogcnbx', i4)
1007  format ('moogcnax', i4)
1008  format (
     .     'IGNORING C_2 REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')
1010  format (
     .     'IGNORING CO REQUEST; WAVELENGTH RANGE OUT OF BOUNDS')
1014  format ('moogatom', i5)
1020  format (80(' '))


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


