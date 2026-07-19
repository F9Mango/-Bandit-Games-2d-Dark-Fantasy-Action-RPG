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

'gdata.bg_image = _loadimage("gfx/bg2.png", 32)'_newimage(gwindowx, gwindowy, 32)
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

dim shared map_backgrounds(255) as long
map_backgrounds(0) = _loadimage("gfx/bg.png", 32)
map_backgrounds(1) = _loadimage("gfx/bg2.png", 32)
map_backgrounds(2) = _loadimage("gfx/bg3.png", 32)

dim shared map_tileset_gfx(255) as long
map_tileset_gfx(0) = _loadimage("gfx/0.png", 32)
map_tileset_gfx(1) = _loadimage("gfx/stone_wall.png", 32)
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
map_tileset_gfx(16) = _loadimage("gfx/1_top.png", 32)
map_tileset_gfx(17) = _loadimage("gfx/brick.png", 32)
map_tileset_gfx(18) = _loadimage("gfx/brick_bg.png", 32)
map_tileset_gfx(19) = _loadimage("gfx/tree.png", 32)
map_tileset_gfx(20) = _loadimage("gfx/brick_bg_window.png", 32)
map_tileset_gfx(21) = _loadimage("gfx/ladder.png", 32)
map_tileset_gfx(22) = _loadimage("gfx/bridge.png", 32)
map_tileset_gfx(23) = _loadimage("gfx/dirt.png", 32)
map_tileset_gfx(24) = _loadimage("gfx/grass.png", 32)
map_tileset_gfx(25) = _loadimage("gfx/button.bmp", 32)
map_tileset_gfx(26) = _loadimage("gfx/button_pressed.bmp", 32)
map_tileset_gfx(27) = _loadimage("gfx/hut.png", 32)
map_tileset_gfx(28) = _loadimage("gfx/stone_wall_door.png", 32)
map_tileset_gfx(29) = _loadimage("gfx/stone.png", 32)
map_tileset_gfx(30) = _loadimage("gfx/wizard_seated.png", 32)
map_tileset_gfx(31) = _loadimage("gfx/shopfront.png", 32)
map_tileset_gfx(32) = _loadimage("gfx/lava.png", 32)
map_tileset_gfx(33) = _loadimage("gfx/startile.png", 32)

dim shared entity_sprites(255) as long
entity_sprites(0) = _loadimage("gfx/key.png", 32)
entity_sprites(1) = _loadimage("gfx/bat.png", 32)
entity_sprites(2) = _loadimage("gfx/food.png", 32)
entity_sprites(3) = _loadimage("gfx/sword.png", 32)
entity_sprites(4) = _loadimage("gfx/wizard.png", 32)
entity_sprites(5) = _loadimage("gfx/coin.png", 32)
for i = 0 to 3
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

map_tileset(12).is_image = 1
map_tileset(12).index_start = 16
map_tileset(12).index_end = 16
map_tileset(12).has_collision = 1
map_tileset(12).layer = 1

map_tileset(13).is_image = 1
map_tileset(13).index_start = 17
map_tileset(13).index_end = 17
map_tileset(13).has_collision = 1
map_tileset(13).layer = 1

map_tileset(14).is_image = 1
map_tileset(14).index_start = 18
map_tileset(14).index_end = 18
map_tileset(14).has_collision = 0
map_tileset(14).layer = 0

map_tileset(15).is_image = 1
map_tileset(15).index_start = 19
map_tileset(15).index_end = 19
map_tileset(15).has_collision = 0
map_tileset(15).layer = 0

map_tileset(16).is_image = 1
map_tileset(16).index_start = 20
map_tileset(16).index_end = 20
map_tileset(16).has_collision = 0
map_tileset(16).layer = 0

map_tileset(17).is_image = 1
map_tileset(17).index_start = 21
map_tileset(17).index_end = 21
map_tileset(17).has_collision = 0
map_tileset(17).layer = 0
map_tileset(17).class = 4

