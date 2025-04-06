      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYEE APP'
      *      - RECORD LAYOUT FOR 'EUACTTS' TEMPORARY STORAGE QUEUE.
      *        (USER ACTIVITY TEMPORARY STORAGE)
      ******************************************************************
       01 USER-ACTIVITY-RECORD.
          05 UA-USER-ID                 PIC X(8).
          05 UA-USER-TYPE               PIC X(3).
             88 UA-IS-ADMINISTRATOR               VALUE 'ADM'.
             88 UA-IS-MANAGER                     VALUE 'MGR'.
             88 UA-IS-STANDARD                    VALUE 'STD'.
          05 UA-USER-SIGN-ON-STATUS     PIC X(1).
             88 UA-IS-IN-PROCESS                  VALUE 'I'.
             88 UA-IS-LOCKED-OUT                  VALUE 'L'.
             88 UA-IS-SIGNED-ON                   VALUE 'S'.
          05 UA-RETRY-NUMBER            PIC 9(2).
          05 UA-LAST-ACTIVITY-TIMESTAMP.
             10 UA-LAST-ACTIVITY-DATE   PIC X(8).
             10 UA-LAST-ACTIVITY-TIME   PIC X(6).
