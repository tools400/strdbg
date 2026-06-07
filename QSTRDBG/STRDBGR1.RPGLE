**free
//=====================================================================*
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : STRDBG                                             *
//  Objekt  . . . : STRDBGR1                                           *
//  Beschreibung  : Start Debug - Select Job                           *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Datum . . . . : 22.06.2005                                         *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  07.12.2006  Th.Raddatz    Added procedure lf_getUniqueJob().       *
//                                                                     *
//  04.04.2008  Th.Raddatz    Replaced external data structures:       *
//                               XDJOBI0200                            *
//                               XDJOBI0400                            *
//                               XDJOBL0100                            *
//                                                                     *
//  23.05.2013  Th.Raddatz    Fixed problem, that SFLEND was not       *
//                            properly displayed. (End/More...)        *
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
//                           ACTGRP(*CALLER) +                         *
//                           BNDSRVPGM(*LIBL/BASICS1  +                *
//                                     *LIBL/LSTJOB ) +                *
//                           BNDDIR(QC2LE) +                           *
//                           DETAIL(*BASIC);                           *
// >>END-PRE-COMPILER<<                                                *
//=====================================================================*
/copy QSTRDBG,H_SPEC
/copy QSTRDBG,COPYRIGHT
//=====================================================================*
dcl-f STRDBGFM workstn(*ext) usage(*input: *output) usropn extfile(g_dspF)
  indds(workstnInd) infds(workstnInf) sfile(PBSFL: g_sflrrn);

dcl-s g_dspF char(21) inz;
dcl-s g_sflrrn int(5) inz;

dcl-ds workstnInd qualified;
  sflNxtChg    ind pos(84);
  B_OPTION_RI  ind pos(85);
  B_OPTION_PC  ind pos(86);
  sflDsp       ind pos(80);
  sflDspCtl    ind pos(81);
  sflClr       ind pos(82);
  sflEnd       ind pos(83);
  isWideScreen ind pos(88);
end-ds;

dcl-ds workstnInf qualified;
  key char(1) pos(369);
end-ds;

// ------------------------------------
//  Type definitions
// ------------------------------------
/copy QSTRDBG,TYPEDEF
/copy QSTRDBG,FDJOBI0200
/copy QSTRDBG,FDJOBI0400
/copy QSTRDBG,FDJOBL0100

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QLSTJOB,PLSTJOB
/copy QBASICS1,PBASICS1

dcl-pr QCMDEXC extpgm('QCMDEXC');
  i_cmd         char(32702) options(*varsize) const;
  i_length      packed(15: 5) const;
  i_IGC_control char(3) options(*nopass) const;
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
/define PI_LITERAL
/copy QSTRDBG,PSTRDBGR1
/undefine PI_LITERAL

dcl-pr p_main;
  i_qJob   likeds(qJob_t) const;
  o_qJob   likeds(qJob_t);
  o_cmdKey like(keyPressed_t);
end-pr;

//  Laden Subfile
dcl-pr lf_loadSubfile ind;
  hJobs like(lstJob_handle_t) const;
end-pr;

//  Löschen Subfile
dcl-pr lp_clearSubfile;
end-pr;

//  Anzeigen Subfile, warten auf Benutzereingaben
dcl-pr lf_showScreen like(keyPressed_t);
end-pr;

//  Verarbeiten Subfile-Eingaben
dcl-pr lf_doSubfileOptions ind;
  o_qJob likeds(qJob_t);
end-pr;

//  Lesen geänderten Subfile-Datensatz
dcl-pr lf_readc ind;
  o_SUBFILE likerec(PBSFL);
end-pr;

//  Prüfen Subfile-Datensatz
dcl-pr lf_isSubfileRecordValid ind;
  i_SUBFILE_IN likerec(PBSFL: *input) value;
end-pr;

//  Prüfen Subfile-Auswahl
dcl-pr lf_isSubfileOptionValid ind;
  i_option like(B_OPTION) value;
end-pr;

//  Löschen Subfile Fehlerbezugszahlen
dcl-pr lf_clearSubfileErrorIndicator;
end-pr;

//  Laden Texte für Subfiledatensatz
dcl-pr lf_loadSubfileText likerec(PBSFL: *OUTPUT);
  i_SUBFILE_OUT likerec(PBSFL: *OUTPUT);
end-pr;

