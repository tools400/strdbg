      /IF NOT DEFINED(jobi0400_t)
      /DEFINE jobi0400_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0400                                      *
      *===============================================================*
      *
     D jobi0400_t      DS                  qualified           based(pDummy)
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  job                          10A
     D  user                         10A
     D  nbr                           6A
     D  intJobID                     16A
     D  status                       10A
     D  type                          1A
     D  subType                       1A
     D  dateTimeEnt                  13A
     D  dateTimeAct                  13A
     D  jobAcctCode                  15A
     D  jobD                         10A
     D  jobDLib                      10A
     D  unitOfWorkID                 24A
     D  mode                          8A
     D  inqMsgRply                   10A
     D  logCLPgms                    10A
     D  brkMsgHdl                    10A
     D  stsMsgHdl                    10A
     D  devRcvrAct                   13A
     D  ddmCnvHdl                    10A
     D  dateSep                       1A
     D  dateFmt                       4A
     D  prtText                      30A
     D  sbmJob                       10A
     D  sbmUser                      10A
     D  sbmNbr                        6A
     D  sbmMsgQ                      10A
     D  sbmMsgQLib                   10A
     D  timeSep                       1A
     D  ccsid                        10I 0
     D  dateTimeScd                   8A
     D  prtKeyFmt                    10A
     D  sortSeq                      10A
     D  sortSeqLib                   10A
     D  langID                        3A
     D  countryID                     2A
     D  complSts                      1A
     D  signedOnJob                   1A
     D  jobSws                        8A
     D  msgQFullAct                  10A
     D  reserved_01                   1A
     D  msgQMaxSize                  10I 0
     D  dftCcsid                     10I 0
     D  rtgData                      80A
     D  decFmt                        1A
     D  chrIDCtrl                    10A
     D  serverType                   30A
     D  alwMltThrds                   1A
     D  jobLogPnd                     1A
     D  reserved_02                   1A
     D  jobEndRsn                    10I 0
     D  jobTypeEnhncd                10I 0
     D  dateTimeEnd                  13A
     D  reserved_03                   1A
     D  splFActn                     10A
     D  ofsAspGrpInf                 10I 0
     D  numEAspGrpInf                10I 0
     D  lenAspGrpInfE                10I 0
     D  timeZoneDscNm                10A
     D  jobLogOutput                 10A
      *
      /ENDIF
