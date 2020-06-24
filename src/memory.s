; SNES Microgame engine
; Copyright (C) 2020 NovaSquirrel
;
; This program is free software: you can redistribute it and/or
; modify it under the terms of the GNU General Public License as
; published by the Free Software Foundation; either version 3 of the
; License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
; General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;

; Format for 16-bit X and Y positions and speeds:
; HHHHHHHH LLLLSSSS
; |||||||| ||||++++ - subpixels
; ++++++++ ++++------ actual pixels

.include "memory.inc"

.segment "ZEROPAGE"
  keydown: .res 2
  keynew:  .res 2
  keylast: .res 2
  retraces: .res 2
  OamPtr: .res 2
  seed: .res 4
  ScrollX: .res 2
  ScrollY: .res 2
  TempVal: .res 4

  DecodePointer: .res 3
  LevelBlockPtr: .res 3

  MicrogameTime:       .res 2 ; Game frames
  MicrogameRealFrames: .res 2 ; Used to determine when to run everything twice
  MicrogameFrames:     .res 2 ; Used for every X frames stuff

  MicrogameDifficulty: .res 1 ; 1, 2, or 4
  MicrogameWon: .res 1
  MicrogameLost: .res 1
  MicrogameJustWon: .res 1
  MicrogameJustLost: .res 1

  ; Variables for use in games
  MicrogameGlobals: .res 32 ; 16 globals
  MicrogameTemp:    .res 16 ; 8 temporary variables

  ThisActor:  .res 2 ; current actor
  OtherActor: .res 2 ; the other actor

  MapWidth:  .res 1
  MapHeight: .res 1

  ; Pointers for the current game's data
  GameDataPointer: .res 3
  GameDataPointer_BlockUL:    .res 3
  GameDataPointer_BlockUR:    .res 3
  GameDataPointer_BlockLL:    .res 3
  GameDataPointer_BlockLR:    .res 3
  GameDataPointer_BlockFlags: .res 3
  GameDataPointer_ActorRun:   .res 3
  GameDataPointer_ActorInit:  .res 3
  GameDataPointer_Animations: .res 3

.segment "BSS"
  ActorSize = 15*2
  ActorStart: .res ActorLen*ActorSize
  ActorEnd:
  INVALID_ACTOR: .res ActorSize ; dummy

  ActorType         = 0  ; Actor type ID
  ActorPX           = 2  ; Positions
  ActorPY           = 4  ;
  ActorVX           = 6  ; Speeds
  ActorVY           = 8  ;
  ActorVarA         = 10 ; 
  ActorVarB         = 12 ; 
  ActorVarC         = 14 ; 
  ActorVarD         = 16 ; 
  ActorVarE         = 18 ; 
  ActorVarF         = 20 ; 
  ActorDirection    = 22 ;
  ActorArt          = 24 ;
  ActorSpeed        = 26 ;
  ActorOnGround     = 28 ;

  OAM:   .res 512
  OAMHI: .res 512

  ColumnUpdateAddress: .res 2     ; Address to upload to, or zero for none
  ColumnUpdateBuffer:  .res 32*2  ; 32 tiles vertically
  RowUpdateAddress:    .res 2     ; Address to upload to, or zero for none
  RowUpdateBuffer:     .res 64*2  ; 64 tiles horizontally

  BlockUpdateAddress:  .res BLOCK_UPDATE_COUNT*2
  BlockUpdateDataTL:   .res BLOCK_UPDATE_COUNT*2
  BlockUpdateDataTR:   .res BLOCK_UPDATE_COUNT*2
  BlockUpdateDataBL:   .res BLOCK_UPDATE_COUNT*2
  BlockUpdateDataBR:   .res BLOCK_UPDATE_COUNT*2

  OldScrollX: .res 2
  OldScrollY: .res 2
  GameInitPhase: .res 1

  RanIntoBlockAType:     .res 2
  RanIntoBlockAPosition: .res 2
  RanIntoBlockBType:     .res 2
  RanIntoBlockBPosition: .res 2

.segment "BSS7E"

.segment "BSS7F"
LevelMap: .res 32768 ; 128*128
