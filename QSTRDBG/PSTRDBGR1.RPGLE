      /IF NOT DEFINED(STRDBGR1)
      /DEFINE STRDBGR1
      *
      /COPY QLSTJOB,PLSTJOB
      *
      /IF DEFINED(PI_LITERAL)
     D STRDBGR1...
     D                 PR                         extpgm('STRDBGR1')
      /ELSE
     D g_pgm_strdbgr1  S             21A   inz
     D STRDBGR1...
     D                 PR                         extpgm(g_pgm_strdbgr1)
      /ENDIF
     D  gi_qJob                            const  likeds(qJob_t    )
     D  go_qJob                                   likeds(qJob_t    )
     D  go_cmdKey                                 like(keyPressed_t)
      *
      /ENDIF
