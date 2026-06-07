# STRDBG - A Tools/400 Utility

STRDBG is utility for starting and ending the 5250 IBM debugger. The
advantage of the utility over the IBM STRDBG command is, that it
automatically starts a service job when the user wants to debug
a different job.

## Dependencies

Dependencies:

- [BASICS1](https://github.com/tools400/basics1)
- [LSTJOB](https://github.com/tools400/lstjob)

## Installation

Compile members with the following PDM option:

   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO)
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)
     USER1(*LIST) USER2(*FULL)

Members of type MAKPGM or BND are used for linking programs (MAKPGM)
and service programs (BND).

The [STRPREPRC](https://github.com/tools400/strpreprc) utility is used for compiling the members. The utility retrieves object creation parameters from the source member that is compiled and building and executing the final object creation command.

---

2019, Thomas Raddatz
