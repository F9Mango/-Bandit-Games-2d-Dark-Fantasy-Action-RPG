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
	p as xy
	tl as xy
	tr as xy
	bl as xy
	br as xy
	v as xy
end type
dim shared map(128,128) as _unsigned integer
dim shared tile_map(21, 16) as screen_tile

dim shared tile_size as long: tile_size = 32
const player_width = 1
const player_height = 1
dim shared scale_multiplier as double
scale_multiplier = tile_size / 32

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

dim player as entity
dim camera as xy

dim isPlatformer as _unsigned _byte

player.p.x = 4
player.p.y = 4

screen _newimage(1920, 1080, 32)
_font 8

do
	_limit 60
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
			if isPlatformer = 0 then
				isPlatformer = 1
			else
				isPlatformer = 0
			end if
			pp = 60
		case "-":
			if tile_size > 8 then tile_size = tile_size - 8: scale_multiplier = tile_size / 32
		case "=":
			if tile_size < 128 then tile_size = tile_size + 8: scale_multiplier = tile_size / 32
	end select
	
	for i = 1 to 10
		if isPlatformer = 0 then
			if _keydown(asc("w")) then player.v.y = player.v.y - 0.02
			if _keydown(asc("s")) then player.v.y = player.v.y + 0.02
			if _keydown(asc("a")) then player.v.x = player.v.x - 0.02
			if _keydown(asc("d")) then player.v.x = player.v.x + 0.02
			player.v.x = player.v.x * 0.9
			player.v.y = player.v.y * 0.9
		else
			if playerCanJump = 1 then
				if _keydown(asc("a")) then player.v.x = player.v.x - 0.02
				if _keydown(asc("d")) then player.v.x = player.v.x + 0.02
			else
				if _keydown(asc("a")) then player.v.x = player.v.x - 0.0005
				if _keydown(asc("d")) then player.v.x = player.v.x + 0.0005
			end if
			if _keydown(asc("w")) then
				if playerHoldingJump = 1 then
					player.v.y = player.v.y - 0.0035
				end if
				if playerCanJump = 1 and playerHoldingJump = 0 then
					player.v.y = player.v.y - 0.5
					playerCanJump = 0
					playerHoldingJump = 1
				end if
			else
				playerHoldingJump = 0
			end if
			if playerCanJump = 0 then player.v.y = player.v.y + 0.005
		end if
		if player.v.x > 0.9 then player.v.x = 0.9
		if player.v.y > 0.9 then player.v.y = 0.9
		if player.v.x < -0.9 then player.v.x = -0.9
		if player.v.y < -0.9 then player.v.y = -0.9
		
		'Initializing the values for the player's corner collisions.
		'Top left xy
		player.tl.x = player.p.x - (8 * player_width)
		player.tl.y = player.p.y - (16 * player_height)
		'Top right xy
		player.tr.x = player.p.x + (8 * player_width)
		player.tr.y = player.p.y - (16 * player_height)
		'Bottom left xy
		player.bl.x = player.p.x - (8 * player_width)
		player.bl.y = player.p.y
		'Bottom right xy
		player.br.x = player.p.x + (8 * player_width)
		player.br.y = player.p.y
		
		'Add velocity values to corner collisions and check.
		if isColWMap(player.tl.x + player.v.x, player.tl.y) = 1 then
			player.v.x = 0.001
		end if
		
		
		if isColWMap(player.tl.x, player.tl.y + player.v.y) = 1 then
			player.v.y = 0.001
		end if
		
		
		if isColWMap(player.tr.x + player.v.x, player.tr.y) = 1 then
			player.v.x = -0.001
		end if
		
		
		if isColWMap(player.tr.x, player.tr.y + player.v.y) = 1 then
			player.v.y = 0.001
		end if
		
		
		if isColWMap(player.bl.x + player.v.x, player.bl.y) = 1 then
			player.v.x = 0.001
		end if
		
		
		if isColWMap(player.bl.x, player.bl.y + player.v.y) = 1 then
			player.v.y = -0.001
		end if
		
		
		if isColWMap(player.br.x + player.v.x, player.br.y) = 1 then
			player.v.x = -0.001
		end if
		
		
		if isColWMap(player.br.x, player.br.y + player.v.y) = 1 then
			player.v.y = -0.001
		end if
		
		
		if isPlatformer = 1 then
			if isColWMap(player.p.x, player.p.y + 1) = 1 or isColWMap(player.p.x - 8, player.p.y + 1) = 1 or isColWMap(player.p.x + 8, player.p.y + 1) = 1 then
				player.v.x = player.v.x * 0.9
				playerCanJump = 1
			else
				playerCanJump = 0
			end if
		end if
		
		
		player.p.x = player.p.x + player.v.x' * scale_multiplier)
		player.p.y = player.p.y + player.v.y' * scale_multiplier)
		
	next i

	camera.x = int(player.p.x / (32 * 20)) * 20
	camera.y = int(player.p.y / (32 * 15)) * 15
	
	
	cls
	for y = 0 to 14
		for x = 0 to 19
			
			newx = camera.x + x
			newy = camera.y + y
			
			'Check if the x and y values are within the array boundaries.
			if newx >= 0 and newx <= 128 then
				if newy >= 0 and newy <= 128 then
					tile_map(x, y).tile_start.x = x * tile_size
					tile_map(x, y).tile_start.y = y * tile_size
					tile_map(x, y).tile_end.x = x * tile_size + tile_size
					tile_map(x, y).tile_end.y = y * tile_size + tile_size
					tile_map(x, y).tile_index = map(newx, newy)
					
					drawx1 = tile_map(x, y).tile_start.x
					drawy1 = tile_map(x, y).tile_start.y
					drawx2 = tile_map(x, y).tile_end.x
					drawy2 = tile_map(x, y).tile_end.y
					'if x = 21 then drawx2 = drawx2 - (tile_size / 2)
					'if y = 16 then drawy2 = drawy2 - (tile_size / 2)
					
					select case tile_map(x, y).tile_index
						case 0:
							line (drawx1, drawy1)-(drawx2, drawy2), _rgb(0, 64, 0), BF
						case 1:
							line (drawx1, drawy1)-(drawx2, drawy2), _rgb(128, 128, 0), BF
						
					
					'select case map(camera.x + x, camera.y + y)
					'	case 0:
					'		line (x * 32, y * 32)-(x * 32 + 32, y * 32 + 32), _rgb(0, 64, 0), BF
					'	case 1:
					'		line (x * 32, y * 32)-(x * 32 + 32, y * 32 + 32), _rgb(128, 128, 0), BF
					'	
					end select
					
					line (drawx1, drawy1)-(drawx2, drawy2), _rgb(0, 0, 0), B
				end if
			end if
			
			
		next x
	next y
	'Draw Player
	tileSizeX = tile_map(0, 0).tile_end.x - tile_map(0, 0).tile_start.x
	tileSizeY = tile_map(0, 0).tile_end.y - tile_map(0, 0).tile_start.y
	px = (player.p.x * scale_multiplier) - ((camera.x * (32)) * scale_multiplier)
	py = (player.p.y * scale_multiplier) - ((camera.y * (32)) * scale_multiplier)
	p1x = px - (8 * player_width * scale_multiplier)
	p1y = py - (16 * player_height * scale_multiplier)
	p2x = px + (8 * player_width * scale_multiplier)
	p2y = py
	line (p1x, p1y)-(p2x, p2y), _rgb(255, 0, 255), BF
	pset (px, py), _rgb(255, 255, 255)
	
	'Display useful information.
	locate 1, 1
	print scale_multiplier
	print player.p.x, player.p.y
	print player.v.x, player.v.y
	print camera.x, camera.y
	print playerCanJump, playerHoldingJump
	
	_display
loop

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
