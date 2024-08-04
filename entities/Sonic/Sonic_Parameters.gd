extends Node


const GRAVITY = 9.8
const UPDIR_SLERP_RATE = 10.0
const FLOOR_NORMAL_TRANSITION_MAX = 0.1
const FLICKER_CYCLE_TIME = 1.0

const GROUND_NORMAL_TRANSITION_MIN = 0.85
const GROUND_NORMAL_HOP = 0.1


const WALK_MIN_SPEED = 0.5
const WALK_MAX_SPEED = 8.0
const WALK_SPEED_POWER = 5.0
const WALK_ANIM_SPEED_MOD = 1.0

const RUN_MAX_SPEED = 14.0
const RUN_SPEED_POWER = 20.0
const RUN_ANIM_SPEED_MOD = 0.5

const SPRINT_MAX_SPEED = 25.0
const SPRINT_ANIM_SPEED_MOD = 1.0

const DASHMODE_MIN_CHARGE = 1.0
const DASHMODE_MAX_CHARGE = 1.0
const DASHMODE_DISCHARGE_RATE = 1.0
const DASHMODE_SLOW_DISCHARGE_RATE = 1.0
const DASHMODE_INCREMENT_RING = 1.0


const JUMP_POWER = 10.0
