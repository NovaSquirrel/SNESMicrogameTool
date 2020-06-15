;
; SNES Microgame engine
; Copyright 2020 NovaSquirrel
; 
; This software is provided 'as-is', without any express or implied
; warranty.  In no event will the authors be held liable for any damages
; arising from the use of this software.
; 
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it and redistribute it
; freely, subject to the following restrictions:
; 
; 1. The origin of this software must not be misrepresented; you must not
;    claim that you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation would be
;    appreciated but is not required.
; 2. Altered source versions must be plainly marked as such, and must not be
;    misrepresented as being the original software.
; 3. This notice may not be removed or altered from any source distribution.
;
.include "snes.inc"
.include "global.inc"
.include "memory.inc"
.smart
.global LevelBuf
.import BlockTopLeft, BlockTopRight, BlockBottomLeft, BlockBottomRight

.segment "CODE"

.export GetLevelColumnPtr
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

.export RenderLevelColumnUpload
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

.export RenderLevelRowUpload
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
.export RenderLevelColumnLeft
.proc RenderLevelColumnLeft
  tya
  asl
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
  rtl
.endproc

; Render the right tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; 16-bit accumulator and index
.a16
.i16
.export RenderLevelColumnRight
.proc RenderLevelColumnRight
  tya
  asl
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
  rtl
.endproc


; Render the left tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; Initialize X with buffer position before calling.
; 16-bit accumulator and index
.a16
.i16
.export RenderLevelRowTop
.proc RenderLevelRowTop
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
  rtl
.endproc

; Render the right tile of a column of blocks
; (at LevelBlockPtr starting from index Y)
; Initialize X with buffer position before calling.
; 16-bit accumulator and index
.a16
.i16
.export RenderLevelRowBottom
.proc RenderLevelRowBottom
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
  rtl
.endproc
