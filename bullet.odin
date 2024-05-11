package main

import rl "vendor:raylib"

BULLET_RADIUS :: 10.0
BULLET_SPEED :: 15.0
BULLET_COLOR :: rl.LIME
BULLET_DAMAGE :: 20

Class :: enum{
    Normal,
    Shotgun,
    FireWizard,
}

Bullet :: struct{
    pos: rl.Vector2,
    forward: rl.Vector2,

    /* can be changed by bulletType */
    color: rl.Color,
    radius: f32,
    speed: f32,
    dmg: f32,

    attack_enemy: bool,

    //specific to shotgun class
    is_shotgun: bool,
    dmg_decrement: f32,
}

create_bullet :: proc(type: Class) -> Bullet{
    bullet := Bullet{}
    switch type{
        case .Normal: bullet = create_bullet_normal()
        case .Shotgun: bullet = create_bullet_shotgun()
        case .FireWizard: bullet = create_bullet_fire_wizard()
    }
    return bullet
}

get_reload_time_for_class :: proc(type: Class) -> f32{
    reload_time: f32
    switch type{
        case .Normal: reload_time = 30.0
        case .Shotgun: reload_time = 60.0
        case .FireWizard: reload_time = 90.0
    }
    return reload_time
}

create_bullet_normal :: proc() -> Bullet{
    return Bullet{
        color = rl.Color{200, 200, 200, 255},
        radius = 10.0,
        speed = 12.0,
        dmg = 20.0,
    }
}

create_bullet_shotgun :: proc() -> Bullet{
    return Bullet{
        color = rl.Color{232, 152, 52, 255},
        radius = 7.0,
        speed = 15.0,
        dmg = 40.0,
        is_shotgun = true,
        dmg_decrement = 0.9,
    }
}

create_bullet_fire_wizard :: proc() -> Bullet{
    return Bullet{
        color = rl.Color{200, 200, 200, 255},
        radius = 10.0,
        speed = 12.0,
        dmg = 20.0,
    }
}

is_bullet_outside_screen :: proc(bullet: Bullet, camera: rl.Camera2D) -> bool{
    //(NOTE): this is still incorrect, should fix this 
	width := f32(WIDTH)/ camera.zoom
	height := f32(HEIGHT) / camera.zoom
	return bullet.pos.x > width || bullet.pos.x < 0.0 || bullet.pos.y > height || bullet.pos.y < 0.0
}

is_bullet_colliding_with_rect :: proc(b: Bullet, r: rl.Rectangle) -> bool{
    return b.pos.x > r.x && b.pos.x < r.x + r.width && b.pos.y > r.y && b.pos.y < r.y + r.height
}

bullet_update :: proc(bullet: Bullet) -> Bullet{
    bullet := bullet
    bullet.pos += bullet.forward * bullet.speed

    if bullet.is_shotgun{
        bullet.dmg *= bullet.dmg_decrement
    }
    return bullet
}

bullet_render :: proc(bullet: Bullet){
    rl.DrawCircleV(bullet.pos, bullet.radius, bullet.color)
}

