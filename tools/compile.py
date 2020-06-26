#!/usr/bin/env python3
#
# SNES Microgame engine compiler
# Copyright 2019-2020 NovaSquirrel
# 
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
#
import glob, json, math

outfile = None
gamename = None
label_count = 0
def next_label():
	global label_count
	label_count += 1
	return label_count

def label_name(label):
	return "lbl_%d" % label

def insert_label(label):
	outfile.write("%s:\n" % label_name(label))

# -----------------------------------------------------------------------------

conditions = {}
conditions_flags = {} # The branch condition for if the condition is -not- true

conditions['find-type'] = ('jsl ActorFindType', 1)
conditions_flags['find-type'] = 'cc'
conditions['easy'] = 'lda MicrogameDifficulty\ncmp #1'
conditions_flags['easy'] = 'eq'
conditions['medium'] = 'lda MicrogameDifficulty\nand #2'
conditions_flags['medium'] = 'eq'
conditions['hard'] = 'lda MicrogameDifficulty\nand #4'
conditions_flags['hard'] = 'eq'
conditions['difficulty'] = ('and MicrogameDifficulty', 1)
conditions_flags['difficulty'] = 'eq'
conditions['key-press'] = ('and keynew', 1)
conditions_flags['key-press'] = 'eq'
conditions['key-release'] = ('sta 0\nlda keydown\neor #255\nand keylast\nand 0', 1)
conditions_flags['key-press'] = 'eq'
conditions_flags['key-release'] = 'eq'
conditions['key-held'] = ('and keydown', 1)
conditions_flags['key-held'] = 'eq'
conditions['random'] = ('jsl RandomChance', 1)
conditions_flags['random'] = 'cc'
conditions['just-won'] = 'lda MicrogameJustWon'
conditions_flags['just-won'] = 'eq'
conditions['just-lost'] = 'lda MicrogameJustLost'
conditions_flags['just-lost'] = 'eq'
conditions['has-won'] = 'lda MicrogameWon'
conditions_flags['has-won'] = 'eq'
conditions['has-won'] = 'lda MicrogameLost'
conditions_flags['has-won'] = 'eq'
conditions['in-region'] = ('jsl ActorInRegion', 4)
conditions_flags['in-region'] = 'cc'
conditions['touching-type'] = ('jsl ActorTouchingType', 1)
conditions_flags['touching-type'] = 'cc'
conditions['actor-on-ground'] = 'lda ActorOnGround,x'
conditions_flags['actor-on-ground'] = 'eq'
conditions['actor-hit-ceiling'] = 'lda BlockHitFromAboveOrBelow\ncmp #2'
conditions_flags['actor-hit-ceiling'] = 'eq'

conditions['actor-hit-wall'] = 'lda RanIntoBlockAType\nora RanIntoBlockBType'
conditions_flags['actor-hit-wall'] = 'eq'
conditions['actor-hit-floor-block'] = ('jsl ActorHitFloorBlock', 1)
conditions_flags['actor-hit-floor-block'] = 'cc'
conditions['actor-hit-floor-block-class'] = ('jsl ActorHitFloorBlockClass', 1)
conditions_flags['actor-hit-floor-block-class'] = 'cc'
conditions['actor-hit-ceiling-block'] = ('jsl ActorHitCeilingBlock', 1)
conditions_flags['actor-hit-ceiling-block'] = 'cc'
conditions['actor-hit-ceiling-block-class'] = ('jsl ActorHitCeilingBlockClass', 1)
conditions_flags['actor-hit-ceiling-block-class'] = 'cc'

conditions['actor-overlap-block'] = ('jsl ActorOverlapBlock', 1)
conditions_flags['actor-overlap-block'] = 'cc'
conditions['actor-overlap-block-class'] = ('jsl ActorOverlapBlockClass', 1)
conditions_flags['actor-overlap-block-class'] = 'cc'
conditions['actor-center-overlap-block'] = ('jsl ActorCenterOverlapBlock', 1)
conditions_flags['actor-center-overlap-block'] = 'cc'
conditions['actor-center-overlap-block-class'] = ('jsl ActorCenterOverlapBlockClass', 1)
conditions_flags['actor-center-overlap-block-class'] = 'cc'
conditions['actor-ran-into-block'] = ('jsl ActorRanIntoBlock', 1)
conditions_flags['actor-ran-into-block'] = 'cc'
conditions['actor-ran-into-block-class'] = ('jsl ActorRanIntoBlockClass', 1)
conditions_flags['actor-ran-into-block-class'] = 'cc'

