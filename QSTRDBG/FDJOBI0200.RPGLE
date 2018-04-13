      /IF NOT DEFINED(jobi0200_t)
      /DEFINE jobi0200_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0200                                      *
      *===============================================================*
      *
     D jobi0200_t      DS                  qualified           based(pDummy)
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  job                          10A
     D  user                         10A
     D  nbr                           6A
     D  intJobID                     16A
     D  status                       10A
     D  type                          1A
     D  subType                       1A
     D  sbsDName                     10A
     D  runPty                       10I 0
     D  sysPoolID                    10I 0
     D  prcTimeUsd                   10I 0
     D  numAuxIORq                   10I 0
     D  numIntTact                   10I 0
     D  rspTimeTot                   10I 0
     D  fncType                       1A
     D  fncName                      10A
     D  actJobSts                     4A
     D  numDBLckW                    10I 0
     D  numIntLckW                   10I 0
     D  numNonDBLckW                 10I 0
     D  timeDBLckW                   10I 0
     D  timeIntLckW                  10I 0
     D  timeNonDBLckW                10I 0
     D  reserved_01                   1A
     D  currSysPoolID                10I 0
     D  thrdCount                    10I 0
     D  prcUntTmUsd                  20U 0
     D  numAuxIORqLng                20U 0
     D  prcUntTmUsdDB                20U 0
     D  pageFaults                   20U 0
     D  actJobStsJobEnd...
     D                                4A
     D  memPoolName                  10A
     D  msgRply                       1A
      *
      /ENDIF
