**free
ctl-opt debug option(*srcstmt: *nodebugio);
/if NOT defined(NO_DECEDIT)
ctl-opt decedit('0,');
/endif
ctl-opt datedit(*DMY.);
ctl-opt datfmt(*iso);
ctl-opt timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
