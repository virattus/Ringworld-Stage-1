extends BasicState


var VerticalVelocity := 0.0


const BOUNCE_VELOCITY = 10.0


func Enter(_msg := {}) -> void:
	owner.EnemyInvincible = false


func Exit() -> void:
	VerticalVelocity = 0.0


func Update(_delta: float) -> void:
	owner.Move()

	var newVel = owner.velocity
	
	newVel.y -= 10.0 * _delta
	
	if owner.is_on_floor():
		var direction = owner.global_position.direction_to(owner.player.global_position)
		newVel = (direction * Vector3(1, 0, 1)) + (Vector3.UP * BOUNCE_VELOCITY)
	
	owner.SetVelocity(newVel)
