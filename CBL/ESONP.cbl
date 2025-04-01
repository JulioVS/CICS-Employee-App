       IDENTIFICATION DIVISION.
       PROGRAM-ID. ESONP.
      ******************************************************************
      *   CICS PLURALSIGHT 'EMPLOYE APP'
      *      - 'SIGN IN' PROGRAM
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ******************************************************************
      *   INCLUDE MY SYMBOLIC MAP COPYBOOK AND IBM'S AID KEYS' ONE.
      ******************************************************************
       COPY ESONMAP.
       COPY DFHAID.
      ******************************************************************
      *   DEFINE MY SESSION STATE DATA FOR PASSING INTO COMM-AREA.
      ******************************************************************
       01 WS-SESSION-STATE.
          05 WS-USER-ID        PIC X(8).
          05 WS-USER-PASSWORD  PIC X(8).
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
                MAP('ESONM')
                MAPSET('ESONMAP')
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
           PERFORM 2300-UPDATE-STATE.
           PERFORM 2400-MAKE-GREETING.

      *    SEND THE MAP BACK WITH A GREETING
           PERFORM 1200-SEND-MAP.
           PERFORM 2500-RETURN-AND-END.

       2100-RESTORE-STATE.
      *    RESTORE PREVIOUS SESSION DATA INTO MY LOCAL VARS
           MOVE DFHCOMMAREA TO WS-SESSION-STATE.

       2200-RECEIVE-MAP.
      *    GET INPUT FROM THE USER
           EXEC CICS RECEIVE
                MAP('ESONM')
                MAPSET('ESONMAP')
                INTO (ESONMI)
                END-EXEC.

       2300-UPDATE-STATE.
      *    IF NEW DATA WAS RECEIVED, UPDATE STATE
           IF USERIDI IS NOT EQUAL TO LOW-VALUES
              MOVE USERIDI TO WS-USER-ID
           END-IF.
           IF PASSWDI IS NOT EQUAL TO LOW-VALUES
              MOVE PASSWDI TO WS-USER-PASSWORD
           END-IF.

       2400-MAKE-GREETING.
      *    GREET THE USER WITH A MESSAGE
           INITIALIZE MESSO.

           STRING "Hello " DELIMITED BY SIZE
                  WS-USER-ID DELIMITED BY SPACE
                  "!" DELIMITED BY SIZE
              INTO MESSO
           END-STRING.
           
       2500-RETURN-AND-END.
      *    THIS ENDS THE CICS CONVERSATION
           EXEC CICS RETURN
                END-EXEC.
                