map_tileset(18).is_image = 1
map_tileset(18).index_start = 22
map_tileset(18).index_end = 22
map_tileset(18).has_collision = 0
map_tileset(18).layer = 0

map_tileset(19).is_image = 1
map_tileset(19).index_start = 23
map_tileset(19).index_end = 23
map_tileset(19).has_collision = 0
map_tileset(19).layer = 0

map_tileset(20).is_image = 1
map_tileset(20).index_start = 24
map_tileset(20).index_end = 24
map_tileset(20).has_collision = 0
map_tileset(20).layer = 0

map_tileset(21).is_image = 1
map_tileset(21).index_start = 25
map_tileset(21).index_end = 25
map_tileset(21).has_collision = 1
map_tileset(21).layer = 1

map_tileset(22).is_image = 1
map_tileset(22).index_start = 26
map_tileset(22).index_end = 26
map_tileset(22).has_collision = 1
map_tileset(22).layer = 1

map_tileset(23).is_image = 1
map_tileset(23).index_start = 27
map_tileset(23).index_end = 27
map_tileset(23).bg_index = 4
map_tileset(23).has_collision = 1
map_tileset(23).layer = 1

map_tileset(24).is_image = 1
map_tileset(24).index_start = 28
map_tileset(24).index_end = 28
map_tileset(24).class = 2
map_tileset(24).layer = 1

map_tileset(25).is_image = 1
map_tileset(25).index_start = 29
map_tileset(25).index_end = 29
map_tileset(25).has_collision = 1
map_tileset(25).layer = 1

map_tileset(26).is_image = 1
map_tileset(26).bg_index = 4
map_tileset(26).index_start = 3
map_tileset(26).index_end = 3
map_tileset(26).class = 2
map_tileset(26).layer = 1

map_tileset(27).is_image = 1
map_tileset(27).index_start = 30
map_tileset(27).index_end = 30
map_tileset(27).has_collision = 0
map_tileset(27).layer = 0

map_tileset(28).is_image = 1
map_tileset(28).index_start = 31
map_tileset(28).index_end = 31
map_tileset(28).has_collision = 1
map_tileset(28).layer = 1

map_tileset(29).is_image = 1
map_tileset(29).index_start = 32
map_tileset(29).index_end = 32
map_tileset(29).has_collision = 1
map_tileset(29).layer = 0

map_tileset(30).is_image = 1
map_tileset(30).index_start = 33
map_tileset(30).index_end = 33
map_tileset(30).has_collision = 0
map_tileset(30).layer = 0

map_tileset(126).is_image = 0
map_tileset(126).solid_color.r = 255
map_tileset(126).solid_color.g = 64
map_tileset(126).solid_color.b = 255
map_tileset(126).has_collision = 1
map_tileset(126).layer = 0

map_tileset(127).is_image = 0
map_tileset(127).solid_color.r = 255
map_tileset(127).solid_color.g = 64
map_tileset(127).solid_color.b = 255
map_tileset(127).has_collision = 0
map_tileset(127).layer = 0

map_tileset(128).is_image = 1
map_tileset(128).index_start = 5
map_tileset(128).index_end = 7
map_tileset(128).frame_threshold = 15
map_tileset(128).solid_color.r = 0
map_tileset(128).solid_color.g = 64
map_tileset(128).class = 2

dim shared map(0, 0) as map_tile
dim shared ebrush as map_tile
dim shared tile_map(21, 16) as screen_tile

gset.tile_size = 32
gset.scale_multiplier = gset.tile_size / 32
gset.numberOfEntities = 0

dim shared camera as xy
dim shared camera_buffer as xy
camera_buffer.x = -1
camera_buffer.y = -1
dim shared entities(128) as entity
dim shared e_sorting_buffer(128) as entity
dim shared blank_entity as entity
dim shared playerHoldingJump as _unsigned _byte
dim shared player_data as player_variables
player_data.maxHealth = 10
player_data.health = player_data.maxHealth
player_data.sword_level = 0

'player_data.dmg_cooldown = 10000

