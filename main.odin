package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH  :: 960
HEIGHT :: 720

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

	enemy := Enemy{
		rect = rl.Rectangle{200, HEIGHT / 2, 50, 50},
		color = rl.RED,
	}

	enemies: [dynamic]Enemy
	append(&enemies, enemy)

	for !rl.WindowShouldClose(){
		player = player_update(player)

		add_bullet := player_add_bullet()

		if add_bullet{
			bullet := Bullet{
				radius = BULLET_RADIUS,
				color = BULLET_COLOR,
				speed = BULLET_SPEED,
				pos = rl.Vector2{player.pos.x + player.size / 2, player.pos.y + player.size / 2},
				forward = vec_norm(player.forward),
			}
			append(&bullets, bullet)
		}


		//ENEMY-BULLET INTERACTION
		i := 0
		for i < len(bullets){
			removed_bullet := false
			for j in 0..<len(enemies){
				if is_bullet_colliding_with_enemy(bullets[i], enemies[j]){
					enemies[j].dead = true
					unordered_remove(&bullets, i)
					removed_bullet = true
				}
			}
			if !removed_bullet{
				i +=1 
			}
		}

		//BULLET UPDATING AND DELETING
		i = 0
		for i < len(bullets){
			if is_bullet_outside_screen(bullets[i]){
				unordered_remove(&bullets, i)
			}
			else{
				bullets[i] = bullet_update(bullets[i])
				i += 1
			}
		}

		//ENEMY UPDATING AND DELETING
		i = 0
		for i < len(enemies){
			if enemies[i].dead{
				unordered_remove(&enemies, i)
			}
			else{
				i += 1
			}
		}

		//rendering
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)

		for bullet in bullets{
			bullet_render(bullet)
		}

		player_render(player)

		for enemy in enemies{
			enemy_render(enemy)
		}
	}
}