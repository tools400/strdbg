      /IF NOT DEFINED(STRDBGR)
      /DEFINE STRDBGR
      *
     D STRDBGR...
     D                 PR                         extpgm('STRDBGR')
     D  gi_pgmList                         const  likeds(pgmList_t )
     D  gi_dspmodsrc                  1A   const
     D  gi_srcdbgpgm                       const  likeds(qObj_t    )
     D  gi_dftpgm                    10A   const
     D  gi_maxtrc                     5I 0 const
     D  gi_trcfull                    1A   const
     D  gi_unmonpgm                        const  likeds(qObj_t    )
     D  gi_updprod                    1A   const
     D  gi_opmsrc                     1A   const
     D  gi_srvpgm                          const  likeds(pgm_t     )
     D  gi_class                           const  likeds(class_t   )
     D  gi_qJob                            const  likeds(qJob_t    )
     D  gi_alwWideScn                 1A   const
      *
      /ENDIF
