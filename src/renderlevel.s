.include "snes.inc"
.include "global.inc"
.include "memory.inc"
.smart
.global LevelBuf
.import BlockTopLeft, BlockTopRight, BlockBottomLeft, BlockBottomRight

.segment "CODE"

LEVEL_HEIGHT = 128
LEVEL_WIDTH  = 128
LEVEL_TILE_SIZE = 1
ForegroundBG = $c000


.proc GetLevelColumnPtr
.a16
  and #255
  xba ; * 256
  lsr ; * 128
  sta LevelBlockPtr
  rtl
.endproc

.a16
.i16
.export RenderLevelScreens
.proc RenderLevelScreens
  setaxy16
  lda #256*15
  sta ScrollX

  lda #256
  sta ScrollY

  ; -------------------

BlockNum = 0
BlocksLeft = 2
YPos = 4
  ; Start rendering
  lda ScrollX+1 ; Get the column number in blocks
  and #$ff
  sub #4   ; Render out past the left side a bit
  sta BlockNum
  jsl GetLevelColumnPtr
  lda #26  ; Go 26 blocks forward
  sta BlocksLeft

  lda ScrollY
  xba
  and #LEVEL_HEIGHT-1
  asl
  sta YPos

Loop:
  lda LevelBlockPtr

  ; Calculate the column address
  lda BlockNum
  and #15
  asl
  ora #ForegroundBG>>1
  sta ColumnUpdateAddress

  ; Use the other nametable if necessary
  lda BlockNum
  and #16
  beq :+
    lda #2048>>1
    tsb ColumnUpdateAddress
  :

  ; Upload two columns
  ldy YPos
  jsl RenderLevelColumnLeft
  jsl RenderLevelColumnUpload
  inc ColumnUpdateAddress
  ldy YPos
  jsl RenderLevelColumnRight
  jsl RenderLevelColumnUpload

  ; Move onto the next block
  lda LevelBlockPtr
  add #LEVEL_HEIGHT*LEVEL_TILE_SIZE
  and #(LEVEL_WIDTH*LEVEL_HEIGHT*LEVEL_TILE_SIZE)-1
  sta LevelBlockPtr
  inc BlockNum

  dec BlocksLeft
  bne Loop


  stz ColumnUpdateAddress
  rtl
.endproc

.proc RenderLevelColumnUpload
  php
  seta16

  ; Set DMA parameters
  lda ColumnUpdateAddress
  sta PPUADDR
  lda #DMAMODE_PPUDATA
  sta DMAMODE
  lda #ColumnUpdateBuffer
  sta DMAADDR
  lda #32*2
  sta DMALEN

  seta8
  stz DMAADDRBANK

  lda #INC_DATAHI|VRAM_DOWN
  sta PPUCTRL

  lda #%00000001
  sta COPYSTART

  lda #INC_DATAHI
  sta PPUCTRL
  plp
  rtl
.endproc

.proc RenderLevelRowUpload
  php

  ; .------------------
  ; | First screen
  ; '------------------
  seta16

  ; Set DMA parameters  
  lda RowUpdateAddress
  sta PPUADDR
  lda #DMAMODE_PPUDATA
  sta DMAMODE
  lda #RowUpdateBuffer
  sta DMAADDR
  lda #32*2
  sta DMALEN

  seta8
  stz DMAADDRBANK

  lda #%00000001
  sta COPYSTART

  ; .------------------
  ; | Second screen
  ; '------------------
  seta16

  ; Reset the counters. Don't need to do DMAMODE again I assume?
  lda RowUpdateAddress
  ora #2048>>1
  sta PPUADDR
  lda #RowUpdateBuffer+32*2
  sta DMAADDR
  lda #32*2
  sta DMALEN

  seta8
  stz DMAADDRBANK

  lda #%00000001
  sta COPYSTART

  plp
  rtl
.endproc

.segment "BlockGraphicData"
; Render the left tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; 16-bit accumulator and index
.a16
.i16
.proc RenderLevelColumnLeft
  phb
  phk
  plb

  tya
  asl
  and #(32*2)-1
  tax
  stx TempVal
: lda [LevelBlockPtr],y ; Get the next level tile
  iny
  phy
  and #255
  asl
  tay
  ; Write the two tiles in
  lda [GameDataPointer_BlockUL],y
  sta ColumnUpdateBuffer,x
  inx
  inx
  lda [GameDataPointer_BlockLL],y
  sta ColumnUpdateBuffer,x
  inx
  inx
  ply

  ; Wrap around in the buffer
  txa
  and #(32*2)-1
  tax

  ; Stop after 32 tiles vertically
  cpx TempVal
  bne :-

  plb
  rtl
.endproc

; Render the right tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; 16-bit accumulator and index
.a16
.i16
.proc RenderLevelColumnRight
  phb
  phk
  plb

  tya
  asl
  and #(32*2)-1
  tax
  stx TempVal
: lda [LevelBlockPtr],y ; Get the next level tile
  iny
  phy
  and #255
  asl
  tay
  ; Write the two tiles in
  lda [GameDataPointer_BlockUR],y
  sta ColumnUpdateBuffer,x
  inx
  inx
  lda [GameDataPointer_BlockLR],y
  sta ColumnUpdateBuffer,x
  inx
  inx
  ply

  ; Wrap around in the buffer
  txa
  and #(32*2)-1
  tax

  ; Stop after 32 tiles vertically
  cpx TempVal
  bne :-

  plb
  rtl
.endproc


; Render the left tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; Initialize X with buffer position before calling.
; 16-bit accumulator and index
.a16
.i16
.proc RenderLevelRowTop
  phb
  phk
  plb

  lda #20
  sta TempVal

: lda [LevelBlockPtr],y ; Get the next level tile
  phy
  and #255
  asl
  tay
  ; Write the two tiles in
  lda [GameDataPointer_BlockUL],y
  sta RowUpdateBuffer,x
  inx
  inx
  lda [GameDataPointer_BlockUR],y
  sta RowUpdateBuffer,x
  inx
  inx
  ply

  ; Next column
  lda LevelBlockPtr
  add #128 ;LevelColumnSize
  and #(LEVEL_WIDTH*LEVEL_HEIGHT*LEVEL_TILE_SIZE)-1 ; Mask for entire level, dimensions actually irrelevant
  sta LevelBlockPtr

  ; Wrap around in the buffer
  txa
  and #(64*2)-1
  tax

  ; Stop after 64 tiles horizontally
  dec TempVal
  bne :-

  plb
  rtl
.endproc

; Render the right tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; Initialize X with buffer position before calling.
; 16-bit accumulator and index
.a16
.i16
.proc RenderLevelRowBottom
  phb
  phk
  plb

  lda #20
  sta TempVal

: lda [LevelBlockPtr],y ; Get the next level tile
  phy
  and #255
  asl
  tay
  ; Write the two tiles in
  lda [GameDataPointer_BlockLL],y
  sta RowUpdateBuffer,x
  inx
  inx
  lda [GameDataPointer_BlockLR],y
  sta RowUpdateBuffer,x
  inx
  inx
  ply

  ; Next column
  lda LevelBlockPtr
  add #128 ;LevelColumnSize
  and #(LEVEL_WIDTH*LEVEL_HEIGHT*LEVEL_TILE_SIZE)-1 ; Mask for entire level, dimensions actually irrelevant
  sta LevelBlockPtr

  ; Wrap around in the buffer
  txa
  and #(64*2)-1
  tax

  ; Stop after 64 tiles horizontally
  dec TempVal
  bne :-

  plb
  rtl
.endproc
