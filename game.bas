type settings
	isPlatformer as _unsigned _byte
	tile_size as long
	scale_multiplier as double
	numberOfEntities as long
end type
type xy
	x as double
	y as double
end type
type xy_int
	x as _unsigned long
	y as _unsigned long
end type
type screen_tile
	tile_start as xy_int
	tile_end as xy_int
	tile_index as _unsigned integer
end type
type entity
	'Position and velocity
	p as xy
	v as xy
	'Four corners' coordinates
	tl as xy
	tr as xy
	bl as xy
	br as xy
	'Width and height multipliers
	w as double
	h as double
	'Controls and multiplies the entity's interaction with gravity.
	gravity as double
	'Determines if the entity is on the ground.
	onGround as _unsigned _byte
end type
dim shared gset as settings
dim shared map(128,128) as _unsigned integer
dim shared tile_map(21, 16) as screen_tile

gset.tile_size = 32
gset.scale_multiplier = gset.tile_size / 32
gset.numberOfEntities = 0

for y = 0 to 128
	for x = 0 to 128
		randomize (timer + x + y)
		select case int(rnd * 10)
			case 0:
				map(x, y) = 1
			case else:
				map(x, y) = 0
		end select
	next x
next y


dim shared camera as xy
dim shared entities(gset.numberOfEntities) as entity
dim shared playerHoldingJump as _unsigned _byte

entities(0).w = 1
entities(0).h = 1
entities(0).p.x = 32
entities(0).p.y = 32

screen _newimage(800, 600, 32)
print "Commands:"
print "  Rescale the map with -/+ keys"
print "  Regenerate the map with G key"
print "  Switch between top-down and platformer control with P key"
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
		next j
	next i

	camera.x = int(entities(0).p.x / (32 * 20)) * 20
	camera.y = int(entities(0).p.y / (32 * 15)) * 15
	cls
	draw_map
	draw_entity entities(0)
	_display
loop

sub ui_input
	a$ = inkey$
	select case a$
		case "g":
			for y = 0 to 128
				for x = 0 to 128
					randomize (timer + x + y)
					select case int(rnd * 10)
						case 0:
							map(x, y) = 1
						case else:
							map(x, y) = 0
					end select
				next x
			next y
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
	end select
end sub

sub entity_physics (j as _unsigned long)
	if j >< 0 then
		if gset.isPlatformer = 0 then
		entities(j).v.x = entities(j).v.x * 0.9
		entities(j).v.y = entities(j).v.y * 0.9
		else
			if entities(j).onGround = 0 then 
				entities(j).v.y = entities(j).v.y + 0.005
			end if
		end if
	end if
	
	if entities(j).v.x > 0.5 then entities(j).v.x = 0.5
	if entities(j).v.y > 0.5 then entities(j).v.y = 0.5
	if entities(j).v.x < -0.5 then entities(j).v.x = -0.5
	if entities(j).v.y < -0.5 then entities(j).v.y = -0.5
	
	'Initializing the values for the player's corner collisions.
	'Top left xy
	entities(j).tl.x = entities(j).p.x - (8 * entities(j).w)
	entities(j).tl.y = entities(j).p.y - (16 * entities(j).h)
	'Top right xy
	entities(j).tr.x = entities(j).p.x + (8 * entities(j).w)
	entities(j).tr.y = entities(j).p.y - (16 * entities(j).h)
	'Bottom left xy
	entities(j).bl.x = entities(j).p.x - (8 * entities(j).w)
	entities(j).bl.y = entities(j).p.y
	'Bottom right xy
	entities(j).br.x = entities(j).p.x + (8 * entities(j).w)
	entities(j).br.y = entities(j).p.y
	
	'Add velocity values to corner collisions and check.
	if isColWMap(entities(j).tl.x + entities(j).v.x, entities(j).tl.y) = 1 then
		entities(j).v.x = 0.001
	end if
	
	if isColWMap(entities(j).tl.x, entities(j).tl.y + entities(j).v.y) = 1 then
		entities(j).v.y = 0.001
	end if
	
	if isColWMap(entities(j).tr.x + entities(j).v.x, entities(j).tr.y) = 1 then
		entities(j).v.x = -0.001
	end if
	
	if isColWMap(entities(j).tr.x, entities(j).tr.y + entities(j).v.y) = 1 then
		entities(j).v.y = 0.001
	end if
	
	if isColWMap(entities(j).bl.x + entities(j).v.x, entities(j).bl.y) = 1 then
		entities(j).v.x = 0.001
	end if
	
	if isColWMap(entities(j).bl.x, entities(j).bl.y + entities(j).v.y) = 1 then
		entities(j).v.y = -0.001
	end if
	
	if isColWMap(entities(j).br.x + entities(j).v.x, entities(j).br.y) = 1 then
		entities(j).v.x = -0.001
	end if
	
	if isColWMap(entities(j).br.x, entities(j).br.y + entities(j).v.y) = 1 then
		entities(j).v.y = -0.001
	end if
	
	if gset.isPlatformer = 1 then
		if isColWMap(entities(j).p.x, entities(j).p.y + 1) = 1 then
			entities(j).v.x = entities(j).v.x * 0.9
			entities(j).onGround = 1
		elseif isColWMap(entities(j).p.x - 8, entities(j).p.y + 1) = 1 then
			entities(j).v.x = entities(j).v.x * 0.9
			entities(j).onGround = 1
		elseif isColWMap(entities(j).p.x + 8, entities(j).p.y + 1) = 1 then
			entities(j).v.x = entities(j).v.x * 0.9
			entities(j).onGround = 1
		else
			entities(j).onGround = 0
		end if
	end if
	
	entities(j).p.x = entities(j).p.x + entities(j).v.x
	entities(j).p.y = entities(j).p.y + entities(j).v.y
