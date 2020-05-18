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
conditions_flags = {}

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
conditions_flags['actor-on-ground'] = 'ne'
conditions['actor-overlap-block'] = ('jsl ActorOverlapBlock', 1)
conditions_flags['actor-overlap-block'] = 'cs'

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

def condition_block_target_flags(a):
	pass
conditions['block-target-flags'] = condition_block_target_flags

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
actions['win-game'] = 'jsl WinGame'
actions['lose-game'] = 'jsl LoseGame'
actions['jump-to-xy'] = ('ActorJumpToXY', 2)
actions['jump-to-other'] = 'jsl ActorJumpToActor'
actions['swap-places'] = 'jsl ActorSwapWithActor'
actions['destroy'] = 'lda #0\nsta ActorType,x'
actions['destroy-type'] = ('ActorDestroyType', 1)
actions['target-this'] = 'ldx ThisActor'
actions['target-other'] = 'ldx OtherActor'
actions['exit'] = 'jmp Exit'
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

def cmd_scroll_set(a):
	pass
actions['scroll-set'] = cmd_scroll_set

def cmd_scroll_slide(a):
	pass
actions['scroll-slide'] = cmd_scroll_slide

def cmd_scroll_follow_actor(a):
	pass
actions['scroll-follow-actor'] = cmd_scroll_follow_actor

def cmd_block_retarget_xy(a):
	pass
actions['block-retarget-xy'] = cmd_block_retarget_xy

def cmd_animation(a):
	outfile.write('lda #%s_Animation::%s\nsta ActorArt,x\n' % (gamename, a[0]))
actions['animation'] = cmd_animation

def cmd_call(a):
	outfile.write('jsr %s_subroutine_%s\n' % (gamename, a[0]))
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
			outfile.write('lda #%d\n' % (a[3]-a[1]))
			outfile.write('jsl RandomWithMax\n')
			if a[1] != 0:
				outfile.write('add #%d\n' % a[1])
			outfile.write('sta %s\n' % compile_value(a[0]))
		# Increments and decrements
		elif a[2] == '+' and a[0] == a[1] and type(a[3]) == int and not y_register:
			outfile.write('inc %s\n' % compile_value(a[0]))
		elif a[2] == '-' and a[0] == a[1] and type(a[3]) == int and not y_register:
			outfile.write('dec %s\n' % compile_value(a[0]))
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
		print("Invalid set action")
actions['set'] = cmd_set

# -----------------------------------------------------------------------------

values = {}
values ['type']         = 'ActorType,x'
values ['direction']    = 'ActorDir,x'
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
values ['other-direction']    = 'ActorDir,y'
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
	elif s[0] == 'variable':
		return 'Variable_'+s[1] #TODO: allocate per-game?
	else:
		print("Bad value: "+str(value))

def compile_block(block):
	""" Compile one block of actions """
	for action in block:
		if type(action) == list:
			""" Action """
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
			""" Condition """
			exit = next_label()
			not_else = next_label() # get an else label if needed or not

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

			outfile.write('\n') # spacing between actions
		else:
			print('Item in block is the wrong type')

def compile_routine(name, block):
	""" Makes a routine and the necessary stuff around it """
	outfile.write('.proc %s\n' % name)
	compile_block(block)
	outfile.write('Exit:\nrts\n.endproc\n\n')

def compile_microgame(game, output, name):
	""" Compile the whole microgame """
	global outfile, gamename

	outfile = open(output, 'w')

	gamename = name

	# exports
	outfile.write('.export %s_ActorPlacement, %s_ActorWidth, %s_ActorHeight, %s_ActorRun, %s_ActorInit, %s_ActorGraphic, %s_Run, %s_Init\n\n' % (gamename, gamename, gamename, gamename, gamename, gamename, gamename, gamename))

	# actor type list
	outfile.write('.enum %s_ActorType\nempty\n' % gamename)
	for name in game['actors']:
		outfile.write(name+'\n')
	outfile.write('.endenum\n\n')

	# actor placement
	outfile.write('.proc %s_ActorPlacement\n' % gamename)
	if 'actor_placement' in game:
		for a in game['actor_placement']:
			outfile.write('.byt %s_ActorType::%s, %d, %d\n' % (gamename, a[0], a[1], a[2]))
	outfile.write('.byt 255\n.endproc\n\n')

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

	outfile.write('.proc %s_ActorRun\n.dbyt (DoNothing-1)\n' % gamename)
	for name, actor in game['actors'].items():
		if 'run' in actor:
			outfile.write('.addr %s_Actor_Run_%s\n' % (gamename, name))
		else:
			outfile.write('.addr DoNothing\n')
	outfile.write('.endproc\n\n')

	outfile.write('.proc %s_ActorInit\n.addr DoNothing\n' % gamename)
	for name, actor in game['actors'].items():
		if 'init' in actor:
			outfile.write('.addr %s_Actor_Init_%s-1\n' % (gamename, name))
		else:
			outfile.write('.addr DoNothing\n')
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
