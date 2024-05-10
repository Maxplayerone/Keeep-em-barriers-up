package main

import rl "vendor:raylib"

import "core:fmt"
import "core:math"

Player :: struct{
	rect: rl.Rectangle,
    rotation: f32,
	speed: f32,
	forward: rl.Vector2,
	health: f32,

	class: Class,

	reload_time: f32,
	cur_time: f32,
	can_shoot: bool,
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

	player.cur_time += 1.0
	if player.cur_time >= player.reload_time{
		player.can_shoot = true
		//player.cur_time = 0.0 //setting up when player.can_shoot = false in main
	}

	return player
}

//we might Player later to figure out which type of bullet
//to add
player_add_bullet :: proc(can_shoot: bool) -> bool{
	if can_shoot && rl.IsMouseButtonPressed(.LEFT){
		return true
	}
	return false
}

player_draw_forward_vec :: proc(player: Player){
	rl.DrawLineEx(player_get_center(player), player_get_center(player) + vec_norm(player.forward) * 50.0, 6.0, rl.ORANGE)
}

player_draw :: proc(player: Player){
	rl.DrawRectangleRec(player.rect, rl.WHITE)
}

player_draw_reload_bar :: proc(player: Player){
	outer_rec := rl.Rectangle{20.0, 50.0, 140.0, 30.0}
	offset: f32 = 5.0
	fill_amount := player.cur_time / player.reload_time
	if fill_amount > 1.0{
		fill_amount = 1.0
	}
	rl.DrawRectangleRec(outer_rec, rl.GRAY)
	rl.DrawRectangleRec(rl.Rectangle{outer_rec.x + offset, outer_rec.y + offset, (outer_rec.width - 2 * offset) * fill_amount, outer_rec.height - 2 * offset}, rl.GREEN)
	rl.DrawText("Reload time", i32(outer_rec.x), i32(outer_rec.y - outer_rec.height), 25, rl.WHITE)
}
