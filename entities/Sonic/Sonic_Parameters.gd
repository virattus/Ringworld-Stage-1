extends Node


const GRAVITY = 9.8
const UPDIR_SLERP_RATE = 10.0
const FLOOR_NORMAL_TRANSITION_MAX = 0.1
const FLICKER_CYCLE_TIME = 0.0625

const GROUND_NORMAL_TRANSITION_MIN = 0.85
const GROUND_NORMAL_HOP = 0.1

const ATTACK_BOUNCE_POW = 8.0

const DAMAGE_THRESHOLD_BALL = 1
const DAMAGE_THRESHOLD_STRIKEDASH = 1
const DAMAGE_THRESHOLD_NORMAL = 0

const IDLE_MAX_SPEED = 0.1

const WALK_MAX_SPEED = 8.0
const WALK_SPEED_POWER = 3.0
const WALK_ANIM_SPEED_MOD = 1.0

const RUN_MAX_SPEED = 16.0
const RUN_SPEED_POWER = 3.0
const RUN_ANIM_SPEED_MOD = 0.5

const SPRINT_MAX_SPEED = 25.0
const SPRINT_ANIM_SPEED_MOD = 1.0

const MOVE_MAX_SPEED = 25.0

const DASHMODE_MIN_CHARGE = 0.0
const DASHMODE_MAX_CHARGE = 1.1
const DASHMODE_DISCHARGE_RATE = 0.05
const DASHMODE_SLOW_DISCHARGE_RATE = 0.01
const DASHMODE_INCREMENT_RING = 0.05
const DASHMODE_INCREMENT_ENEMY = 0.1

const BALL_MIN_SPEED = 1.0

const AIR_INPUT_VEL = 2.0
const AIR_WATER_INPUT_VEL = 1.0

const JUMP_POWER = 10.0
