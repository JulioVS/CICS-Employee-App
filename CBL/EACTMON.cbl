       IDENTIFICATION DIVISION.
       PROGRAM-ID. EACTMON.
      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYE APP'
      *      - 'ACTIVITY MONITOR' PROGRAM
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   INCLUDE MY APPLICATION CONSTANTS, CONTAINER, QUEUE LAYOUT
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
       01 WS-ITEM-NUMBER               PIC S9(4) USAGE IS COMPUTATIONAL.
       01 WS-CICS-RESPONSE             PIC S9(8) USAGE IS COMPUTATIONAL.
       
       PROCEDURE DIVISION.
       MAIN-LOGIC SECTION.
      *
           PERFORM 1000-GET-DATA-FROM-CALLER.
           PERFORM 2000-GET-SIGN-ON-RULES.
           PERFORM 9000-RETURN-DATA-TO-CALLER.
                           
           EXEC CICS RETURN
                END-EXEC.


       SUB-ROUTINE SECTION.
      *
       1000-GET-DATA-FROM-CALLER.
      *    READ INCOMING DATA FROM CONTAINER 
           EXEC CICS GET
                CONTAINER(AC-ACTMON-CONTAINER-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                INTO (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                END-EXEC.
                
           INITIALIZE MON-RESPONSE.

       2000-GET-SIGN-ON-RULES.
      *    GET SIGN-ON RULES FROM QUEUE OR FILE 
           MOVE AC-SIGNON-RULES-ITEM-NUM TO WS-ITEM-NUMBER.

      *    TRY FIRST READING THE SIGN-ON RULES FROM THE QUEUE
           EXEC CICS READQ TS
                QUEUE(AC-SIGNON-RULES-QUEUE-NAME)
                ITEM(WS-ITEM-NUMBER)
                INTO (SIGN-ON-RULES-RECORD)
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

      *    IF NO QUEUE ENTRY, THEN READ FROM FILE
           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN DFHRESP(QIDERR)
                PERFORM 2100-LOAD-RULES-FROM-FILE
           WHEN OTHER
                DISPLAY 'ERROR: CICS READQ TS FAILED'
                DISPLAY 'CICS RESPONSE CODE: ' WS-CICS-RESPONSE
                MOVE WS-CICS-RESPONSE TO MON-RESPONSE
           END-EVALUATE.

       2100-LOAD-RULES-FROM-FILE.
      *    READ SIGN-ON RULES FROM FILE 
           EXEC CICS READ
                FILE(AC-SIGNON-RULES-FILE-NAME)
                INTO (SIGN-ON-RULES-RECORD)
                RIDFLD(AC-SIGNON-RULES-RRN)
                RRN
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

      *    IF ALL WENT WELL, THEN WRITE TO QUEUE
           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                PERFORM 2200-CREATE-RULES-QUEUE
           WHEN OTHER
                DISPLAY 'ERROR: CICS READ FILE FAILED'
                DISPLAY 'CICS RESPONSE CODE: ' WS-CICS-RESPONSE
                MOVE WS-CICS-RESPONSE TO MON-RESPONSE
           END-EVALUATE.

       2200-CREATE-RULES-QUEUE.
      *    WRITE SIGN-ON RULES TO QUEUE (CREATING IT)
           MOVE AC-SIGNON-RULES-ITEM-NUM TO WS-ITEM-NUMBER.

           EXEC CICS WRITEQ TS
                QUEUE(AC-SIGNON-RULES-QUEUE-NAME)
                ITEM(WS-ITEM-NUMBER)
                FROM (SIGN-ON-RULES-RECORD)
                LENGTH(LENGTH OF SIGN-ON-RULES-RECORD)
                MAIN
                RESP(WS-CICS-RESPONSE)
                END-EXEC.

           EVALUATE WS-CICS-RESPONSE
           WHEN DFHRESP(NORMAL)
                CONTINUE
           WHEN OTHER
                DISPLAY 'ERROR: CICS WRITEQ TS FAILED'
                DISPLAY 'CICS RESPONSE CODE: ' WS-CICS-RESPONSE
                MOVE WS-CICS-RESPONSE TO MON-RESPONSE
           END-EVALUATE.

       9000-RETURN-DATA-TO-CALLER.
      *    WRITE OUTGOING DATA TO CONTAINER
           EXEC CICS PUT
                CONTAINER(AC-ACTMON-CONTAINER-NAME)
                CHANNEL(AC-ACTMON-CHANNEL-NAME)
                FROM (ACTIVITY-MONITOR-CONTAINER)
                FLENGTH(LENGTH OF ACTIVITY-MONITOR-CONTAINER)
                END-EXEC.