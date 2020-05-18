#!/usr/bin/env python3
#
# SNES Microgame engine builder
# Copyright 2020 NovaSquirrel
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
from compile import *
from translate import *
from readtiled import *


def make_game(game_name):
	game_directory = 'games/%s/' % game_name
	print("Building game %s" % game_name)
	info = translate_xml(game_directory+'microgame.xml')

	#import json
	#print(json.dumps(info, indent=2))

	compile_microgame(info, game_directory+'microgame.s', game_name)

make_game('example')