'player_data.keys = 10

dim shared inventory(255) as inventory_slot
add_to_inventory "key", 4, 0

dim shared chat_system as chat_system_vars
dim shared chats(65535) as conversation

entities(0).state = 1
entities(0).w = 16
entities(0).h = 16
entities(0).o.x = -8
entities(0).o.y = -16

entities(0).wm = 1
entities(0).hm = 1.5
entities(0).p.x = 50*32
entities(0).p.y = 83*32
entities(0).look.r = 255
entities(0).look.b = 255

gset.world_size.x = 200
gset.world_size.y = 150
redim map(gset.world_size.x, gset.world_size.y) as map_tile

load_map_old "map3.bmp"
load_chats 10, "chat.txt"
map(49, 97).tile_type = 24
map(49, 97).var_A = 2*32 + 16
map(49, 97).var_B = 118*32 + 16
map(49, 97).var_C = 1

map(0, 118).tile_type = 26
map(0, 118).var_A = 49*32 + 16
map(0, 118).var_B = 98*32 + 16
map(0, 118).var_C = 0

screen _newimage(gset.screen_resolution.x, gset.screen_resolution.y, 32)
_printmode _keepbackground
print "Commands:"
print "  Regenerate the map with G key"
print "  Switch between top-down and platformer control with P key"
print "  Delete tiles under the player's action point with the . key"
print "  Unlock door tiles under the player's action point with the E key"
print "  Attack with spacebar"
print "  Consume food from your inventory with the F key"
print "  Switch to editor mode with \ key"
print
print "  Top-down:"
print "		Move with WASD"
print
print "  Platform:"
print "     Move left and right with A & D"
print "     Jump with W"
print
print "  Editor Controls:"
print "     E - set tile id for the brush"
print "     R - set brush ABC variables"
print "     T - set event index for interaction"
print "     Y - set event index for a zone"
print "     U - enable entity spawning on the brush"
print "     I - set entity id"
print "     O - set quantity to spawn"
print "     , - load saved map file"
print "     . - save map file"
print "     ' - load chat-system file"
sleep
'_font 8


dim pgridx as integer
dim pgridy as integer

