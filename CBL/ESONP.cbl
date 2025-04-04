       IDENTIFICATION DIVISION.
       PROGRAM-ID. ESONP.
      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYE APP'
      *      - 'SIGN ON' PROGRAM
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   INCLUDE MY SYMBOLIC MAP COPYBOOK AND IBM'S AID KEYS' ONE.
      ******************************************************************
       COPY ESONP.
       COPY ESONMAP.
       COPY EREGUSR.
       COPY DFHAID.
      ******************************************************************
      *   DEFINE MY SESSION STATE DATA FOR PASSING INTO COMM-AREA.
      ******************************************************************
       01 WS-SESSION-STATE.
          05 WS-USER-ID        PIC X(8).
          05 WS-USER-PASSWORD  PIC X(8).
       01 WS-READ-RESP         PIC S9(8) USAGE IS COMPUTATIONAL.
       01 WS-CURRENT-DATE      PIC X(14).
      ******************************************************************
      *   EXPLICITLY DEFINE THE COMM-AREA FOR THE TRANSACTION.
      ******************************************************************
       LINKAGE SECTION.
       01 DFHCOMMAREA          PIC X(16).

       PROCEDURE DIVISION.
       MAIN-LOGIC SECTION.
      *
           IF EIBCALEN IS EQUAL TO ZERO
              PERFORM 1000-FIRST-INTERACTION
           ELSE
              PERFORM 2000-PROCESS-USER-INPUT
           END-IF.

       SUB-ROUTINE SECTION.
      *
       1000-FIRST-INTERACTION.
      *    THIS IS THE START OF THE (PSEUDO) CONVERSATION,
      *    MEANING THE FIRST INTERACTION OF THE PROCESS,
      *    HENCE THE EMPTY COMM-AREA
           PERFORM 1100-INITIALIZE.
           PERFORM 1200-SEND-MAP.
           PERFORM 1300-RETURN-STATEFULLY.

       1100-INITIALIZE.
      *    CLEAR SESSION STATE AND MAP FIELDS
           INITIALIZE WS-SESSION-STATE.
           INITIALIZE ESONMO.

      *    FOR THE FIRST INTERACTION, WE SEND THE MAP WITH JUST
      *    THE TRANSACTION ID ON IT
           MOVE EIBTRNID TO TRANIDO.

       1200-SEND-MAP.
      *    SENDS MAP TO THE USER
           EXEC CICS SEND
                MAP(AC-MAP-NAME)
                MAPSET(AC-MAPSET-NAME)
                FROM (ESONMO)
                ERASE
                END-EXEC.

       1300-RETURN-STATEFULLY.
      *    RETURNS SAVING THE CURRENT SESSION STATE
      *    AND THE CONVERSATION WILL KEEP GOING
           EXEC CICS RETURN
                COMMAREA(WS-SESSION-STATE)
                TRANSID(EIBTRNID)
                END-EXEC.

       2000-PROCESS-USER-INPUT.
      *    THIS IS THE CONTINUATION OF THE CONVERSATION,
      *    MEANING THE SECOND INTERACTION OF THE PROCESS,
      *    HENCE THE COMM-AREA IS NOT EMPTY
           PERFORM 2100-RESTORE-STATE.
           PERFORM 2200-RECEIVE-MAP.

      *    CHECK PRESSED KEY
           EVALUATE EIBAID  
           WHEN DFHENTER  
                PERFORM 2300-SIGN-ON-USER
           WHEN DFHPF3
           WHEN DFHPF12
                PERFORM 2400-CANCEL-PROCESS
           WHEN OTHER
                PERFORM 2500-SEND-MESSAGE
           END-EVALUATE.

           PERFORM 2600-RETURN-AND-END.

       2100-RESTORE-STATE.
      *    RESTORE PREVIOUS SESSION DATA INTO MY LOCAL VARS
           MOVE DFHCOMMAREA TO WS-SESSION-STATE.

       2200-RECEIVE-MAP.
      *    GET INPUT FROM THE USER
           EXEC CICS RECEIVE
                MAP(AC-MAP-NAME)
                MAPSET(AC-MAPSET-NAME)
                INTO (ESONMI)
                END-EXEC.

       2300-SIGN-ON-USER.
           PERFORM 2310-UPDATE-STATE.
           PERFORM 2320-GREET-USER.
           PERFORM 2330-LOOKUP-USER-ID.

       2310-UPDATE-STATE.
      *    IF NEW DATA WAS RECEIVED, UPDATE STATE
           IF USERIDI IS NOT EQUAL TO LOW-VALUES
              MOVE USERIDI TO WS-USER-ID
           END-IF.
           IF PASSWDI IS NOT EQUAL TO LOW-VALUES
              MOVE PASSWDI TO WS-USER-PASSWORD
           END-IF.

       2320-GREET-USER.
      *    GREET THE USER WITH A MESSAGE
           INITIALIZE MESSO.
           STRING "Hello " DELIMITED BY SIZE
                  WS-USER-ID DELIMITED BY SPACE
                  "!" DELIMITED BY SIZE
              INTO MESSO
           END-STRING.
      *    PERFORM 1200-SEND-MAP.
           
       2330-LOOKUP-USER-ID.
      *    LOOKUP THE USER ID IN THE VSAM FILE
      *    (MINE IS 'Z45864.PSVS.EREGUSR' AS REGISTERED IN CICS)
           EXEC CICS READ
                FILE(AC-FILE-NAME)
                INTO (REG-USER-RECORD)
                RIDFLD(WS-USER-ID)
                RESP(WS-READ-RESP)
                END-EXEC.

           MOVE FUNCTION CURRENT-DATE(1:14) TO WS-CURRENT-DATE.
           INITIALIZE MESSO.
                
           EVALUATE WS-READ-RESP
           WHEN DFHRESP(NORMAL)
                IF RU-USER-PASSWORD IS EQUAL TO WS-USER-PASSWORD
                   IF RU-IS-ACTIVE
                      IF RU-LAST-EFFECTIVE-DATE IS LESS THAN
                         OR EQUAL TO WS-CURRENT-DATE 
                         MOVE "User authenticated!" TO MESSO
                      ELSE
                         MOVE "User not yet available!" TO MESSO
                      END-IF
                   ELSE
                      MOVE "User is inactive!" TO MESSO
                   END-IF
                ELSE
                   MOVE "Invalid password!" TO MESSO
                END-IF
           WHEN DFHRESP(NOTFND)
                MOVE "User not found!" TO MESSO
           WHEN OTHER
                MOVE "Error reading user data!" TO MESSO 
           END-EVALUATE.

           PERFORM 1200-SEND-MAP.

       2400-CANCEL-PROCESS.
      *    CLEAR SCREEN
           EXEC CICS SEND CONTROL
                ERASE
                END-EXEC.

       2500-SEND-MESSAGE.
      *    SEND 'INVALID KEY' MESSAGE TO THE USER      
           INITIALIZE MESSO.
           MOVE "Invalid key pressed!" TO MESSO.
           PERFORM 1200-SEND-MAP.

       2600-RETURN-AND-END.
      *    END CICS CONVERSATION
           EXEC CICS RETURN
                END-EXEC.