; Shared definitions for Frontier                 (Frontier.inc)
; Every .asm file includes this file instead of Irvine32.inc.

INCLUDE Irvine32.inc

BoardSize   = 5                 ; the board is 5 tiles by 5 tiles
CellCount   = BoardSize * BoardSize  ; cells are numbered 0 to 24, row by row
LastCell    = CellCount - 1     ; the bot's corner
CenterCell  = 12                ; always has a mine
MinePairs   = 2                 ; random mirrored pairs next to the center mine
MaxTurns    = 20                ; turns on each board
HeadStart   = 3                 ; bot points added for each board cleared
BotDelay    = 400               ; milliseconds before the bot moves

CellEmpty   = 0                 ; values in CellType
CellFree    = 1                 ; a mine nobody owns yet
CellPlayer  = 2                 ; a mine the player owns
CellBot     = 3                 ; a mine the bot owns
