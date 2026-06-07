**free
//=====================================================================*
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : STRDBG                                             *
//  Objekt  . . . : STRDBGR                                            *
//  Beschreibung  : Start Debug with STRSRVJOB - CPP                   *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Datum . . . . : 22.06.2005                                         *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  18.12.2006  Th.Raddatz    Added parameter WIDESCN(*PRV|*NO|*YES).  *
//                                                                     *
//  26.01.2009  Th.Raddatz    Now monitoring QCMDEXC for errors and    *
//                            resending error message to command line. *
//                                                                     *
//  28.01.2009  Th.Raddatz    Fixed monitoring QCMDEXC for errors.     *
//                                                                     *
//  16.07.2011  Th.Raddatz    Changed program to clear the job         *
//                            EXIT and CANCEL keys.                    *
//                                                                     *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//   >>COMPILE<<                                                       *
//     >>PARM<< TRUNCNBR(*NO);                                         *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< OPTION(*EVENTF);                                       *
//   >>END-COMPILE<<                                                   *
//   >>EXECUTE<<                                                       *
//   >>CMD<<    CRTPGM       PGM(&LI/&OB) +                            *
//                           MODULE(&LI/&OB) +                         *
//                           ACTGRP(*NEW) +                            *
//                           BNDSRVPGM(*LIBL/BASICS1) +                *
//                           BNDDIR(QC2LE) +                           *
//                           DETAIL(*BASIC);                           *
// >>END-PRE-COMPILER<<                                                *
//=====================================================================*
/copy QSTRDBG,H_SPEC
/copy QSTRDBG,COPYRIGHT
//=====================================================================*
//
// ------------------------------------
//  Type definitions
// ------------------------------------
/copy QSTRDBG,TYPEDEF

//  Layout von pgmList_t:

//  1-2   Int2   Anzahl Einträge von pgmE_t
//  3-x   Int3   Offset zu Eintrag n von pgmE_t (max. 20 Offsets)
//  *     Char   pgmE_t

dcl-ds pgmList_t qualified template;
  numE   int(5);
  ofs    int(5) dim(20);
  buffer char(640);
end-ds;
//  buffer size:    max. 20 * 32 Byte Programm Eintrag     =  640 Byte
//                                                            --------
//                                                            640 Byte

dcl-ds pgmE_t qualified template;
  numE int(5);
  pgm  likeds(qObj_t);
  type char(10);
end-ds;

dcl-ds class_t qualified template;
  numE int(5);
  name varchar(5000) dim(10);
end-ds;

dcl-ds pgm_t qualified template;
  numE int(5);
  pgmE likeds(qObj_t) dim(20);
end-ds;

// ------------------------------------
//  Constants
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1
/copy QLSTJOB,PLSTJOB
/copy QSTRDBG,PSTRDBGR1
/copy QSTRDBG,QWCCCJOB

dcl-pr QCMDEXC extpgm('QCMDEXC');
  i_cmd         char(32702) options(*varsize) const;
  i_length      packed(15: 5) const;
  i_IGC_control char(3) options(*nopass) const;
end-pr;

//  Send Program Message (QMHSNDPM) API
dcl-pr QMHSNDPM extpgm('QMHSNDPM');
  i_msgID    char(7) const;
  i_qMsgF    char(20) const;
  i_msgData  char(32767) options(*varsize) const;
  i_length   int(10) const;
  i_msgType  char(10) const;
  i_callStkE char(32767) options(*varsize) const;
  i_callStkC int(10) const;
  o_msgKey   char(4);
  io_ErrCode char(32767) options(*varsize);
end-pr;

// Resend Escape Message (QMHRSNEM) API
dcl-pr QMHRSNEM extpgm('QMHRSNEM');
  i_msgKey     char(4) const;
  io_ErrCode   char(32767) options(*varsize);
  i_callStkE   char(32767) options(*nopass: *varsize) const;
  i_lenStkE    int(10) options(*nopass) const;
  i_fmtStkE    char(8) options(*nopass) const;
  i_frmStkEAdr char(16) options(*nopass) const;
  i_frmStkECnt int(10) options(*nopass) const;
end-pr;

