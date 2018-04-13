      *=====================================================================*
      *                                                                     *
      *  Kurzdokumentation :                                                *
      *                                                                     *
      *  Bereich . . . : STRDBG                                             *
      *  Objekt  . . . : STRDBGR1                                           *
      *  Beschreibung  : Start Debug - Select Job                           *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Datum . . . . : 22.06.2005                                         *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  07.12.2006  Th.Raddatz    Added procedure lf_getUniqueJob().       *
      *                                                                     *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      * >>PRE-COMPILER<<                                                    *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
      *                           SRCFILE(&SL/&SF) +                        *
      *                           SRCMBR(&SM);                              *
      *   >>COMPILE<<                                                       *
      *     >>PARM<< TRUNCNBR(*NO);                                         *
      *     >>PARM<< DBGVIEW(*LIST);                                        *
      *     >>PARM<< OPTION(*EVENTF);                                       *
      *   >>END-COMPILE<<                                                   *
      *   >>EXECUTE<<                                                       *
      *   >>CMD<<    CRTPGM       PGM(&LI/&OB) +                            *
      *                           MODULE(&LI/&OB) +                         *
      *                           ACTGRP(*CALLER) +                         *
      *                           BNDSRVPGM(&LI/BASICS1  +                  *
      *                                     &LI/LSTJOB ) +                  *
      *                           DETAIL(*BASIC);                           *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
     H DEBUG
      *=====================================================================*
     FSTRDBGFM  CF   E             WORKSTN usropn
     F                                     extfile(g_dspF)
     F                                     indds(workstnInd)
     F                                     infds(workstnInf)
     F                                     SFILE(PBSFL: g_sflrrn)
      *
     D g_dspF          S             21A   inz
     D g_sflrrn        S              5I 0 inz
      *
     D workstnInd      DS                  qualified
     D  sflNxtChg             84     84N
     D  B_OPTION_RI           85     85N
     D  B_OPTION_PC           86     86N
     D  sflDsp                80     80N
     D  sflDspCtl             81     81N
     D  sflClr                82     82N
     D  sflEnd                83     83N
     D  isWideScreen          88     88N
      *
     D workstnInf...
     D                 DS                  qualified
     D  key                  369    369A
      *
      * ------------------------------------
      *  Type definitions
      * ------------------------------------
      /COPY QSTRDBG,TYPEDEF
      /COPY QSTRDBG,FDJOBI0200
      /COPY QSTRDBG,FDJOBI0400
      /COPY QSTRDBG,FDJOBL0100
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QLSTJOB,PLSTJOB
      /COPY QBASICS1,PBASICS1
      *
     D QCMDEXC...
     D                 PR                         extpgm('QCMDEXC')
     D  i_cmd                     32702A   const  options(*varsize)
     D  i_length                     15P 5 const
     D  i_IGC_control                 3A   const  options(*nopass)
      *
      * Resend Escape Message (QMHRSNEM) API
     D QMHRSNEM...
     D                 PR                         extpgm('QMHRSNEM')
     D  i_msgKey                      4A   const
     D  io_ErrCode                32767A          options(*varsize )
     D  i_callStkE                32767A   const  options(*nopass: *varsize)
     D  i_lenStkE                    10I 0 const  options(*nopass)
     D  i_fmtStkE                     8A   const  options(*nopass)
     D  i_frmStkEAdr                 16A   const  options(*nopass)
     D  i_frmStkECnt                 10I 0 const  options(*nopass)
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      /DEFINE PI_LITERAL
      /COPY QSTRDBG,PSTRDBGR1
      /UNDEFINE PI_LITERAL
      *
     D p_main...
     D                 PR
     D  i_qJob                             const  likeds(qJob_t    )
     D  o_qJob                                    likeds(qJob_t    )
     D  o_cmdKey                                  like(keyPressed_t)
      *
      *  Laden Subfile
     D lf_loadSubfile...
     D                 PR              N
     D  hJobs                              const  like(lstJob_handle_t)
      *
      *  Löschen Subfile
     D lp_clearSubfile...
     D                 PR
      *
      *  Anzeigen Subfile, warten auf Benutzereingaben
     D lf_showScreen...
     D                 PR                         like(keyPressed_t)
      *
      *  Verarbeiten Subfile-Eingaben
     D lf_doSubfileOptions...
     D                 PR              N
     D  o_qJob                                    likeds(qJob_t    )
      *
      *  Lesen geänderten Subfile-Datensatz
     D lf_readc...
     D                 PR              N
      *
      *  Prüfen Subfile-Datensatz
     D lf_isSubfileRecordValid...
     D                 PR              N
      *
      *  Prüfen Subfile-Auswahl
     D lf_isSubfileOptionValid...
     D                 PR              N
     D  i_option                           value  like(B_OPTION)
      *
      *  Löschen Subfile Fehlerbezugszahlen
     D lf_clearSubfileErrorIndicator...
     D                 PR
      *
      *  Laden Texte für Subfiledatensatz
     D lf_loadSubfileText...
     D                 PR
      *
      *  Prüfen auf eindeutige Jobauswahl und ermitteln Job.
     D lf_getUniqueJob...
     D                 PR              N
     D  hJobs                              const  like(lstJob_handle_t)
     D  q1Job                                     likeds(qJob_t       )
      *
      *  Prüfen, ob der Jobstatus gültig ist.
     D lf_isJobStatusValid...
     D                 PR              N
     D  jobStatus                    10A   const
      *
      *  Initialisieren Programm
     D lp_initProgram...
     D                 PR
      *
      * ------------------------------------
      *  Global fields
      * ------------------------------------
     D g_pssr          DS                  qualified
     D  isActive                       N   inz(cFalse)
      *
      * ------------------------------------
      *  Program Status Information
      * ------------------------------------
     D sds            SDS                  qualified
     D  pgmName                1     10A
     D  statusCode            11     15S 0
     D  statusCodePrv         16     20S 0
     D  srcLineNbr            21     28A
     D  routine               29     36A
     D  numParms              37     39S 0
     D  msgID                 40     46A
     D   excType                      3A   overlay(msgID)
     D   excNbr                       4A   overlay(msgID: *next)
     D  reserved_1            47     50A
     D  msgWorkArea           51     80A
     D  pgmLib                81     90A
     D  msgText               91    170A
     D  excpID               171    174A
     D  lastFileUsed         175    184A
     D  reserved_2           185    190A
     D  jobDate              191    198A
     D  century              199    200S 0
     D  lastFileUsed8        201    208A
     D  lastFileStat         209    243A
     D  job                  244    253A
     D  user                 254    263A
     D  nbr                  264    269A
     D  pgmDate              270    275S 0
     D  date                 276    281S 0
     D  time                 282    287S 0
     D  pgmCrtDate           288    293A
     D  pgmCrtTime           294    299A
     D  compilerLvl          300    303A
     D  srcFile              304    313A
     D  srcLib               314    323A
     D  srcMbr               324    333A
     D  prcOfPgm             334    343A
     D  prcOfMod             344    353A
     D  Reserved             354    429A
     D  curUsrPrf            358    367A
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
     D STRDBGR1...
     D                 PI
     D  gi_qJob                            const  likeds(qJob_t    )
     D  go_qJob                                   likeds(qJob_t    )
     D  go_cmdKey                                 like(keyPressed_t)
      *
     D errCode         DS                  likeds(errCode_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
      *===============================================================*
      *  Haupsteuerung
      *===============================================================*
     P p_main...
     P                 B
      *
     D p_main...
     D                 PI
     D  i_qJob                             const  likeds(qJob_t    )
     D  o_qJob                                    likeds(qJob_t    )
     D  o_cmdKey                                  like(keyPressed_t)
      *
      *  Schleifensteuerung
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
     D doShowScreen    S               N   inz(cTrue )
     D key             S                   like(keyPressed_t) inz
      *
      *  Hilfsfelder
     D hJobs           S                   like(lstJob_handle_t)   inz
     D q1Job           DS                  likeds(qJob_t       )   inz
     D jobl0100        DS                  likeds(jobl0100_t   )   inz
     D jobi0200        DS                  likeds(jobi0200_t   )   inz
     D msg             DS                  likeds(msg_t        )   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P p_main...
     P                 E
      *
      *===============================================================*
      *  Laden Subfile
      *===============================================================*
     P lf_loadSubfile...
     P                 B
      *
     D lf_loadSubfile...
     D                 PI              N
     D  hJobs                              const  like(lstJob_handle_t)
      *
      *  Return value
     D isData          S               N   inz(cFalse)
      *
      *  Schleifensteuerung
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Hilfsfelder
     D x               S             10I 0                         inz
     D msg             DS                  likeds(msg_t      )     inz
     D jobl0100        DS                  likeds(jobl0100_t )     inz
     D jobi0200        DS                  likeds(jobi0200_t )     inz
     D jobi0400        DS                  likeds(jobi0400_t )     inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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
               clear PBSFL;

               // Laden versteckte Felder
               H_JOB      = jobi0400.job;
               H_USER     = jobi0400.user;
               H_NBR      = jobi0400.nbr;
               H_TYPE     = jobi0400.type;
               H_STATUS   = jobi0400.status;
               H_ACTJOBST = jobi0200.actJobSts;
               H_DATTIMEN = jobi0400.dateTimeEnt;

               // Laden sichtbare Felder
               B_OPTION = 0;

               // Laden Texte und Bezeichnungen
               lf_loadSubfileText();

               lf_clearSubfileErrorIndicator();
               workstnInd.sflNxtChg   = cFalse;

               g_sflrrn = g_sflrrn + 1;
               write PBSFL;

               // Anzeigen Subfile Daten
               workstnInd.sflDsp = cTrue;
               isData = cTrue;

            endif;
         endfor;

         SFSANR = 1;

         return isData;

      /END-FREE
      *
     P lf_loadSubfile...
     P                 E
      *
      *===============================================================*
      *  Löschen Subfile
      *===============================================================*
     P lp_clearSubfile...
     P                 B
      *
     D lp_clearSubfile...
     D                 PI
      *
      *  Schleifensteuerung
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P lp_clearSubfile...
     P                 E
      *
      *===============================================================*
      *  Anzeigen Subfile, warten auf Benutzereingaben
      *===============================================================*
     P lf_showScreen...
     P                 B
      *
     D lf_showScreen...
     D                 PI                         like(keyPressed_t)
      *
      *  Return value
     D key             S                   like(keyPressed_t) inz
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

            write MSGCTL;

            if not workstnInd.sflDsp;
               write PBLEER;
            endif;

            write PBBOT;

            exfmt PBCTL;

            key = workstnInf.key;

         return key;

      /END-FREE
      *
     P lf_showScreen...
     P                 E
      *
      *===============================================================*
      *  Verarbeiten Subfile-Eingaben
      *===============================================================*
     P lf_doSubfileOptions...
     P                 B
      *
     D lf_doSubfileOptions...
     D                 PI              N
     D  o_qJob                                    likeds(qJob_t    )
      *
      *  Return value
     D isChanged       S               N   inz(cTrue)
      *
      *  Hilfsfelder
     D isError         S               N   inz(cFalse)
     D cmd             S           2048A   varying inz
     D option          S                   like(B_OPTION) inz
     D sflRrn          DS                  qualified inz
     D  firstError                    5I 0
     D  lastChanged                   5I 0
      *
      *  Konstanten
     D cCMD_WRKJOB...
     D                 C                   const('WRKJOB +
     D                                              JOB(&NBR/&USER/&JOB)')
     D cCMD_WRKJOB_SPLF...
     D                 C                   const('WRKJOB +
     D                                              JOB(&NBR/&USER/&JOB) +
     D                                              OPTION(*SPLF)')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear sflRrn;

         clear o_qJob;

         dow (lf_readc() <> cEOF) and (o_qJob = '');

            lf_clearSubfileErrorIndicator();

            if B_OPTION = 0;
               isError     = cFalse;
               workstnInd.sflNxtChg = cFalse;
            else;
               if not lf_isSubfileRecordValid();
                  isError = cTrue;
                  workstnInd.sflNxtChg = cTrue;
               else;
                  isError = cFalse;
                  workstnInd.sflNxtChg = cFalse;
               endif;
            endif;

            if not isError;
               option = B_OPTION;
               B_OPTION = 0;
            endif;

            // Aktualisieren Subfiledatensatz
            update PBSFL;

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
               o_qJob.name = H_JOB;
               o_qJob.user = H_USER;
               o_qJob.nbr  = H_NBR;
               isChanged = cFalse;
            when option = 5;
               cmd = cCMD_WRKJOB;
               cmd = f_replace('&NBR' : %trim(H_NBR ): cmd);
               cmd = f_replace('&USER': %trim(H_USER): cmd);
               cmd = f_replace('&JOB' : %trim(H_JOB ): cmd);
               QCMDEXC(cmd: %len(cmd));
               isChanged = cTrue;
            when option = 8;
               cmd = cCMD_WRKJOB_SPLF;
               cmd = f_replace('&NBR' : %trim(H_NBR ): cmd);
               cmd = f_replace('&USER': %trim(H_USER): cmd);
               cmd = f_replace('&JOB' : %trim(H_JOB ): cmd);
               QCMDEXC(cmd: %len(cmd));
               isChanged = cTrue;
            endsl;
         enddo;

         // Positionieren Cursor
         if sflrrn.firstError > 0;
            SFSANR = sflRrn.firstError;
         endif;

         return isChanged;

      /END-FREE
      *
     P lf_doSubfileOptions...
     P                 E
      *
      *===============================================================*
      *  Lesen geänderten Subfile-Datensatz
      *===============================================================*
     P lf_readc...
     P                 B
      *
     D lf_readc...
     D                 PI              N
      *
      *  Return value
     D isEOF           S               N   inz(cFalse)
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         readc PBSFL;
         if %eof(STRDBGFM);
            isEOF = cTrue;
         else;
            isEOF = cFalse;
         endif;

         return isEOF;

      /END-FREE
      *
     P lf_readc...
     P                 E
      *
      *===============================================================*
      *  Prüfen Subfile-Datensatz
      *===============================================================*
     P lf_isSubfileRecordValid...
     P                 B
      *
     D lf_isSubfileRecordValid...
     D                 PI              N
      *
      *  Return value
     D isValid         S               N   inz(cFalse)
      *
      *  Hilfsfelder
     D isError         S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         dou isError or isValid;
            if not lf_isSubfileOptionValid(B_OPTION);
               workstnInd.B_OPTION_RI = cTrue;
               workstnInd.B_OPTION_PC = cTrue;
               isError = cTrue;
               leave;
            endif;

            isValid = cTrue;
         enddo;

         return isValid;

      /END-FREE
      *
     P lf_isSubfileRecordValid...
     P                 E
      *
      *===============================================================*
      *  Prüfen Subfile-Auswahl
      *===============================================================*
     P lf_isSubfileOptionValid...
     P                 B
      *
     D lf_isSubfileOptionValid...
     D                 PI              N
     D  i_option                           value  like(B_OPTION)
      *
      *  Return value
     D isValid         S               N   inz(cFalse)
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_option = 1) or (i_option = 5) or (i_option = 8);
            isValid = cTrue;
            isValid = cTrue;
         else;
            isValid = cFalse;
         endif;

         return isValid;

      /END-FREE
      *
     P lf_isSubfileOptionValid...
     P                 E
      *
      *===============================================================*
      *  Löschen Subfile Fehlerbezugszahlen
      *===============================================================*
     P lf_clearSubfileErrorIndicator...
     P                 B
      *
     D lf_clearSubfileErrorIndicator...
     D                 PI
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         workstnInd.B_OPTION_RI = cFalse;
         workstnInd.B_OPTION_PC = cFalse;

         return;

      /END-FREE
      *
     P lf_clearSubfileErrorIndicator...
     P                 E
      *
      *===============================================================*
      *  Laden Texte für Subfiledatensatz
      *===============================================================*
     P lf_loadSubfileText...
     P                 B
      *
     D lf_loadSubfileText...
     D                 PI
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         O_JOB  = H_JOB;
         O_USER = H_USER;
         O_NBR  = H_NBR;

         select;
         when H_TYPE = 'A';
            O_TYPE   = 'AUTO';
         when H_TYPE = 'B';
            O_TYPE   = 'BATCH';
         when H_TYPE = 'I';
            O_TYPE   = 'INTER';
         when H_TYPE = 'M';
            O_TYPE   = 'SBS';
         when H_TYPE = 'R';
            O_TYPE   = 'RDR';
         when H_TYPE = 'S';
            O_TYPE   = 'SYS';
         when H_TYPE = 'W';
            O_TYPE   = 'WTR';
         when H_TYPE = 'X';
            O_TYPE   = 'SCPF';
         endsl;

         select;
         when H_STATUS = '*ACTIVE';
            O_STATUS = 'ACTIVE';
         when H_STATUS = '*JOBQ';
            O_STATUS = 'JOBQ';
         when H_STATUS = '*OUTQ';
            O_STATUS = 'OUTQ';
         endsl;

         %subst(O_STATUS
                : 1 + %len(O_STATUS) - %len(H_ACTJOBST)
                : %len(H_ACTJOBST) ) = H_ACTJOBST;


         O_DATE = %char(%date(%subst(H_DATTIMEN: 1: 7): *CYMD0): *DMY);
         O_DATE = %xlate('/': '.': O_DATE);

         return;

      /END-FREE
      *
     P lf_loadSubfileText...
     P                 E
      *
      *===============================================================*
      *  Prüfen auf eindeutige Jobauswahl und ermitteln Job.
      *===============================================================*
     P lf_getUniqueJob...
     P                 B
      *
     D lf_getUniqueJob...
     D                 PI              N
     D  hJobs                              const  like(lstJob_handle_t)
     D  q1Job                                     likeds(qJob_t       )
      *
      *  Funktionswert
     D isUniqueJob     S               N   inz(cFalse)
      *
      *  Hilfsfelder
     D x               S             10I 0                         inz
     D numJobs         S             10I 0                         inz
     D msg             DS                  likeds(msg_t      )     inz
     D jobl0100        DS                  likeds(jobl0100_t )     inz
     D tmpJobl0100     DS                  likeds(jobl0100   )     inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P lf_getUniqueJob...
     P                 E
      *
      *===============================================================*
      *  Prüfen, ob der Jobstatus gültig ist.
      *===============================================================*
     P lf_isJobStatusValid...
     P                 B
      *
     D lf_isJobStatusValid...
     D                 PI              N
     D  jobStatus                    10A   const
      *
      *  Funktionswert
     D isValid         S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (jobStatus = '*ACTIVE') or (jobStatus = '*JOBQ'  );
            isValid = cTrue;
         else;
            isValid = cFalse;
         endif;

         return isValid;

      /END-FREE
      *
     P lf_isJobStatusValid...
     P                 E
      *
      *===============================================================*
      *  Initialisieren Programm
      *===============================================================*
     P lp_initProgram...
     P                 B
      *
     D lp_initProgram...
     D                 PI
      *
      *  Hilfsfelder
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         S_PGMQ = '*';   // Anzuzeigenden Nachrichtenwartesch

         if f_getDisplayMode() = cDISPLAY_MODE_DS3;
            workstnInd.isWideScreen = cFalse;  // Bildschirmgröße 24
         else;
            workstnInd.isWideScreen = cTrue;   // Bildschirmgröße 27   2
         endif;

         return;

      /END-FREE
      *
     P lp_initProgram...
     P                 E
      *
