#!/usr/bin/env python3
#
# SNES Microgame engine translator
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
import xml.etree.ElementTree as ET # phone home
import sys

def strip_namespace(tag):
	# change "{whatever}tag" to "tag"
	find = tag.find('}')
	if find >= 0:
		tag = tag[find+1:]
	return tag

class Block(object):
	def __init__(self, block):
		# translate the XML of a block to something I can work with
		tagname = strip_namespace(block.tag)
		if tagname != 'block' and tagname != 'shadow':
			print("Bad tag, got "+tagname)
			sys.exit()

		# get ready to parse
		self.type = block.attrib['type']
		self.field = {}
		self.statement = {}
		self.value = {}
		self.next = None
		self.mutation = {}

		# iterate over the items inside the block
		for e in block:
			tagname2 = strip_namespace(e.tag)
			if tagname2 == 'field':
				self.field[e.attrib['name']] = e.text
			elif tagname2 == 'statement':
				self.statement[e.attrib['name']] = e[0]
			elif tagname2 == 'value':
				self.value[e.attrib['name']] = e[0]
				# If there's a shadow block as well as a real block, use the real one instead
				if strip_namespace(e[0].tag) == 'shadow' and len(e) > 1:
					self.value[e.attrib['name']] = e[1]
			elif tagname2 == 'next':
				self.next = e[0]
			elif tagname2 == 'mutation':
				self.mutation = e.attrib

	def translate_value(self, name):
		block = Block(self.value[name])
		if block.type == 'math_number':
			return int(block.field['NUM'])
		elif block.type == 'property':
			return property_list[block.field['NAME']]
		elif block.type == 'other_property':
			return 'other-'+property_list[block.field['NAME']]
		elif block.type == 'global':
			return 'global'+block.field['NUM']
		elif block.type == 'temp':
			return 'temp'+block.field['NUM']
		elif block.type == 'sound_effect':
			return 'sound:'+block.field['SOUND']
		elif block.type == 'actor_type':
			return 'actor:'+block.field['NAME']
		elif block.type == 'block_type':
			return 'block:'+block.field['NAME']
		elif block.type == 'block_class':
			return 'block-class:'+block.field['NAME']
		elif block.type == 'coordinate_pixels':
			return 16*int(block.field['NUM'])
		elif block.type == 'variables_get':
			return 'variable:'+block.field['VAR']
		else:
			print("Unknown value type " + block.type)
#######################################

# should have just made the property block use the right name
property_list = {}

property_list["TYPE"] = 'type'
property_list["DIRECTION"] = 'direction'
property_list["SPEED"] = 'speed'
property_list["XPOS"] = 'x-position'
property_list["YPOS"] = 'y-position'
property_list["XVEL"] = 'x-velocity'
property_list["YVEL"] = 'y-velocity'
property_list["VAR1"] = 'var1'
property_list["VAR2"] = 'var2'
property_list["VAR3"] = 'var3'
property_list["VAR4"] = 'var4'
property_list["VAR5"] = 'var5'
property_list["VAR6"] = 'var6'

#######################################

conditions = {}

def cnd_if_find_type(block):
	return ['find-type', block.translate_value('NAME')]
conditions['if_find_type'] = cnd_if_find_type

def cnd_at_end(block):
	return ['at-end']
conditions['at_end'] = cnd_at_end

def cnd_every_x_frames(block):
	return ['every-%s-frames' % block.field['FREQUENCY']]
conditions['every_x_frames'] = cnd_every_x_frames

def cnd_difficulty(block):
	allowed = 0
	if block.field['EASY'] == 'TRUE':
		allowed |= 1
	if block.field['MEDIUM'] == 'TRUE':
		allowed |= 2
	if block.field['HARD'] == 'TRUE':
		allowed |= 4
	return ['difficulty', allowed]
conditions['difficulty'] = cnd_difficulty

def cnd_won_lost(block):
	return []
conditions['won_lost'] = cnd_won_lost

