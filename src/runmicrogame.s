.include "snes.inc"
.include "global.inc"
.include "memory.inc"
.smart

.segment "CODE"


.export StartMicrogame
.proc StartMicrogame
  setaxy8
  .import example_GameData
  lda #<example_GameData
  sta GameDataPointer+0
  lda #>example_GameData
  sta GameDataPointer+1
  lda #^example_GameData
  sta GameDataPointer+2
  sta GameDataPointer_BlockUL+2
  sta GameDataPointer_BlockUR+2
  sta GameDataPointer_BlockLL+2
  sta GameDataPointer_BlockLR+2
  sta GameDataPointer_BlockFlags+2
  sta GameDataPointer_ActorInit+2
  sta GameDataPointer_ActorRun+2

  ; Load in the pointers
  seta16
  ldy #5
  lda [GameDataPointer],y
  sta GameDataPointer_BlockUL
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockUR
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockLL
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockLR
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_BlockFlags
  ldy #16+1
  lda [GameDataPointer],y
  sta GameDataPointer_ActorRun
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_ActorInit
 
: jmp :-
.endproc


.proc MicrogameLoop
  rtl
.endproc
