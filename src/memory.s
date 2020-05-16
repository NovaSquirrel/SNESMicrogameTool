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

.segment "BSS"
  ActorSize = 14*2
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

  OAM:   .res 512
  OAMHI: .res 512

.segment "BSS7E"

.segment "BSS7F"