//  Open List of Objects (QGYOLOBJ) API
dcl-pr QGYOLOBJ extpgm('QGYOLOBJ');
  o_rcvVar      char(32767) options(*varsize);
  i_lenRcvVar   int(10) const;
  o_listInf     char(80);
  i_numRcdRet   int(10) const;
  i_sortInf     char(32767) options(*varsize) const;
  i_qObj        char(20) const;
  i_objType     char(10) const;
  i_authCtrl    char(32767) options(*varsize) const;
  i_selectCtrl  char(32767) options(*varsize) const;
  i_numFldRet   int(10) const;
  i_keyOfFldRet char(32767) options(*varsize) const;
  io_ErrCode    char(32767) options(*varsize);
end-pr;

//  Get List Entries (QGYGTLE) API
dcl-pr QGYGTLE extpgm('QGYGTLE');
  o_rcvVar    char(32767) options(*varsize);
  i_lenRcvVar int(10) const;
  i_hRequest  char(4) const;
  o_listInf   char(80);
  i_numRcdRet int(10) const;
  i_startRcd  int(10) const;
  io_ErrCode  char(32767) options(*varsize);
end-pr;

//  Close List (QGYCLST) API
dcl-pr QGYCLST extpgm('QGYCLST');
  i_hRequest char(4) const;
  io_ErrCode char(32767) options(*varsize);
end-pr;

// ------------------------------------
//  Prototypes
// ------------------------------------
/copy QSTRDBG,PSTRDBGR

dcl-pr p_main;
  i_pgmList    likeds(pgmList_t) value;
  i_dspmodsrc  char(1) value;
  i_srcdbgpgm  likeds(qObj_t) value;
  i_dftpgm     char(10) value;
  i_maxtrc     int(5) value;
  i_trcfull    char(1) value;
  i_unmonpgm   likeds(qObj_t) value;
  i_updprod    char(1) value;
  i_opmsrc     char(1) value;
  i_srvPgmList likeds(pgm_t) value;
  i_class      likeds(class_t) value;
  i_qJob       likeds(qJob_t) value;
  i_alwWideScn char(1) value;
  o_msg        likeds(msg_t);
end-pr;

//  Abrufen Objekttyp.
dcl-pr f_rtvObjType char(10);
  i_obj char(10) value;
  i_lib char(10) value;
end-pr;

//  Signal error condition.
dcl-pr p_signalError;
  i_errText varchar(132) value;
end-pr;

//  Set screen size.
dcl-pr p_setScnSize;
  i_alwWideScn char(1) value;
end-pr;

//  Clear the job exit and cancel keys.
dcl-pr clearJobKeys;
end-pr;

// ------------------------------------
//  Global fields
// ------------------------------------
dcl-ds g_strsrvjob qualified;
  isActive ind inz(cFalse);
end-ds;
dcl-ds g_pssr qualified;
  isActive ind inz(cFalse);
end-ds;

// ------------------------------------
//  Global constants
// ------------------------------------
//  Parameter values: WIDESCN
dcl-c cWIDESCN_PRV 'P';
dcl-c cWIDESCN_NO 'N';
dcl-c cWIDESCN_YES 'Y';

//  Environment variable: ILE_DEBUGGER_1
dcl-c cENVVAR_ILE_DEBUGGER_1 'ILE_DEBUGGER_1';
dcl-c cVALUE_ALLOW_WIDE_SCREEN_YES 'ALLOW_WIDE_SCREEN';
dcl-c cVALUE_ALLOW_WIDE_SCREEN_NO 'DO_NOT_ALLOW_WIDE_SCREEN';

// ------------------------------------
//  Program Status Information
// ------------------------------------
dcl-ds sds qualified psds;
  pgmName       char(10) pos(1);
  statusCode    zoned(5) pos(11);
  statusCodePrv zoned(5) pos(16);
  srcLineNbr    char(8) pos(21);
  routine       char(8) pos(29);
  numParms      zoned(3) pos(37);
  msgID         char(7) pos(40);
  excType       char(3) overlay(msgID);
  excNbr        char(4) overlay(msgID: *next);
  reserved_1    char(4) pos(47);
  msgWorkArea   char(30) pos(51);
  pgmLib        char(10) pos(81);
  msgText       char(80) pos(91);
  excpID        char(4) pos(171);
  lastFileUsed  char(10) pos(175);
  reserved_2    char(6) pos(185);
  jobDate       char(8) pos(191);
  century       zoned(2) pos(199);
  lastFileUsed8 char(8) pos(201);
  lastFileStat  char(35) pos(209);
  job           char(10) pos(244);
  user          char(10) pos(254);
  nbr           char(6) pos(264);
  pgmDate       zoned(6) pos(270);
  date          zoned(6) pos(276);
  time          zoned(6) pos(282);
  pgmCrtDate    char(6) pos(288);
  pgmCrtTime    char(6) pos(294);
  compilerLvl   char(4) pos(300);
  srcFile       char(10) pos(304);
  srcLib        char(10) pos(314);
  srcMbr        char(10) pos(324);
  prcOfPgm      char(10) pos(334);
  prcOfMod      char(10) pos(344);
  Reserved      char(76) pos(354);
  curUsrPrf     char(10) pos(358);
