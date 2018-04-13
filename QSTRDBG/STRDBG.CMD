/* =============================================================== */
/*                                                                 */
/*  Kurzdokumentation :                                            */
/*                                                                 */
/*  Bereich . . . : STRDBG                                         */
/*  Objekt  . . . : STRDBG                                         */
/*  Beschreibung  : Start Debug with STRSRVJOB                     */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>  */
/*  Datum . . . . : 22.06.2005                                     */
/*                                                                 */
/* =============================================================== */
/*                                                                 */
/*  This software is free software, you can redistribute it and/or */
/*  modify it under the terms of the GNU General Public License    */
/*  (GPL) as published by the Free Software Foundation.            */
/*                                                                 */
/*  See GNU General Public License for details.                    */
/*          http://www.opensource.org                              */
/*          http://www.opensource.org/licenses/gpl-license.html    */
/*                                                                 */
/* =============================================================== */
/*  History:                                                       */
/*                                                                 */
/*  Datum       Name          Änderung                             */
/*  ----------  ------------  -----------------------------------  */
/*                                                                 */
/* =============================================================== */
/* >>PRE-COMPILER<<                                                */
/*                                                                 */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/&OB) +                        */
/*                           SRCFILE(&SL/&SF) +                    */
/*                           SRCMBR(&SM);                          */
/*                                                                 */
/*   >>COMPILE<<                                                   */
/*     >>PARM<< PGM(&LI/STRDBGR);                                  */
/*     >>PARM<< MODE(*ALL );                                       */
/*     >>PARM<< ALLOW(*ALL);                                       */
/*     >>PARM<< MAXPOS(1);                                         */
/*     >>PARM<< PMTFILE(QDEVELOP/QCPFPMT);                         */
/*     >>PARM<< HLPSCHIDX(*NONE);                                  */
/*     >>PARM<< HLPPNLGRP(*LIBL/STRDBGP);                          */
/*     >>PARM<< HLPID(STRDBG);                                     */
/*   >>END-COMPILE<<                                               */
/*                                                                 */
/*   >>EXECUTE<<                                                   */
/*                                                                 */
/* >>END-PRE-COMPILER<<                                            */
/* =============================================================== */
             CMD        PROMPT('Start Debug')

             PARM       KWD(PGM) +
                        TYPE(PGM) +
                        DFT(*NONE) +
                        SNGVAL( +
                          (*NONE )) +
                        MAX(20) +
                        PGM(*YES) +
                        PROMPT('Program' 1)

             PARM       KWD(DSPMODSRC) +
                        TYPE(*CHAR) +
                        LEN(1) +
                        RSTD(*YES) +
                        DFT(*PGMDEP) +
                        SPCVAL( +
                          (*PGMDEP P) +
                          (*NO N) +
                          (*YES Y)) +
                        EXPR(*YES) +
                        PMTCTL(*PMTRQS) +
                        PROMPT('Display module source' 9)

             PARM       KWD(SRCDBGPGM) +
                        TYPE(QOBJ) +
                        DFT(*SYSDFT) +
                        SNGVAL( +
                          (*SYSDFT )) +
                        PGM(*YES) +
                        PMTCTL(*PMTRQS) +
                        PROMPT('Source debug program' 10)

             PARM       KWD(DFTPGM) +
                        TYPE(*NAME) +
                        LEN(10) +
                        DFT(*PGM) +
                        SPCVAL( +
                          (*PGM ) +
                          (*NONE )) +
                        PGM(*YES) +
                        EXPR(*YES) +
                        PROMPT('Default program' 2)

             PARM       KWD(MAXTRC) +
                        TYPE(*INT2) +
                        DFT(200) +
                        REL(*GE 1) +
                        EXPR(*YES) +
                        PROMPT('Maximum trace statements' 3)

             PARM       KWD(TRCFULL) +
                        TYPE(*CHAR) +
                        LEN(1) +
                        RSTD(*YES) +
                        DFT(*STOPTRC) +
                        SPCVAL( +
                          (*STOPTRC T) +
                          (*WRAP W)) +
                        EXPR(*YES) +
                        PROMPT('Trace full' 4)

             PARM       KWD(UNMONPGM) +
                        TYPE(QOBJ) +
                        DFT(*NONE) +
                        SNGVAL( +
                          (*NONE )) +
                        PGM(*YES) +
                        PMTCTL(*PMTRQS) +
                        PROMPT('Unmonitored message program' 11)

             PARM       KWD(UPDPROD) +
                        TYPE(*CHAR) +
                        LEN(1) +
                        RSTD(*YES) +
                        DFT(*YES) +
                        SPCVAL( +
                          (*NO N) +
                          (*YES Y)) +
                        EXPR(*YES) +
                        PROMPT('Update production files' 5)

             PARM       KWD(OPMSRC) +
                        TYPE(*CHAR) +
                        LEN(1) +
                        RSTD(*YES) +
                        DFT(*YES) +
                        SPCVAL( +
                          (*NO N) +
                          (*YES Y)) +
                        EXPR(*YES) +
                        PROMPT('OPM source level debug' 6)

             PARM       KWD(SRVPGM) +
                        TYPE(QOBJ) +
                        DFT(*NONE) +
                        SNGVAL( +
                          (*NONE )) +
                        MAX(20) +
                        PGM(*YES) +
                        PROMPT('Service program' 7)

             PARM       KWD(CLASS) +
                        TYPE(*CHAR) +
                        LEN(5000) +
                        DFT(*NONE) +
                        SPCVAL( +
                          (*NONE )) +
                        MAX(20) +
                        EXPR(*YES) +
                        VARY(*YES) +
                        INLPMTLEN(50) +
                        PROMPT('Class' 8)

             PARM       KWD(JOB) +
                        TYPE(QJOB) +
                        DFT(*) +
                        SNGVAL((*)) +
                        PROMPT('Job name')

             PARM       KWD(WIDESCN) +
                        TYPE(*CHAR) +
                        LEN(1) +
                        DFT(*PRV) +
                        RSTD(*YES) +
                        SPCVAL( +
                          (*PRV P) +
                          (*NO  N) +
                          (*YES Y)) +
                        EXPR(*YES) +
                        PROMPT('Allow wide screen')

 PGM:        ELEM       TYPE(QOBJ) +
                        MIN(1) +
                        PROMPT('Name')
             ELEM       TYPE(*CHAR) +
                        LEN(10) +
                        DFT(*AUTO) +
                        RSTD(*YES) +
                        VALUES( +
                          (*AUTO  )  +
                          (*PGM   )  +
                          (*SRVPGM)) +
                        EXPR(*YES) +
                        PROMPT('Type')

QOBJ:        QUAL       TYPE(*NAME) +
                        LEN(10) +
                        MIN(1) +
                        EXPR(*YES)
             QUAL       TYPE(*NAME) +
                        LEN(10) +
                        DFT(*LIBL) +
                        SPCVAL( +
                          (*LIBL ) +
                          (*CURLIB *CURLIB   )) +
                        EXPR(*YES) +
                        PROMPT('Library')

QJOB:        QUAL       TYPE(*NAME) +
                        LEN(10) +
                        MIN(0) +
                        SPCVAL( +
                          (*ALL  )) +
                        EXPR(*YES)
             QUAL       TYPE(*NAME) +
                        LEN(10) +
                        DFT(*ALL) +
                        SPCVAL( +
                          (*ALL  )) +
                        EXPR(*YES) +
                        PROMPT('User')
             QUAL       TYPE(*CHAR) +
                        LEN(6) +
                        DFT(*ALL) +
                        SPCVAL( +
                          (*ALL  )) +
                        EXPR(*YES) +
                        PROMPT('Number')