conditions['always'] = 'clc' # dummy, probably shouldn't use
conditions_flags['always'] = 'cc'

conditions['every-2-frames'] = 'lda MicrogameFrames\nand #1'
conditions_flags['every-2-frames'] = 'ne'
conditions['every-4-frames'] = 'lda MicrogameFrames\nand #3'
conditions_flags['every-4-frames'] = 'ne'
conditions['every-8-frames'] = 'lda MicrogameFrames\nand #7'
conditions_flags['every-8-frames'] = 'ne'
conditions['every-16-frames'] = 'lda MicrogameFrames\nand #15'
conditions_flags['every-16-frames'] = 'ne'
conditions['every-32-frames'] = 'lda MicrogameFrames\nand #31'
conditions_flags['every-32-frames'] = 'ne'
conditions['every-64-frames'] = 'lda MicrogameFrames\nand #63'
conditions_flags['every-64-frames'] = 'ne'
conditions['every-128-frames'] = 'lda MicrogameFrames\nand #127'
conditions_flags['every-128-frames'] = 'ne'
conditions['at-end'] = 'lda MicrogameTime \ cmp #128' # todo
conditions_flags['at_end'] = 'ne'

conditions ['block-target-solid'] = ('BlockTargetSolid', 1)
conditions_flags['block-target-solid'] = 'cc'

def condition_block_target_flags(a):
	print("Block target flags")
conditions['block-target-flags'] = condition_block_target_flags
conditions_flags['block-target-flags'] = 'cc'

def insert_branch(flags, label, negate):
	opposite = {
		'cc': 'cs',
		'cs': 'cc',
		'pl': 'mi',
		'mi': 'pl',
		'ne': 'eq',
		'eq': 'ne',
		'vc': 'vs',
		'vs': 'vc',
	}
	if negate:
		flags = opposite[flags]
	outfile.write('j%s %s\n' % (flags, label_name(label)))

def compile_condition(condition, label, negate):
	# allow negation
	if condition[0] == 'not':
		negate = not negate
		condition.pop(0)

	if len(condition) == 3:
		if condition[1] == '>':
			outfile.write('lda %s\n' % compile_value(condition[2]))
			outfile.write('cmp %s\n' % compile_value(condition[0]))
			insert_branch('cs', label, negate)
			return
		elif condition[1] == '>=':
			outfile.write('lda %s\n' % compile_value(condition[0]))
			outfile.write('cmp %s\n' % compile_value(condition[2]))
			insert_branch('cc', label, negate)
			return
		elif condition[1] == '<':
			outfile.write('lda %s\n' % compile_value(condition[0]))
			outfile.write('cmp %s\n' % compile_value(condition[2]))
			insert_branch('cs', label, negate)
			return
		elif condition[1] == '<=':
			outfile.write('lda %s\n' % compile_value(condition[2]))
			outfile.write('cmp %s\n' % compile_value(condition[0]))
			insert_branch('cc', label, negate)
			return
		elif condition[1] == '==':
			if condition[2] == 0:
				outfile.write('lda %s\n' % compile_value(condition[0]))
			else:
				outfile.write('lda %s\n' % compile_value(condition[0]))
				outfile.write('cmp %s\n' % compile_value(condition[2]))
			insert_branch('ne', label, negate)
			return
		elif condition[1] == '!=':
			if condition[2] == 0:
				outfile.write('lda %s\n' % compile_value(condition[0]))
			else:
				outfile.write('lda %s\n' % compile_value(condition[0]))
				outfile.write('cmp %s\n' % compile_value(condition[2]))
			insert_branch('eq', label, negate)
			return
	if condition[0] == 'and':
		condition.pop(0)
		for c in condition:
			compile_condition(c, label, negate)
		return
	if condition[0] == 'or':
		condition.pop(0)
		doit = next_label()

		while len(condition):
			c = condition.pop(0)
			if len(condition) == 0: # last one
				compile_condition(c, label, negate)
			else: # all others are the opposite
				compile_condition(c, doit, not negate)

		insert_label(doit)
		return

	# fall back and try to use the list
	name = condition[0]
	args = condition[1:]
	if name in conditions:
		if type(conditions[name]) == str: # fill in the string with the other arguments
			outfile.write((conditions[name] % tuple(args))+"\n")
		elif type(conditions[name]) == tuple:
			# call a primitive but with zeropage and/or accumulator arguments
			variable = len(args)-2 # zeropage variable to write to
			while len(args):
				value = args.pop()
				outfile.write('lda %s\n' % compile_value(value))
				if variable >= 0:
					outfile.write('sta %d\n' % variable)
				variable -= 1
			outfile.write('%s\n' % conditions[name][0]) # no JSR on this one
		else:
			conditions[name](args)
		insert_branch(conditions_flags[name], label, negate)
	else:
		print('Unknown condition: %s' % name)

