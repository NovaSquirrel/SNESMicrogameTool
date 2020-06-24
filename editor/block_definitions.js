Blockly.defineBlocksWithJsonArray([{
  "type": "assembly",
  "message0": "ASM %1",
  "args0": [
    {
      "type": "field_input",
      "name": "instruction",
      "text": ""
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Type an assembly language instruction here",
  "helpUrl": ""
},
{
  "type": "animation",
  "message0": "Animation: %1 %2 X Flip: %3 Y Flip: %4",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": ""
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "XFLIP",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "YFLIP",
      "checked": false
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Change the actor's current animation",
  "helpUrl": ""
},
{
  "type": "game_info",
  "message0": "Name %1 %2 Instruction %3 %4 Long? %5",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "example"
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_input",
      "name": "INSTRUCTION",
      "text": "Get!"
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "LONG",
      "checked": false
    }
  ],
  "colour": 120,
  "tooltip": "Define info for the game",
  "helpUrl": ""
},
{
  "type": "every_x_frames",
  "message0": "Every %1 frames",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "FREQUENCY",
      "options": [
        [
          "2",
          "2"
        ],
        [
          "4",
          "4"
        ],
        [
          "8",
          "8"
        ],
        [
          "16",
          "16"
        ],
        [
          "32",
          "32"
        ],
        [
          "64",
          "64"
        ],
        [
          "128",
          "128"
        ]
      ]
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Do the action every so often",
  "helpUrl": ""
},
{
  "type": "set_math",
  "message0": "Set %1 to %2 %3 %4 %5",
  "args0": [
    {
      "type": "input_value",
      "name": "VARIABLE",
      "check": "Number"
    },
    {
      "type": "input_value",
      "name": "LEFT",
      "check": "Number"
    },
    {
      "type": "field_dropdown",
      "name": "OPERATION",
      "options": [
        [
          "+",
          "ADD"
        ],
        [
          "-",
          "SUB"
        ],
        [
          "*",
          "MULTIPLY"
        ],
        [
          "/",
          "DIVIDE"
        ],
        [
          "%",
          "MODULO"
        ],
        [
          "random",
          "RANDOM"
        ],
        [
          "AND",
          "AND"
        ],
        [
          "OR",
          "OR"
        ],
        [
          "XOR",
          "XOR"
        ],
        [
          "<<",
          "SHIFTL"
        ],
        [
          ">>",
          "SHIFTR"
        ]
      ]
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "input_value",
      "name": "RIGHT",
      "check": "Number"
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Set a variable to the result of some math",
  "helpUrl": ""
},
{
  "type": "actor",
  "message0": "Actor %1 %2 Init %3 Run %4",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "default"
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "input_statement",
      "name": "INIT"
    },
    {
      "type": "input_statement",
      "name": "RUN"
    }
  ],
  "colour": 135,
  "tooltip": "Defines an actor",
  "helpUrl": ""
},
{
  "type": "ball_movement",
  "message0": "Ball movement",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Moves forward at an angle",
  "helpUrl": ""
},
{
  "type": "ball_movement_stop",
  "message0": "Ball movement (Stop at walls)",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Moves forward at an angle",
  "helpUrl": ""
},
{
  "type": "ball_movement_reflect",
  "message0": "Ball movement (Reflect against walls)",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Moves forward at an angle",
  "helpUrl": ""
},
{
  "type": "ball_movement_bounce",
  "message0": "Ball movement (Bounce against walls)",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Moves forward at an angle",
  "helpUrl": ""
},
{
  "type": "vector_movement",
  "message0": "Vector movement",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Add velocity to the position",
  "helpUrl": ""
},
{
  "type": "vector_movement_stop",
  "message0": "Vector movement (Stop at walls)",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Add velocity to the position",
  "helpUrl": ""
},
{
  "type": "vector_movement_reflect",
  "message0": "Vector movement (Reflect against walls)",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Add velocity to the position",
  "helpUrl": ""
},
{
  "type": "eightway_movement",
  "message0": "8-way movement %1 %2 Left %3 %4 Down %5 %6 Up %7 %8 Right %9 %10 Collide with level?",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "LEFT",
      "checked": true
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "DOWN",
      "checked": true
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "UP",
      "checked": true
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "RIGHT",
      "checked": true
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "COLLIDE",
      "checked": true
    }
  ],
  "inputsInline": false,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Move in response to the player's presses",
  "helpUrl": ""
},
{
  "type": "property",
  "message0": "This %1",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "NAME",
      "options": [
        [
          "type",
          "TYPE"
        ],
        [
          "direction",
          "DIRECTION"
        ],
        [
          "speed",
          "SPEED"
        ],
        [
          "x position",
          "XPOS"
        ],
        [
          "y position",
          "YPOS"
        ],
        [
          "x velocity",
          "XVEL"
        ],
        [
          "y velocity",
          "YVEL"
        ],
        [
          "variable 1",
          "VAR1"
        ],
        [
          "variable 2",
          "VAR2"
        ],
        [
          "variable 3",
          "VAR3"
        ],
        [
          "variable 4",
          "VAR4"
        ],
        [
          "variable 5",
          "VAR5"
        ],
        [
          "variable 6",
          "VAR6"
        ]
      ]
    }
  ],
  "output": "Number",
  "colour": 230,
  "tooltip": "Property for this object",
  "helpUrl": ""
},
{
  "type": "other_property",
  "message0": "Other %1",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "NAME",
      "options": [
        [
          "type",
          "TYPE"
        ],
        [
          "direction",
          "DIRECTION"
        ],
        [
          "speed",
          "SPEED"
        ],
        [
          "x position",
          "XPOS"
        ],
        [
          "y position",
          "YPOS"
        ],
        [
          "x velocity",
          "XVEL"
        ],
        [
          "y velocity",
          "YVEL"
        ],
        [
          "variable 1",
          "VAR1"
        ],
        [
          "variable 2",
          "VAR2"
        ],
        [
          "variable 3",
          "VAR3"
        ],
        [
          "variable 4",
          "VAR4"
        ],
        [
          "variable 5",
          "VAR5"
        ],
        [
          "variable 6",
          "VAR6"
        ]
      ]
    }
  ],
  "output": "Number",
  "colour": 230,
  "tooltip": "Property for other block",
  "helpUrl": ""
},
{
  "type": "win_game",
  "message0": "Win game",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Win the game",
  "helpUrl": ""
},
{
  "type": "lose_game",
  "message0": "Lose game",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Lose the game",
  "helpUrl": ""
},
{
  "type": "destroy",
  "message0": "Destroy",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Destroy the current object",
  "helpUrl": ""
},
{
  "type": "exit",
  "message0": "Exit code",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Stop running this code",
  "helpUrl": ""
},
{
  "type": "target_other",
  "message0": "As other object %1 %2",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "input_statement",
      "name": "NAME"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Do these actions as the other object",
  "helpUrl": ""
},
{
  "type": "actor_type",
  "message0": "Actor %1",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "default"
    }
  ],
  "output": "actor_type",
  "colour": 65,
  "tooltip": "Specify an actor type by name",
  "helpUrl": ""
},
{
  "type": "actor_class",
  "message0": "Actor class %1",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "default"
    }
  ],
  "output": "actor_type",
  "colour": 65,
  "tooltip": "Specify an actor class by name",
  "helpUrl": ""
},
{
  "type": "block_type",
  "message0": "Block type %1",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "default"
    }
  ],
  "output": "block_type",
  "colour": 65,
  "tooltip": "Specify an block type by name",
  "helpUrl": ""
},
{
  "type": "block_class",
  "message0": "Block class %1",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "default"
    }
  ],
  "output": "block_type",
  "colour": 65,
  "tooltip": "Specify an block class by name",
  "helpUrl": ""
},
{
  "type": "jump_xy",
  "message0": "Jump to %1 %2",
  "args0": [
    {
      "type": "input_value",
      "name": "XPOS"
    },
    {
      "type": "input_value",
      "name": "YPOS"
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Jump to a specific location",
  "helpUrl": ""
},
{
  "type": "jump_other",
  "message0": "Jump to other actor",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Jump to the other object",
  "helpUrl": ""
},
{
  "type": "swap_places",
  "message0": "Swap places with other",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Swap positions with another object",
  "helpUrl": ""
},
{
  "type": "destroy_type",
  "message0": "Destroy all %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME",
      "check": "actor_type"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Destroy all objects of a given type",
  "helpUrl": ""
},
{
  "type": "stop_moving",
  "message0": "Stop moving",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Clear the speed and velocity",
  "helpUrl": ""
},
{
  "type": "reverse",
  "message0": "Reverse movement",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Turn around",
  "helpUrl": ""
},
{
  "type": "find_type",
  "message0": "Find actor of type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME",
      "check": "actor_type"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Find first actor of a given type",
  "helpUrl": ""
},
{
  "type": "look_xy",
  "message0": "Look towards %1 %2",
  "args0": [
    {
      "type": "input_value",
      "name": "POSX"
    },
    {
      "type": "input_value",
      "name": "POSY"
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Look towards a given X and Y",
  "helpUrl": ""
},
{
  "type": "look_other",
  "message0": "Look towards other actor",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Look towards the other actor",
  "helpUrl": ""
},
{
  "type": "apply_gravity",
  "message0": "Apply gravity with strength: %1 Collide with level? %2",
  "args0": [
    {
      "type": "input_value",
      "name": "STRENGTH",
      "check": "Number"
    },
    {
      "type": "field_checkbox",
      "name": "COLLIDE",
      "checked": true
    }
  ],
  "inputsInline": false,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Add an amount of gravity",
  "helpUrl": ""
},
{
  "type": "create",
  "message0": "Create %1 at %2 %3",
  "args0": [
    {
      "type": "input_value",
      "name": "TYPE",
      "check": "actor_type"
    },
    {
      "type": "input_value",
      "name": "POSX",
      "check": "Number"
    },
    {
      "type": "input_value",
      "name": "POSY",
      "check": "Number"
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Create an actor somewhere",
  "helpUrl": ""
},
{
  "type": "if_find_type",
  "message0": "Actor of type %1 exists",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME",
      "check": "actor_type"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Can an actor of a given type be found?",
  "helpUrl": ""
},
{
  "type": "difficulty",
  "message0": "%1 Easy %2 %3 Medium %4 %5 Hard",
  "args0": [
    {
      "type": "field_checkbox",
      "name": "EASY",
      "checked": true
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "MEDIUM",
      "checked": true
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "HARD",
      "checked": true
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "What difficulty is the microgame on?",
  "helpUrl": ""
},
{
  "type": "won_lost",
  "message0": "Game %1 %2",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "WHEN",
      "options": [
        [
          "has been",
          "HAS_BEEN"
        ],
        [
          "is",
          "IS"
        ]
      ]
    },
    {
      "type": "field_dropdown",
      "name": "WINLOSE",
      "options": [
        [
          "won",
          "WON"
        ],
        [
          "lost",
          "LOST"
        ]
      ]
    }
  ],
  "inputsInline": true,
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Detect game win/loss",
  "helpUrl": ""
},
{
  "type": "keys",
  "message0": "Key %1 %2",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "KEY",
      "options": [
        [
          "A",
          "A"
        ],
        [
          "B",
          "B"
        ],
        [
          "X",
          "X"
        ],
        [
          "Y",
          "Y"
        ],
        [
          "Left",
          "LEFT"
        ],
        [
          "Down",
          "DOWN"
        ],
        [
          "Up",
          "UP"
        ],
        [
          "Right",
          "RIGHT"
        ],
        [
          "Select",
          "SELECT"
        ],
        [
          "L",
          "L"
        ],
        [
          "R",
          "R"
        ]
      ]
    },
    {
      "type": "field_dropdown",
      "name": "STATE",
      "options": [
        [
          "down",
          "DOWN"
        ],
        [
          "pressed",
          "PRESSED"
        ],
        [
          "up",
          "UP"
        ],
        [
          "released",
          "RELEASED"
        ]
      ]
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Detect the state of a key",
  "helpUrl": ""
},
{
  "type": "touching_type",
  "message0": "Touching actor type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME",
      "check": "actor_type"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Is the actor touching an actor of a type?",
  "helpUrl": ""
},
{
  "type": "in_region",
  "message0": "In region %1 %2 to %3 %4",
  "args0": [
    {
      "type": "input_value",
      "name": "XPOS1"
    },
    {
      "type": "input_value",
      "name": "YPOS1"
    },
    {
      "type": "input_value",
      "name": "XPOS2"
    },
    {
      "type": "input_value",
      "name": "YPOS2"
    }
  ],
  "inputsInline": true,
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Is the actor in a given region?",
  "helpUrl": ""
},
{
  "type": "asm_condition",
  "message0": "%1 flags %2",
  "args0": [
    {
      "type": "input_statement",
      "name": "NAME"
    },
    {
      "type": "field_dropdown",
      "name": "FLAGS",
      "options": [
        [
          "eq",
          "eq"
        ],
        [
          "ne",
          "ne"
        ],
        [
          "pl",
          "pl"
        ],
        [
          "mi",
          "mi"
        ],
        [
          "cc",
          "cc"
        ],
        [
          "cs",
          "cs"
        ],
        [
          "vc",
          "vc"
        ],
        [
          "vs",
          "vs"
        ]
      ]
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "coordinate_pixels",
  "message0": "Pixels %1",
  "args0": [
    {
      "type": "field_number",
      "name": "NUM",
      "value": 0,
      "min": -2048,
      "max": 4095
    }
  ],
  "output": "Number",
  "colour": 230,
  "tooltip": "Converts an amount of pixels to a coordinate",
  "helpUrl": ""
},
{
  "type": "global",
  "message0": "Global (1-16) %1",
  "args0": [
    {
      "type": "field_number",
      "name": "NUM",
      "value": 1,
      "min": 1,
      "max": 16
    }
  ],
  "output": "Number",
  "colour": 65,
  "tooltip": "Access a global variable",
  "helpUrl": ""
},
{
  "type": "temp",
  "message0": "Temp (1-8) %1",
  "args0": [
    {
      "type": "field_number",
      "name": "NUM",
      "value": 1,
      "min": 1,
      "max": 8
    }
  ],
  "output": null,
  "colour": 65,
  "tooltip": "Access a temporary variable",
  "helpUrl": ""
},
{
  "type": "set_nomath",
  "message0": "Set %1 to %2",
  "args0": [
    {
      "type": "input_value",
      "name": "LEFT",
      "check": "Number"
    },
    {
      "type": "input_value",
      "name": "RIGHT",
      "check": "Number"
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "at_end",
  "message0": "At end of game",
  "output": "Boolean",
  "colour": 210,
  "tooltip": "Triggered at the end of a microgame",
  "helpUrl": ""
},
{
  "type": "game_init_run",
  "message0": "Game %1 Init %2 Run %3",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "input_statement",
      "name": "INIT"
    },
    {
      "type": "input_statement",
      "name": "RUN"
    }
  ],
  "inputsInline": false,
  "colour": 120,
  "tooltip": "Code for the game itself",
  "helpUrl": ""
},
{
  "type": "play_sfx",
  "message0": "Play sound %1",
  "args0": [
    {
      "type": "input_value",
      "name": "SOUND",
      "check": "Number"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Play a sound effect",
  "helpUrl": ""
},
{
  "type": "sound_effect",
  "message0": "Sound %1",
  "args0": [
    {
      "type": "field_input",
      "name": "SOUND",
      "text": ""
    }
  ],
  "output": "Number",
  "colour": 230,
  "tooltip": "Sound effect",
  "helpUrl": ""
},
{
  "type": "note",
  "message0": "// %1",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": "default"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 20,
  "tooltip": "A comment",
  "helpUrl": ""
},
{
  "type": "block_target_map_xy",
  "message0": "Target block at %1 X (block units) %2 Y (block units) %3",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "input_value",
      "name": "X",
      "check": "Number"
    },
    {
      "type": "input_value",
      "name": "Y",
      "check": "Number"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_coordinate_xy",
  "message0": "Target block at %1 X (coordinate) %2 Y (coordinate) %3",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "input_value",
      "name": "X",
      "check": "Number"
    },
    {
      "type": "input_value",
      "name": "Y",
      "check": "Number"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_actor_xy",
  "message0": "Target block at %1 X (from actor) %2 Y (from actor) %3",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "input_value",
      "name": "X",
      "check": "Number"
    },
    {
      "type": "input_value",
      "name": "Y",
      "check": "Number"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_change_type",
  "message0": "Change block to type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_retarget_xy",
  "message0": "Move block target by %1 , %2",
  "args0": [
    {
      "type": "field_number",
      "name": "X",
      "value": 0
    },
    {
      "type": "field_number",
      "name": "Y",
      "value": 0
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_x",
  "message0": "Targeted block X",
  "output": "Number",
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_y",
  "message0": "Targeted block Y",
  "output": "Number",
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_type",
  "message0": "Targeted block type",
  "output": "Number",
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_class",
  "message0": "Targeted block class",
  "output": "Number",
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_flags",
  "message0": "Block has %1 %2 Solid %3 Platform %4 A %5 B %6 C %7 D %8 E %9 F %10",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "NAME",
      "options": [
        [
          "any of these flags",
          "ANY"
        ],
        [
          "all of these flags",
          "ALL"
        ],
        [
          "exactly these flags",
          "EQUAL"
        ],
        [
          "none of these flags",
          "NONE"
        ]
      ]
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "field_checkbox",
      "name": "SOLID",
      "checked": true
    },
    {
      "type": "field_checkbox",
      "name": "SOLID_TOP",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "FLAG_A",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "FLAG_B",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "FLAG_C",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "FLAG_D",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "FLAG_E",
      "checked": false
    },
    {
      "type": "field_checkbox",
      "name": "FLAG_F",
      "checked": false
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "block_target_solid",
  "message0": "Block target is solid",
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},

{
  "type": "actor_hit_ceiling_block",
  "message0": "Actor hit ceiling of block type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_hit_ceiling_block_class",
  "message0": "Actor hit ceiling of block class %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_hit_floor_block",
  "message0": "Actor hit floor of block type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_hit_floor_block_class",
  "message0": "Actor hit floor of block class %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_hit_ceiling",
  "message0": "Actor touched the ceiling",
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},

{
  "type": "actor_ran_into_block",
  "message0": "Actor ran into block type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_ran_into_block_class",
  "message0": "Actor ran into block class %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_overlap_block",
  "message0": "Actor touching block type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_overlap_block_class",
  "message0": "Actor touching block class %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_center_overlap_block",
  "message0": "Actor's center touching block type %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_center_overlap_block_class",
  "message0": "Actor's center touching block class %1",
  "args0": [
    {
      "type": "input_value",
      "name": "NAME"
    }
  ],
  "output": null,
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "scroll_set",
  "message0": "Set scroll to %1 , %2",
  "args0": [
    {
      "type": "input_value",
      "name": "X"
    },
    {
      "type": "input_value",
      "name": "Y"
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "scroll_slide",
  "message0": "Slide scroll to %1 , %2 slowed by %3",
  "args0": [
    {
      "type": "input_value",
      "name": "X"
    },
    {
      "type": "input_value",
      "name": "Y"
    },
    {
      "type": "field_dropdown",
      "name": "SLOW",
      "options": [
        [
          "1",
          "DIV1"
        ],
        [
          "2",
          "DIV2"
        ],
        [
          "4",
          "DIV4"
        ],
        [
          "8",
          "DIV8"
        ]
      ]
    }
  ],
  "inputsInline": true,
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "scroll_follow_actor",
  "message0": "Scroll follows actor, slowed by %1",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "SLOW",
      "options": [
        [
          "1",
          "DIV1"
        ],
        [
          "2",
          "DIV2"
        ],
        [
          "4",
          "DIV4"
        ],
        [
          "8",
          "DIV8"
        ]
      ]
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "label",
  "message0": "Label %1 :",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": ""
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 0,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "goto",
  "message0": "Goto %1",
  "args0": [
    {
      "type": "field_input",
      "name": "NAME",
      "text": ""
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_on_ground",
  "message0": "Actor touching the ground",
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "actor_hit_wall",
  "message0": "Actor hit a wall",
  "output": "Boolean",
  "colour": 210,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "do_while",
  "message0": "do %1 while %2",
  "args0": [
    {
      "type": "input_statement",
      "name": "DO"
    },
    {
      "type": "input_value",
      "name": "BOOL",
      "check": "Boolean"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "",
  "helpUrl": ""
}

]);