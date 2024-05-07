package main

import rl "vendor:raylib"

import "core:fmt"
import "core:math"

Player :: struct{
	pos: rl.Vector2,
    rotation: f32,
	size: f32,
	speed: f32,
	forward: rl.Vector2
}

player_get_rect :: proc(player: Player) -> rl.Rectangle{
	return rl.Rectangle{player.pos.x, player.pos.y, player.size, player.size}
}

player_get_center :: proc(player: Player) -> rl.Vector2{
	return rl.Vector2{player.pos.x + player.size / 2, player.pos.y + player.size / 2}
}

player_update :: proc(player: Player) -> (Player, bool){
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

	player.rotation = math.atan2(rl.GetMousePosition().y - player_get_center(player).y, rl.GetMousePosition().x - player_get_center(player).x)
	player.forward = vec_rotate_rad({0.0, 1.0}, player.rotation - deg_to_rad(90.0))

	if rl.IsMouseButtonPressed(.LEFT){
		add_bullet = true
	}

	return player, add_bullet
}

player_draw_forward_vec :: proc(player: Player){
	rl.DrawLineEx(player_get_center(player), player_get_center(player) + vec_norm(player.forward) * 50.0, 6.0, rl.ORANGE)
}

player_render :: proc(player: Player){
	rl.DrawRectangleRec(player_get_rect(player), rl.WHITE)
}