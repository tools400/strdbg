/* =============================================================== */
/*                                                                 */
/*  Kurzdokumentation :                                            */
/*                                                                 */
/*  Bereich . . . : ENDDBG                                         */
/*  Objekt  . . . : ENDDBG                                         */
/*  Beschreibung  : End Debug Mode with ENDSRVJOB                  */
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
/*     >>PARM<< PGM(&LI/ENDDBGR);                                  */
/*     >>PARM<< MODE(*DEBUG);                                      */
/*     >>PARM<< ALLOW(*ALL);                                       */
/*     >>PARM<< MAXPOS(*NOMAX);                                    */
/*     >>PARM<< PMTFILE(QDEVELOP/QCPFPMT);                         */
/*     >>PARM<< HLPSCHIDX(*NONE);                                  */
/*     >>PARM<< HLPPNLGRP(*LIBL/ENDDBGP);                          */
/*     >>PARM<< HLPID(ENDDBG);                                     */
/*   >>END-COMPILE<<                                               */
/*                                                                 */
/*   >>EXECUTE<<                                                   */
/*                                                                 */
/* >>END-PRE-COMPILER<<                                            */
/* =============================================================== */
             CMD        PROMPT('End Debug Mode')

