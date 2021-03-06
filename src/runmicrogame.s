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


.export StartMicrogame
.proc StartMicrogame
  setaxy8
  .import example_GameData
  lda #1
  sta seed+0
  ina
  sta seed+1
  ina
  sta seed+2
  ina
  sta seed+3

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
  sta GameDataPointer_Animations+2

  ; Load in the pointers
  seta16
  ldy #3*2
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
  ldy #9*2
  lda [GameDataPointer],y
  sta GameDataPointer_ActorRun
  iny
  iny
  lda [GameDataPointer],y
  sta GameDataPointer_ActorInit
  ldy #14*2
  lda [GameDataPointer],y
  sta GameDataPointer_Animations

  ; Palettes
  lda #DMAMODE_CGDATA
  sta DMAMODE
  lda [GameDataPointer]
  sta DMAADDR
  lda #16*2*16
  sta DMALEN
  seta8
  lda GameDataPointer+2
  sta DMAADDRBANK
  stz CGADDR
  lda #1
  sta COPYSTART

  ; Background CHR
  seta16
  lda #DMAMODE_PPUDATA
  sta DMAMODE
  ldy #11*2
  lda [GameDataPointer],y
  sta DMALEN
  ldy #2*2
  lda [GameDataPointer],y
  sta DMAADDR
  seta8
  ldy #1*2+0
  lda [GameDataPointer],y
  sta DMAADDRBANK
  stz PPUADDR+0
  stz PPUADDR+1
  lda #1
  sta COPYSTART

  ; Sprite CHR
  seta16
  ldy #12*2
  lda [GameDataPointer],y
  sta DMALEN
  ldy #13*2
  lda [GameDataPointer],y
  sta DMAADDR
  seta8
  ldy #1*2+1
  lda [GameDataPointer],y
  sta DMAADDRBANK
  stz PPUADDR+0
  lda #$80>>1
  sta PPUADDR+1
  lda #1
  sta COPYSTART

  ; Clear the map
  setxy16
  ldx #0
  ldy #128*128
  .import MemClear7F
  jsl MemClear7F

  stz ScrollX
  stz ScrollY

  ; Load map zero
  lda #0
  jsr LoadMicrogameMap

  jmp MicrogameLoop
.endproc

.proc LoadMicrogameMap
Pointer = DecodePointer
MapNum = 3
ActorList = 4 ; Word
ColumnsLeft = 6
RowsLeft = 7
  setaxy8
  sta MapNum

  lda GameDataPointer+2
  sta Pointer+2

  seta16
  ldy #8*2 ; Map list
  lda [GameDataPointer],y
  sta Pointer

  ; Select the correct map
  lda MapNum
  and #255
  asl
  tay
  lda [Pointer],y
  sta Pointer

  seta8
  lda #1
  sta GameInitPhase

  ; Background color
  stz CGADDR
  lda [Pointer]
  sta CGDATA
  ldy #1
  lda [Pointer],y
  sta CGDATA

  ; Get actor list pointer
  iny
  lda [Pointer],y
  sta ActorList+0
  iny
  lda [Pointer],y
  sta ActorList+1

  ; Get width and height
  iny
  lda [Pointer],y
  sta MapWidth
  sta ColumnsLeft
  iny
  lda [Pointer],y
  sta MapHeight
  sta RowsLeft
  setxy16

  lda #^LevelMap
  pha
  plb

  ; Now Y points at the map data itself
  ldx #0
  iny
Loop:
  lda [Pointer],y
  sta LevelMap,x
  iny
  inx
  lda [Pointer],y
  sta LevelMap,x
  iny
  inx
  dec RowsLeft
  bne Loop
  ; Next column
  lda MapHeight
  sta RowsLeft
  seta16
  txa
  and #.loword(~255) ; Reset to the first row
  add #256           ; Move down a column
  tax
  seta8
  dec ColumnsLeft
  bne Loop

  ; Clear the actor list
  ldx #ActorStart
: stz 0,x
  inx
  cpx #ActorEnd
  bne :-

  ; Change the data bank to the game's bank
  lda GameDataPointer+2
  pha
  plb

  ; -----------------------------------------------------

  ; Insert all of the actors and run their init routines
  seta16
  lda ActorList
  sta Pointer

  ldx #ActorStart
  ldy #0
  .import CallActorInit