# -----------------------------------------------------------------------------

actions = {}
actions['ball-movement'] = 'jsl ActorBallMovement'
actions['ball-movement-stop'] = 'jsl ActorBallMovement'
actions['ball-movement-reflect'] = 'jsl ActorBallMovement'
actions['ball-movement-bounce'] = 'jsl ActorBallMovement'
actions['vector-movement'] = 'jsl ActorApplyVelocity'
actions['vector-movement-stop'] = 'jsl ActorApplyVelocity'
actions['vector-movement-reflect'] = 'jsl ActorApplyVelocity'
actions['8way-movement'] = ('Actor8WayMovement', 1)
actions['8way-movement-stop'] = ('Actor8WayMovementCollide', 1)
actions['win-game'] = 'jsl WinGame'
actions['lose-game'] = 'jsl LoseGame'
actions['jump-to-xy'] = ('ActorJumpToXY', 2)
actions['jump-to-other'] = 'jsl ActorJumpToActor'
actions['swap-places'] = 'jsl ActorSwapWithActor'
actions['destroy'] = 'lda #0\nsta ActorType,x'
actions['destroy-type'] = ('ActorDestroyType', 1)
actions['target-this'] = 'ldx ThisActor'
actions['target-other'] = 'ldx OtherActor'
actions['exit'] = 'rtl'
actions['stop'] = 'jsl ActorStop'
actions['reverse'] = 'jsl ActorReverse'
actions['create'] = ('ActorCreateAtXY', 3)
actions['play-sound'] = ('PlaySoundEffect', 1)
actions['find-type'] = ('ActorFindType', 1)
actions['look-at-actor'] = 'jsl ActorLookAtActor'
actions['look-at-point'] = ('ActorLookAtPoint', 2)
actions['apply-gravity'] = ('ApplyGravity', 1)
actions['apply-gravity-collide'] = ('ActorFall', 1)

actions['block-target-map-xy'] = ('BlockTargetXY', 2)
actions['block-target-coordinate-xy'] = ('BlockTargetCoordinate', 2)
actions['block-target-actor-xy'] = ('BlockTargetActorXY', 2)
actions['block-change-type'] = ('BlockChangeType', 1)
actions[''] = ''

def cmd_label(a):
	outfile.write('Label_%s:\n' % a[0])
actions['label'] = cmd_label

def cmd_goto(a):
	outfile.write('jmp Label_%s\n' % a[0])
actions['goto'] = cmd_goto

def cmd_scroll_set(a):
	print("scroll set")
actions['scroll-set'] = cmd_scroll_set

def cmd_scroll_slide(a):
	print("scroll slide")
actions['scroll-slide'] = cmd_scroll_slide

def cmd_scroll_follow_actor(a):
	if a[0] == 0:
		outfile.write('jsl ScrollCenterActor\n')
	elif a[0] == 1:
		outfile.write('jsl ScrollFollowActor2\n')
	elif a[0] == 2:
		outfile.write('jsl ScrollFollowActor4\n')
	elif a[0] == 3:
		outfile.write('jsl ScrollFollowActor8\n')
actions['scroll-follow-actor'] = cmd_scroll_follow_actor

def cmd_block_retarget_xy(a):
	offset = (a[1]+a[0]*128)*2
	outfile.write('lda LevelBlockPtr\nadd #%d\nsta LevelBlockPtr' % offset)
actions['block-retarget-xy'] = cmd_block_retarget_xy

def cmd_animation(a):
	outfile.write('lda #%s_Animation::%s\nsta ActorArt,x\n' % (gamename, a[0]))
actions['animation'] = cmd_animation

def cmd_call(a):
	outfile.write('jsl %s_subroutine_%s\n' % (gamename, a[0]))
actions['call'] = cmd_call

