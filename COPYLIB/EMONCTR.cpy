      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYEE APP'
      *      - RECORD LAYOUT FOR 'EMONCTR' CONTAINER.
      *        (ACTIVITY MONITOR CONTAINER)
      ******************************************************************
       01 ACTIVITY-MONITOR-CONTAINER.
          05 MON-REQUEST.
             10 MON-LINKING-PROGRAM     PIC X(8).
             10 MON-USER-ID             PIC X(8).
             10 MON-USER-ACTION         PIC X(1).
                88 MON-UA-NOTIFY                  VALUE 'N'.
                88 MON-UA-SIGN-ON                 VALUE 'S'.
                88 MON-UA-SIGN-OFF                VALUE 'F'.                
                88 MON-UA-APP-FUNCTION            VALUE 'A'.
          05 MON-RESPONSE.
             10 MON-RESPONSE-CODE       PIC X(1).
                88 MON-PROCESSING-ERROR           VALUE 'E'.
             10 MON-SIGN-ON-STATUS      PIC X(1).
                88 MON-ST-NOT-SET                 VALUE SPACES.
                88 MON-ST-IN-PROCESS              VALUE 'I'.
                88 MON-ST-LOCKED-OUT              VALUE 'L'.
                88 MON-ST-SIGNED-ON               VALUE 'S'.
             10 MON-USER-TYPE           PIC X(3).
                88 MON-UT-NOT-SET                 VALUE SPACES.
                88 MON-UT-ADMINISTRATOR           VALUE 'ADM'.
                88 MON-UT-MANAGER                 VALUE 'MGR'.
                88 MON-UT-STANDARD                VALUE 'STD'.
             10 MON-MESSAGE             PIC X(79).