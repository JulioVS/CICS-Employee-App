      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYE APP'
      *      - RECORD LAYOUT FOR 'EREGUSR' VSAM FILE.
      ******************************************************************
       01 EREGUSR-REC.
          05 ER-USER-ID              PIC X(8).
          05 ER-USER-PASSWORD        PIC X(8).
          05 ER-USER-TYPE            PIC X(3).
          05 ER-STATUS               PIC X(1).
          05 ER-LAST-EFFECTIVE-DATE  PIC X(14).
          05 ER-LED REDEFINES ER-LAST-EFFECTIVE-DATE.
             10 ER-LED-DATE          PIC X(8).
             10 ER-LED-TIME          PIC X(6).
          05 FILLER                  PIC X(66).