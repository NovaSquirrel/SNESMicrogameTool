.include "ns_snes.s"

; main.s
.global main, nmi_handler, irq_handler

; ppuclear.s
.global ppu_copy_oam, ppu_pack_oamhi, ppu_clear_oam
.global ppu_copy, ppu_clear_nt, ppu_vsync
.global OAM, OAMHI

; bg.s
.global load_bg_tiles, draw_bg

; player.s
.global load_player_tiles, move_player, draw_player_sprite
.globalzp player_xlo, player_xhi, player_dxlo, player_yhi
.globalzp player_frame_sub, player_frame, player_facing

; blarggapu.s
.global spc_boot_apu


; Behavior primitives
.global random
.global RandomWithMaxConstant
.global ActorBallMovement
.global ActorBallMovementStop
.global ActorBallMovementReflect
.global ActorBallMovementBounce
.global ActorApplyVelocity
.global VectorMovementStop
.global VectorMovementReflect
.global Actor8WayMovement
.global Actor8WayMovementCollide
.global WinGame
.global LoseGame
.global ActorJumpToXY
.global ActorJumpToActor
.global ActorSwapWithActor
.global ActorDestroyType
.global ActorStop
.global ActorReverse
.global ActorCreateAtXY
.global PlaySoundEffect
.global ActorFindType
.global ActorLookAtPoint
.global ActorApplyGravity
.global ActorFall
.global BlockTargetXY
.global BlockTargetCoordinate
.global BlockTargetActorXY
.global BlockChangeType
.global ScrollCenterActor
.global ScrollFollowActor2
.global ScrollFollowActor4
.global ScrollFollowActor8

.global RandomChance
.global ActorInRegion
.global ActorTouchingType
.global ActorRanIntoBlock
.global ActorCenterOverlapBlock
.global ActorOverlapBlock

LEVEL_HEIGHT = 128
LEVEL_WIDTH  = 128
LEVEL_TILE_SIZE = 1
ForegroundBG = $c000
