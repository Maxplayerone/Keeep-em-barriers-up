package main

import rl "vendor:raylib"

BULLET_RADIUS :: 10.0
BULLET_SPEED :: 15.0
BULLET_COLOR :: rl.LIME

Bullet :: struct{
    pos: rl.Vector2,
    forward: rl.Vector2,
    radius: f32,
    color: rl.Color,
    speed: f32,
}

is_bullet_outside_screen :: proc(bullet: Bullet) -> bool{
	width := f32(WIDTH)
	height := f32(HEIGHT)
	return bullet.pos.x > width || bullet.pos.x < 0.0 || bullet.pos.y > height || bullet.pos.y < 0.0
}

is_bullet_colliding_with_enemy :: proc(b: Bullet, e: Enemy) -> bool{
    return b.pos.x > e.rect.x && b.pos.x < e.rect.x + e.rect.width && b.pos.y > e.rect.y && b.pos.y < e.rect.y + e.rect.height
}

bullet_update :: proc(bullet: Bullet) -> Bullet{
    bullet := bullet
    bullet.pos += bullet.forward * bullet.speed
    return bullet
}

bullet_render :: proc(bullet: Bullet){
    rl.DrawCircleV(bullet.pos, bullet.radius, bullet.color)
}

