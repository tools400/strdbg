**free
/if NOT defined(jobi0200_t)
/define jobi0200_t
//===============================================================*
//  QUSRJOBI API - JOBI0200                                      *
//===============================================================*

dcl-ds jobi0200_t qualified template;
  bytRet          int(10);
  bytAvl          int(10);
  job             char(10);
  user            char(10);
  nbr             char(6);
  intJobID        char(16);
  status          char(10);
  type            char(1);
  subType         char(1);
  sbsDName        char(10);
  runPty          int(10);
  sysPoolID       int(10);
  prcTimeUsd      int(10);
  numAuxIORq      int(10);
  numIntTact      int(10);
  rspTimeTot      int(10);
  fncType         char(1);
  fncName         char(10);
  actJobSts       char(4);
  numDBLckW       int(10);
  numIntLckW      int(10);
  numNonDBLckW    int(10);
  timeDBLckW      int(10);
  timeIntLckW     int(10);
  timeNonDBLckW   int(10);
  reserved_01     char(1);
  currSysPoolID   int(10);
  thrdCount       int(10);
  prcUntTmUsd     uns(20);
  numAuxIORqLng   uns(20);
  prcUntTmUsdDB   uns(20);
  pageFaults      uns(20);
  actJobStsJobEnd char(4);
  memPoolName     char(10);
  msgRply         char(1);
end-ds;

/endif
