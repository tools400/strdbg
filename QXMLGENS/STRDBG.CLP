/* -------------------------------------------------------------------------- */
/* STRDBG     - SCRIPT MEMBER                                                 */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
/* >>PRE-COMPILER<<                                                           */
/*   >>CRTCMD<<  XMLGEN  XMLSCRIPT(&SM) SCRIPTSRCF(&SL/&SF);                  */
/*   >>IMPORTANT<<                                                            */
/*     >>PARM<<  SRCTOFILE(&LI/QXML);                                         */
/*     >>PARM<<  XMLMBR(*SCRIPT);                                             */
/*     >>PARM<<  ENCODING('ISO-8859-1');                                      */
/*     >>PARM<<  AUTHOR('Thomas Raddatz');                                    */
/*   >>END-IMPORTANT<<                                                        */
/*   >>EXECUTE<<                                                              */
/* >>END-PRE-COMPILER<<                                                       */
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QSTRDBG) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QSTRDBG)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE ) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(ENDDBG    ) XMBRATR(CMD  ) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(ENDDBGP   ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(ENDDBGR   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0200) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0400) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBL0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)


             XMLGENMBR  XMBR(PENDDBGR  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PSTRDBGR  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PSTRDBGR1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QWCCCJOB  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBG    ) XMBRATR(CMD  ) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBGFM  ) XMBRATR(DSPF ) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBGP   ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBGR   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBGR_51) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBGR1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(STRDBGR151) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(TYPEDEF  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QSTRDBG   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSTRDBG   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QSTRDBG) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('V5R1M0'  '&SRCFILE' '&TOLIB')) XRLS(*EQ V5R1M0)
             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB')) XRLS(*GE V5R2M0)
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

