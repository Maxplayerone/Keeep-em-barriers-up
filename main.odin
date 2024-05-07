package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH  :: 960
HEIGHT :: 720

is_bullet_outside_screen :: proc(bullet: Bullet) -> bool{
	width := f32(WIDTH)
	height := f32(HEIGHT)
	return bullet.pos.x > width || bullet.pos.x < 0.0 || bullet.pos.y > height || bullet.pos.y < 0.0
}

main :: proc(){
	rl.InitWindow(WIDTH, HEIGHT, "shooter")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)	

	player := Player{
		pos = rl.Vector2{WIDTH / 2, HEIGHT / 2},
		size = 50.0,
		speed = 8.0,
		forward = rl.Vector2{0.0, -1.0}
	}
	

	bullets: [dynamic]Bullet

	for !rl.WindowShouldClose(){

		add_bullet := false
		player, add_bullet = update_player(player)
		if add_bullet{
			bullet := Bullet{
				radius = BULLET_RADIUS,
				color = BULLET_COLOR,
				speed = BULLET_SPEED,
				pos = rl.Vector2{player.pos.x + player.size / 2, player.pos.y},
				forward = vec_norm(player.forward),
			}
			append(&bullets, bullet)
		}

		i := 0
		for i < len(bullets){
			if is_bullet_outside_screen(bullets[i]){
				unordered_remove(&bullets, i)
			}else{
				bullets[i] = bullet_update(bullets[i])
				i += 1
			}

		}


		//rendering
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)

		render_player(player)

		for bullet in bullets{
			bullet_render(bullet)
		}

		fmt.println("bullet size ", len(bullets))
	}
}