       IDENTIFICATION DIVISION.
       PROGRAM-ID. EACTMON.
      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYE APP'
      *      - 'ACTIVITY MONITOR' PROGRAM
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   INCLUDE MY APPLICATOIN CONSTANTS, CONTAINER, QUEUE LAYOUT
      *      AND SIGN-ON RULES COPYBOOKS.-
      ******************************************************************
       COPY ECONST.
       COPY EMONCTR.
       COPY EUACTTS.
       COPY ESONRUL.
      ******************************************************************
      *   DEFINE MY USER ACTIVITY QUEUE NAME.
      ******************************************************************
       01 WS-USER-ACTIVITY-QUEUE-NAME.
          05 WS-UA-QNAME-PREFIX        PIC X(8).
          05 WS-UA-QNAME-USERID        PIC X(8).
       01 WS-ITEM-NUMBER               PIC S9(8) USAGE IS COMPUTATIONAL.
       01 WS-CICS-RESPONSE             PIC S9(8) USAGE IS COMPUTATIONAL.
       
       PROCEDURE DIVISION.
       MAIN-LOGIC SECTION.
      *
           PERFORM 1000-INITIAL-PROCESSING.
           GOBACK.

       SUB-ROUTINE SECTION.
      *
       1000-INITIAL-PROCESSING.
           PERFORM 1100-GET-DATA-FROM-CALLER.

       1100-GET-DATA-FROM-CALLER.
           EXEC CICS GET
                CONTAINER(AC-ACTMON-CHANNEL-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                INTO (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.
           IF WS-CICS-RESPONSE NOT = DFHRESP(NORMAL)
              DISPLAY 'ERROR GETTING USERID CONTAINER'
              DISPLAY 'CICS RESPONSE CODE: ' WS-CICS-RESPONSE
              PERFORM 9000-ABEND-PROCESSING
           END-IF.

       9000-ABEND-PROCESSING.
           DISPLAY 'PROGRAM ABENDING'
           DISPLAY 'CICS RESPONSE CODE: ' WS-CICS-RESPONSE
           EXEC CICS RETURN
                END-EXEC.