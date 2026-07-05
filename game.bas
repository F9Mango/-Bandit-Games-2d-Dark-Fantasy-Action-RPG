rem $DYNAMIC
'$include: 'data_types.bi'
'$include: 'entity_types.bi'

dim shared gset as settings
dim shared gdata as graphics_data

gset.world_size.x = 128
gset.world_size.y = 128

gset.screen_resolution.x = 800
gset.screen_resolution.y = 600

gset.window_size = 0.85

gwindowx = gset.screen_resolution.x * gset.window_size
gwindowy = gset.screen_resolution.y * gset.window_size

gset.window_offset.x = (800 - 640) / 2 - 16' int(gset.screen_resolution.x * (250 / 1366))
gset.window_offset.y = 16' (gset.screen_resolution.y * (1 - gset.window_size))
gset.tile_size = (gset.screen_resolution.x / 20) * gset.window_size
gset.scale_multiplier = gset.tile_size / 32

gdata.bg_tiles = _newimage(gwindowx, gwindowy, 32)
gdata.entity_layer = _newimage(gwindowx, gwindowy, 32)
gdata.entity_fg_layer = _newimage(gwindowx, gwindowy, 32)
gdata.fg_tiles = _newimage(gwindowx, gwindowy, 32)
gdata.ui_bg = _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)
gdata.ui = _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)



open "log.txt" for output as #1
close #1
open "log.txt" for append as #1

dim shared overlay_img as long: overlay_img = _loadimage("gfx/overlay.png", 32)
_clearcolor _rgb(255, 64, 255), overlay_img
dim shared heart_img as long: heart_img = _loadimage("gfx/heart.png", 32)
_clearcolor _rgb(255, 64, 255), heart_img

dim shared map_tileset_gfx(255) as long
map_tileset_gfx(0) = _loadimage("gfx/0.png", 32)
map_tileset_gfx(1) = _loadimage("gfx/1.png", 32)
map_tileset_gfx(2) = _loadimage("gfx/door_closed.png", 32)
map_tileset_gfx(3) = _loadimage("gfx/door_open.png", 32)
map_tileset_gfx(4) = _loadimage("gfx/black.png", 32)
map_tileset_gfx(5) = _loadimage("gfx/portal1.png", 32)
map_tileset_gfx(6) = _loadimage("gfx/portal2.png", 32)
map_tileset_gfx(7) = _loadimage("gfx/portal3.png", 32)
map_tileset_gfx(8) = _loadimage("gfx/door_closed_d.png", 32)
map_tileset_gfx(9) = _loadimage("gfx/door_open_d.png", 32)
map_tileset_gfx(10) = _loadimage("gfx/door_closed_l.png", 32)
map_tileset_gfx(11) = _loadimage("gfx/door_open_l.png", 32)
map_tileset_gfx(12) = _loadimage("gfx/door_closed_r.png", 32)
map_tileset_gfx(13) = _loadimage("gfx/door_open_r.png", 32)
map_tileset_gfx(14) = _loadimage("gfx/shrubbery.png", 32)
map_tileset_gfx(15) = _loadimage("gfx/water.png", 32)

dim shared entity_sprites(255) as long
entity_sprites(0) = _loadimage("gfx/key.png", 32)
entity_sprites(1) = _loadimage("gfx/bat.png", 32)
for i = 0 to 1
	    _clearcolor _rgb(255, 64, 255), entity_sprites(i)
next i

dim shared map_tileset(128) as tile_attributes

map_tileset(0).is_image = 1
map_tileset(0).bg_index = 0


map_tileset(1).is_image = 1
map_tileset(1).index_start = 1
map_tileset(1).index_end = 1
map_tileset(1).solid_color.r = 128
map_tileset(1).solid_color.g = 128
map_tileset(1).has_collision = 1
map_tileset(1).layer = 1

map_tileset(2).is_image = 1
map_tileset(2).bg_index = 4
map_tileset(2).index_start = 2
map_tileset(2).index_end = 2
map_tileset(2).solid_color.r = 255
map_tileset(2).solid_color.g = 255
map_tileset(2).has_collision = 1
map_tileset(2).layer = 1
map_tileset(2).class = 1

map_tileset(3).is_image = 1
map_tileset(3).bg_index = 4
map_tileset(3).index_start = 3
map_tileset(3).index_end = 3
map_tileset(3).solid_color.r = 64
map_tileset(3).solid_color.g = 64
map_tileset(3).layer = 1

map_tileset(4).is_image = 1
map_tileset(4).bg_index = 4
map_tileset(4).index_start = 8
map_tileset(4).index_end = 8
map_tileset(4).solid_color.r = 255
map_tileset(4).solid_color.g = 255
map_tileset(4).has_collision = 1
map_tileset(4).layer = 1
map_tileset(4).class = 1