def cnd_keys(block):
	if block.field['STATE'] == 'DOWN':
		return ['key-held', 'key:'+block.field['KEY']]
	elif block.field['STATE'] == 'UP':
		return ['not', 'key-held', 'key:'+block.field['KEY']]
	elif block.field['STATE'] == 'PRESSED':
		return ['key-press', 'key:'+block.field['KEY']]
	elif block.field['STATE'] == 'RELEASED':
		return ['key-release', 'key:'+block.field['KEY']]
conditions['keys'] = cnd_keys

def cnd_touching_type(block):
	return ['touching-type', block.translate_value('NAME')]
conditions['touching_type'] = cnd_touching_type


def cnd_actor_hit_ceiling_block(block):
	return ['actor-hit-ceiling-block', block.translate_value('NAME')]
conditions['actor_hit_ceiling_block'] = cnd_actor_hit_ceiling_block

def cnd_actor_hit_ceiling_block_class(block):
	return ['actor-hit-ceiling-block-class', block.translate_value('NAME')]
conditions['actor_hit_ceiling_block_class'] = cnd_actor_hit_ceiling_block_class

def cnd_actor_hit_floor_block(block):
	return ['actor-hit-floor-block', block.translate_value('NAME')]
conditions['actor_hit_floor_block'] = cnd_actor_hit_floor_block

def cnd_actor_hit_floor_block_class(block):
	return ['actor-hit-floor-block-class', block.translate_value('NAME')]
conditions['actor_hit_floor_block_class'] = cnd_actor_hit_floor_block_class


def cnd_actor_ran_into_block(block):
	return ['actor-ran-into-block', block.translate_value('NAME')]
conditions['actor_ran_into_block'] = cnd_actor_ran_into_block

def cnd_actor_ran_into_block_class(block):
	return ['actor-ran-into-block-class', block.translate_value('NAME')]
conditions['actor_ran_into_block_class'] = cnd_actor_ran_into_block_class

def cnd_actor_overlap_block(block):
	return ['actor-overlap-block', block.translate_value('NAME')]
conditions['actor_overlap_block'] = cnd_actor_overlap_block

def cnd_actor_overlap_block_class(block):
	return ['actor-overlap-block-class', block.translate_value('NAME')]
conditions['actor_overlap_block_class'] = cnd_actor_overlap_block_class

def cnd_actor_center_overlap_block(block):
	return ['actor-center-overlap-block', block.translate_value('NAME')]
conditions['actor_center_overlap_block'] = cnd_actor_center_overlap_block

def cnd_actor_center_overlap_block_class(block):
	return ['actor-center-overlap-block-class', block.translate_value('NAME')]
conditions['actor_center_overlap_block_class'] = cnd_actor_center_overlap_block_class

def cnd_in_region(block):
	return ['in-region', block.translate_value('XPOS1'), block.translate_value('YPOS1'), block.translate_value('XPOS2'), block.translate_value('YPOS2')]
conditions['in_region'] = cnd_in_region

def cnd_block_target_flags(block):
	# TODO: actually interpret these flags?
	return ['block-target-flags']
conditions['block_target_flags'] = cnd_block_target_flags

def cnd_block_target_solid(block):
	return ['block-target-solid']
conditions['block_target_solid'] = cnd_block_target_solid

def cnd_asm_condition(block):
	flags = block.field['FLAGS']
	return ['asm-condition', flags, translate_routine(block.statement['ASM'])]
conditions['asm_condition'] = cnd_asm_condition

def cnd_logic_operation(block):
	return [block.field['OP'].lower(), translate_condition(block.value['A']), translate_condition(block.value['B'])]
conditions['logic_operation'] = cnd_logic_operation

def cnd_logic_compare(block):
	comparisons = {}
	comparisons['EQ'] = '=='
	comparisons['NEQ'] = '!='
	comparisons['LT'] = '<'
	comparisons['LTE'] = '<='
	comparisons['GT'] = '>'
	comparisons['GTE'] = '>='
	return [block.translate_value('A'), comparisons[block.field['OP']], block.translate_value('B')]
conditions['logic_compare'] = cnd_logic_compare

def cnd_logic_boolean(block):
	if block.field['BOOL'] == 'TRUE':
		return ['always']
	else:
		return ['not', 'always']
