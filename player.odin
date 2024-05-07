package main

import rl "vendor:raylib"

import "core:fmt"

Player :: struct{
	pos: rl.Vector2,
    rotation: f32,
	size: f32,
	speed: f32,
	forward: rl.Vector2
}

get_player_rect :: proc(player: Player) -> rl.Rectangle{
	return rl.Rectangle{player.pos.x, player.pos.y, player.size, player.size}
}

update_player :: proc(player: Player) -> (Player, bool){
	player := player
	add_bullet := false

	if rl.IsKeyDown(.W){
		player.pos.y -= player.speed
	}
	if rl.IsKeyDown(.S){
		player.pos.y += player.speed
	}
	if rl.IsKeyDown(.A){
		player.pos.x -= player.speed
	}
	if rl.IsKeyDown(.D){
		player.pos.x += player.speed
	}


	player.rotation = angle_btw_two_vecs_full_circle(rl.Vector2{0.0, 1.0}, mouse_pos_at_screen_center())
	player.forward = vec_rotate_rad({0.0, -1.0}, player.rotation + deg_to_rad(180.0))

	if rl.IsMouseButtonPressed(.LEFT){
		//bullet.pos = rl.Vector2{player.pos.x + player.size / 2, player.pos.y}
		//bullet.forward = vec_norm(player.forward)
		add_bullet = true
	}

	return player, add_bullet
}

render_player :: proc(player: Player){
	rl.DrawRectangleRec(get_player_rect(player), rl.WHITE)
}