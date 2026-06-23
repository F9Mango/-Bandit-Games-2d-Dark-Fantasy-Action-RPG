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
type graphics_data
	bg_image as long
	bg_tiles as long
	entity_layer as long
	fg_tiles as long
	ui as long
	show_hotpoints as _unsigned _byte
end type
type tile_attributes
	'Determines whether the object is drawn from an image handle or a solid color value
	is_image as _unsigned _byte
	
	bg_index as _unsigned long ' Specifies the background graphic of each tile
	bg_color as color_rgb 'Specifies the background color of each tile
	
	'Specifies the beginning and ending of the tile's animation within the map_tileset_gfx array.
	index_start as _unsigned long
	index_end as _unsigned long
	
	'Variables for the animation process
	frame_counter as _unsigned long 'Specifies which frame is being displayed, this variable is added to index_start to find the specific image handle.
	frame_threshold as _unsigned long 'The amount of steps required to increment the frame counter, is compared against the frame step
	frame_step as _unsigned long 'A counter that increments with each loop of the main game, compared against the frame threshold. When equal to or greater than the threshold, will be reset to 0 and the frame counter will be incremented 
	'is_looping as _unsigned _byte 'Specifies whether or not to reset the frame counter once the sum of the frame counter and index_start is equal to index_end.
	
	solid_color as color_rgb
	
	has_collision as _unsigned _byte
	layer as _unsigned _byte
	class as _unsigned _byte '0 = inert tile, 1 = door, 2 = teleport zone, 3 = event trigger
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
type player_variables
	health as double
	maxHealth as double
	sword_level as _unsigned _byte
	bow_level as _unsigned _byte
	keys as _unsigned integer
	big_keys as _unsigned integer
end type
type inventory_slot
	item_id as _unsigned integer
	item_name as string * 255
end type