conditions['logic_boolean'] = cnd_logic_boolean

def cnd_logic_negate(block):
	return ['not'] + translate_condition(block.value['BOOL'])
conditions['logic_negate'] = cnd_logic_negate

def cnd_actor_on_ground(block):
	return ['actor-on-ground']
conditions['actor_on_ground'] = cnd_actor_on_ground

def cnd_actor_hit_ceiling(block):
	return ['actor-hit-ceiling']
conditions['actor_hit_ceiling'] = cnd_actor_hit_ceiling

def cnd_actor_hit_wall(block):
	return ['actor-hit-wall']
conditions['actor_hit_wall'] = cnd_actor_hit_wall

def translate_condition(block):
	block = Block(block)
	if block.type in conditions:
		return conditions[block.type](block)
	else:
		print("Unrecognized condition block: "+block.type)

#######################################

blocks = {}

def blk_assembly(block):
	return ['asm', block.field['instruction']]
blocks['assembly'] = blk_assembly

def blk_set_math(block):
	# should have just directly used the names here too
	operators = {}
	operators['ADD'] = '+'
	operators['SUB'] = '-'
	operators['MULTIPLY'] = '*'
	operators['DIVIDE'] = '/'
	operators['MODULO'] = '%'
	operators['RANDOM'] = 'random'
	operators['AND'] = '&'
	operators['OR'] = '|'
	operators['XOR'] = '^'
	operators['SHIFTL'] = '<<'
	operators['SHIFTR'] = '>>'
	return ['set',
		block.translate_value('VARIABLE'),
		block.translate_value('LEFT'),
		operators[block.field['OPERATION']],
		block.translate_value('RIGHT')]

blocks['set_math'] = blk_set_math

all_animations = set()
def blk_animation(block):
	flips = 0
	if block.field['XFLIP'] == 'TRUE':
		flips |= 0x4000
	if block.field['YFLIP'] == 'TRUE':
		flips |= 0x8000
	all_animations.add(block.field['NAME'])
	return ['animation', '%s|%d' % (block.field['NAME'], flips)]	
blocks['animation'] = blk_animation

def blk_set_nomath(block):
	return ['set', block.translate_value('LEFT'), block.translate_value('RIGHT')]
blocks['set_nomath'] = blk_set_nomath

def blk_ball_movement(block):
	return ['ball-movement']
blocks['ball_movement'] = blk_ball_movement

def blk_ball_movement_stop(block):
	return ['ball-movement-stop']
blocks['ball_movement_stop'] = blk_ball_movement_stop

def blk_ball_movement_reflect(block):
	return ['ball-movement-reflect']
blocks['ball_movement_reflect'] = blk_ball_movement_reflect

def blk_vector_movement(block):
	return ['vector-movement']
blocks['vector_movement'] = blk_vector_movement

def blk_vector_movement_stop(block):
	return ['vector-movement-stop']
blocks['vector_movement_stop'] = blk_vector_movement_stop

def blk_vector_movement_reflect(block):
	return ['vector-movement-reflect']
blocks['vector_movement_reflect'] = blk_vector_movement_reflect

def blk_eightway_movement(block):
	allowed = 0
	if block.field['RIGHT'] == 'TRUE':
		allowed |= 0x0100
	if block.field['LEFT'] == 'TRUE':
		allowed |= 0x0200
	if block.field['DOWN'] == 'TRUE':
		allowed |= 0x0400
	if block.field['UP'] == 'TRUE':
		allowed |= 0x0800
	if block.field['COLLIDE'] == 'TRUE':
		return ['8way-movement-stop', allowed]
	else:
		return ['8way-movement', allowed]
blocks['eightway_movement'] = blk_eightway_movement

def blk_win_game(block):
	return ['win-game']
blocks['win_game'] = blk_win_game

def blk_lose_game(block):
	return ['lose-game']
blocks['lose_game'] = blk_lose_game

def blk_destroy(block):
	return ['destroy']
blocks['destroy'] = blk_destroy

def blk_destroy_type(block):
	return ['destroy-type', block.translate_value('NAME')]
blocks['destroy_type'] = blk_destroy_type

