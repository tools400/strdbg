      /IF NOT DEFINED(jobl0100_t)
      /DEFINE jobl0100_t
      *===============================================================*
      *  QUSLJOB  API - JOBL0100                                      *
      *===============================================================*
      *
     D jobl0100_t      DS                  qualified           based(pDummy)
     D  job                          10A
     D  user                         10A
     D  nbr                           6A
     D  intJobID                     16A
     D  status                       10A
     D  type                          1A
     D  subType                       1A
     D  reserved_01                   2A
      *
      /ENDIF
