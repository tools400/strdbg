      *=====================================================================*
      *                                                                     *
      *  Kurzdokumentation :                                                *
      *                                                                     *
      *  Bereich . . . : STRDBG                                             *
      *  Objekt  . . . : STRDBGR                                            *
      *  Beschreibung  : Start Debug with STRSRVJOB - CPP                   *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Datum . . . . : 22.06.2005                                         *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  18.12.2006  Th.Raddatz    Added parameter WIDESCN(*PRV|*NO|*YES).  *
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
      *                           ACTGRP(*NEW) +                            *
      *                           BNDSRVPGM(&LI/BASICS1) +                  *
      *                           DETAIL(*BASIC);                           *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
     H DEBUG
      *=====================================================================*
      *
      * ------------------------------------
      *  Type definitions
      * ------------------------------------
      /COPY QSTRDBG,TYPEDEF
      *
      *  Layout von pgmList_t:
      *
      *  1-2   Int2   Anzahl Einträge von pgmE_t
      *  3-x   Int3   Offset zu Eintrag n von pgmE_t (max. 20 Offsets)
      *  *     Char   pgmE_t
      *
     D pgmList_t       DS                  qualified   based(pDummy)
     D  numE                          5I 0
     D  ofs                           5I 0                    dim(20)
     D  buffer                      640A
      *  buffer size:    max. 20 * 32 Byte Programm Eintrag     =  640 Byte
      *                                                            --------
      *                                                            640 Byte
      *
     D pgmE_t          DS                  qualified   based(pDummy)
     D  numE                          5I 0
     D  pgm                                like(qObj_t    )
     D  type                         10A
      *
     D class_t         DS                  qualified   based(pDummy)
     D  numE                          5I 0
     D  name                       5000A   varying            dim(10)
      *
     D pgm_t           DS                  qualified   based(pDummy)
     D  numE                          5I 0
     D  pgmE                               like(qObj_t    ) dim(20)
      *
      * ------------------------------------
      *  Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      /COPY QLSTJOB,PLSTJOB
      /COPY QSTRDBG,PSTRDBGR1
      *
     D QCMDEXC...
     D                 PR                         extpgm('QCMDEXC')
     D  i_cmd                     32702A   const  options(*varsize)
     D  i_length                     15P 5 const
     D  i_IGC_control                 3A   const  options(*nopass)
      *
      *  Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')
     D  i_msgID                       7A   const
     D  i_qMsgF                      20A   const
     D  i_msgData                 32767A   const  options(*varsize )
     D  i_length                     10I 0 const
     D  i_msgType                    10A   const
     D  i_callStkE                32767A   const  options(*varsize )
     D  i_callStkC                   10I 0 const
     D  o_msgKey                      4A
     D  io_ErrCode                32767A          options(*varsize )
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
      *  Open List of Objects (QGYOLOBJ) API
     D QGYOLOBJ...
     D                 PR                         extpgm('QGYOLOBJ')
     D  o_rcvVar                  32767A          options(*varsize )
     D  i_lenRcvVar                  10I 0 const
     D  o_listInf                    80A
     D  i_numRcdRet                  10I 0 const
     D  i_sortInf                 32767A   const  options(*varsize )
     D  i_qObj                       20A   const
     D  i_objType                    10A   const
     D  i_authCtrl                32767A   const  options(*varsize )
     D  i_selectCtrl              32767A   const  options(*varsize )
     D  i_numFldRet                  10I 0 const
     D  i_keyOfFldRet             32767A   const  options(*varsize )
     D  io_ErrCode                32767A          options(*varsize )
      *
      *  Get List Entries (QGYGTLE) API
     D QGYGTLE...
     D                 PR                         extpgm('QGYGTLE')
     D  o_rcvVar                  32767A          options(*varsize )
     D  i_lenRcvVar                  10I 0 const
     D  i_hRequest                    4A   const
     D  o_listInf                    80A
     D  i_numRcdRet                  10I 0 const
     D  i_startRcd                   10I 0 const
     D  io_ErrCode                32767A          options(*varsize )
      *
      *  Close List (QGYCLST) API
     D QGYCLST...
     D                 PR                         extpgm('QGYCLST')
     D  i_hRequest                    4A   const
     D  io_ErrCode                32767A          options(*varsize )
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      /COPY QSTRDBG,PSTRDBGR
      *
     D p_main...
     D                 PR
     D  i_pgmList                          value  likeds(pgmList_t )
     D  i_dspmodsrc                   1A   value
     D  i_srcdbgpgm                        value  likeds(qObj_t    )
     D  i_dftpgm                     10A   value
     D  i_maxtrc                      5I 0 value
     D  i_trcfull                     1A   value
     D  i_unmonpgm                         value  likeds(qObj_t    )
     D  i_updprod                     1A   value
     D  i_opmsrc                      1A   value
     D  i_srvPgmList                       value  likeds(pgm_t     )
     D  i_class                            value  likeds(class_t   )
     D  i_qJob                             value  likeds(qJob_t    )
     D  i_alwWideScn                  1A   value
      *
      *  Abrufen Objekttyp.
     D f_rtvObjType...
     D                 PR            10A
     D  i_obj                        10A   value
     D  i_lib                        10A   value
      *
      *  Signal error condition.
     D p_signalError...
     D                 PR
     D  i_errText                   132A   value  varying
      *
      *  Set screen size.
     D p_setScnSize...
     D                 PR
     D  i_alwWideScn                  1A   value
      *
      * ------------------------------------
      *  Global fields
      * ------------------------------------
     D g_strsrvjob     DS                  qualified
     D  isActive                       N   inz(cFalse)
     D g_pssr          DS                  qualified
     D  isActive                       N   inz(cFalse)
      *
      * ------------------------------------
      *  Global constants
      * ------------------------------------
      *  Parameter values: WIDESCN
     D cWIDESCN_PRV    C                   const('P')
     D cWIDESCN_NO     C                   const('N')
     D cWIDESCN_YES    C                   const('Y')
      *
      *  Environment variable: ILE_DEBUGGER_1
     D cENVVAR_ILE_DEBUGGER_1...
     D                 C                   const('ILE_DEBUGGER_1')
     D cVALUE_ALLOW_WIDE_SCREEN_YES...
     D                 C                   const('ALLOW_WIDE_SCREEN')
     D cVALUE_ALLOW_WIDE_SCREEN_NO...
     D                 C                   const('DO_NOT_ALLOW_WIDE_SCREEN')
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
     D STRDBGR...
     D                 PI
     D  gi_pgmList                         const  likeds(pgmList_t )
     D  gi_dspmodsrc                  1A   const
     D  gi_srcdbgpgm                       const  likeds(qObj_t    )
     D  gi_dftpgm                    10A   const
     D  gi_maxtrc                     5I 0 const
     D  gi_trcfull                    1A   const
     D  gi_unmonpgm                        const  likeds(qObj_t    )
     D  gi_updprod                    1A   const
     D  gi_opmsrc                     1A   const
     D  gi_srvPgmList                      const  likeds(pgm_t     )
     D  gi_class                           const  likeds(class_t   )
     D  gi_qJob                            const  likeds(qJob_t    )
     D  gi_alwWideScn                 1A   const
      *
     D errCode         DS                  likeds(errCode_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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
                gi_alwWideScn);

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
     D  i_pgmList                          value  likeds(pgmList_t )
     D  i_dspmodsrc                   1A   value
     D  i_srcdbgpgm                        value  likeds(qObj_t    )
     D  i_dftpgm                     10A   value
     D  i_maxtrc                      5I 0 value
     D  i_trcfull                     1A   value
     D  i_unmonpgm                         value  likeds(qObj_t    )
     D  i_updprod                     1A   value
     D  i_opmsrc                      1A   value
     D  i_srvPgmList                       value  likeds(pgm_t     )
     D  i_class                            value  likeds(class_t   )
     D  i_qJob                             value  likeds(qJob_t    )
     D  i_alwWideScn                  1A   value
      *
      *  Schleifensteuerung
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Hilfsfelder
     D keyPressed      S                   like(keyPressed_t) inz
     D qJob            DS                  likeds(qJob_t    ) inz
     D cmd             S          32702A   varying inz
     D cmdStrSrvJob    S          32702A   varying inz
     D x               S             10I 0 inz
     D pgmE            DS                  likeds(pgmE_t    ) based(pPgmE)
     D pgmE_pgm        DS                  likeds(qObj_t    )
     D                                     based(pPgmE_pgm)
      *
     D srvPgmList      DS                  likeds(pgm_t     )
     D srvPgmList_pgmE...
     D                 DS                  likeds(qObj_t    )
     D                                     based(pSrvPgmList_pgmE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Übertragen Liste der Serviceprogramme in interne Tabelle
         clear srvPgmList;
         for x = 1 to i_srvPgmList.numE;
            srvPgmList.numE = srvPgmList.numE + 1;
            srvPgmList.pgmE(srvPgmList.numE) = i_srvPgmList.pgmE(x);
         endfor;

         // Tue es , bis wir fertig sind oder ein Fehler auftritt:
         dou isDone or isError;

            if i_qJob.name <> '*';
               g_pgm_strdbgr1 = %trim(sds.pgmLib) + '/' + 'STRDBGR1';
               STRDBGR1(i_qJob: qJob: keyPressed);
               if keyPressed <> cKEY_ENTER;
                  isError = cTrue;
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
                  pPgmE_pgm = %addr(pgmE.pgm);

                  // Get object type
                  if pgmE_pgm.name <> '*NONE';
                     if pgmE.type = '*AUTO';
                        pgmE.type = f_rtvObjType(pgmE_pgm.name: pgmE_pgm.lib);
                     endif;

                     // Copy service programs to service program array
                     if (pgmE.type = '*SRVPGM');
                        pSrvPgmList_pgmE = %addr(srvPgmList.pgmE(1));
                        if srvPgmList_pgmE.name = '*NONE';
                           srvPgmList_pgmE.name = '';
                           srvPgmList_pgmE.lib  = '';
                           srvPgmList.numE = 0;
                        endif;
                        if srvPgmList.numE >= %elem(srvPgmList.pgmE);
                           p_signalError('Number of service programs +
                                          exceed maximum of ' +
                                          %char(%elem(srvPgmList.pgmE)));
                        endif;
                        srvPgmList.numE = srvPgmList.numE + 1;
                        pSrvPgmList_pgmE =
                              %addr(srvPgmList.pgmE(srvPgmList.numE));
                        srvPgmList_pgmE.name = pgmE_pgm.name;
                        srvPgmList_pgmE.lib  = pgmE_pgm.lib;
                        iter;
                     endif;
                  endif;

                  // Send escape message on non-(service-)program objects
                  if pgmE_pgm.name <> '*NONE';
                  if (pgmE.type <> '*PGM') and (pgmE.type <> '*PGM');
                     p_signalError('Program '     + %trimR(pgmE_pgm.name) +
                                   ' in library ' + %trimR(pgmE_pgm.lib ) +
                                   ' can not be accessed');
                  endif;
                  endif;

                  // Produce parameter PGM()
                  if x > 1;
                     cmd = cmd + ' ';
                  endif;

                  if pgmE_pgm.lib <> '';
                     cmd = cmd + %trimR(pgmE_pgm.lib ) + '/';
                  endif;
                  if pgmE_pgm.name <> '';
                     cmd = cmd + %trimR(pgmE_pgm.name);
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

                  pSrvPgmList_pgmE = %addr(srvPgmList.pgmE(x));

                  // Produce parameter SRVPGM()
                  if x > 1;
                     cmd = cmd + ' ';
                  endif;

                  if srvPgmList_pgmE.lib <> '';
                     cmd = cmd + %trimR(srvPgmList_pgmE.lib ) + '/';
                  endif;
                  if srvPgmList_pgmE.name <> '';
                     cmd = cmd + %trimR(srvPgmList_pgmE.name);
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
               QCMDEXC(cmdStrSrvJob: %len(cmdStrSrvJob));

               // Remember that STRSRVJOB is active
               g_strsrvjob.isActive = cTrue;
            endif;

            // Process STRDBG command
            QCMDEXC(cmd: %len(cmd));

            // Everything is done
            isDone = cTrue;
         enddo;

         return;

      /END-FREE
      *
     P p_main...
     P                 E
      *
      *===============================================================*
      *  Retrieve object type.
      *===============================================================*
     P f_rtvObjType...
     P                 B
      *
     D f_rtvObjType...
     D                 PI            10A
     D  i_obj                        10A   value
     D  i_lib                        10A   value
      *
      *  Return value
     D objType         S             10A   inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D i               S             10I 0 inz
      *
     D obj             DS                  qualified
     D  name                         10A   inz
     D  lib                          10A   inz
     D  type                         10A   inz
     D  infStat                       1A   inz
     D  reserved_1                    1A   inz
     D  numFldRet                    10I 0 inz
      *
     D listInf         DS                  qualified
     D  numRcdTot                    10I 0 inz
     D  rcdRet                       10I 0 inz
     D  hRequest                      4A   inz
     D  rcdLen                       10I 0 inz
     D  infCplInd                     1A   inz
     D  datTimCrt                    13A   inz
     D  listStatInd                   1A   inz
     D  reserved_1                    1A   inz
     D  lenInfRet                    10I 0 inz
     D  firstRcd                     10I 0 inz
     D  reserved_2                   40A   inz
      *
     D sortInf         DS                  qualified
     D  numKeys                      10I 0 inz
      *
     D authCtrl        DS                  qualified
     D  length                       10I 0 inz
     D  callLvl                      10I 0 inz
     D  ofsObjAuth                   10I 0 inz
     D  numObjAuth                   10I 0 inz
     D  ofsLibAuth                   10I 0 inz
     D  numLibAuth                   10I 0 inz
     D  reserved_1                    4A   inz
     D  objAuthList                        like(authList_t   ) inz
     D  libAuthList                        like(authList_t   ) inz
      *
     D authCtrl_objAuthList...
     D                 DS                  likeds(authList_t   )
     D                                     based(pAuthCtrl_objAuthList)
      *
     D authCtrl_libAuthList...
     D                 DS                  likeds(authList_t   )
     D                                     based(pAuthCtrl_libAuthList)
      *
     D selectCtrl      DS                  qualified
     D  length                       10I 0 inz
     D  value                        10I 0 inz
     D  ofsStat                      10I 0 inz
     D  numStat                      10I 0 inz
     D  reserved_1                   10I 0 inz
     D  statList                           like(statList_t   ) inz
      *
     D selectCtrl_statList...
     D                 DS                  likeds(statList_t )
     D                                     based(pSelectCtrl_statList)
      *
     D qObj            DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
     D authList_t      DS                  qualified   based(pDummy)
     D  auth                         10A   dim(1)
      *
     D statList_t      DS                  qualified   based(pDummy)
     D  stat                          1A   dim(1)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pAuthCtrl_objAuthList = %addr(authCtrl.objAuthList);
         pAuthCtrl_libAuthList = %addr(authCtrl.libAuthList);

         pSelectCtrl_statList  = %addr(selectCtrl.statList );

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
         authCtrl_objAuthList.auth(1) = '*EXECUTE';
         authCtrl_libAuthList.auth(1) = '*USE';

         selectCtrl.length     = %size(selectCtrl);
         selectCtrl.value      = 0;   // 0=select; 1=omit
         selectCtrl.ofsStat    = %size(selectCtrl) - %size(selectCtrl.statList);
         selectCtrl.numStat    = 1;
         selectCtrl.reserved_1 = 0;
         selectCtrl_statList.stat(1) = '*';

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

      /END-FREE
      *
     P f_rtvObjType...
     P                 E
      *
      *===============================================================*
      *  Signal error condition.
      *===============================================================*
     P p_signalError...
     P                 B
      *
     D p_signalError...
     D                 PI
     D  i_errText                   132A   value  varying
      *
      *  Helper fields
     D msgKey          S              4A                      inz
     D qMsgF           DS                  likeds(qObj_t    ) inz
     D errCode         DS                  likeds(errCode_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qMsgF.name = 'QCPFMSG';
         qMsgF.lib  = '*LIBL';
         errCode = f_newApiErrCode(cFalse);
         QMHSNDPM('CPF9898': qMsgF: i_errText: %len(i_errText):
                  '*ESCAPE': '*CTLBDY': 1: msgKey: errCode);

         return;

      /END-FREE
      *
     P p_signalError...
     P                 E
      *
      *===============================================================*
      *  Set screen size. (Parameter: WIDESCN)
      *===============================================================*
     P p_setScnSize...
     P                 B
      *
     D p_setScnSize...
     D                 PI
     D  i_alwWideScn                  1A   value
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P p_setScnSize...
     P                 E
      *
