class_name BodyPartAttributes
extends Resource

@export var intelligence: int
@export var attack: int
@export var speed: int
@export var endurance: int


func add(other: BodyPartAttributes):
	intelligence += other.intelligence
	attack += other.attack
	speed += other.speed
	endurance += other.endurance


func equals(other: BodyPartAttributes):
	return intelligence == other.intelligence && \
		attack == other.attack && \
		speed == other.speed && \
		endurance == other.endurance
