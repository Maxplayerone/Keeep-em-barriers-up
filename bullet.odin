package main

import rl "vendor:raylib"

BULLET_RADIUS :: 10.0
BULLET_SPEED :: 15.0
BULLET_COLOR :: rl.LIME
BULLET_DAMAGE :: 20

Bullet :: struct{
    pos: rl.Vector2,
    forward: rl.Vector2,
    radius: f32,
    color: rl.Color,
    speed: f32,
    dmg: int,
    attack_enemy: bool,
}

is_bullet_outside_screen :: proc(bullet: Bullet) -> bool{
	width := f32(WIDTH)
	height := f32(HEIGHT)
	return bullet.pos.x > width || bullet.pos.x < 0.0 || bullet.pos.y > height || bullet.pos.y < 0.0
}

is_bullet_colliding_with_rect :: proc(b: Bullet, r: rl.Rectangle) -> bool{
    return b.pos.x > r.x && b.pos.x < r.x + r.width && b.pos.y > r.y && b.pos.y < r.y + r.height
}

bullet_update :: proc(bullet: Bullet) -> Bullet{
    bullet := bullet
    bullet.pos += bullet.forward * bullet.speed
    return bullet
}

bullet_render :: proc(bullet: Bullet){
    rl.DrawCircleV(bullet.pos, bullet.radius, bullet.color)
}

