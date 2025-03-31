//DFHZITCL PROC LNGPRFX='IGY640',    Qualifier for COBOL compiler
//       LIBPRFX='CEE',              Qualifier for LE/390
//       INDEX='DFH620.CICS',        Qualifier(s) for CICS libraries
//       PROGLIB=,                   Name of appl load library
//       DSCTLIB='DFH620.CICS.SDFHCOB',  Private macro/dsect
//       OUTC=*,                     Class for print output
//       REG=200M,                   Region size for all steps
//       CBLPARM=('NODYNAM,RENT',    Compiler options
//        'SIZE(4000K),CICS(''COBOL3'')'), Translator options
//*      LNKPARM='LIST,XREF,RENT,MAP', Binder options
//       LNKPARM='RENT', Binder options
//       WORK=SYSDA                  Unit for work datasets
//*********************************************************************
//*                                                                   *
//*                                                                   *
//*                                                                   *
//*     Licensed Materials - Property of IBM                          *
//*                                                                   *
//*     5655-YA1                                                      *
//*                                                                   *
//*     (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.       *
//*                                                                   *
//*                                                                   *
//*                                                                   *
//*                                                                   *
//* STATUS = 7.5.0                                                    *
//*                                                                   *
//* CHANGE ACTIVITY :                                                 *
//*                                                                   *
//* $MOD(DFHZITCL),COMP(COMMAND),PROD(CICS TS )                       *
//*                                                                   *
//*  PN= REASON REL YYMMDD HDXXIII : REMARKS                          *
//* $01= A84313 640 040604 HDBGNRB : Migrate PQ84313 from SPA R630    *
//* $L0= Base   620 011211 HD7OPW  : Base                             *
//* $P1= D04451 630 030307 HD4PALS : remove sdfhc370 reference        *
//* $P2= D08934 630 030919 HD3SCWG : DFHEILID now in SDFHSAMP         *
//* $P3= D12714 640 041230 HD6KRAH : Compiler level                   *
//* $P4= D07074 670 091019 HD4PALT : remove PDSE reference            *
//*      D85873 690 140226 HDLHJJH : Compiler level 5.1 and 4.2       *
//*     R144470 720 171101 HDFVGMB : Remove LIB as a compile option   *
//*                                                                   *
//*********************************************************************
//*
//*   This procedure uses the Enterprise COBOL compiler and its
//*   integrated CICS translator to generate a COBOL module
//*   into an application load library.
//*
//*
//*      This procedure contains 3 steps:
//*      1.   Exec the COBOL compiler and integrated translator
//*      2.   Reblock DFHEILID for use by the binder step
//*      3.   Bind the output into dataset &PROGLIB
//*
//*      The following JCL should be used
//*      to execute this procedure
//*
//*      //APPLPROG EXEC DFHZITCL,PROGLIB=dsnname
//*      //COBOL.SYSIN  DD *
//*         .
//*         . Application program
//*         .
//*      /*
//*      //LKED.SYSIN DD *
//*         NAME anyname(R)
//*      /*
//*
//*      Where   anyname   is the name of your application program.
//*      (Refer to the application programming guide for full details,
//*      including what to do if your program contains calls to
//*      the common programming interface.)
//*
//*      Note:
//*      The compiler LIB option is no longer required when using
//*      COBOL 5 and later and has been removed from the CBLPARM.
//*      For earlier versions of COBOL this option must be manually
//*      reinstated.
//*
//COBOL  EXEC PGM=IGYCRCTL,REGION=&REG,
//       PARM=&CBLPARM
//STEPLIB  DD DSN=&LNGPRFX..SIGYCOMP,DISP=SHR
//         DD DSN=&INDEX..SDFHLOAD,DISP=SHR
//SYSLIB   DD DSN=&DSCTLIB,DISP=SHR
//         DD DSN=&INDEX..SDFHCOB,DISP=SHR
//         DD DSN=&INDEX..SDFHMAC,DISP=SHR
//         DD DSN=&INDEX..SDFHSAMP,DISP=SHR
//SYSPRINT DD SYSOUT=&OUTC
//SYSLIN   DD DSN=&&LOADSET,DISP=(MOD,PASS),
//            UNIT=&WORK,SPACE=(TRK,(3,3))
//SYSUT1   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT2   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT3   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT4   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT5   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT6   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT7   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//** Additional datasets needed for 5.1 compiler **
//SYSUT8   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT9   DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT10  DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT11  DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT12  DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT13  DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT14  DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSUT15  DD UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSMDECK DD UNIT=&WORK,SPACE=(CYL,(1,1))
//** End of additional dataset needed for 5.1 compiler **
//*
//COPYLINK EXEC PGM=IEBGENER,COND=(7,LT,COBOL)
//SYSUT1   DD DSN=&INDEX..SDFHSAMP(DFHEILID),DISP=SHR
//SYSUT2   DD DSN=&&COPYLINK,DISP=(NEW,PASS),
//            DCB=(LRECL=80,BLKSIZE=400,RECFM=FB),
//            UNIT=&WORK,SPACE=(400,(20,20))
//SYSPRINT DD SYSOUT=&OUTC
//SYSIN    DD DUMMY
//*
//LKED   EXEC PGM=IEWL,REGION=&REG,
//            PARM='&LNKPARM',COND=(7,LT,COBOL)
//SYSLIB   DD DSN=&INDEX..SDFHLOAD,DISP=SHR
//         DD DSN=&LIBPRFX..SCEELKED,DISP=SHR
//SYSLMOD  DD DSN=&PROGLIB,DISP=SHR
//SYSUT1   DD UNIT=&WORK,DCB=BLKSIZE=1024,
//            SPACE=(1024,(200,20))
//SYSPRINT DD SYSOUT=&OUTC
//SYSLIN   DD DSN=&&COPYLINK,DISP=(OLD,DELETE)
//         DD DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD DDNAME=SYSIN
