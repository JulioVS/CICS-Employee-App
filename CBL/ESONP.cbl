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
           IF EIBCALEN IS EQUAL TO ZERO
      *       THIS IS THE START OF THE (PSEUDO) CONVERSATION,
      *       MEANING THE FIRST INTERACTION OF THE PROCESS,
      *       HENCE THE EMPTY COMM-AREA.-
              INITIALIZE WS-SESSION-STATE
              INITIALIZE ESONMO

      *       FOR THE FIRST INTERACTION, IT SENDS THE EMPY MAP WITH
      *       JUST THE TRANSACTION ID ON IT (AN ECHO OF A KNOWN VALUE)
              MOVE EIBTRNID TO TRANIDO

              EXEC CICS SEND
                   MAP('ESONM')
                   MAPSET('ESONMAP')
                   FROM (ESONMO)
                   ERASE
                   END-EXEC

      *       THEN, IT RETURNS JUST SAVING THE STILL-EMPTY STATE
      *       AND ENDING THIS STEP OF THE CONVERSATION.
              EXEC CICS RETURN
                   COMMAREA(WS-SESSION-STATE)
                   TRANSID(EIBTRNID)
                   END-EXEC
           ELSE
      *       THIS IS THE CONTINUATION OF THE CONVERSATION,
      *       MEANING THE SECOND INTERACTION OF THE PROCESS,
      *       HENCE THE COMM-AREA IS NOT EMPTY.

      *       RESTORE PREVIOUS SESSION DATA INTO MY VARS
              MOVE DFHCOMMAREA TO WS-SESSION-STATE

      *       GET INPUT FROM USER
              EXEC CICS RECEIVE
                   MAP('ESONM')
                   MAPSET('ESONMAP')
                   INTO (ESONMI)
                   END-EXEC

      *       IF NEW DATA WAS SENT, UPDATE STATE
              IF USERIDI IS NOT EQUAL TO LOW-VALUES
                 MOVE USERIDI TO WS-USER-ID
              END-IF
              IF PASSWDI IS NOT EQUAL TO LOW-VALUES
                 MOVE PASSWDI TO WS-USER-PASSWORD
              END-IF

      *       SEND THE MAP BACK WITH A GREETING!
              STRING "Hello " DELIMITED BY SIZE
                     WS-USER-ID DELIMITED BY SPACE
                     "!" DELIMITED BY SIZE
                 INTO MESSO
              END-STRING

              EXEC CICS SEND
                   MAP('ESONM')
                   MAPSET('ESONMAP')
                   FROM (ESONMO)
                   ERASE
                   END-EXEC

              EXEC CICS RETURN
                   COMMAREA(WS-SESSION-STATE)
                   TRANSID(EIBTRNID)
                   END-EXEC
           END-IF.