//  Laden Update Image für Subfiledatensatz
dcl-pr lf_loadSubfileOutImage likerec(PBSFL: *OUTPUT);
  i_SUBFILE_IN likerec(PBSFL: *input);
end-pr;

//  Prüfen auf eindeutige Jobauswahl und ermitteln Job.
dcl-pr lf_getUniqueJob ind;
  hJobs like(lstJob_handle_t) const;
  q1Job likeds(qJob_t);
end-pr;

//  Prüfen, ob der Jobstatus gültig ist.
dcl-pr lf_isJobStatusValid ind;
  jobStatus char(10) const;
end-pr;

//  Initialisieren Programm
dcl-pr lp_initProgram;
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
dcl-pi STRDBGR1;
  gi_qJob   likeds(qJob_t) const;
  go_qJob   likeds(qJob_t);
  go_cmdKey like(keyPressed_t);
end-pi;

dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

p_main(gi_qJob: go_qJob: go_cmdKey);

*inlr = *on;

return;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//   Error handle
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

begsr   *PSSR;

  if not g_pssr.isActive;
    g_pssr.isActive = cTrue;

    errCode = f_newApiErRCode(cTrue);
    QMHRSNEM('': errCode);

  endif;

endsr   '*CANCL';


//===============================================================*
//  Haupsteuerung
//===============================================================*
dcl-proc p_main;
  dcl-pi *n;
    i_qJob   likeds(qJob_t) const;
    o_qJob   likeds(qJob_t);
    o_cmdKey like(keyPressed_t);
  end-pi;

  //  Schleifensteuerung
  dcl-s isDone ind inz(cFalse);
  dcl-s isError ind inz(cFalse);
  dcl-s doShowScreen ind inz(cTrue);
  dcl-s key like(keyPressed_t) inz;

  //  Hilfsfelder
  dcl-s hJobs like(lstJob_handle_t) inz;
  dcl-ds q1Job likeds(qJob_t) inz;
  //jobl0100        DS                  likeds(jobl0100_t )     inz
  //jobi0200        DS                  likeds(jobi0200_t )     inz
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Initialisieren Programm
  lp_initProgram();

  // Tue es , bis wir fertig sind oder ein Fehler auftritt:
  dou isDone or isError;

    // Abrufen Job-Liste
    f_opnJobLst(i_qJob.name: i_qJob.user: i_qJob.nbr:
                cLSTJOB_STATUS_ALL: cLSTJOB_ORDERBY_NAME_DESC: hJobs);

    // Wenn nur 1 Job den Suchkriterien entspricht, ...
    if lf_getUniqueJob(hJobs: q1Job);
      // ... dann diesen Job direkt als gefunden
      //     zurück geben.
      o_qJob = q1Job;
      // ... fake that ENTER was pressed
      key    = cKEY_ENTER;
      // ... leave processing loop
      isDone = cTrue;
      leave;
    endif;

    // Öffnen Bildschirmdatei
    g_dspF = %trim(sds.pgmLib) + '/' + 'STRDBGFM';
    open STRDBGFM;

    // Füllen Subfile
    lf_loadSubfile(hJobs);

    // Ausgeben Bildschirm
    doShowScreen = cTrue;

    dow doShowScreen;

      key = lf_showScreen();

      // Verarbeiten Eingabe für ...
      select;
      // ... F3
      when key = cKEY_F3;
        doShowScreen = cFalse;
      // ... F5
      when key = cKEY_F5;
        if (not HANDLE_isNull(hJobs));
          f_cloJobLst(hJobs);
        endif;
        f_opnJobLst(i_qJob.name: i_qJob.user: i_qJob.nbr:
                    cLSTJOB_STATUS_ALL: cLSTJOB_ORDERBY_NAME_DESC:
                    hJobs);
        lf_loadSubfile(hJobs);
        doShowScreen = cTrue;
      // ... F12
      when key = cKEY_F12;
        doShowScreen = cFalse;
      // ... ENTER
      when key = cKEY_ENTER;
        if lf_doSubfileOptions(o_qJob);
          doShowScreen = cTrue;
        else;
          doShowScreen = cFalse;
        endif;
      endsl;

    enddo;

    // Everything is done
    isDone = cTrue;
  enddo;

  o_cmdKey = key;

  // Schließen Bildschirmdatei
  if %open(STRDBGFM);
    close STRDBGFM;
    g_dspF = '';
  endif;

  // Schließen Liste der Jobs
  if (not HANDLE_isNull(hJobs));
    f_cloJobLst(hJobs);
  endif;

  return;