def blk_exit(block):
	return ['exit']
blocks['exit'] = blk_exit

def blk_target_other(block):
	return ['as-other-actor', translate_routine(block.statement['DO'])]
blocks['target_other'] = blk_target_other

def blk_jump_xy(block):
	return ['jump-to-xy', block.translate_value('XPOS'), block.translate_value('YPOS')]
blocks['jump_xy'] = blk_jump_xy

def blk_jump_other(block):
	return ['jump-to-other']
blocks['jump_other'] = blk_jump_other

def blk_swap_places(block):
	return ['swap-places']
blocks['swap_places'] = blk_swap_places

def blk_stop_moving(block):
	return ['stop']
blocks['stop_moving'] = blk_stop_moving

def blk_reverse(block):
	return ['reverse']
blocks['reverse'] = blk_reverse

def blk_find_type(block):
	return ['find-type', block.translate_value('NAME')]
blocks['find_type'] = blk_find_type

def blk_look_xy(block):
	return ['look-at-point', block.translate_value('POSX'), block.translate_value('POSY')]
blocks['look_xy'] = blk_look_xy

def blk_look_other(block):
	return ['look-at-actor']
blocks['look_other'] = blk_look_other

def blk_create(block):
	return ['create', block.translate_value('TYPE'), block.translate_value('POSX'), block.translate_value('POSY')]
blocks['create'] = blk_create

def blk_play_sfx(block):
	return ['play-sound', block.translate_value('SOUND')]
blocks['play_sfx'] = blk_play_sfx

def blk_controls_whileUntil(block):
	out = {}
	out['while'] = translate_condition(block.value['BOOL'])
	if block.field['MODE'].lower() == 'until': # Apparently "until" is just an inverse while, not a do-until
		out['while'].insert('not', 0)
	out['do'] = translate_routine(block.statement['DO'])
	return out
blocks['controls_whileUntil'] = blk_controls_whileUntil

def blk_do_while(block):
	out = {}
	out['dowhile'] = translate_condition(block.value['BOOL'])
	out['do'] = translate_routine(block.statement['DO'])
	return out
blocks['do_while'] = blk_do_while

def blk_apply_gravity(block):
	if block.field['COLLIDE'] == 'TRUE':
		return ['apply-gravity-collide', block.translate_value('STRENGTH')]
	else:
		return ['apply-gravity', block.translate_value('STRENGTH')]
blocks['apply_gravity'] = blk_apply_gravity

def blk_scroll_follow_actor(block):
	if block.field['SLOW'] == 'DIV1':
		return ['scroll-follow-actor', 0]
	if block.field['SLOW'] == 'DIV2':
		return ['scroll-follow-actor', 1]
	if block.field['SLOW'] == 'DIV4':
		return ['scroll-follow-actor', 2]
	if block.field['SLOW'] == 'DIV8':
		return ['scroll-follow-actor', 3]
blocks['scroll_follow_actor'] = blk_scroll_follow_actor

def blk_scroll_slide(block):
	x, y = block.translate_value('X'), block.translate_value('Y')
	if block.field['SLOW'] == 'DIV1':
		return ['scroll-slide', 0, x, y]
	if block.field['SLOW'] == 'DIV2':
		return ['scroll-slide', 1, x, y]
	if block.field['SLOW'] == 'DIV4':
		return ['scroll-slide', 2, x, y]
	if block.field['SLOW'] == 'DIV8':
		return ['scroll-slide', 3, x, y]
blocks['scroll_slide'] = blk_scroll_slide

def blk_scroll_set(block):
	return ['scroll-set', block.translate_value('X'), block.translate_value('Y')]
blocks['scroll_set'] = blk_scroll_set

def blk_note(block):
	return []
blocks['note'] = blk_note

def blk_block_target_map_xy(block):
	return ['block-target-map-xy', block.translate_value('X'), block.translate_value('Y')]
blocks['block_target_map_xy'] = blk_block_target_map_xy

def blk_block_target_coordinate_xy(block):
	return ['block-target-coordinate-xy', block.translate_value('X'), block.translate_value('Y')]