end-ds;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi STRDBGR;
  gi_pgmList    likeds(pgmList_t) const;
  gi_dspmodsrc  char(1) const;
  gi_srcdbgpgm  likeds(qObj_t) const;
  gi_dftpgm     char(10) const;
  gi_maxtrc     int(5) const;
  gi_trcfull    char(1) const;
  gi_unmonpgm   likeds(qObj_t) const;
  gi_updprod    char(1) const;
  gi_opmsrc     char(1) const;
  gi_srvPgmList likeds(pgm_t) const;
  gi_class      likeds(class_t) const;
  gi_qJob       likeds(qJob_t) const;
  gi_alwWideScn char(1) const;
end-pi;

dcl-ds msg likeds(msg_t) inz;
dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

p_main(gi_pgmList   :
       gi_dspmodsrc :
       gi_srcdbgpgm :
       gi_dftpgm    :
       gi_maxtrc    :
       gi_trcfull   :
       gi_unmonpgm  :
       gi_updprod   :
       gi_opmsrc    :
       gi_srvPgmList:
       gi_class     :
       gi_qJob      :
       gi_alwWideScn:
       msg          );

if (msg.ID <> cMSG_ID_OK);
  msg.type = cMsg_Escape;
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
endif;

*inlr = *on;

return;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//   Error handle
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

begsr   *PSSR;

  if not g_pssr.isActive;
    g_pssr.isActive = cTrue;

    if g_strsrvjob.isActive = cTrue;
      QCMDEXC('ENDSRVJOB': 9);
    endif;

    errCode = f_newApiErrCode(cTrue);
    QMHRSNEM('': errCode);

  endif;

endsr   '*CANCL';


