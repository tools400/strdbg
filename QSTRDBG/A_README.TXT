STRDBG - A Tools/400 Utility
----------------------------

STRDBG is utility for starting and ending the 5250 IBM debugger. The
advantage of the utility over the IBM STRDBG command is, that it
automatically starts a service job when the user wants to debug
a different job.

Dependencies: BASICS1, LSTJOB

Compile members with the following PDM option:                                                     
                                                                          
   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO) 
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)          
     USER1(*LIST) USER2(*FULL)                                            

Members of type MAKPGM or BND are used for linking programs (MAKPGM) 
and service programs (BND).

2018, Thomas Raddatz