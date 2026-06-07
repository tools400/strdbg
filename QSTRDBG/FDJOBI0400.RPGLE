**free
/if NOT defined(jobi0400_t)
/define jobi0400_t
//===============================================================*
//  QUSRJOBI API - JOBI0400                                      *
//===============================================================*

dcl-ds jobi0400_t qualified template;
  bytRet        int(10);
  bytAvl        int(10);
  job           char(10);
  user          char(10);
  nbr           char(6);
  intJobID      char(16);
  status        char(10);
  type          char(1);
  subType       char(1);
  dateTimeEnt   char(13);
  dateTimeAct   char(13);
  jobAcctCode   char(15);
  jobD          char(10);
  jobDLib       char(10);
  unitOfWorkID  char(24);
  mode          char(8);
  inqMsgRply    char(10);
  logCLPgms     char(10);
  brkMsgHdl     char(10);
  stsMsgHdl     char(10);
  devRcvrAct    char(13);
  ddmCnvHdl     char(10);
  dateSep       char(1);
  dateFmt       char(4);
  prtText       char(30);
  sbmJob        char(10);
  sbmUser       char(10);
  sbmNbr        char(6);
  sbmMsgQ       char(10);
  sbmMsgQLib    char(10);
  timeSep       char(1);
  ccsid         int(10);
  dateTimeScd   char(8);
  prtKeyFmt     char(10);
  sortSeq       char(10);
  sortSeqLib    char(10);
  langID        char(3);
  countryID     char(2);
  complSts      char(1);
  signedOnJob   char(1);
  jobSws        char(8);
  msgQFullAct   char(10);
  reserved_01   char(1);
  msgQMaxSize   int(10);
  dftCcsid      int(10);
  rtgData       char(80);
  decFmt        char(1);
  chrIDCtrl     char(10);
  serverType    char(30);
  alwMltThrds   char(1);
  jobLogPnd     char(1);
  reserved_02   char(1);
  jobEndRsn     int(10);
  jobTypeEnhncd int(10);
  dateTimeEnd   char(13);
  reserved_03   char(1);
  splFActn      char(10);
  ofsAspGrpInf  int(10);
  numEAspGrpInf int(10);
  lenAspGrpInfE int(10);
  timeZoneDscNm char(10);
  jobLogOutput  char(10);
end-ds;

/endif