map_tileset(5).is_image = 1
map_tileset(5).bg_index = 4
map_tileset(5).index_start = 9
map_tileset(5).index_end = 9
map_tileset(5).solid_color.r = 64
map_tileset(5).solid_color.g = 64
map_tileset(5).layer = 1

map_tileset(6).is_image = 1
map_tileset(6).bg_index = 4
map_tileset(6).index_start = 10
map_tileset(6).index_end = 10
map_tileset(6).solid_color.r = 255
map_tileset(6).solid_color.g = 255
map_tileset(6).has_collision = 1
map_tileset(6).layer = 1
map_tileset(6).class = 1

map_tileset(7).is_image = 1
map_tileset(7).bg_index = 4
map_tileset(7).index_start = 11
map_tileset(7).index_end = 11
map_tileset(7).solid_color.r = 64
map_tileset(7).solid_color.g = 64
map_tileset(7).layer = 1

map_tileset(8).is_image = 1
map_tileset(8).bg_index = 4
map_tileset(8).index_start = 12
map_tileset(8).index_end = 12
map_tileset(8).solid_color.r = 255
map_tileset(8).solid_color.g = 255
map_tileset(8).has_collision = 1
map_tileset(8).layer = 1
map_tileset(8).class = 1

map_tileset(9).is_image = 1
map_tileset(9).bg_index = 4
map_tileset(9).index_start = 13
map_tileset(9).index_end = 13
map_tileset(9).solid_color.r = 64
map_tileset(9).solid_color.g = 64
map_tileset(9).layer = 1

map_tileset(10).is_image = 1
map_tileset(10).index_start = 14
map_tileset(10).index_end = 14
map_tileset(10).has_collision = 1
map_tileset(10).layer = 1

map_tileset(11).is_image = 1
map_tileset(11).index_start = 15
map_tileset(11).index_end = 15
map_tileset(11).has_collision = 1

map_tileset(128).is_image = 1
map_tileset(128).index_start = 5
map_tileset(128).index_end = 7
map_tileset(128).frame_threshold = 15
map_tileset(128).solid_color.r = 0
map_tileset(128).solid_color.g = 64
map_tileset(128).class = 2

dim shared map(0, 0) as map_tile
dim shared tile_map(21, 16) as screen_tile

gset.tile_size = 32
gset.scale_multiplier = gset.tile_size / 32
gset.numberOfEntities = 0

dim shared camera as xy
dim shared entities(128) as entity
dim shared e_sorting_buffer(128) as entity
dim shared blank_entity as entity
dim shared playerHoldingJump as _unsigned _byte
dim shared player_data as player_variables
player_data.maxHealth = 10
player_data.health = player_data.maxHealth

'player_data.keys = 10

dim shared inventory(255) as inventory_slot
add_to_inventory "key", 1, 0

entities(0).state = 1
entities(0).w = 16
entities(0).h = 16
entities(0).o.x = -8
entities(0).o.y = -16

entities(0).wm = 1
entities(0).hm = 1.5
entities(0).p.x = 64
entities(0).p.y = 64
entities(0).look.r = 255
entities(0).look.b = 255


'generate_map
load_map "map.bmp"

map(10, 10).tile_type = 128
map(10, 10).var_A = 50*32
map(10, 10).var_B = 7*32
map(10, 10).var_C = 0

map(11, 10).tile_type = 128
map(11, 10).var_A = 50*32
map(11, 10).var_B = 7*32
map(11, 10).var_C = 0

map(10, 11).event_index_zone = 1


screen _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)
_printmode _keepbackground
print "Commands:"
print "  Rescale the map with -/+ keys"
print "  Regenerate the map with G key"
print "  Spawn a key entity on the current screen with the L key"
print "  Spawn an enemy bat entity on the current screen with the ; key"
print "  Switch between top-down and platformer control with P key"
print "  Delete tiles under the player's action point with the . key"
print "  Unlock yellow tiles under the player's action point with the E key"
print
print "  Top-down:"
print "		Move with WASD"
print
print "  Platform:"
print "     Move left and right with A & D"
print "     Jump with W"
sleep
_font 8


dim pgridx as integer
dim pgridy as integer