end-proc;

//===============================================================*
//  Laden Subfile
//===============================================================*
dcl-proc lf_loadSubfile;
  dcl-pi *n ind;
    hJobs like(lstJob_handle_t) const;
  end-pi;

  //  Return value
  dcl-s isData ind inz(cFalse);

  //  Schleifensteuerung
  dcl-s isDone ind inz(cFalse);
  dcl-s isError ind inz(cFalse);

  //  Hilfsfelder
  dcl-s x int(10) inz;
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds jobl0100 likeds(jobl0100_t) inz;
  dcl-ds jobi0200 likeds(jobi0200_t) inz;
  dcl-ds jobi0400 likeds(jobi0400_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Löschen Subfile
  lp_clearSubfile();

  // Lesen Jobs
  for x = 1 to f_getNumJobAvl(hJobs);

    // Abrufen ersten/nächsten Job
    if x = 1;
      f_getFirstJob(hJobs: jobl0100);
    else;
      f_getNextJob(hJobs: jobl0100);
    endif;

    if lf_isJobStatusValid(jobl0100.status);

      // Abrufen zusätzlicher Job-Attribute
      jobi0200 = f_rtvJobA(jobl0100.intJobID: 'JOBI0200': msg);
      jobi0400 = f_rtvJobA(jobl0100.intJobID: 'JOBI0400': msg);

      // Löschen Subfile-Felder
      clear ds_SUBFILE_OUT;

      // Laden versteckte Felder
      ds_SUBFILE_OUT.H_JOB      = jobi0400.job;
      ds_SUBFILE_OUT.H_USER     = jobi0400.user;
      ds_SUBFILE_OUT.H_NBR      = jobi0400.nbr;
      ds_SUBFILE_OUT.H_TYPE     = jobi0400.type;
      ds_SUBFILE_OUT.H_STATUS   = jobi0400.status;
      ds_SUBFILE_OUT.H_ACTJOBST = jobi0200.actJobSts;
      ds_SUBFILE_OUT.H_DATTIMEN = jobi0400.dateTimeEnt;

      // Laden sichtbare Felder
      ds_SUBFILE_OUT.B_OPTION = 0;

      // Laden Texte und Bezeichnungen
      ds_SUBFILE_OUT = lf_loadSubfileText(ds_SUBFILE_OUT);

      lf_clearSubfileErrorIndicator();
      workstnInd.sflNxtChg   = cFalse;

      g_sflrrn = g_sflrrn + 1;
      write PBSFL ds_SUBFILE_OUT;

      // Anzeigen Subfile Daten
      workstnInd.sflDsp = cTrue;
      isData = cTrue;

    endif;
  endfor;

  workstnInd.sflEnd = cTrue;

  SFSANR = 1;

  return isData;


end-proc;

//===============================================================*
//  Löschen Subfile
//===============================================================*
dcl-proc lp_clearSubfile;
  dcl-pi *n;
  end-pi;

  //  Schleifensteuerung
  dcl-s isDone ind inz(cFalse);
  dcl-s isError ind inz(cFalse);

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstnInd.sflDsp    = cFalse;
  workstnInd.sflDspCtl = cFalse;
  workstnInd.sflClr    = cTrue;
  workstnInd.sflEnd    = cFalse;

  write PBCTL;

  workstnInd.sflDsp    = cFalse;
  workstnInd.sflDspCtl = cTrue;
  workstnInd.sflClr    = cFalse;
  workstnInd.sflEnd    = cFalse;

  g_sflrrn = 0;

  return;


end-proc;

//===============================================================*
//  Anzeigen Subfile, warten auf Benutzereingaben
//===============================================================*
dcl-proc lf_showScreen;
  dcl-pi *n like(keyPressed_t);
  end-pi;

  //  Return value
  dcl-s key like(keyPressed_t) inz;

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  write MSGCTL;

  if not workstnInd.sflDsp;
    write PBLEER;
  endif;

  write PBBOT;

  exfmt PBCTL;

  key = workstnInf.key;

  return key;


end-proc;

//===============================================================*
//  Verarbeiten Subfile-Eingaben
//===============================================================*
dcl-proc lf_doSubfileOptions;
  dcl-pi *n ind;
    o_qJob likeds(qJob_t);
  end-pi;

  //  Return value
  dcl-s isChanged ind inz(cTrue);

  //  Hilfsfelder
  dcl-s isError ind inz(cFalse);
  dcl-s cmd varchar(2048) inz;
  dcl-s option like(ds_SUBFILE_OUT.B_OPTION) inz;
  dcl-ds sflRrn qualified inz;
    firstError  int(5);
    lastChanged int(5);
  end-ds;
  dcl-ds ds_SUBFILE_IN likerec(PBSFL: *input);
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT);

  //  Konstanten
  dcl-c cCMD_WRKJOB 'WRKJOB JOB(&NBR/&USER/&JOB)';
  dcl-c cCMD_WRKJOB_SPLF 'WRKJOB JOB(&NBR/&USER/&JOB) OPTION(*SPLF)';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear sflRrn;

  clear o_qJob;

  dow (lf_readc(ds_SUBFILE_IN) <> cEOF) and (o_qJob = '');

    lf_clearSubfileErrorIndicator();

    if ds_SUBFILE_IN.B_OPTION = 0;
      isError     = cFalse;
      workstnInd.sflNxtChg = cFalse;
    else;
      if not lf_isSubfileRecordValid(ds_SUBFILE_IN);
        isError = cTrue;
        workstnInd.sflNxtChg = cTrue;
      else;
        isError = cFalse;
        workstnInd.sflNxtChg = cFalse;
      endif;
    endif;

    // Füllen Subfiledatensatz für Update
    ds_SUBFILE_OUT = lf_loadSubfileOutImage(ds_SUBFILE_IN);

    if not isError;
      option = ds_SUBFILE_OUT.B_OPTION;
      ds_SUBFILE_OUT.B_OPTION = 0;
    endif;

    // Aktualisieren Subfiledatensatz
    update PBSFL ds_SUBFILE_OUT;

    // Beibehalten Cursor-Position
    sflrrn.lastChanged = g_sflRrn;

    // Verlassen Schleife bei Fehler = Satz zur Änderung markiert
    if isError;
      if sflRrn.firstError = 0;
        sflrrn.firstError = g_sflRrn;
      endif;
      leave;
    endif;

    // Verarbeiten Subfileauswahl
    select;
    when option = 1;
      o_qJob.name = ds_SUBFILE_OUT.H_JOB;
      o_qJob.user = ds_SUBFILE_OUT.H_USER;
      o_qJob.nbr  = ds_SUBFILE_OUT.H_NBR;
      isChanged = cFalse;
    when option = 5;
      cmd = cCMD_WRKJOB;
      cmd = f_replace('&NBR' : %trim(ds_SUBFILE_OUT.H_NBR ): cmd);
      cmd = f_replace('&USER': %trim(ds_SUBFILE_OUT.H_USER): cmd);
      cmd = f_replace('&JOB' : %trim(ds_SUBFILE_OUT.H_JOB ): cmd);
      QCMDEXC(cmd: %len(cmd));
      isChanged = cTrue;
    when option = 8;
      cmd = cCMD_WRKJOB_SPLF;
      cmd = f_replace('&NBR' : %trim(ds_SUBFILE_OUT.H_NBR ): cmd);
      cmd = f_replace('&USER': %trim(ds_SUBFILE_OUT.H_USER): cmd);
      cmd = f_replace('&JOB' : %trim(ds_SUBFILE_OUT.H_JOB ): cmd);
      QCMDEXC(cmd: %len(cmd));
      isChanged = cTrue;
    endsl;
  enddo;

  // Positionieren Cursor
  if sflrrn.firstError > 0;
    SFSANR = sflRrn.firstError;
  endif;

  return isChanged;