do
	_limit 60
	
	update_ui
	
	for i = 0 to 128
		animate_tileset i
	next i
	
	select case int(entities(0).p.y / 32)
	
		case 105 to 120:
			gdata.bg_image = 0
		case else:
			gdata.bg_image = 1
	end select
	if camera.x = 60 and camera.y = 0 then
		gdata.bg_image = 2
	end if
	
	select case gset.interaction_mode
		case 0: 'Gameplay.
		
			if player_data.dmg_cooldown <> 0 then player_data.dmg_cooldown = (player_data.dmg_cooldown - 1)
			if player_data.sword_cooldown <> 0 then player_data.sword_cooldown = (player_data.sword_cooldown - 1)
			if player_data.health <= 0 then gset.interaction_mode = 2
			
			if player_data.health > player_data.maxHealth then player_data.health = player_data.maxHealth
			
			ui_input
			
			for i = 1 to 10
				player_specific_physics
				
				for j = 0 to 128 'gset.numberOfEntities
					if entities(j).state <> 0 then
						entities(j).screenpos.x = int((entities(j).p.x / (32)) / 20) * 20
						entities(j).screenpos.y = int((entities(j).p.y / (32)) / 15) * 15
						
						if j <> 0 then
							
							if entities(j).screenpos.x = camera.x and entities(j).screenpos.y = camera.y then
							
							
								if entities(i).state = 1 then entity_ai j: entity_physics j
								
								
								if entity_is_colliding(entities(0), entities(j)) = 1 then
									select case entities(j).id
										case 0:
											destroy_entity j, 0
											add_to_inventory "key", 1, 0
										case 1:
											if player_data.dmg_cooldown = 0 then
												print #1, "Player has collided with a bat! decrementing health by 1 and setting i-frames..."
												player_data.health = player_data.health - 1
												player_data.dmg_cooldown = 25
												update_ui
											end if
										case 2:
											if player_data.dmg_cooldown = 0 then
												print #1, "Player has collided with a husk! decrementing health by 2 and setting i-frames..."
												player_data.health = player_data.health - 2
												player_data.dmg_cooldown = 25
												update_ui
											end if
										case 3:
											destroy_entity j, 0
											add_to_inventory "food", 1, 0
										case 7:
											destroy_entity j, 0
											add_to_inventory "coin", 1, 0
										case 4:
											player_data.sword_level = entities(j).var_A
											destroy_entity j, 0
										case 8:
											player_data.sword_level = entities(j).var_A
											destroy_entity j, 0
										case 9 to 10:
											if player_data.dmg_cooldown = 0 then
												player_data.health = player_data.health - 2
												player_data.dmg_cooldown = 25
												update_ui
											end if
										case 11:
											if player_data.dmg_cooldown = 0 then
												print #1, "Player has collided with a fireball! decrementing health by 1 and setting i-frames..."
												player_data.health = player_data.health - 1
												player_data.dmg_cooldown = 25
												update_ui
											end if
										case 12:
											destroy_entity j, 0
											add_to_inventory "Moon Pearl", 1, 0
										case 13:
											destroy_entity j, 0
											add_to_inventory "Sun Pearl", 1, 0
									end select
								end if
							else
								if entities(j).screenpos.x <> camera.x or entities(j).screenpos.y <> camera.y then
									'print #1, "   Entity "; j; " is outside the screen. "; entities(j).screenpos.x; entities(j).screenpos.y; " is outside of camera:"; camera.x; camera.y
									entities(j).p = entities(j).home
								end if
							end if
							
						else
							entity_physics j
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
			
			if camera.x <> camera_buffer.x or camera.y <> camera_buffer.y then
				'for i = 0 to 128
				'	if is_on_screen(entities(i)) = 0 then destroy_entity i, 1
				'next i
				for y = camera.y to camera.y + 15
					for x = camera.x to camera.x + 20
						if checkInBounds(x, y) = 1 then
						
							if map(x, y).spawn_entity = 1 then
								if map(x, y).entity_spawned = 0 then
								
									if map(x, y).entity_quantity <= 1 then
										create_entity map(x, y).entity_id, "grid", x + ((gset.tile_size / 32) / 2), y + ((gset.tile_size / 32) / 2), 1, 7
										if map(x, y).dont_repeat_spawning = 1 then map(x, y).entity_spawned = 1
									end if
									if map(x, y).entity_quantity > 1 then
										for i = 1 to map(x, y).entity_quantity
											create_entity map(x, y).entity_id, "grid", x + ((gset.tile_size / 32) / 2), y + ((gset.tile_size / 32) / 2), 1, 7
											if map(x, y).dont_repeat_spawning = 1 then map(x, y).entity_spawned = 1
										next i
									end if
								end if
								
							end if
							
						end if
					next x
				next y
			end if
			
			camera_buffer.x = camera.x
			camera_buffer.y = camera.y
			
			draw_screen_gameplay
			print gdata.show_hotpoints
			print player_data.sword_cooldown
			print entities(0).p.x, entities(0).p.y
			
		case 1: 'NPC chat menu
			draw_screen_gameplay
			draw_screen_chat
			chatsystem
		case 2: 'Defeat screen
			draw_screen_gameplay
			_source 0
			_dest 0
			line (0, 0)-(800, 600), _rgba(255, 0, 0, 127), bf
			_printstring (400 - 32, 300 - 8), "YOU DIED!"
			i$ = inkey$
			if i$ = chr$(27) then goto end_program
		case 50: 'editor mode
		
			ebrush.dont_repeat_spawning = 1
			
			for i = 0 to 100: a = _mouseinput: next i
			mx = int((_mousex) / gset.tile_size) + camera.x
			my = int((_mousey) / gset.tile_size) + camera.y
			
			_source 0
			_dest 0
			cls
			draw_screen_editor mx, my
			locate 34, 1
			'print mx, my
			'print camera.x, camera.y
			print "selected: (e)id="; ebrush.tile_type; "   (r)(A="; ebrush.var_A; " B="; ebrush.var_B; " C="; ebrush.var_C; ") (t)ei="; ebrush.event_index_interact; " (y)ez="; ebrush.event_index_zone
			print "          (u)se="; ebrush.spawn_entity; " (i)eid="; ebrush.entity_id; " (o)eq="; ebrush.entity_quantity; " (p)edrs="; ebrush.dont_repeat_spawning
			locate 36, 8
			
			i$ = inkey$
			select case lcase$(i$)
				case "\":
					gset.interaction_mode = 0
				case "'":
					input amount, file$
					load_chats amount, file$
				case ".":
					input file$
					save_map file$
				case ",":
					input file$
					load_map file$
				case "-":
					if ebrush.tile_type - 1 < 0 then ebrush.tile_type = 127 else ebrush.tile_type = ebrush.tile_type - 1
				case "=":
					ebrush.tile_type = ebrush.tile_type + 1
					if ebrush.tile_type > 127 then ebrush.tile_type = 0
				case "w":
					camera.y = camera.y - 15
				case "s":
					camera.y = camera.y + 15
				case "a":
					camera.x = camera.x - 20
				case "d":
					camera.x = camera.x + 20
				case "e":
					input ebrush.tile_type
				case "r":
					input ebrush.var_A, ebrush.var_B, ebrush.var_C
				case "t":
					input ebrush.event_index_interact
				case "y":
					input ebrush.event_index_zone
				case "u":
					select case ebrush.spawn_entity
						case 0:
							ebrush.spawn_entity = 1
						case 1:
							ebrush.spawn_entity = 0
					end select
				case "i":
					input ebrush.entity_id
				case "o":
					input ebrush.entity_quantity
				case "p":
					input ebrush.dont_repeat_spawning
			end select
			
			if _mousebutton(1) then
				if checkInBounds(mx, my) = 1 then
					map(mx, my) = ebrush
				end if
			end if
			
			if _mousebutton(2) then
				entities(0).p.x = _mousex + camera.x*32
				entities(0).p.y = _mousey + camera.y*32
			end if
	end select
	
	'l = entity_test_zone(entities(0), 300, 300, 600, 600)
	'print entities(0).p.x, entities(0).p.y, l
	
	_display
