extends "res://entities/Sonic/MoveGround.gd"


var IgnoreInput := 0.0

var FootstepAccumulator := 0.0


const RUN_RATIO_DIVISOR = 200.0

const MOVE_CHARMESH_VEL_ORIENT_MIN_SPEED = 2.0

const FOOTSTEP_TIME_MOD = 0.5


const WATER_RUN_SPLASH = preload("res://effects/WaterRunSplash/WaterRunSplash.tscn")


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 0.0)
	owner.AnimTree.set("parameters/Ground/blend_amount", 1.0)
	owner.AnimTree.set("parameters/GroundSecondary/blend_amount", -1.0)
	
	if _msg.has("IgnoreInput"):
		IgnoreInput = _msg["IgnoreInput"]
		
	if _msg.has("Boost"):
		owner.SetVelocity(_msg["Boost"])
		owner.SndSpinLaunch.play()


func Exit() -> void:
	IgnoreInput = 0.0
	owner.SetRunOnWater(false)
	

func Update(_delta: float) -> void:
	if !HandleMovementAndCollisions(_delta):
		ChangeState("Fall")
		return
	
	UpdateMoveAnimations()
	
	if Input.is_action_just_pressed("Jump"):
		ChangeState("Jump")
		return
	
	if Input.is_action_just_pressed("Attack"):
		ChangeState("Ball")
		return
	
	if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
		owner.SetRunOnWater(true)
	else:
		owner.SetRunOnWater(false)
	
	FootstepAccumulator += _delta
	if FootstepAccumulator > (1.0 - (owner.Speed / owner.PARAMETERS.MOVE_MAX_SPEED)) * FOOTSTEP_TIME_MOD:
		if !owner.GroundCollision and owner.IsOnWaterSurface(): #raycast doesn't hit solid ground idiot
			owner.SndWaterRunFootstep.play()
			var splash = WATER_RUN_SPLASH.instantiate()
			owner.get_parent().add_child(splash)
			splash.global_transform = owner.CharMesh.global_transform
			
		FootstepAccumulator = 0.0
			
	
	var newVel = owner.velocity
	
	var inputVel = owner.GetInputVector(owner.up_direction)
	
	if IgnoreInput > 0.0:
		inputVel = Vector3.ZERO
		IgnoreInput -= _delta
	
	if inputVel.length() > 0.0:
		if newVel.length() > owner.PARAMETERS.WALK_MAX_SPEED:
			if owner.GroundCollision: #Only skid if not running on water
				if HandleSkid(inputVel):
					return
					
			newVel = CalculateRunVelocity(inputVel, _delta)
		else:
			newVel = CalculateWalkVelocity(inputVel, _delta)
	else:
		newVel = owner.ApplyDrag(newVel, _delta)
	
	if newVel.length() > owner.PARAMETERS.MOVE_MAX_SPEED:
		newVel = newVel.normalized() * owner.PARAMETERS.MOVE_MAX_SPEED
	
	
	if inputVel.length() > 0.0:
		#only update model's direction if player moves stick
		owner.OrientCharMesh()
		
	else:
		var influence = CurveInfluence(_delta)
		
		if influence.length() <= 0.05 and newVel.length() <= owner.PARAMETERS.IDLE_MAX_SPEED:
			ChangeState("Idle")
			return
		
		newVel += influence
		
		if newVel.length() > MOVE_CHARMESH_VEL_ORIENT_MIN_SPEED:
			var orientation = newVel.normalized()
			if owner.CharMesh.GetForwardVector().dot(orientation) < 0.0:
				orientation = -orientation
			
			owner.CharMesh.LerpMeshOrientation(orientation, _delta)
	
	owner.SetVelocity(newVel)


func CalculateWalkVelocity(inputVel: Vector3, delta: float) -> Vector3:
	var speedMod = owner.PARAMETERS.WALK_SPEED_POWER
	if owner.IsUnderwater:
		speedMod = owner.PARAMETERS.WALK_SPEED_POWER / 3.0
	
	var inputValue : Vector3 = (inputVel * speedMod * delta) + (inputVel.normalized() * owner.Speed)
	var newVel = inputValue
	
	return newVel


func CalculateRunVelocity(inputVel: Vector3, delta: float) -> Vector3:
	var newVel : Vector3 = owner.velocity
	
	var ratio : float = (owner.Speed - owner.PARAMETERS.WALK_MAX_SPEED) / RUN_RATIO_DIVISOR
	print("Run ratio: %s" % ratio)
	
	var newSpeed : float = (newVel + (inputVel * owner.PARAMETERS.RUN_SPEED_POWER * delta)).length()
	
	if newVel.length() >= owner.PARAMETERS.RUN_MAX_SPEED:
		newSpeed = lerp(newSpeed, owner.PARAMETERS.RUN_MAX_SPEED, delta)
	
	newVel = (newVel * ratio) + ((inputVel * owner.PARAMETERS.RUN_SPEED_POWER * delta) * (1.0 - ratio))
	
	newVel = newVel.normalized() * newSpeed
	
	#newVel = owner.ApplyDrag(newVel, delta)
	
	#Remove excess velocity for curves/spheres
	newVel = newVel - (owner.up_direction * owner.up_direction.dot(newVel))
	
	return newVel


func HandleSkid(input: Vector3) -> bool:
	if input.length() > owner.PARAMETERS.SKID_MIN_STICK_MAGNITUDE:
		if owner.IsInputSkidding(input):
			ChangeState("Skid")
			return true
	
	return false


func UpdateMoveAnimations() -> void:
	owner.CharMesh.AlignToY(owner.up_direction)
	
	if owner.DashMode:
		if owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
			owner.AnimTree.set("parameters/StrikeDash/blend_amount", 1.0)
			owner.AnimTree.set("parameters/TSStrikeDash/scale", owner.Speed * owner.PARAMETERS.SPRINT_ANIM_SPEED_MOD)
		else:
			owner.AnimTree.set("parameters/StrikeDash/blend_amount", 0.0)
			owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
			owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.WALK_ANIM_SPEED_MOD)
	else:
		owner.AnimTree.set("parameters/StrikeDash/blend_amount", 0.0)
		if owner.Speed > owner.PARAMETERS.RUN_MAX_SPEED:
			owner.AnimTree.set("parameters/Run/blend_amount", 1.0)
			owner.AnimTree.set("parameters/TSSprint/scale", owner.Speed * owner.PARAMETERS.SPRINT_ANIM_SPEED_MOD)
		elif owner.Speed > owner.PARAMETERS.WALK_MAX_SPEED:
			owner.AnimTree.set("parameters/Run/blend_amount", 0.0)
			owner.AnimTree.set("parameters/TSRun/scale", owner.Speed * owner.PARAMETERS.RUN_ANIM_SPEED_MOD)
		else:
			owner.AnimTree.set("parameters/Run/blend_amount", -1.0)
			owner.AnimTree.set("parameters/TSWalk/scale", owner.Speed * owner.PARAMETERS.WALK_ANIM_SPEED_MOD)