blocks['block_target_coordinate_xy'] = blk_block_target_coordinate_xy

def blk_block_target_actor_xy(block):
	return ['block-target-actor-xy', block.translate_value('X'), block.translate_value('Y')]
blocks['block_target_actor_xy'] = blk_block_target_actor_xy

def blk_retarget_xy(block):
	return ['block-retarget-xy', int(block.field['X']), int(block.field['Y'])]
blocks['block_retarget_xy'] = blk_retarget_xy

def blk_block_change_type(block):
	return ['block-change-type', block.translate_value('NAME')]
blocks['block_change_type'] = blk_block_change_type

def blk_math_change(block):
	return ['set',
		'variable:'+block.field['VAR'],
		'variable:'+block.field['VAR'],
		'+',
		block.translate_value('DELTA')]
blocks['math_change'] = blk_math_change

def blk_variables_set(block):
	return ['set',
		'variable:'+block.field['VAR'],
		block.translate_value('VALUE')]
blocks['variables_set'] = blk_variables_set


def blk_label(block):
	return ['label', block.field['NAME']]
blocks['label'] = blk_label

def blk_goto(block):
	return ['goto', block.field['NAME']]
blocks['goto'] = blk_goto

def blk_procedures_callnoreturn(block):
	return ['call', block.mutation['name']]
blocks['procedures_callnoreturn'] = blk_procedures_callnoreturn

def blk_controls_if(block):
	has_elif = 0
	if 'elseif' in block.mutation:
		has_elif = int(block.mutation['elseif'])

	out = {}
	put_else_in = out # dictionary to put the if/else in

	# turn else-if into nested ifs
	for i in range(has_elif):
		the_elif = {}
		the_elif['if'] = translate_condition(block.value['IF'+str(i+1)])
		the_elif['then'] = translate_routine(block.statement['DO'+str(i+1)] if 'DO'+str(i+1) in block.statement else None)
		put_else_in['else'] = the_elif
		put_else_in = the_elif

	out['if'] = translate_condition(block.value['IF0'])
	out['then'] = translate_routine(block.statement['DO0'] if 'DO0' in block.statement else None)
	if 'ELSE' in block.statement:
		put_else_in['else'] = translate_routine(block.statement['ELSE'])
	return out
blocks['controls_if'] = blk_controls_if

def translate_instruction(block):
	if block.type in blocks:
		return blocks[block.type](block)
	else:
		print("Unrecognized block "+block.type)
		sys.exit()

#######################################

def translate_routine(routine):
	out = []

	# convert the weird linked list thing to an array
	while routine != None:
		block = Block(routine)
		out.append(translate_instruction(block))
		routine = block.next
	return out

def translate_xml(filename):
	all_animations.clear()
	tree = ET.parse(filename)
	root = tree.getroot()

	out = {'game': {}, 'actors': {}, 'subroutines': {}, 'variables': []}

	for e in root:
		tag = strip_namespace(e.tag)
		if tag == 'variables':
			for variable in e:
				out['variables'].append(variable.text)
			continue
		block = Block(e)
		if block.type == 'actor':
			actorname = block.field['NAME']
			out['actors'][actorname] = {}

			if 'RUN' in block.statement:
				out['actors'][actorname]['run'] = translate_routine(block.statement['RUN'])
			if 'INIT' in block.statement:
				out['actors'][actorname]['init'] = translate_routine(block.statement['INIT'])			
		elif block.type == 'game_init_run':
			if 'RUN' in block.statement:
				out['game']['run'] = translate_routine(block.statement['RUN'])
			if 'INIT' in block.statement:
				out['game']['init'] = translate_routine(block.statement['INIT'])
		elif block.type == 'procedures_defnoreturn':
			out['subroutines'][block.field['NAME']] = translate_routine(block.statement['STACK'])
		elif block.type == 'game_info':
			out['game']['name'] = block.field['NAME']
			out['game']['instruction'] = block.field['INSTRUCTION']
			out['game']['length'] = 8 if (block.field['LONG'] == 'TRUE') else 4
		else:
			print("Unexpected block? "+block.type)
	out['animations'] = list(all_animations)
	return out
