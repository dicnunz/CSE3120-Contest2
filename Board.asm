; Board data, moves, mines and scoring            (Board.asm)

INCLUDE Frontier.inc

.data
CellType     BYTE CellCount DUP(CellEmpty)  ; what is on each cell
PlayerCell   BYTE 0             ; the player starts in the top-left corner
BotCell      BYTE LastCell      ; the bot starts in the bottom-right corner
PlayerPoints DWORD 0
BotPoints    DWORD 0
TurnNumber   DWORD 1            ; MaxTurns + 1 once the board is over

.code

END