end-proc;

//===============================================================*
//  Lesen geänderten Subfile-Datensatz
//===============================================================*
dcl-proc lf_readc;
  dcl-pi *n ind;
    o_SUBFILE likerec(PBSFL);
  end-pi;

  //  Return value
  dcl-s isEOF ind inz(cFalse);

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  readc PBSFL o_SUBFILE;
  if %eof(STRDBGFM);
    isEOF = cTrue;
  else;
    isEOF = cFalse;
  endif;

  return isEOF;


end-proc;

//===============================================================*
//  Prüfen Subfile-Datensatz
//===============================================================*
dcl-proc lf_isSubfileRecordValid;
  dcl-pi *n ind;
    i_SUBFILE_IN likerec(PBSFL: *input) value;
  end-pi;

  //  Return value
  dcl-s isValid ind inz(cFalse);

  //  Hilfsfelder
  dcl-s isError ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou isError or isValid;
    if not lf_isSubfileOptionValid(i_SUBFILE_IN.B_OPTION);
      workstnInd.B_OPTION_RI = cTrue;
      workstnInd.B_OPTION_PC = cTrue;
      isError = cTrue;
      leave;
    endif;

    isValid = cTrue;
  enddo;

  return isValid;


end-proc;

//===============================================================*
//  Prüfen Subfile-Auswahl
//===============================================================*
dcl-proc lf_isSubfileOptionValid;
  dcl-pi *n ind;
    i_option like(B_OPTION) value;
  end-pi;

  //  Return value
  dcl-s isValid ind inz(cFalse);

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_option = 1) or (i_option = 5) or (i_option = 8);
    isValid = cTrue;
    isValid = cTrue;
  else;
    isValid = cFalse;
  endif;

  return isValid;


