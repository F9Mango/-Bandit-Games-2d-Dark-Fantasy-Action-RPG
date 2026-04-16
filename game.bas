rem $DYNAMIC
'$include: 'data_types.bi'
dim shared gset as settings
dim shared gdata as graphics_data
gset.world_size.x = 128
gset.world_size.y = 128
gset.screen_resolution.x = 640
gset.screen_resolution.y = 480
gdata.bg_tiles = _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)
gdata.entity_layer = _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)
gdata.fg_tiles = _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)

dim shared map_tileset_gfx(3) as long
map_tileset_gfx(0) = _loadimage("gfx/0.png", 32)
map_tileset_gfx(1) = _loadimage("gfx/1.png", 32)
dim shared map_tileset(128) as tile_attributes
map_tileset(0).is_image = 1
map_tileset(1).is_image = 1
map_tileset(1).index_start = 1
map_tileset(0).solid_color.g = 64
map_tileset(1).solid_color.r = 128
map_tileset(1).solid_color.g = 128
map_tileset(1).has_collision = 1
map_tileset(1).layer = 1
map_tileset(2).is_image = 0
map_tileset(2).solid_color.r = 255
map_tileset(2).solid_color.g = 255
map_tileset(2).has_collision = 1
map_tileset(3).is_image = 0
map_tileset(3).solid_color.r = 64
map_tileset(3).solid_color.g = 64
map_tileset(4).is_image = 0
map_tileset(4).solid_color.r = 0
map_tileset(4).solid_color.g = 64

dim shared map(0, 0) as map_tile
dim shared tile_map(21, 16) as screen_tile

gset.tile_size = 32
gset.scale_multiplier = gset.tile_size / 32
gset.numberOfEntities = 0

'generate_map
load_map "map.png"

map(10, 10).tile_type = 4
map(10, 10).var_A = 512
map(10, 10).var_B = 512
map(10, 10).var_C = 1

dim shared camera as xy
dim shared entities(100) as entity
dim shared playerHoldingJump as _unsigned _byte
dim shared player_data as player_variables
player_data.keys = 10

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

screen _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)
_printmode _keepbackground
print "Commands:"
print "  Rescale the map with -/+ keys"
print "  Regenerate the map with G key"
print "  Spawn a random entity on the current screen with the L key"
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

do
	_limit 60
	ui_input
	
	for i = 1 to 10
		player_specific_physics
		for j = 0 to gset.numberOfEntities
			entity_physics j
			if j <> 0 then
				if entity_is_colliding(entities(0), entities(j)) = 1 then
					entities(j).state = 0
					player_data.keys = player_data.keys + 1
				end if
			end if
		next j
	next i

	camera.x = int(entities(0).p.x / (32 * 20)) * 20
	camera.y = int(entities(0).p.y / (32 * 15)) * 15
	
	_source gdata.bg_tiles
	_dest gdata.bg_tiles
	cls , _rgba(0, 0, 0, 0)
	_source gdata.fg_tiles
	_dest gdata.fg_tiles
	cls , _rgba(0, 0, 0, 0)
	_source gdata.entity_layer
	_dest gdata.entity_layer
	cls , _rgba(0, 0, 0, 0)
	
	for i = 0 to gset.numberOfEntities
		draw_entity entities(i)
	next i
	
	_source 0
	_dest 0
	cls
	
	draw_map
	
	_putimage (0, 0), gdata.bg_tiles
	_putimage (0, 0), gdata.entity_layer
	_putimage (0, 0), gdata.fg_tiles
	
	locate 1,1
	print "Keys: "; player_data.keys
	
	_display
loop

sub ui_input
	a$ = inkey$
	select case a$
		case "g":
			generate_map
		case "p":
			if gset.isPlatformer = 0 then
				gset.isPlatformer = 1
			else
				gset.isPlatformer = 0
			end if
			pp = 60
		case "-":
			if gset.tile_size > 8 then gset.tile_size = gset.tile_size - 8: gset.scale_multiplier = gset.tile_size / 32
		case "=":
			if gset.tile_size < 128 then gset.tile_size = gset.tile_size + 8: gset.scale_multiplier = gset.tile_size / 32
		case "l":
			create_entity
		case ".":
			x = int(entities(0).actionPoint.x / 32)
			y = int(entities(0).actionPoint.y / 32)
			if isColWMap(entities(0).actionPoint.x, entities(0).actionPoint.y) = 1 then map(x ,y).tile_type = 0
		case "e":
			x = int(entities(0).actionPoint.x / 32)
			y = int(entities(0).actionPoint.y / 32)
			if map(x, y).tile_type = 2 then
				if player_data.keys > 0 then
					map(x ,y).tile_type = 3
					player_data.keys = player_data.keys - 1
				end if
			end if
	end select
end sub

'$include: 'map_grid.bm'
'$include: 'physics_subroutines.bm'
'$include: 'graphics_subroutines.bm'
'$include: 'entity_programming.bm'
