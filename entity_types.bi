type entity
	state as _unsigned _byte
	id as _unsigned integer
	home as xy
	'Position and velocity
	p as xy
	v as xy
	'Base dimensions
	w as double
	h as double
	'XY offset between core coordinates and bounding box
	o as xy
	'Four corners' coordinates
	tl as xy
	tr as xy
	bl as xy
	br as xy
	'Width and height multipliers
	wm as double
	hm as double
	'Controls and multiplies the entity's interaction with gravity.
	gravity as double
	'Determines if the entity is on the ground.
	onGround as _unsigned _byte
	isFlying as _unsigned _byte
	'Graphics values
	layer as _unsigned _byte
	is_image as _unsigned _byte
	index_start as _unsigned long
	index_end as _unsigned long
	frame_counter as _unsigned long
	frame_threshold as _unsigned long
	frame_step as _unsigned long
	is_looping as _unsigned _byte 'Specifies whether or not to reset the frame counter once the sum of the frame counter and index_start is equal to index_end.
	look as color_rgb
	direction as xy
	'Position from which the entity shoots projectile/interacts with environment.
	actionPoint_default as xy
	actionPoint as xy
	
	'Entity-specific values
	var_A as long
	var_B as long
	var_C as long
	var_D as long
	var_E as long
	var_F as long
	var_G as long
	var_H as long
end type
