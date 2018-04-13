      /IF NOT DEFINED(QWCCCJOB)
      /DEFINE QWCCCJOB
      *
      *  Change Current Job (QWCCCJOB) API
     D QWCCCJOB...
     D                 PR                  extpgm('QWCCCJOB')
     D  i_chgJobInf               65535A   const  options(*varsize)
     D  io_errCode                65535A          options(*varsize)
      *
      *  Change job information
     D QWCCCJOB_chgJobInf_t...
     D                 DS                  qualified           based(pDummy)
     D  numE                         10I 0
     D  key                                likeds(QWCCCJOB_varLenRcd_t)
     D                                     dim(2)
      *
      *  Change job variable length record entry
     D QWCCCJOB_varLenRcd_t...
     D                 DS                  qualified           based(pDummy)
     D  id                           10I 0
     D  length                       10I 0
     D  data                          1A
      *
     D QWCCCJOB_EXIT_KEY...
     D                 C                   1
     D QWCCCJOB_CANCEL_KEY...
     D                 C                   2
      *
      /ENDIF
