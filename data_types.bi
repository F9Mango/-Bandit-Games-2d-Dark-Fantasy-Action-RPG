type xy
	x as double
	y as double
end type
type xy_int
	x as _unsigned long
	y as _unsigned long
end type
type color_rgb
	r as _unsigned _byte
	g as _unsigned _byte
	b as _unsigned _byte
	tcr as _unsigned _byte
	tcg as _unsigned _byte
	tcb as _unsigned _byte
end type
type settings
	world_size as xy_int
	screen_resolution as xy_int
	isPlatformer as _unsigned _byte
	tile_size as long
	scale_multiplier as double
	numberOfEntities as long
end type
type tile_attributes
	is_image as _unsigned _byte
	index_start as _unsigned long
	index_end as _unsigned long
	frame_counter as _unsigned long
	frame_threshold as _unsigned long
	frame_step as _unsigned long
	solid_color as color_rgb
	has_collision as _unsigned _byte
	tile_offset as xy_int
	tile_size as xy
end type
type map_tile
	tile_type as _unsigned integer
	var_A as long
	var_B as long
	var_C as long
end type
type screen_tile
	tile_start as xy_int
	tile_end as xy_int
	tile_index as _unsigned integer
end type
type entity
	state as _unsigned _byte
	id as _unsigned integer
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
	'Graphics values
	is_image as _unsigned _byte
	index_start as _unsigned long
	index_end as _unsigned long
	frame_counter as _unsigned long
	frame_threshold as _unsigned long
	frame_step as _unsigned long
	look as color_rgb
	direction as xy
	'Position from which the entity shoots projectile/interacts with environment.
	actionPoint_default as xy
	actionPoint as xy
end type
type player_variables
	health as double
	maxHealth as double
	sword_level as _unsigned _byte
	bow_level as _unsigned _byte
	keys as _unsigned integer
	big_keys as _unsigned integer
end type
