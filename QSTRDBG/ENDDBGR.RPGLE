      *=====================================================================*
      *                                                                     *
      *  Kurzdokumentation :                                                *
      *                                                                     *
      *  Bereich . . . : ENDDBG                                             *
      *  Objekt  . . . : ENDDBGR                                            *
      *  Beschreibung  : End Debug Mode with ENDSRVJOB - CPP                *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Datum . . . . : 22.06.2005                                         *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
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
      *                           BNDDIR(QC2LE) +                           *
      *                           BNDSRVPGM(&LI/BASICS1) +                  *
      *                           BNDDIR(QC2LE) +                           *
      *                           DETAIL(*BASIC);                           *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
      /COPY QSTRDBG,H_SPEC
      /COPY QSTRDBG,COPYRIGHT
      *=====================================================================*
      *
      * ------------------------------------
      *  Type definitions
      * ------------------------------------
      /COPY QSTRDBG,TYPEDEF
      *
      * ------------------------------------
      *  Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
     D QCMDEXC...
     D                 PR                         extpgm('QCMDEXC')
     D  i_cmd                     32702A   const  options(*varsize)
     D  i_length                     15P 5 const
     D  i_IGC_control                 3A   const  options(*nopass)
      *
      *  Process Commands (QCAPCMD) API
     D QCAPCMD...
     D                 PR                         extpgm('QCAPCMD')
     D  i_cmd...
     D                            32702A   const  options(*varsize)
     D  i_cmdLength...
     D                               10I 0 const
     D  i_optCtrlBlk...
     D                            32767A   const  options(*varsize)
     D  i_optCtrlBlkLength...
     D                               10I 0 const
     D  i_optCtrlBlkFormat...
     D                                8A   const
     D  o_chgCmd...
     D                            32702A          options(*varsize)
     D  i_chgCmdLength...
     D                               10I 0 const
     D  o_chgCmdLengthAvl...
     D                               10I 0
     D  io_errorCode...
     D                            32767A          options(*varsize)
      *
     D QMHRMVPM...
     D                 PR                         extpgm('QMHRMVPM')
     D  i_callStkE                   10A   const
     D  i_callStkC                   10I 0 const
     D  i_msgKey                      4A   const
     D  i_msgToRmv                   10A   const
     D  i_errCode                 65535A   const  options(*varsize)
     D  i_lenCallStkE                10I 0 const  options(*nopass)
     D  i_callStkEQ                  20A   const  options(*nopass)
     D  i_rmvUnhExcp                 10A   const  options(*nopass)
     D  i_callStkEDT                 10A   const  options(*nopass)
     D  i_alwDftRpyRj                10A   const  options(*nopass)
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
      /COPY QSTRDBG,PENDDBGR
      *
     D p_main...
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
     D ENDDBGR...
     D                 PI
      *
     D errCode         DS                  likeds(errCode_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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
      *
      *  Schleifensteuerung
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Hilfsfelder
     D cmd             S          32702A   varying inz
      *
      *  Helper fields QCAPCMD
     D optCtrlBlk      DS                  qualified
     D  typeCmdPrc             1      4I 0 inz(0)
     D  DBCS_data              5      5A   inz('0')
     D  prmtAction             6      6A   inz('0')
     D  cmdStrSyntax           7      7A   inz('0')
     D  msgRtvKey              8     11A   inz(*BLANKS)
     D  res_01                12     20A   inz(*ALLx'00')
      *
     D chgCmd          S            128A   inz
     D chgCmdBytAvl    S             10I 0 inz
     D errCode         DS                  likeds(errCode_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P p_main...
     P                 E
      *