end-proc;

//===============================================================*
//  Löschen Subfile Fehlerbezugszahlen
//===============================================================*
dcl-proc lf_clearSubfileErrorIndicator;
  dcl-pi *n;
  end-pi;

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstnInd.B_OPTION_RI = cFalse;
  workstnInd.B_OPTION_PC = cFalse;

  return;


end-proc;

//===============================================================*
//  Laden Texte für Subfiledatensatz
//===============================================================*
dcl-proc lf_loadSubfileText;
  dcl-pi *n likerec(PBSFL: *OUTPUT);
    i_SUBFILE_OUT likerec(PBSFL: *OUTPUT);
  end-pi;

  //  Return value
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ds_SUBFILE_OUT = i_SUBFILE_OUT;

  ds_SUBFILE_OUT.O_JOB    = ds_SUBFILE_OUT.H_JOB;
  ds_SUBFILE_OUT.O_USER   = ds_SUBFILE_OUT.H_USER;
  ds_SUBFILE_OUT.O_NBR    = ds_SUBFILE_OUT.H_NBR;

  select;
  when ds_SUBFILE_OUT.H_TYPE = 'A';
    ds_SUBFILE_OUT.O_TYPE   = 'AUTO';
  when ds_SUBFILE_OUT.H_TYPE = 'B';
    ds_SUBFILE_OUT.O_TYPE   = 'BATCH';
  when ds_SUBFILE_OUT.H_TYPE = 'I';
    ds_SUBFILE_OUT.O_TYPE   = 'INTER';
  when ds_SUBFILE_OUT.H_TYPE = 'M';
    ds_SUBFILE_OUT.O_TYPE   = 'SBS';
  when ds_SUBFILE_OUT.H_TYPE = 'R';
    ds_SUBFILE_OUT.O_TYPE   = 'RDR';
  when ds_SUBFILE_OUT.H_TYPE = 'S';
    ds_SUBFILE_OUT.O_TYPE   = 'SYS';
  when ds_SUBFILE_OUT.H_TYPE = 'W';
    ds_SUBFILE_OUT.O_TYPE   = 'WTR';
  when ds_SUBFILE_OUT.H_TYPE = 'X';
    ds_SUBFILE_OUT.O_TYPE   = 'SCPF';
  endsl;

  select;
  when ds_SUBFILE_OUT.H_STATUS = '*ACTIVE';
    ds_SUBFILE_OUT.O_STATUS = 'ACTIVE';
  when ds_SUBFILE_OUT.H_STATUS = '*JOBQ';
    ds_SUBFILE_OUT.O_STATUS = 'JOBQ';
  when ds_SUBFILE_OUT.H_STATUS = '*OUTQ';
    ds_SUBFILE_OUT.O_STATUS = 'OUTQ';
  endsl;

  %subst(ds_SUBFILE_OUT.O_STATUS               :
         1 + %len(ds_SUBFILE_OUT.O_STATUS  )
           - %len(ds_SUBFILE_OUT.H_ACTJOBST)   :
         %len(ds_SUBFILE_OUT.H_ACTJOBST)       ) =
              ds_SUBFILE_OUT.H_ACTJOBST;

  ds_SUBFILE_OUT.O_DATE = %char(
         %date(%subst(ds_SUBFILE_OUT.H_DATTIMEN: 1: 7): *CYMD0): *DMY);
  ds_SUBFILE_OUT.O_DATE = %xlate('/': '.': ds_SUBFILE_OUT.O_DATE);

  return ds_SUBFILE_OUT;


