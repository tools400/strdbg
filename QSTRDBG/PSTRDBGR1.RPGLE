**free
/if NOT defined(STRDBGR1)
/define STRDBGR1

/copy QLSTJOB,PLSTJOB

/if defined(PI_LITERAL)
dcl-pr STRDBGR1 extpgm('STRDBGR1');
/else
  dcl-s g_pgm_strdbgr1 char(21) inz;
dcl-pr STRDBGR1 extpgm(g_pgm_strdbgr1);
/endif
  gi_qJob   likeds(qJob_t) const;
  go_qJob   likeds(qJob_t);
  go_cmdKey like(keyPressed_t);
end-pr;

/endif
