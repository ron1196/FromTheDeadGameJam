@tool
extends BodyPart

const ANIMATION_EXPLODE_NAME: String = "explode"

@onready var self_destruct: SelfDestructTrait = %SelfDestruct
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite


func activate_trait(unit: Unit, gtrait_idx: int) -> bool:
	var gtrait: GTrait = traits[gtrait_idx]

	match gtrait:
		self_destruct:
			animated_sprite.play(ANIMATION_EXPLODE_NAME)
			await animated_sprite.animation_finished
			self_destruct.activate(unit)
			return true

	return false
