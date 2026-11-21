; Board data, moves, mines and scoring            (Board.asm)

INCLUDE Frontier.inc

.data
CellType     BYTE CellCount DUP(CellEmpty)  ; what is on each cell
PlayerCell   BYTE 0             ; the player starts in the top-left corner
BotCell      BYTE LastCell      ; the bot starts in the bottom-right corner
PlayerPoints DWORD 0
BotPoints    DWORD 0
TurnNumber   DWORD 1            ; MaxTurns + 1 once the board is over
BoardLevel   DWORD 1            ; which board of the run this is
GamePhase    DWORD PhaseYou     ; whose move it is, or how the board ended

.code
;-----------------------------------------------------
CellToRowCol PROC USES ebx
;
; Splits a cell number into its row and column.
; Receives: EAX = cell (0 to 24)
; Returns: EAX = row, EDX = column
;-----------------------------------------------------
    mov edx,0                   ; DIV divides EDX:EAX
    mov ebx,BoardSize
    div ebx                     ; EAX = cell / 5, EDX = cell mod 5
    ret
CellToRowCol ENDP

END
