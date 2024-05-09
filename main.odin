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
		rect = rl.Rectangle{WIDTH / 2, HEIGHT / 2, 50.0, 50.0},
		speed = 8.0,
		forward = rl.Vector2{0.0, -1.0},
		health = 100,
	}

	bullets: [dynamic]Bullet

	enemy := Enemy{
		rect = rl.Rectangle{200, HEIGHT / 2, 50, 50},
		color = rl.RED,
		health = 100,
		max_health = 100,
		speed = 5.0,
		to_player_radius = 200.0,
		time_btw_shots = 45.0,
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
				pos = player_get_center(player),
				forward = vec_norm(player.forward),
				dmg = BULLET_DAMAGE, 
				attack_enemy = true
			}
			append(&bullets, bullet)
		}


		//ENEMY-BULLET-PLAYER INTERACTION
		i := 0
		for i < len(bullets){
			removed_bullet := false
			for j in 0..<len(enemies){
				if bullets[i].attack_enemy && is_bullet_colliding_with_rect(bullets[i], enemies[j].rect){
					enemies[j].health -= bullets[i].dmg
					if enemies[j].health <= 0{
						enemies[j].dead = true
					}

					unordered_remove(&bullets, i)
					removed_bullet = true
				}
			}

			if !bullets[i].attack_enemy && is_bullet_colliding_with_rect(bullets[i], player.rect){
				player.health -= bullets[i].dmg

				removed_bullet = true
				unordered_remove(&bullets, i)
			}
			if !removed_bullet{
				i +=1 
			}
		}

		if player.health < 0.0{
			fmt.println("your ded")
			break
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
				enemies[i] = enemy_update(enemies[i], player_get_pos(player))
				if enemies[i].can_shoot{

					bullet := Bullet{
						radius = BULLET_RADIUS,
						color = BULLET_COLOR,
						speed = BULLET_SPEED,
						pos = enemy_center(enemies[i]),
						forward = enemies[i].forward,
						dmg = BULLET_DAMAGE, 
						attack_enemy = false,
					}
					append(&bullets, bullet)

					enemies[i].can_shoot = false
				}

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
			enemy_render_healthbar(enemy)
		}
	}
}