ActorLoop:
  lda [Pointer],y
  iny
  and #255
  cmp #255
  beq LastActor
  sta ActorType,x

  lda [Pointer],y
  sta ActorPX,x
  iny
  iny
  lda [Pointer],y
  sub #$0100
  sta ActorPY,x
  iny
  iny

  ; Attributes, 128 is yflip, 64 is xflip
  lda [Pointer],y
  and #255
  iny

  phy
  stx ThisActor
  jsl CallActorInit
  ply

  txa
  add #ActorSize
  tax
  bra ActorLoop
LastActor:

  ; Pointer to run when initializing
  ldy #16*2
  lda [GameDataPointer],y
  beq :+
    sta 0
    jsl CallPointer
  :

  ; Set up PPU registers and stuff
  seta8
  lda #1
  sta BGMODE       ; mode 1

  stz BGCHRADDR+0  ; bg planes 0-1 CHR at $0000
  lda #$e>>1
  sta BGCHRADDR+1  ; bg plane 2 CHR at $e000
  lda #$8000 >> 14
  sta OBSEL      ; sprite CHR at $8000, sprites are 8x8 and 16x16
  lda #1 | ($c000 >> 9)
  sta NTADDR+0   ; plane 0 nametable at $c000, 2 screens wide
  lda #0 | ($d000 >> 9)
  sta NTADDR+1   ; plane 1 nametable at $d000, 1 screen
  lda #0 | ($e000 >> 9)
  sta NTADDR+2   ; plane 2 nametable at $e000, 1 screen

  stz PPURES
  lda #%00010001  ; enable plane 0 and sprites
  sta BLENDMAIN
  stz BLENDSUB
  lda #VBLANK_NMI|AUTOREAD
  sta PPUNMI
  stz CGWSEL
  stz CGADSUB
  stz GameInitPhase


  ; Render the screen
  lda #$7f
  sta LevelBlockPtr+2
  .import RenderLevelScreens
  jsl RenderLevelScreens

  ldy #0
  ldx #($d000 >> 1)
  jsl ppu_clear_nt
  rts
.endproc

.proc MicrogameLoop
  seta8
  lda #VBLANK_NMI|AUTOREAD
  sta PPUNMI
  seta16
  ldx #0
  jsl ppu_clear_oam
  jsl ppu_pack_oamhi

Forever:
  jsl WaitVblank
  ; -------------------------------------------------------
  ; Do vblank things!
  ; -------------------------------------------------------
  seta8
  lda #15
  sta PPUBRIGHT
  jsl ppu_copy_oam

  ; -------------------------------------------------------
  ; Do screen updates
  ; -------------------------------------------------------

  ; Do row/column updates if required
  lda ColumnUpdateAddress
  beq :+
    .import RenderLevelColumnUpload
    jsl RenderLevelColumnUpload
    stz ColumnUpdateAddress
  :
  lda RowUpdateAddress
  beq :+
    .import RenderLevelRowUpload
    jsl RenderLevelRowUpload
    stz RowUpdateAddress
  :

  ; Do block updates
  seta16
  ldx #(BLOCK_UPDATE_COUNT-1)*2
BlockUpdateLoop:
  lda BlockUpdateAddress,x
  beq SkipBlock
  sta PPUADDR
  lda BlockUpdateDataTL,x
  sta PPUDATA
  lda BlockUpdateDataTR,x
  sta PPUDATA

  lda BlockUpdateAddress,x ; Move down a row
  add #(32*2)>>1
  sta PPUADDR
  lda BlockUpdateDataBL,x
  sta PPUDATA
  lda BlockUpdateDataBR,x
  sta PPUDATA

  stz BlockUpdateAddress,x ; Cancel out the block now that it's been written
SkipBlock:
  dex
  dex
  bpl BlockUpdateLoop

  ; -------------------------------------------------------
  ; Wait for the controller information to be ready
  ; -------------------------------------------------------
  seta8
  lda #$01