loop

end_program:
close #1
system

sub player_sword_attack
	if player_data.sword_level > 0 and player_data.sword_cooldown = 0 then
		damage = 2 ^ player_data.sword_level
		player_data.sword_cooldown = 25
		for i = 0 to 128
			if entities(i).state = 1 then
				select case entities(i).id
					case 1 to 2:
						if entity_test_zone(entities(i), player_data.meleeboxtl.x, player_data.meleeboxtl.y, player_data.meleeboxbr.x, player_data.meleeboxbr.y) = 1 then
							print #1, "sword struck enemy"; i; "!"
							if entities(i).var_H > 0 then
								entities(i).var_H = entities(i).var_H - damage
								entities(i).knock_v.x = entities(i).knock_v.x + entities(0).direction.x * 10 + rnd
								entities(i).knock_v.y = entities(i).knock_v.y + entities(0).direction.y * 10 + rnd
							end if
							if entities(i).var_H <= 0 then destroy_entity i, 0
						end if
					case 9 to 10:
						if entity_test_zone(entities(i), player_data.meleeboxtl.x, player_data.meleeboxtl.y, player_data.meleeboxbr.x, player_data.meleeboxbr.y) = 1 then
							print #1, "sword struck enemy"; i; "!"
							if entities(i).var_H > 0 then
								entities(i).var_H = entities(i).var_H - damage
								entities(i).knock_v.x = entities(i).knock_v.x + entities(0).direction.x * 10 + rnd
								entities(i).knock_v.y = entities(i).knock_v.y + entities(0).direction.y * 10 + rnd
							end if
							if entities(i).var_H <= 0 then destroy_entity i, 0
						end if
				end select
			end if
		next i
	end if