def cmd_asm(a):
	for line in a:
		outfile.write(line+'\n')
actions['asm'] = cmd_asm

def cmd_set(a):
	if len(a) == 2: # set destination source
		outfile.write('lda %s\n' % compile_value(a[1]))
		outfile.write('sta %s\n' % compile_value(a[0]))
	elif len(a) == 4: #set destination a operator b
		y_register = a[0].startswith("other-")

		# random numbers
		if a[2] == 'random': # only constants allowed for now
			power2test = math.log2(a[3]-a[1]+1)
			is_power_of_2 = power2test == int(power2test)
			mask = pow(2, math.ceil(power2test))-1

			if is_power_of_2:
				outfile.write('jsl random\nand #%d\n' % mask)
			else:
				# Mask
				outfile.write('lda #%d\nsta 0\n' % mask)
				# Highest allowed
				outfile.write('lda #%d\n' % (a[3]-a[1]))
				outfile.write('jsl RandomWithMaxConstant\n')
			if a[1] != 0:
				outfile.write('add #%d\n' % a[1])
			outfile.write('sta %s\n' % compile_value(a[0]))
		# Increments and decrements
		# TODO: was there previously some logic that made it check for incrementing by 1? it didn't seem like there was
		elif a[2] == '+' and a[0] == a[1] and type(a[3]) == int and not y_register and a[3] == 1:
			outfile.write('inc %s\n' % compile_value(a[0]))
		elif a[2] == '+' and a[0] == a[1] and type(a[3]) == int and not y_register and a[3] == -1:
			outfile.write('dec %s\n' % compile_value(a[0]))
		elif a[2] == '-' and a[0] == a[1] and type(a[3]) == int and not y_register and a[3] == 1:
			outfile.write('dec %s\n' % compile_value(a[0]))
		elif a[2] == '-' and a[0] == a[1] and type(a[3]) == int and not y_register and a[3] == -1:
			outfile.write('inc %s\n' % compile_value(a[0]))
		# Regular math
		else:
			outfile.write('lda %s\n' % compile_value(a[1]))
			if a[2] == '+':
				outfile.write('add %s\n' % compile_value(a[3]))
			elif a[2] == '-':
				outfile.write('sub %s\n' % compile_value(a[3]))
			elif a[2] == '|':
				outfile.write('ora %s\n' % compile_value(a[3]))
			elif a[2] == '&':
				outfile.write('and %s\n' % compile_value(a[3]))
			elif a[2] == '^':
				outfile.write('eor %s\n' % compile_value(a[3]))
			# only constant shifts right now
			elif a[2] == '<<':
				outfile.write('asl\n' * a[3])
			elif a[2] == '>>':
				outfile.write('lsr\n' * a[3])
			outfile.write('sta %s\n' % compile_value(a[0]))
	else:
		print("Invalid set action " + str(a))
actions['set'] = cmd_set

# -----------------------------------------------------------------------------

values = {}
values ['type']         = 'ActorType,x'
values ['direction']    = 'ActorDirection,x'
values ['speed']        = 'ActorSpeed,x'
values ['x-position']   = 'ActorPX,x'
values ['y-position']   = 'ActorPY,x'
values ['x-velocity']   = 'ActorVX,x'
values ['y-velocity']   = 'ActorVY,x'
values ['var1']         = 'ActorVarA,x'
values ['var2']         = 'ActorVarB,x'
values ['var3']         = 'ActorVarC,x'
values ['var4']         = 'ActorVarD,x'
values ['var5']         = 'ActorVarE,x'
values ['var6']         = 'ActorVarF,x'

values ['other-type']         = 'ActorType,y'
values ['other-direction']    = 'ActorDirection,y'
values ['other-speed']        = 'ActorSpeed,y'
values ['other-x-position']   = 'ActorPX,y'
values ['other-y-position']   = 'ActorPY,y'
values ['other-x-velocity']   = 'ActorVX,y'
values ['other-y-velocity']   = 'ActorVY,y'
values ['other-var1']         = 'ActorVarA,y'
values ['other-var2']         = 'ActorVarB,y'
values ['other-var3']         = 'ActorVarC,y'
values ['other-var4']         = 'ActorVarD,y'
values ['other-var5']         = 'ActorVarE,y'
values ['other-var6']         = 'ActorVarF,y'

