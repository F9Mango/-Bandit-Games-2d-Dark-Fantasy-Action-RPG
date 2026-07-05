type xy
	x as single
	y as single
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
	window_size as single
	window_offset as xy
	isPlatformer as _unsigned _byte
	tile_size as long
	scale_multiplier as double
	numberOfEntities as long
	interaction_mode as _unsigned _byte
end type
type graphics_data
	bg_image as long
	bg_tiles as long
	entity_layer as long
	entity_fg_layer as long
	fg_tiles as long
	ui_bg as long
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
	spawn_entity as _unsigned integer '
	entity_spawned as _unsigned _byte
end type
type map_tile
	tile_type as _unsigned integer
	animation_offset as integer
	var_A as long
	var_B as long
	var_C as long
	event_index_interact as integer
	event_index_zone as integer
end type
type screen_tile
	tile_start as xy_int
	tile_end as xy_int
	tile_index as _unsigned integer
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
	state as _unsigned _byte
	item_name as string * 255
	unstackable as _unsigned _byte
	quantity as _unsigned integer
end type
