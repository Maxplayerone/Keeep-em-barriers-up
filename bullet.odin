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

bullet_update :: proc(bullet: Bullet) -> Bullet{
    bullet := bullet
    bullet.pos += bullet.forward * bullet.speed
    return bullet
}

bullet_render :: proc(bullet: Bullet){
    rl.DrawCircleV(bullet.pos, bullet.radius, bullet.color)
}

