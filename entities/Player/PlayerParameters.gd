class_name PlayerParameters
extends Node


#const GRAVITY = 9.8
const GRAVITY = 13.125 #2D Sonic gravity I think
const GRAVITY_UNDERWATER = 3.75 #2D sonic
const UPDIR_SLERP_RATE = 10.0
const FLOOR_NORMAL_TRANSITION_MAX = 0.1
const FLICKER_CYCLE_TIME = 0.0625

const OXYGEN_MAX_TIME = 30.0
const OXYGEN_CHIME_1 = 5.0
const OXYGEN_CHIME_2 = 5.0
const OXYGEN_CHIME_3 = 5.0
const OXYGEN_BUBBLE_5 = 2.0
const OXYGEN_BUBBLE_4 = 2.0
const OXYGEN_BUBBLE_3 = 2.0
const OXYGEN_BUBBLE_2 = 2.0
const OXYGEN_BUBBLE_1 = 2.0
const OXYGEN_BUBBLE_0 = 2.0
const OXYGEN_LAST_GASP = 2.0 + 2.0 # just extend the last state to account for the animation

const GROUND_NORMAL_TRANSITION_MIN = 0.85
const GROUND_NORMAL_HOP = 0.1

const SKID_MIN_STICK_MAGNITUDE = 0.15
const SKID_MAX_ANGLE = -0.75

const MOVE_MAX_SPEED = 25.0
const VEL_TRUE_CAP = 255.0
const TERMINAL_VELOCITY = 16.0 #yep, we have a max -Y speed exclusively

const JUMP_RELEASE_MAX_Y_SPEED = 4.0

const FALL_DRAG = 0.125
const FALL_MAX_Y_DRAG_SPEED = -4.0 #Only apply XZ drag when falling faster than this


const DASHMODE_MIN_CHARGE = 0.0
const DASHMODE_MAX_CHARGE = 1.1
const DASHMODE_DISCHARGE_RATE = 0.05
const DASHMODE_SLOW_DISCHARGE_RATE = 0.01
const DASHMODE_INCREMENT_RING = 0.05
const DASHMODE_INCREMENT_ENEMY = 0.1

const HURT_INVINCIBILITY_TIME = 2.0
