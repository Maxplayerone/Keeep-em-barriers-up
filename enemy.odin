package main

import rl "vendor:raylib"

Enemy :: struct{
    rect: rl.Rectangle,
    color: rl.Color,
}

enemy_render :: proc(e: Enemy){
    rl.DrawRectangleRec(e.rect, e.color)
}