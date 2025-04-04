      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYE APP'
      *      - RECORD LAYOUT FOR 'ESONRUL' VSAM FILE.
      *        (SIGN-ON RULES)
      ******************************************************************
       01 SIGN-ON-RULES-RECORD.
          05 SR-MAXIMUM-ATTEMPTS     PIC 9(2).
          05 SR-LOCKOUT-INTERVAL     PIC 9(4).
          05 SR-INACTIVITY-INTERVAL  PIC 9(4).