end sub

sub player_specific_physics
	if gset.isPlatformer = 0 then
		if _keydown(asc("w")) then entities(0).v.y = entities(0).v.y - 0.02
		if _keydown(asc("s")) then entities(0).v.y = entities(0).v.y + 0.02
		if _keydown(asc("a")) then entities(0).v.x = entities(0).v.x - 0.02
		if _keydown(asc("d")) then entities(0).v.x = entities(0).v.x + 0.02
		entities(0).v.x = entities(0).v.x * 0.9
		entities(0).v.y = entities(0).v.y * 0.9
	else
		if entities(0).onGround = 1 then
			if _keydown(asc("a")) then entities(0).v.x = entities(0).v.x - 0.02
			if _keydown(asc("d")) then entities(0).v.x = entities(0).v.x + 0.02
		else
			if _keydown(asc("a")) then entities(0).v.x = entities(0).v.x - 0.0005
			if _keydown(asc("d")) then entities(0).v.x = entities(0).v.x + 0.0005
		end if
		if _keydown(asc("w")) then
			if playerHoldingJump = 1 then
				entities(0).v.y = entities(0).v.y - 0.0035
			end if
			if entities(0).onGround = 1 and playerHoldingJump = 0 then
				entities(0).v.y = entities(0).v.y - 0.5
				entities(0).onGround = 0
				playerHoldingJump = 1
			end if
		else
			playerHoldingJump = 0
		end if
		if entities(0).onGround = 0 then entities(0).v.y = entities(0).v.y + 0.005
	end if
end sub

sub draw_map
	for y = 0 to 14
		for x = 0 to 19
			
			newx = camera.x + x
			newy = camera.y + y
			
			'Check if the x and y values are within the array boundaries.
			if newx >= 0 and newx <= 128 then
				if newy >= 0 and newy <= 128 then
					tile_map(x, y).tile_start.x = x * gset.tile_size
					tile_map(x, y).tile_start.y = y * gset.tile_size
					tile_map(x, y).tile_end.x = x * gset.tile_size + gset.tile_size
					tile_map(x, y).tile_end.y = y * gset.tile_size + gset.tile_size
					tile_map(x, y).tile_index = map(newx, newy)
					
					draw_tile tile_map(x, y)
				end if
			end if
			
		next x
	next y
end sub

sub draw_tile (t as screen_tile)
	drawx1 = t.tile_start.x
	drawy1 = t.tile_start.y
	drawx2 = t.tile_end.x
	drawy2 = t.tile_end.y
	select case t.tile_index
		case 0:
			line (drawx1, drawy1)-(drawx2, drawy2), _rgb(0, 64, 0), BF
		case 1:
			line (drawx1, drawy1)-(drawx2, drawy2), _rgb(128, 128, 0), BF
	end select
	line (drawx1, drawy1)-(drawx2, drawy2), _rgb(0, 0, 0), B
	if isColWMap(entities(0).p.x, entities(0).p.y) = 1 then line (drawx1 + 4, drawy1 + 4)-(drawx2 - 4, drawy2 - 4), _rgb(0, 0, 255), B
end sub

sub draw_entity (e as entity)
	tileSizeX = tile_map(0, 0).tile_end.x - tile_map(0, 0).tile_start.x
	tileSizeY = tile_map(0, 0).tile_end.y - tile_map(0, 0).tile_start.y
	ex = (e.p.x * gset.scale_multiplier) - ((camera.x * (32)) * gset.scale_multiplier)
	ey = (e.p.y * gset.scale_multiplier) - ((camera.y * (32)) * gset.scale_multiplier)
	e1x = ex - (8 * e.w * gset.scale_multiplier)
	e1y = ey - (16 * e.h * gset.scale_multiplier)
	e2x = ex + (8 * e.w * gset.scale_multiplier)
	e2y = ey
	line (e1x, e1y)-(e2x, e2y), _rgb(255, 0, 255), BF
	pset (ex, ey), _rgb(255, 255, 255)
end sub

function localToGrid(a as double)
	localToGrid = int(a / 32)
end function

function isColWMap(x1 as double, y1 as double)
	'Scale and truncate entity-coordinates to match the tile grid.
	x = int(x1 / 32)
	y = int(y1 / 32)
	
	'Initialize the inBounds variable, which determines whether or not the coordinates are within the world boundary.
	inBounds = 0
	
	'Check if coordinates are within world boundary.
	if x >= 0 and x <= 128 then
		if y >= 0 and y <= 128 then
			'Affirm that we are inside the boundary.
			inBounds = 1
		end if
	end if
	
	
	if inBounds = 1 then
		'If we're inside the boundary, compare against the world map grid.
		if map(x, y) <> 0 then
			isColWMap = 1
		else
			isColWMap = 0
		end if
	else
		isColWMap = 0
	end if
end function