//===============================================================*
//  Haupsteuerung
//===============================================================*
dcl-proc p_main;
  dcl-pi *n;
    i_pgmList    likeds(pgmList_t) value;
    i_dspmodsrc  char(1) value;
    i_srcdbgpgm  likeds(qObj_t) value;
    i_dftpgm     char(10) value;
    i_maxtrc     int(5) value;
    i_trcfull    char(1) value;
    i_unmonpgm   likeds(qObj_t) value;
    i_updprod    char(1) value;
    i_opmsrc     char(1) value;
    i_srvPgmList likeds(pgm_t) value;
    i_class      likeds(class_t) value;
    i_qJob       likeds(qJob_t) value;
    i_alwWideScn char(1) value;
    o_msg        likeds(msg_t);
  end-pi;

  //  Hilfsfelder
  dcl-s keyPressed like(keyPressed_t) inz;
  dcl-ds qJob likeds(qJob_t) inz;
  dcl-s cmd varchar(32702) inz;
  dcl-s cmdStrSrvJob varchar(32702) inz;
  dcl-s x int(10) inz;
  dcl-ds pgmE likeds(pgmE_t) based(pPgmE);

  dcl-ds srvPgmList likeds(pgm_t);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  o_msg = f_newMsg(cMSG_ID_OK);

  // Übertragen Liste der Serviceprogramme in interne Tabelle
  clear srvPgmList;
  for x = 1 to i_srvPgmList.numE;
    srvPgmList.numE = srvPgmList.numE + 1;
    srvPgmList.pgmE(srvPgmList.numE).name = i_srvPgmList.pgmE(x).name;
    srvPgmList.pgmE(srvPgmList.numE).lib  = i_srvPgmList.pgmE(x).lib;
  endfor;

  // Tue es, bis wir fertig sind oder ein Fehler auftritt:
  dou '1';

    if i_qJob.name <> '*';
      g_pgm_strdbgr1 = %trim(sds.pgmLib) + '/' + 'STRDBGR1';
      STRDBGR1(i_qJob: qJob: keyPressed);
      if keyPressed <> cKEY_ENTER;
        leave;
      endif;

      // Produce STRSRVJOB command ...
      cmdStrSrvJob = 'STRSRVJOB';

      // ... add parameter JOB()
      cmdStrSrvJob = cmdStrSrvJob + ' JOB(' + %trimR(qJob.nbr)  + '/'
                                  + %trimR(qJob.user) + '/'
                                  + %trimR(qJob.name);
      cmdStrSrvJob = cmdStrSrvJob + ')';
    endif;

    // Set screen size
    p_setScnSize(i_alwWideScn);

    // Produce STRDBG command ...
    cmd = 'QSYS/STRDBG';

    // ... add parameter PGM()
    if i_pgmList.numE > 0;
      cmd = cmd + ' PGM(';

      for x = 1 to i_pgmList.numE;

        // Materialize next program object
        pPgmE = %addr(i_pgmList) + i_pgmList.ofs(x);

        // Get object type
        if pgmE.pgm.name <> '*NONE';
          if pgmE.type = '*AUTO';
            pgmE.type = f_rtvObjType(pgmE.pgm.name: pgmE.pgm.lib);
          endif;

          // Copy service programs to service program array
          if (pgmE.type = '*SRVPGM');
            if srvPgmList.pgmE(1).name = '*NONE';
              srvPgmList.pgmE(1).name = '';
              srvPgmList.pgmE(1).lib  = '';
              srvPgmList.numE = 0;
            endif;
            if srvPgmList.numE >= %elem(srvPgmList.pgmE);
              p_signalError('Number of service programs +
                             exceed maximum of ' +
                             %char(%elem(srvPgmList.pgmE)));
            endif;
            srvPgmList.numE = srvPgmList.numE + 1;
            srvPgmList.pgmE(srvPgmList.numE).name = pgmE.pgm.name;
            srvPgmList.pgmE(srvPgmList.numE).lib  = pgmE.pgm.lib;
            iter;
          endif;
        endif;

        // Send escape message on non-(service-)program objects
        if pgmE.pgm.name <> '*NONE';
          if (pgmE.type <> '*PGM') and (pgmE.type <> '*PGM');
            p_signalError('Program '     + %trimR(pgmE.pgm.name) +
                          ' in library ' + %trimR(pgmE.pgm.lib ) +
                          ' can not be accessed');
          endif;
        endif;

        // Produce parameter PGM()
        if x > 1;
          cmd = cmd + ' ';
        endif;

        if pgmE.pgm.lib <> '';
          cmd = cmd + %trimR(pgmE.pgm.lib ) + '/';
        endif;
        if pgmE.pgm.name <> '';
          cmd = cmd + %trimR(pgmE.pgm.name);
        endif;

      endfor;

      cmd = cmd + ')';
    endif;

    // ... add parameter DSPMODSRC()
    select;
    when i_dspmodsrc = 'P';
      cmd = cmd + ' DSPMODSRC(*PGMDEP)';
    when i_dspmodsrc = 'N';
      cmd = cmd + ' DSPMODSRC(*NO)';
    when i_dspmodsrc = 'Y';
      cmd = cmd + ' DSPMODSRC(*YES)';
    endsl;

    // ... add parameter SRCDBGPGM()
    cmd = cmd + ' SRCDBGPGM(';
    if i_srcdbgpgm.lib <> '';
      cmd = cmd + %trimR(i_srcdbgpgm.lib ) + '/';
    endif;
    if i_srcdbgpgm.name <> '';
      cmd = cmd + %trimR(i_srcdbgpgm.name);
    endif;
    cmd = cmd + ')';

    // ... add parameter DFTPGM()
    cmd = cmd + ' DFTPGM(' + %trimR(i_dftpgm) + ')';

    // ... add parameter MAXTRC()
    cmd = cmd + ' MAXTRC(' + %char(i_maxtrc) + ')';

    // ... add parameter TRCFULL()
    select;
    when i_trcfull = 'T';
      cmd = cmd + ' TRCFULL(*STOPTRC)';
    when i_trcfull = 'W';
      cmd = cmd + ' TRCFULL(*WRAP)';
    endsl;

    // ... add parameter UNMONPGM()
    cmd = cmd + ' UNMONPGM(';
    if i_unmonpgm.lib <> '';
      cmd = cmd + %trimR(i_unmonpgm.lib ) + '/';
    endif;
    if i_unmonpgm.name <> '';
      cmd = cmd + %trimR(i_unmonpgm.name);
    endif;
    cmd = cmd + ')';

    // ... add parameter UPDPROD()
    select;
    when i_updprod = 'N';
      cmd = cmd + ' UPDPROD(*NO)';
    when i_updprod = 'Y';
      cmd = cmd + ' UPDPROD(*YES)';
    endsl;

    // ... add parameter OPMSRC()
    select;
    when i_opmsrc = 'N';
      cmd = cmd + ' OPMSRC(*NO)';
    when i_opmsrc = 'Y';
      cmd = cmd + ' OPMSRC(*YES)';
    endsl;

    // ... add parameter SRVPGM()
    if srvPgmList.numE > 0;
      cmd = cmd + ' SRVPGM(';

      for x = 1 to srvPgmList.numE;

        // Produce parameter SRVPGM()
        if x > 1;
          cmd = cmd + ' ';
        endif;

        if srvPgmList.pgmE(x).lib <> '';
          cmd = cmd + %trimR(srvPgmList.pgmE(x).lib ) + '/';
        endif;
        if srvPgmList.pgmE(x).name <> '';
          cmd = cmd + %trimR(srvPgmList.pgmE(x).name);
        endif;

      endfor;

      cmd = cmd + ')';
    endif;

    // ... add parameter CLASS()
    if i_class.numE > 0;
      cmd = cmd + ' CLASS(';

      for x = 1 to i_class.numE;

        // Produce parameter CLASS()
        if x > 1;
          cmd = cmd + ' ';
        endif;

        cmd = cmd + %trimR(i_class.name(x));

      endfor;

      cmd = cmd + ')';
    endif;

    if i_qJob.name <> '*';
      // Process STRSRVJOB command
      monitor;
        QCMDEXC(cmdStrSrvJob: %len(cmdStrSrvJob));
      on-error;
        o_msg = f_rcvPgmMsgObj(cMsg_Any);
        leave;
      endmon;

      // Remember that STRSRVJOB is active
      g_strsrvjob.isActive = cTrue;
    endif;

    // Process STRDBG command
    monitor;
      QCMDEXC(cmd: %len(cmd));
    on-error;
      o_msg = f_rcvPgmMsgObj(cMsg_Any);
      leave;
    endmon;

  enddo;

  clearJobKeys();

  return;


