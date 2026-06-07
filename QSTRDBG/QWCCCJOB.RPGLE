**free
/if NOT defined(QWCCCJOB)
/define QWCCCJOB

//  Change Current Job (QWCCCJOB) API
dcl-pr QWCCCJOB extpgm('QWCCCJOB');
  i_chgJobInf char(65535) options(*varsize) const;
  io_errCode  char(65535) options(*varsize);
end-pr;

//  Change job information
dcl-ds QWCCCJOB_chgJobInf_t qualified template;
  numE int(10);
  key  likeds(QWCCCJOB_varLenRcd_t) dim(2);
end-ds;

//  Change job variable length record entry
dcl-ds QWCCCJOB_varLenRcd_t qualified template;
  id     int(10);
  length int(10);
  data   char(1);
end-ds;

dcl-c QWCCCJOB_EXIT_KEY 1;
dcl-c QWCCCJOB_CANCEL_KEY 2;

/endif