end sub

sub ui_input
	a$ = inkey$
	
	select case a$
		case chr$(27):
			close #1
			system
		
		case chr$(32):
			print #1, "sword attack!"
			player_sword_attack
		case "]":
			print #1, "Printing entity table (camera values:"; camera.x; "x"; camera.y; ")"
			for i = 0 to 128
				if entities(i).state = 1 then print #1, "   Entity"; str$(i); " with id"; str$(entities(i).id); " at XY"; str$(entities(i).p.x); " x"; str$(entities(i).p.y); " screenXY:"; entities(i).screenpos.x; "x"; entities(i).screenpos.y
			next i
		case "p":
			if gset.isPlatformer = 0 then
				gset.isPlatformer = 1
			else
				gset.isPlatformer = 0
			end if
			pp = 60
			
		case ".":
			x = int(entities(0).actionPoint.x / 32)
			y = int(entities(0).actionPoint.y / 32)
			if isColWMap(entities(0).actionPoint.x, entities(0).actionPoint.y) = 1 then map(x ,y).tile_type = 0
			
			
		case "e":
			x = int(entities(0).actionPoint.x / 32)
			y = int(entities(0).actionPoint.y / 32)
			
			for i = 1 to 128
				if entity_test_zone(entities(i), player_data.meleeboxtl.x, player_data.meleeboxtl.y, player_data.meleeboxbr.x, player_data.meleeboxbr.y) = 1 then
					if entities(i).can_chat = 1 then
						chat_system.active_chat = entities(i).chat
						gset.interaction_mode = 1
					end if
				end if
			next i
			
			if checkInBounds(x, y) = 1 then
				doEvent map(x, y).event_index_interact
				select case map_tileset(map(x, y).tile_type).class
				
					case 1:
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
							clear_empties 'clear empty inventory cells
						end if
						
					case 3: 'event trigger
						doEvent map(x, y).var_A
						
				end select
			end if
			
		case "f":
			if check_inventory("food") > 0 then
				player_data.health = player_data.health + 2
				remove_from_inventory "food", 1
			end if
		
		case "h":
			if gdata.show_hotpoints = 0 then
				gdata.show_hotpoints = 1
			else
				gdata.show_hotpoints = 0
			end if
		case "c":
			gset.interaction_mode = 1
		case "\":
			gset.interaction_mode = 50
	end select
end sub

sub doEvent(event as integer)
	select case event
		case 1:
			
		case 2:
			
		case 10:
			player_data.sword_level = 1: update_ui
			map(93, 110).event_index_interact = 12
		case 11:
			chat_system.active_chat = 4
			gset.interaction_mode = 1
		case 12:
			chat_system.active_chat = 6
			gset.interaction_mode = 1
		case 15:
			chat_system.active_chat = 7
			gset.interaction_mode = 1
		case 20:
			if check_inventory("coin") >= 1 then
				remove_from_inventory "coin", 1
				add_to_inventory "food", 1, 0
			else
				chat_system.active_chat = 8
				gset.interaction_mode = 1
			end if
		case 25:
			if check_inventory("coin") >= 2 then
				remove_from_inventory "coin", 2
				add_to_inventory "arrow", 5, 0
			else
				chat_system.active_chat = 8
				gset.interaction_mode = 1
			end if
		case 30:
			if check_inventory("coin") >= 10 then
				remove_from_inventory "coin", 10
				player_data.maxHealth = player_data.maxHealth + 2
				player_data.health = player_data.maxHealth
			else
				chat_system.active_chat = 8
				gset.interaction_mode = 1
			end if
		case 1111:
			for y = 51 to 53
				map(50, y).tile_type = 11
				map(52, 48).tile_type = 22
				map(52, 48).event_index_interact = 0
			next y
		case 5113:
			gset.interaction_mode = 0
		case else:
			
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
'$include: 'chatsystem.bm'