values ['global']       = 'MicrogameGlobals'
values ['global1']      = 'MicrogameGlobals+2*1'
values ['global2']      = 'MicrogameGlobals+2*2'
values ['global3']      = 'MicrogameGlobals+2*3'
values ['global4']      = 'MicrogameGlobals+2*4'
values ['global5']      = 'MicrogameGlobals+2*5'
values ['global6']      = 'MicrogameGlobals+2*6'
values ['global7']      = 'MicrogameGlobals+2*7'
values ['global8']      = 'MicrogameGlobals+2*8'
values ['global9']      = 'MicrogameGlobals+2*9'
values ['global10']     = 'MicrogameGlobals+2*10'
values ['global11']     = 'MicrogameGlobals+2*11'
values ['global12']     = 'MicrogameGlobals+2*12'
values ['global13']     = 'MicrogameGlobals+2*13'
values ['global14']     = 'MicrogameGlobals+2*14'
values ['global15']     = 'MicrogameGlobals+2*15'
values ['global16']     = 'MicrogameGlobals+2*16'
values ['temp']         = 'MicrogameTemp'
values ['temp1']        = 'MicrogameTemp+2*0'
values ['temp2']        = 'MicrogameTemp+2*1'
values ['temp3']        = 'MicrogameTemp+2*2'
values ['temp4']        = 'MicrogameTemp+2*3'
values ['temp5']        = 'MicrogameTemp+2*4'
values ['temp6']        = 'MicrogameTemp+2*5'
values ['temp7']        = 'MicrogameTemp+2*6'
values ['temp8']        = 'MicrogameTemp+2*7'

values ['block-target-x'] = 'BlockTargetX'
values ['block-target-y'] = 'BlockTargetY'
values ['block-target-x-coord'] = 'BlockTargetXCoord'
values ['block-target-y-coord'] = 'BlockTargetYCoord'
values ['block-target-type'] = '[LevelBlockPtr]'
values ['block-target-class'] = 'BlockTargetClass'

def compile_value(value):
	if type(value) == int:
		if value < 0:
			return '#.loword('+str(value)+')'
		else:
			return '#'+str(value)
	if value in values:
		return values[value]
	# pick from a namespace
	s = value.split(':')
	if s[0] == 'actor':
		return ('#%s_ActorType::' % gamename)+s[1]
	elif s[0] == 'direction':
		return '#Direction::'+s[1]
	elif s[0] == 'sound':
		return '#SoundEffect::'+s[1]
	elif s[0] == 'key':
		return '#KeyValue::K_'+s[1]
	elif s[0] == 'block':
		return ('#%s_Block::' % gamename)+s[1]
	elif s[0] == 'block-class':
		return ('#%s_BlockClass::' % gamename)+s[1]
	elif s[0] == 'variable':
		return 'Variable_'+s[1] #TODO: allocate per-game?
	else:
		print("Bad value: "+str(value))

def compile_block(block):
	""" Compile one block of actions """
	for action in block:
		if type(action) == list:
			""" Action """
			if len(action) == 0:
				continue
			name = action[0]
			args = action[1:]
			if name in actions:
				if type(actions[name]) == str: # fill in the string with the other arguments
					outfile.write((actions[name] % tuple(args))+"\n")
				elif type(actions[name]) == tuple:
					# call a primitive but with zeropage and/or accumulator arguments
					variable = len(args)-2 # zeropage variable to write to
					while len(args):
						value = args.pop()
						outfile.write('lda %s\n' % compile_value(value))
						if variable >= 0:
							outfile.write('sta %d\n' % variable*2)
						variable -= 1
					outfile.write('jsl %s\n' % actions[name][0])
				else:
					actions[name](args)
			else:
				print('Unknown action: %s' % name)
			outfile.write('\n') # spacing between actions
		elif type(action) == dict:
			""" Condition/loop """
			if 'if' in action:
				exit = next_label()
				not_else = next_label() # get an else label even if it's not needed

				# make the code to skip over the 'then' block
				compile_condition(action['if'], exit, False)

				# compile the 'then' block
				compile_block(action['then'])

				# put "else" if necessary
				if 'else' in action:
					outfile.write('jmp %s\n' % label_name(not_else))
				insert_label(exit)
				if 'else' in action:
					compile_block(action['else'])
					insert_label(not_else)
			elif 'while' in action:
				top = next_label()
				exit = next_label()

				# make the code to skip over the 'then' block
				insert_label(top)
				compile_condition(action['if'], exit, False)

				# compile the 'then' block
				compile_block(action['then'])

				# go back to the top, and that'll exit the loop if needed
				outfile.write('jmp %s\n' % label_name(top))
				insert_label(exit)
			elif 'dowhile' in action:
				top = next_label()
				insert_label(top)
				compile_block(action['do'])
				compile_condition(action['dowhile'], top, True)
			else:
				print("Unrecognized conditional/loop "+str(action))
			outfile.write('\n') # spacing between actions
		else:
			print('Item in block is the wrong type ' + str(block))
			raise Exception("Item %s in block is the wrong type: %s" % (str(action), str(block)))

