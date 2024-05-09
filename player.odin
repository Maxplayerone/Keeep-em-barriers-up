package main

import rl "vendor:raylib"

import "core:fmt"
import "core:math"

Player :: struct{
	rect: rl.Rectangle,
    rotation: f32,
	speed: f32,
	forward: rl.Vector2,
	health: int,
}

player_get_pos :: proc(player: Player) -> rl.Vector2{
	return rl.Vector2{player.rect.x, player.rect.y}
}

player_get_center :: proc(player: Player) -> rl.Vector2{
	return rl.Vector2{player.rect.x + player.rect.width / 2, player.rect.y + player.rect.height / 2}
}

player_update :: proc(player: Player) -> Player{
	player := player

	if rl.IsKeyDown(.W){
		player.rect.y -= player.speed
	}
	if rl.IsKeyDown(.S){
		player.rect.y += player.speed
	}
	if rl.IsKeyDown(.A){
		player.rect.x -= player.speed
	}
	if rl.IsKeyDown(.D){
		player.rect.x += player.speed
	}

	player.rotation = math.atan2(rl.GetMousePosition().y - player_get_center(player).y, rl.GetMousePosition().x - player_get_center(player).x)
	player.forward = vec_rotate_rad({0.0, 1.0}, player.rotation - deg_to_rad(90.0))

	return player
}

//we might Player later to figure out which type of bullet
//to add
player_add_bullet :: proc() -> bool{
	if rl.IsMouseButtonPressed(.LEFT){
		return true
	}
	return false
}

player_draw_forward_vec :: proc(player: Player){
	rl.DrawLineEx(player_get_center(player), player_get_center(player) + vec_norm(player.forward) * 50.0, 6.0, rl.ORANGE)
}

player_render :: proc(player: Player){
	rl.DrawRectangleRec(player.rect, rl.WHITE)
}