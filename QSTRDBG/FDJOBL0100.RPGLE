**free
/if NOT defined(jobl0100_t)
/define jobl0100_t
//===============================================================*
//  QUSLJOB  API - JOBL0100                                      *
//===============================================================*

dcl-ds jobl0100_t qualified template;
  job         char(10);
  user        char(10);
  nbr         char(6);
  intJobID    char(16);
  status      char(10);
  type        char(1);
  subType     char(1);
  reserved_01 char(2);
end-ds;

/endif
