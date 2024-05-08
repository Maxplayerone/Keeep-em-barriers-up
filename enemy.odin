package main

import rl "vendor:raylib"

Enemy :: struct{
    rect: rl.Rectangle,
    color: rl.Color,

    health: int,
    max_health: int,
    dead: bool,

    forward: rl.Vector2,
    speed: f32,
    to_player_radius: f32, //how close can enemy be to player
}

enemy_pos :: proc(e: Enemy) -> rl.Vector2{
    return rl.Vector2{e.rect.x, e.rect.y}
}

enemy_center :: proc(e: Enemy) -> rl.Vector2{
    return rl.Vector2{e.rect.x + e.rect.width / 2, e.rect.y + e.rect.height / 2}
}

enemy_update :: proc(e: Enemy, player_pos: rl.Vector2) -> Enemy{
    e := e
    player_enemy_dist := player_pos - enemy_pos(e)
    e.forward = vec_norm(player_enemy_dist)

    if vec_len(player_enemy_dist) > e.to_player_radius{
        pos := enemy_pos(e) + e.forward * e.speed
        e.rect.x = pos.x
        e.rect.y = pos.y
    }
    return e
}

enemy_render :: proc(e: Enemy){
    rl.DrawRectangleRec(e.rect, e.color)
    rl.DrawLineEx(enemy_center(e), enemy_center(e) + e.forward * 50.0, 7.0, rl.ORANGE)
}

enemy_render_healthbar :: proc(e: Enemy){
    offset: f32 = 18.0
    h: f32 = e.rect.height - 2 * offset
    w: f32 = e.rect.width
    outer_rect := rl.Rectangle{e.rect.x, e.rect.y - h - offset, w, h}
    rl.DrawRectangleRec(outer_rect, rl.Color{122, 122, 122, 255})

    offset = 2.0
    inner_rect := rl.Rectangle{outer_rect.x + offset, outer_rect.y + offset, outer_rect.width - 2 * offset, outer_rect.height - 2 * offset}
    inner_rect.width = inner_rect.width * (f32(e.health) / f32(e.max_health))
    rl.DrawRectangleRec(inner_rect, rl.Color{153, 255, 98, 255})
}