end-proc;

//===============================================================*
//  Laden Update Image für Subfiledatensatz
//===============================================================*
dcl-proc lf_loadSubfileOutImage;
  dcl-pi *n likerec(PBSFL: *OUTPUT);
    i_SUBFILE_IN likerec(PBSFL: *input);
  end-pi;

  //  Return value
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Laden versteckte Felder
  ds_SUBFILE_OUT.H_JOB      = i_SUBFILE_IN.H_JOB;
  ds_SUBFILE_OUT.H_USER     = i_SUBFILE_IN.H_USER;
  ds_SUBFILE_OUT.H_NBR      = i_SUBFILE_IN.H_NBR;
  ds_SUBFILE_OUT.H_TYPE     = i_SUBFILE_IN.H_TYPE;
  ds_SUBFILE_OUT.H_STATUS   = i_SUBFILE_IN.H_STATUS;
  ds_SUBFILE_OUT.H_ACTJOBST = i_SUBFILE_IN.H_ACTJOBST;
  ds_SUBFILE_OUT.H_DATTIMEN = i_SUBFILE_IN.H_DATTIMEN;

  // Laden sichtbare Felder
  ds_SUBFILE_OUT.B_OPTION = i_SUBFILE_IN.B_OPTION;

  // Laden Text und Bezeichnungen
  ds_SUBFILE_OUT = lf_loadSubfileText(ds_SUBFILE_OUT);

  return ds_SUBFILE_OUT;


end-proc;

//===============================================================*
//  Prüfen auf eindeutige Jobauswahl und ermitteln Job.
//===============================================================*
dcl-proc lf_getUniqueJob;
  dcl-pi *n ind;
    hJobs like(lstJob_handle_t) const;
    q1Job likeds(qJob_t);
  end-pi;

  //  Funktionswert
  dcl-s isUniqueJob ind inz(cFalse);

  //  Hilfsfelder
  dcl-s x int(10) inz;
  dcl-s numJobs int(10) inz;
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds jobl0100 likeds(jobl0100_t) inz;
  dcl-ds tmpJobl0100 likeds(jobl0100) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Lesen Jobs
  x = 1;
  numJobs = 0;

  dow (x <= f_getNumJobAvl(hJobs)) and (numJobs <= 1);

    // Abrufen ersten/nächsten Job
    if x = 1;
      f_getFirstJob(hJobs: jobl0100);
    else;
      f_getNextJob(hJobs: jobl0100);
    endif;

    if lf_isJobStatusValid(jobl0100.status);
      tmpJobl0100 = jobl0100;
      numJobs = numJobs + 1;
    endif;

    x = x + 1;
  enddo;

  if numJobs = 1;
    q1Job.name = tmpJobl0100.job;
    q1Job.user = tmpJobl0100.user;
    q1Job.nbr  = tmpJobl0100.nbr;
    isUniqueJob = cTrue;
  endif;

  return isUniqueJob;


end-proc;

//===============================================================*
//  Prüfen, ob der Jobstatus gültig ist.
//===============================================================*
dcl-proc lf_isJobStatusValid;
  dcl-pi *n ind;
    jobStatus char(10) const;
  end-pi;

  //  Funktionswert
  dcl-s isValid ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (jobStatus = '*ACTIVE') or (jobStatus = '*JOBQ'  );
    isValid = cTrue;
  else;
    isValid = cFalse;
  endif;

  return isValid;


end-proc;

//===============================================================*
//  Initialisieren Programm
//===============================================================*
dcl-proc lp_initProgram;
  dcl-pi *n;
  end-pi;

  //  Hilfsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  S_PGMQ = '*';   // Anzuzeigenden Nachrichtenwartesch

  if f_getDisplayMode() = cDISPLAY_MODE_DS3;
    workstnInd.isWideScreen = cFalse;  // Bildschirmgröße 24x80
  else;
    workstnInd.isWideScreen = cTrue;   // Bildschirmgröße 27x132
  endif;

  return;


end-proc;

