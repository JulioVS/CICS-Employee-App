      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYEE APP'
      *      - APPLICATION CONSTANTS FOR 'EMPLOYEE' CICS APP.
      ******************************************************************
       01 APPLICATION-CONSTANTS.
      *      SIGN-ON PROCESS CONSTANTS
          05 AC-SIGNON-TRANSACTION-ID  PIC X(4)  VALUE 'ESON'.
          05 AC-SIGNON-PROGRAM-NAME    PIC X(7)  VALUE 'ESONP'.
          05 AC-SIGNON-MAP-NAME        PIC X(7)  VALUE 'ESONM'.
          05 AC-SIGNON-MAPSET-NAME     PIC X(7)  VALUE 'ESONMAP'.
          05 AC-SIGNON-RULES-FILENAME  PIC X(7)  VALUE 'ESONRUL'.
      *      GENERAL PROCESS CONSTANTS
          05 AC-REG-USER-FILENAME      PIC X(7)  VALUE 'EREGUSR'.
      *      ACTIVITY MONITOR
          05 AC-ACTMON-PROGRAM-NAME    PIC X(8)  VALUE 'EACTMON'.
          05 AC-ACTMON-QUEUE-PREFIX    PIC X(8)  VALUE 'EUSERACT'.
          05 AC-ACTMON-CHANNEL-NAME    PIC X(16) VALUE 'DHFTRANSACTION'.
          05 AC-ACTMON-CONTAINER-NAME  PIC X(16) VALUE 'ACTMContainer'.
          