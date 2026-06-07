**free
//=====================================================================*
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : ENDDBG                                             *
//  Objekt  . . . : ENDDBGR                                            *
//  Beschreibung  : End Debug Mode with ENDSRVJOB - CPP                *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Datum . . . . : 22.06.2005                                         *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
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
//                           BNDDIR(QC2LE) +                           *
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

// ------------------------------------
//  Constants
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

dcl-pr QCMDEXC extpgm('QCMDEXC');
  i_cmd         char(32702) options(*varsize) const;
  i_length      packed(15: 5) const;
  i_IGC_control char(3) options(*nopass) const;
end-pr;

//  Process Commands (QCAPCMD) API
dcl-pr QCAPCMD extpgm('QCAPCMD');
  i_cmd              char(32702) options(*varsize) const;
  i_cmdLength        int(10) const;
  i_optCtrlBlk       char(32767) options(*varsize) const;
  i_optCtrlBlkLength int(10) const;
  i_optCtrlBlkFormat char(8) const;
  o_chgCmd           char(32702) options(*varsize);
  i_chgCmdLength     int(10) const;
  o_chgCmdLengthAvl  int(10);
  io_errorCode       char(32767) options(*varsize);
end-pr;

dcl-pr QMHRMVPM extpgm('QMHRMVPM');
  i_callStkE    char(10) const;
  i_callStkC    int(10) const;
  i_msgKey      char(4) const;
  i_msgToRmv    char(10) const;
  i_errCode     char(65535) options(*varsize) const;
  i_lenCallStkE int(10) options(*nopass) const;
  i_callStkEQ   char(20) options(*nopass) const;
  i_rmvUnhExcp  char(10) options(*nopass) const;
  i_callStkEDT  char(10) options(*nopass) const;
  i_alwDftRpyRj char(10) options(*nopass) const;
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

// ------------------------------------
//  Prototypes
// ------------------------------------
/copy QSTRDBG,PENDDBGR

dcl-pr p_main;
end-pr;

// ------------------------------------
//  Global fields
// ------------------------------------
dcl-ds g_pssr qualified;
  isActive ind inz(cFalse);
end-ds;

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
dcl-pi ENDDBGR;
end-pi;

dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

p_main();

*inlr = *on;

return;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//   Error handle
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

begsr   *PSSR;

  if not g_pssr.isActive;
    g_pssr.isActive = cTrue;

    errCode = f_newApiErrCode(cTrue);
    QMHRSNEM('': errCode);

  endif;

endsr   '*CANCL';


//===============================================================*
//  Haupsteuerung
//===============================================================*
dcl-proc p_main;
  dcl-pi *n;
  end-pi;

  //  Schleifensteuerung
  dcl-s isDone ind inz(cFalse);
  dcl-s isError ind inz(cFalse);

  //  Hilfsfelder
  dcl-s cmd varchar(32702) inz;

  //  Helper fields QCAPCMD
  dcl-ds optCtrlBlk qualified;
    typeCmdPrc   int(10) inz(0);
    DBCS_data    char(1) inz('0');
    prmtAction   char(1) inz('0');
    cmdStrSyntax char(1) inz('0');
    msgRtvKey    char(4) inz(*blanks);
    res_01       char(9) inz(*ALLx'00');
  end-ds;

  dcl-s chgCmd char(128) inz;
  dcl-s chgCmdBytAvl int(10) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Tue es , bis wir fertig sind oder ein Fehler auftritt:
  dou isDone or isError;

    // Produce ENDDBG command ...
    cmd = 'QSYS/ENDDBG';

    // Process ENDDBG command
    QCMDEXC(cmd: %len(cmd));

    // Produce ENDSRVJOB command ...
    cmd = 'ENDSRVJOB';

    // Process ENDSRVJOB command
    reset optCtrlBlk;
    errCode = f_newApiErrCode(cTrue);
    QCAPCMD(cmd: %len(cmd): optCtrlBlk: %size(optCtrlBlk): 'CPOP0100':
            chgCmd: 0: chgCmdBytAvl: errCode);

    if errCode.bytAvl <> 0;
      errCode = f_newApiErrCode(cTrue);
      QMHRMVPM('*': 0: '': '*ALL': errCode);
    endif;

    // Everything is done
    isDone = cTrue;
  enddo;

  return;


end-proc;