end-proc;

//===============================================================*
//  Retrieve object type.
//===============================================================*
dcl-proc f_rtvObjType;
  dcl-pi *n char(10);
    i_obj char(10) value;
    i_lib char(10) value;
  end-pi;

  //  Return value
  dcl-s objType char(10) inz;

  //  Helper fields
  dcl-s i int(10) inz;

  dcl-ds obj qualified;
    name       char(10) inz;
    lib        char(10) inz;
    type       char(10) inz;
    infStat    char(1) inz;
    reserved_1 char(1) inz;
    numFldRet  int(10) inz;
  end-ds;

  dcl-ds listInf qualified;
    numRcdTot   int(10) inz;
    rcdRet      int(10) inz;
    hRequest    char(4) inz;
    rcdLen      int(10) inz;
    infCplInd   char(1) inz;
    datTimCrt   char(13) inz;
    listStatInd char(1) inz;
    reserved_1  char(1) inz;
    lenInfRet   int(10) inz;
    firstRcd    int(10) inz;
    reserved_2  char(40) inz;
  end-ds;

  dcl-ds sortInf qualified;
    numKeys int(10) inz;
  end-ds;

  dcl-ds authCtrl qualified;
    length      int(10) inz;
    callLvl     int(10) inz;
    ofsObjAuth  int(10) inz;
    numObjAuth  int(10) inz;
    ofsLibAuth  int(10) inz;
    numLibAuth  int(10) inz;
    reserved_1  char(4) inz;
    objAuthList likeds(authList_t) inz;
    libAuthList likeds(authList_t) inz;
  end-ds;

  dcl-ds selectCtrl qualified;
    length     int(10) inz;
    value      int(10) inz;
    ofsStat    int(10) inz;
    numStat    int(10) inz;
    reserved_1 int(10) inz;
    statList   likeds(statList_t) inz;
  end-ds;

  dcl-ds qObj likeds(qObj_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;

  dcl-ds authList_t qualified template;
    auth char(10) dim(1);
  end-ds;

  dcl-ds statList_t qualified template;
    stat char(1) dim(1);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qObj.name = i_obj;
  qObj.lib  = i_lib;

  authCtrl.length     = %size(authCtrl);
  authCtrl.callLvl    = 0;
  authCtrl.ofsObjAuth = %size(authCtrl) - %size(authCtrl.objAuthList)
                                        - %size(authCtrl.libAuthList);
  authCtrl.numObjAuth = 1;
  authCtrl.ofsLibAuth = %size(authCtrl) - %size(authCtrl.libAuthList);
  authCtrl.numLibAuth = 1;
  authCtrl.reserved_1 = *ALLx'00';
  authCtrl.objAuthList.auth(1) = '*EXECUTE';
  authCtrl.libAuthList.auth(1) = '*USE';

  selectCtrl.length     = %size(selectCtrl);
  selectCtrl.value      = 0;   // 0=select; 1=omit
  selectCtrl.ofsStat    = %size(selectCtrl) - %size(selectCtrl.statList);
  selectCtrl.numStat    = 1;
  selectCtrl.reserved_1 = 0;
  selectCtrl.statList.stat(1) = '*';

  clear obj;
  clear listInf;
  errCode = f_newApiErrCode(cTrue);

  // Open list of objects
  QGYOLOBJ(obj: 0: listInf: -1: sortInf: qObj: '*ALL':
           authCtrl: selectCtrl: 0: '': errCode);

  i = 0;
  dow (i < listInf.numRcdTot) and
      ((obj.type <> '*PGM') and (obj.type <> '*SRVPGM'));
    i = i + 1;
    // Get next object in list
    QGYGTLE(obj: %size(obj): listInf.hRequest: listInf: 1: i: errCode);
  enddo;

  // Close list of objects
  QGYCLST(listInf.hREquest: errCode);

  if (obj.type = '*PGM') or (obj.type = '*SRVPGM');
    objType = obj.type;
  else;
    objType = '*N';
  endif;

  return objType;


end-proc;

//===============================================================*
//  Signal error condition.
//===============================================================*
dcl-proc p_signalError;
  dcl-pi *n;
    i_errText varchar(132) value;
  end-pi;

  //  Helper fields
  dcl-s msgKey char(4) inz;
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qMsgF.name = 'QCPFMSG';
  qMsgF.lib  = '*LIBL';
  errCode = f_newApiErrCode(cFalse);
  QMHSNDPM('CPF9898': qMsgF: i_errText: %len(i_errText):
           '*ESCAPE': '*CTLBDY': 1: msgKey: errCode);

  return;


end-proc;

//===============================================================*
//  Set screen size. (Parameter: WIDESCN)
//===============================================================*
dcl-proc p_setScnSize;
  dcl-pi *n;
    i_alwWideScn char(1) value;
  end-pi;

  //  Helper fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  when i_alwWideScn = cWIDESCN_PRV;
  // Do not change environment variable
  when i_alwWideScn = cWIDESCN_NO;
    f_setEnvVar(cENVVAR_ILE_DEBUGGER_1
                : cVALUE_ALLOW_WIDE_SCREEN_NO);
  when i_alwWideScn = cWIDESCN_YES;
    f_setEnvVar(cENVVAR_ILE_DEBUGGER_1
                : cVALUE_ALLOW_WIDE_SCREEN_YES);
  endsl;

  return;


end-proc;

//===============================================================*
//  Clear the job exit and cancel keys.
//===============================================================*
dcl-proc clearJobKeys;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-ds chgJobInf likeds(QWCCCJOB_chgJobInf_t);
  dcl-ds errCode likeds(errCode_t);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  chgJobInf.numE = 2;

  chgJobInf.key(1).id     = QWCCCJOB_EXIT_KEY;
  chgJobInf.key(1).length = 1;
  chgJobInf.key(1).data   = '0';

  chgJobInf.key(2).id     = QWCCCJOB_CANCEL_KEY;
  chgJobInf.key(2).length = 1;
  chgJobInf.key(2).data   = '0';

  errCode = f_newApiErrCode(cTrue);
  QWCCCJOB(chgJobInf: errCode);

  return;


end-proc;

