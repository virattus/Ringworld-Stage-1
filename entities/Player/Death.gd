extends BasicState


var VerticalVelocity := 0.0

var Gravity := 0.0

const DEATH_INITIAL_VERTICAL_VELOCITY = 5.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Death/blend_amount", 1.0)
	
	if !_msg.has("DeathType"):
		assert(false)
		
	if _msg["DeathType"] == "DROWN":
		VerticalVelocity = 0.0
		owner.SndWaterDrown = true
		Gravity = owner.Parameters.GRAVITY * 0.25
	else:
		VerticalVelocity = DEATH_INITIAL_VERTICAL_VELOCITY
		owner.SndDeath.play()
		Gravity = owner.Parameters.GRAVITY
	
	owner.DashModeDrain = false
	
	owner.ActivateHitbox(false)
	owner.ActivateHurtbox(false)
	
	owner.HealthEmpty.emit()
	

func Exit() -> void:
	owner.AnimTree.set("parameters/Death/blend_amount", 0.0)
	owner.SndDeath.play()


func Update(_delta: float) -> void:
	var cam = get_viewport().get_camera_3d()
	
	owner.CharMesh.look_at(cam.global_transform.origin)
	
	VerticalVelocity -= Gravity * _delta
	
	owner.CharMesh.global_position.y += VerticalVelocity * _delta
