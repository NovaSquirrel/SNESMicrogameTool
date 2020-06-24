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

.segment "CODE"

.import GetLevelColumnPtr

.a16
.i16
.export UpdateScrolling
.proc UpdateScrolling
  ; Is a column update required?
  lda ScrollX
  eor OldScrollX
  and #$80
  beq NoUpdateColumn
    lda ScrollX
    cmp OldScrollX
    jsr ToTiles
    bcs UpdateRight
  UpdateLeft:
    sub #2             ; Two tiles to the left
    jsr UpdateColumn
    bra NoUpdateColumn
  UpdateRight:
    add #34            ; Two tiles past the end of the screen on the right
    jsr UpdateColumn
  NoUpdateColumn:

  ; Is a row update required?
  lda ScrollY
  eor OldScrollY
  and #$80             ; 8-pixel boundary
  beq NoUpdateRow
    lda ScrollY
    cmp OldScrollY
    jsr ToTiles
    bcs UpdateDown
  UpdateUp:
    jsr UpdateRow
    bra NoUpdateRow
  UpdateDown:
    add #29            ; Just past the screen height
    jsr UpdateRow
  NoUpdateRow:

  rts

; Convert a 12.4 scroll position to a number of tiles
ToTiles:
  php
  lsr ; \ shift out the subpixels
  lsr ;  \
  lsr ;  /
  lsr ; /

  lsr ; \
  lsr ;  | shift out 8 pixels
  lsr ; /
  plp
  rts
.endproc

.proc UpdateRow
Temp = 4
YPos = 6
  sta Temp

  ; Calculate the address of the row
  ; (Always starts at the leftmost column
  ; and extends all the way to the right.)
  and #31
  asl ; Multiply by 32, the number of words per row in a screen
  asl
  asl
  asl
  asl
  ora #ForegroundBG>>1
  sta RowUpdateAddress

  ; Get level pointer address
  ; (Always starts at the leftmost column of the screen)
  lda ScrollX
  xba
  dec a
  jsl GetLevelColumnPtr

  ; Get index for the PPU update buffer
  lda ScrollX
  xba
  dec a
  asl
  asl
  and #(64*2)-1
  tax

  ; Take the Y position, rounded to blocks,
  ; as the column of level data to read
  lda Temp
  and #<~1
  tay

  ; Generate the top or the bottom as needed
  lda Temp
  lsr
  bcs :+
  .import RenderLevelRowTop
  jsl RenderLevelRowTop
  rts
: .import RenderLevelRowBottom
  jsl RenderLevelRowBottom
  rts
.endproc

.proc UpdateColumn
Temp = 4
YPos = 6
  sta Temp

  ; Calculate address of the column
  and #31
  ora #ForegroundBG>>1
  sta ColumnUpdateAddress

  ; Use the second screen if required
  lda Temp
  and #32
  beq :+
    lda #2048>>1
    tsb ColumnUpdateAddress
  :

  ; Get level pointer address
  lda Temp ; Get metatile count
  lsr
  jsl GetLevelColumnPtr

  ; Use the Y scroll position in blocks
  lda ScrollY
  xba
  and #LEVEL_HEIGHT-1
  asl
  tay

  ; Generate the top or bottom as needed
  lda Temp
  lsr
  bcc :+
  .import RenderLevelColumnRight
  jsl RenderLevelColumnRight
  rts
: .import RenderLevelColumnLeft
  jsl RenderLevelColumnLeft
  rts 
.endproc