padwait:
  bit VBLSTATUS
  bne padwait

  seta16
  lda ScrollX
  lsr
  lsr
  lsr
  lsr
  sta 0

  lda ScrollY
  lsr
  lsr
  lsr
  lsr
  dec a ; SNES displays lines 1-224 so shift it up to 0-223
  sta 2
  seta8

  lda 0
  sta BGSCROLLX
  lda 1
  sta BGSCROLLX
  lda 2
  sta BGSCROLLY
  lda 3
  sta BGSCROLLY

  ; Update keys
  seta16
  lda keydown
  sta keylast
  lda JOY1CUR
  sta keydown
  lda keylast
  eor #$ffff
  and keydown
  sta keynew

  ; -------------------------------------------------------
  ; Game logic
  ; -------------------------------------------------------
  stz OamPtr

  lda ScrollX
  sta OldScrollX
  lda ScrollY
  sta OldScrollY

  ; Pointer to run every frame
  ldy #15*2
  lda [GameDataPointer],y
  beq :+
    sta 0
    jsl CallPointer
  :

  jsr RunActors
  jsr DrawActors
  .import UpdateScrolling
  jsr UpdateScrolling

  ; -------------------------------------------------------
  ; Prepare OAM for upload
  ; -------------------------------------------------------

  ldx OamPtr
  jsl ppu_clear_oam
  jsl ppu_pack_oamhi

  inc MicrogameFrames

  jmp Forever
.endproc

.proc RunActors
  ldx #ActorStart
Loop:
  lda ActorType,x
  beq Skip
  stx ThisActor
  asl ; * 2
  tay
  lda [GameDataPointer_ActorRun],y
  beq Skip
  sta 0
  jsl Call

Skip:
  txa
  add #ActorSize
  tax
  cpx #ActorEnd
  bne Loop
  rts

Call:
  seta8
  lda GameDataPointer+2
  pha
  plb
  sta 2
  seta16
  jml [0]
.endproc
CallPointer = RunActors::Call

.proc DrawActors
  ldx #ActorStart
Loop:
  lda ActorType,x
  beq Skip

  lda ActorArt,x
  and #OAM_XFLIP|OAM_YFLIP
  sta 0 ; Save flips
  lda ActorArt,x
  and #.loword(~(OAM_XFLIP|OAM_YFLIP))
  asl ; * 2
  asl ; * 4
  tay
  lda [GameDataPointer_Animations],y
  cmp #16
  bne Not16
    iny
    iny
    lda [GameDataPointer_Animations],y
    ora 0
    jsr DispActor16x16
  Not16:

Skip:
  txa
  add #ActorSize
  tax
  cpx #ActorEnd
  bne Loop

  rts
.endproc

.proc WaitVblank
  php
  seta8
loop1:
  bit VBLSTATUS  ; Wait for leaving previous vblank
  bmi loop1
loop2:
  wai
  bit VBLSTATUS  ; Wait for start of this vblank
  bpl loop2
  plp
  rtl
.endproc


; Calculate the position of the Actor on-screen
; and whether it's visible in the first place
.a16
.proc ActorDrawPosition
  lda ActorPX,x
  sub ScrollX
  cmp #.loword(-1*256)
  bcs :+
  cmp #16*256
  bcs Invalid
: jsr Shift
  sub #8
  sta 0

  lda ActorPY,x
  sub ScrollY
  ; TODO: properly allow sprites to be partially offscreen on the top
;  cmp #.loword(-1*256)
;  bcs :+
  cmp #15*256
  bcs Invalid
  jsr Shift
  sub #8
  sta 2

  sec
  rts
Invalid:
  clc
  rts

Shift:
  eor #.loword(-$8000)
  lsr
  lsr
  lsr
  lsr
  add #.loword(-($8000 >> 4))
  rts
.endproc

.a16
.export DispActor16x16
.proc DispActor16x16
  sta 4

  ldy OamPtr

  jsr ActorDrawPosition
  bcs :+
    rts
  :  

  lda 4
  ora #OAM_PRIORITY_2
  sta OAM_TILE,y ; 16-bit, combined with attribute

  seta8
  lda 0
  sta OAM_XPOS,y
  lda 2
  sta OAM_YPOS,y

  ; Get the high bit of the calculated position and plug it in
  lda 1
  cmp #%00000001
  lda #1 ; 16x16 sprites
  rol
  sta OAMHI+1,y
  seta16

  tya
  add #4
  sta OamPtr
  rts
.endproc