do
	_limit 60
	
	for i = 0 to 128
		animate_tileset i
	next i
	
	
	select case gset.interaction_mode
		case 0: 'Gameplay.
			ui_input
			
			for i = 1 to 10
				player_specific_physics
				for j = 0 to 128 'gset.numberOfEntities
					if entities(j).state <> 0 then
						entity_ai j
						entity_physics j
						if j <> 0 then
							if distance2d(entities(0).p, entities(j).p) > 768 then
								print #1, "!!!Entity"; j; "has exceeded maximum distance from the player. Destroying entity..."
								destroy_entity j, 1
							end if
							if entity_is_colliding(entities(0), entities(j)) = 1 then
								select case entities(j).id
									case 0:
										print #1, "Player has collided with a key! destroying key entity and incrementing key counter..."
										destroy_entity j, 1
										add_to_inventory "key", 1, 0
										'player_data.keys = player_data.keys + 1
								end select
							end if
							'egridx = int(entities(j).p.x / 32) - camera.x
							'egridy = int(entities(j).p.y / 32) - camera.y
							'if egridx < 0 or egridy < 0 or egridx > 19 or egridy > 14 then
							'	
							'	print #1, "!!!Entity"; j; "is no longer within the boundary of the visible screen! Destroying..."

							'	destroy_entity j, 0
							'end if
						end if
					end if
				next j
			next i
			
			'check if the player is in an event zone
			egridx = int(entities(0).p.x / 32)
			egridy = int(entities(0).p.y / 32)
			if checkInBounds(egridx, egridy) = 1 then
				doEvent map(egridx, egridy).event_index_zone
			end if

			camera.x = int(entities(0).p.x / (32 * 20)) * 20
			camera.y = int(entities(0).p.y / (32 * 15)) * 15
		case 1: 'NPC chat menu
			
		case 2: 'Defeat screen
		
	end select
	
	
	draw_screen_gameplay
	
	egridx = egridx - camera.x
	egridy = egridy - camera.y
	'locate 10, 1: print egridx, egridy
	
	_display
loop

end_program:
close #1
system

sub ui_input
	a$ = inkey$
	
	select case a$
		case chr$(27):
			close #1
			system
		case "g":
			generate_map
			
		case "p":
			if gset.isPlatformer = 0 then
				gset.isPlatformer = 1
			else
				gset.isPlatformer = 0
			end if
			pp = 60
			
			
		'case "-":
		'	if gset.tile_size > 8 then gset.tile_size = gset.tile_size - 8: gset.scale_multiplier = gset.tile_size / 32
		'case "=":
		'	if gset.tile_size < 128 then gset.tile_size = gset.tile_size + 8: gset.scale_multiplier = gset.tile_size / 32
		
		
		case "l":
			create_entity 0
		case ";":
			create_entity 1
		case "'":
			create_entity 2
		case ".":
			x = int(entities(0).actionPoint.x / 32)
			y = int(entities(0).actionPoint.y / 32)
			if isColWMap(entities(0).actionPoint.x, entities(0).actionPoint.y) = 1 then map(x ,y).tile_type = 0
			
			
		case "e":
			x = int(entities(0).actionPoint.x / 32)
			y = int(entities(0).actionPoint.y / 32)
			if checkInBounds(x, y) = 1 then
				doEvent map(x, y).event_index_interact
				select case map_tileset(map(x, y).tile_type).class
				
					case 1:
						if map_tileset(map(x, y).tile_type).class = 1 then
							'if player_data.keys > 0 then
							'	map(x ,y).tile_type = map(x ,y).tile_type + 1
							'	for y2 = 0 to gset.world_size.y
							'		for x2 = 0 to gset.world_size.x
							'			if map_tileset(map(x2, y2).tile_type).class = 1 and map(x2, y2).var_C = map(x, y).var_C then
							'				map(x2, y2).tile_type = map(x2, y2).tile_type + 1
							'			end if
							'		next x2
							'	next y2
							'	player_data.keys = player_data.keys - 1
							'end if
							if check_inventory("key") > 0 then
								map(x ,y).tile_type = map(x ,y).tile_type + 1
								for y2 = 0 to gset.world_size.y
									for x2 = 0 to gset.world_size.x
										if map_tileset(map(x2, y2).tile_type).class = 1 and map(x2, y2).var_C = map(x, y).var_C then
											map(x2, y2).tile_type = map(x2, y2).tile_type + 1
										end if
									next x2
								next y2
								remove_from_inventory "key", 1
							end if
						end if
						
					case 3: 'event trigger
						'callEvent may(x, y).var_A
						
				end select
			end if
			
			
		case "h":
			if gdata.show_hotpoints = 0 then
				gdata.show_hotpoints = 1
			else
				gdata.show_hotpoints = 0
			end if
			
		case "o":
			print #1, "!!!printing entity table data"
			for i = 0 to 128
				print #1, "entity"; i;": state = ";entities(i).state; ", id = "; entities(i).id
			next i
		case "i":
			sort_entities
	end select
end sub

sub doEvent(event as integer)
	select case event
		case 1:
			for i = 0 to 25
				create_entity 2
			next i
		case 2:
			beep
	end select
end sub

function distance2d(a as xy, b as xy)
	distance2d = sqr(abs((b.x - a.x) ^ 2 + (b.y - a.y) ^ 2))
end function

'$include: 'map_grid.bm'
'$include: 'physics_subroutines.bm'
'$include: 'graphics_subroutines.bm'
'$include: 'entity_programming.bm'
'$include: 'inventory_subroutines.bm'
