**free
/if NOT defined(STRDBGR)
/define STRDBGR

dcl-pr STRDBGR extpgm('STRDBGR');
  gi_pgmList    likeds(pgmList_t) const;
  gi_dspmodsrc  char(1) const;
  gi_srcdbgpgm  likeds(qObj_t) const;
  gi_dftpgm     char(10) const;
  gi_maxtrc     int(5) const;
  gi_trcfull    char(1) const;
  gi_unmonpgm   likeds(qObj_t) const;
  gi_updprod    char(1) const;
  gi_opmsrc     char(1) const;
  gi_srvpgm     likeds(pgm_t) const;
  gi_class      likeds(class_t) const;
  gi_qJob       likeds(qJob_t) const;
  gi_alwWideScn char(1) const;
end-pr;

/endif