def compile_routine(name, block):
	""" Makes a routine and the necessary stuff around it """
	outfile.write('.proc %s\n' % name)
	compile_block(block)
	outfile.write('Exit:\nrtl\n.endproc\n\n')

def compile_microgame(game, output, name, maps, animations):
	""" Compile the whole microgame """
	global outfile, gamename

	outfile = open(output, 'w')

	gamename = name

	# exports and includes
	outfile.write('.include "../../snes.inc"\n')
	outfile.write('.include "../../global.inc"\n')
	outfile.write('.include "../../memory.inc"\n')
	outfile.write('.a16\n')
	outfile.write('.i16\n')
	outfile.write('.export %s_GameData\n\n' % gamename)

	# write background CHR
	outfile.write('.segment "GameChr_%s"\n\n' % gamename)
	outfile.write('.proc %s_ChrData\n' % gamename)
	assert len(maps.map_chr) <= 1024
	for tile in maps.map_chr:
		outfile.write('  .byt %s\n' % (', '.join(['$%.2X' % x for x in tile])))
	outfile.write('.endproc\n%s_EndChrData:\n\n' % gamename)

	# write *sprite* CHR, which must be arranged correctly
	sprite_chr = [[]]*512 # 512 slots for tiles
	# place 16x16 chr first
	for i in range(len(animations.chr16)):
		y = (i//8) * 2
		x = (i%8) * 2
		t = y*32+x
		chr = animations.chr16[i]
		sprite_chr[t]    = chr[0]
		sprite_chr[t+1]  = chr[1]
		sprite_chr[t+16] = chr[2]
		sprite_chr[t+17] = chr[3]
	# place 8x8 next
	tilenumber_for_8 = [] # keep track of what tile number was used here
	for i in range(len(animations.chr8)):
		free = tilenumber_for_8.index([])
		sprite_chr[free] = animations.chr8[i]
		tilenumber_for_8.append(free)
	# trim empty space
	while sprite_chr[-1] == []:
		sprite_chr.pop()

	# actually write sprite CHR
	outfile.write('.segment "GameSpriteChr_%s"\n\n' % gamename)
	outfile.write('.proc %s_SpriteChrData\n' % gamename)
	for tile in sprite_chr:
		if tile == []:
			outfile.write('  .byt %s\n' % (', '.join(['0']*32)))
		else:
			outfile.write('  .byt %s\n' % (', '.join(['$%.2X' % x for x in tile])))
	outfile.write('.endproc\n%s_EndSpriteChrData:\n\n' % gamename)


	outfile.write('.segment "BSS"\n\n')
	for v in game['variables']:
		outfile.write('Variable_%s: .res 2\n' % v)

	outfile.write('.segment "GameData_%s"\n\n' % gamename)
	outfile.write('.proc %s_GameData\n' % gamename)
	outfile.write('.addr %s_PalData\n' % gamename)
	outfile.write('.byt ^%s_ChrData, ^%s_SpriteChrData\n' % (gamename, gamename))
	outfile.write('.addr %s_ChrData\n' % gamename)
	outfile.write('.addr %s_BlockTopLeft\n' % gamename)
	outfile.write('.addr %s_BlockTopRight\n' % gamename)
	outfile.write('.addr %s_BlockBottomLeft\n' % gamename)
	outfile.write('.addr %s_BlockBottomRight\n' % gamename)
	outfile.write('.addr %s_BlockFlags\n' % gamename)
	outfile.write('.addr %s_MapList\n' % gamename)
	outfile.write('.addr %s_ActorRun\n' % gamename)
	outfile.write('.addr %s_ActorInit\n' % gamename)
	outfile.write('.word %d\n' % (32*len(maps.map_chr)))
	outfile.write('.word %d\n' % (32*len(sprite_chr)))
	outfile.write('.addr %s_SpriteChrData\n' % gamename)
	outfile.write('.addr %s_AnimationInfo\n' % gamename)
	if 'run' in game['game']:
		outfile.write('.addr %s_Run\n' % gamename)
	else:
		outfile.write('.addr 0\n')
	if 'init' in game['game']:
		outfile.write('.addr %s_Init\n' % gamename)
	else:
		outfile.write('.addr 0\n')
	outfile.write('.endproc\n\n')

	# actor type list
	outfile.write('.enum %s_ActorType\nempty\n' % gamename)
	for name in game['actors']:
		outfile.write(name+'\n')
	outfile.write('.endenum\n\n')

	# animation
	outfile.write('.enum %s_Animation\n' % gamename)
	for name in animations.animations:
		outfile.write(name+'\n')
	outfile.write('.endenum\n\n')

	outfile.write('.proc %s_AnimationInfo\n' % gamename)
	for name, a in animations.animations.items():
		outfile.write("  ; %s\n" % name)
		outfile.write("  .byt %d,0\n" % a['size'])
		if a['size'] == 8:
			outfile.write("  .word %d|(%d<<9)\n" % (tilenumber_for_8[a['frames'][0]], a['palette']))
		else:
			outfile.write("  .word (%d)+(%d)+(%d<<9)\n" % (a['frames'][0]%8*2, a['frames'][0]//8*32, a['palette']))
	outfile.write('.endproc\n\n')

	outfile.write('.proc %s_PalData\n' % gamename)
	for pal in maps.map_palettes:
		outfile.write('  .word 0\n') # dummy
		outfile.write('  .word %s\n' % (', '.join(['RGB8(%d,%d,%d)' % x for x in pal])))
	for i in range(8-len(maps.map_palettes)):
		outfile.write('  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; dummy\n')
	for pal in animations.palettes:
		outfile.write('  .word 0\n') # dummy
		outfile.write('  .word %s\n' % (', '.join(['RGB8(%d,%d,%d)' % x for x in pal])))
	outfile.write('.endproc\n%s_EndPalData:\n\n' % gamename)

	# export the block data
	all_blocks = [None] + list(maps.map_tiles_used) # <--- convert to a list so we can find an index in it

	# write the four tiles used for each block
	for corner, cornerx, cornery in [('TopLeft', 0, 0), ('TopRight', 0, 1), ('BottomLeft', 1, 0), ('BottomRight', 1, 1)]:
		outfile.write('.proc %s_Block%s\n' % (gamename, corner))
		outfile.write('.word 0\n')
		for block in maps.map_tiles_used:
			data = maps.blocks[block]
			out = data['chr'][cornerx][cornery] | (data['palette']<<10)
			if data['xflip'][cornerx][cornery]:
				out |= 0x4000
			if data['yflip'][cornerx][cornery]:
				out |= 0x8000
			outfile.write('.word %d\n' % out)
		outfile.write('.endproc\n\n')

	# write flags for each block
	outfile.write('.proc %s_BlockFlags\n' % gamename)
	outfile.write('.byt 0\n')
	block_class_list = ['none']
	for block in maps.map_tiles_used:
		data = maps.blocks[block]['data']
		if data:
			out = 0
			if 'solid' in data and data['solid']:
				out |= 0xc0
			if 'solid_top' in data and data['solid_top']:
				out |= 0x40
			if 'class' in data:
				if data['class'] in block_class_list:
					out |= block_class_list.index(data['class'])
				else:
					out |= len(block_class_list)
					block_class_list.append(data['class'])
					assert len(block_class_list) < 32
			outfile.write('.byt %d\n' % out)
		else:
			outfile.write('.byt 0\n')
	outfile.write('.endproc\n\n')

	# write enums for each block
	outfile.write('.enum %s_Block\nempty = 0\n' % gamename)
	for block in maps.map_tiles_used:
		data = maps.blocks[block]['data']
		if data and 'name' in data:
			outfile.write('%s = %d\n' % (data['name'], all_blocks.index(block)))
	outfile.write('.endenum\n\n')

	# write enums for each block class
	outfile.write('.enum %s_BlockClass\n' % gamename)
	for bc in block_class_list:
		outfile.write('%s\n' % bc)
	outfile.write('.endenum\n\n')

	# write the list of maps
	outfile.write('.proc %s_MapList\n' % gamename)
	for map in maps.maps:
		outfile.write('.addr %s_MapData_%s\n' % (gamename, map.name))
	outfile.write('.endproc\n\n')

	# and the map data
	for map in maps.maps:
		outfile.write('.proc %s_MapData_%s\n' % (gamename, map.name))
		outfile.write('.word RGB8(%d,%d,%d)\n' % (map.bgcolor[0], map.bgcolor[1], map.bgcolor[2]))
		outfile.write('.addr Actors\n')
		outfile.write('.byt %d, %d\n' % (map.map_width, map.map_height))

		#for row in map.map_data:
		#	outfile.write('.byt %s\n' % (','.join([str(all_blocks.index(x)) for x in row])))

		# Write column by column instead
		for x in range(map.map_width):
			outfile.write('.word %s\n' % (','.join([str(all_blocks.index(map.map_data[y][x])) for y in range(map.map_height)])))

		outfile.write('Actors:\n')
		for a in map.actor_list:
			outfile.write('.byt %s_ActorType::%s, <%d, >%d, <%d, >%d, %d\n' % (gamename, a[0], a[1]*16, a[1]*16, a[2]*16, a[2]*16, a[3]))
		outfile.write('.byt 255\n')

		outfile.write('.endproc\n\n')

	# write widths and heights, and other necessary tables
	"""
	outfile.write('.proc %s_ActorWidth\n.byt 0\n' % gamename)
	for name, actor in game['actors'].items():
		outfile.write('.byt %d\n' % actor['size'][0])
	outfile.write('.endproc\n\n')

	outfile.write('.proc %s_ActorHeight\n.byt 0\n' % gamename)
	for name, actor in game['actors'].items():
		outfile.write('.byt %d\n' % actor['size'][1])
	outfile.write('.endproc\n\n')
	"""

	outfile.write('.proc %s_ActorRun\n.addr 0\n' % gamename)
	for name, actor in game['actors'].items():
		if 'run' in actor:
			outfile.write('.addr %s_Actor_Run_%s\n' % (gamename, name))
		else:
			outfile.write('.addr 0\n')
	outfile.write('.endproc\n\n')

	outfile.write('.proc %s_ActorInit\n.addr 0\n' % gamename)
	for name, actor in game['actors'].items():
		if 'init' in actor:
			outfile.write('.addr %s_Actor_Init_%s\n' % (gamename, name))
		else:
			outfile.write('.addr 0\n')
	outfile.write('.endproc\n\n')

	"""
	outfile.write('.proc %s_ActorGraphic\n.byt 0\n' % gamename)
	for name, actor in game['actors'].items():
		outfile.write('.byt %s\n' % str(actor['graphic']))
	outfile.write('.endproc\n\n')
	"""

	# write code
	if 'run' in game['game']:
		compile_routine('%s_Run' % gamename, game['game']['run'])
	else:
		compile_routine('%s_Run' % gamename, [])
	if 'init' in game['game']:
		compile_routine('%s_Init' % gamename, game['game']['init'])
	else:
		compile_routine('%s_Init' % gamename, [])
	# actor code
	for name, actor in game['actors'].items():
		if 'run' in actor:
			compile_routine('%s_Actor_Run_%s' % (gamename, name), actor['run'])
		if 'init' in actor:
			compile_routine('%s_Actor_Init_%s' % (gamename, name), actor['init'])
	if 'subroutines' in game:
		for name, routine in game['subroutines'].items():
			compile_routine('%s_subroutine_%s' % (gamename, name), routine)

	outfile.close()

"""
allmicrogames = open('allmicrogames.s', 'w')
allmicrogames.write('.code\n')
all_gamenames = []
for f in glob.glob("*.json"):
	dot_s = f.replace('.json', '.s')
	compile_microgame(f, dot_s)
	all_gamenames.append(gamename)
	allmicrogames.write('.include "%s"\n' % dot_s)
allmicrogames.write('\nMICROGAME_COUNT = %d\n\n' % len(all_gamenames))

for e in ['ActorPlacement', 'ActorWidth', 'ActorHeight', 'ActorRun', 'ActorInit', 'ActorGraphic', 'Run', 'Init']:
	allmicrogames.write('.proc All_%s\n' % e)
	for name in all_gamenames:
		allmicrogames.write('.addr %s_%s\n' % (name, e))
	allmicrogames.write('.endproc\n\n')
allmicrogames.close()
"""
