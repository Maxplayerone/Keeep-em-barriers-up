package main

import "core:math"
import linalg "core:math/linalg"
import "core:fmt"

import rl "vendor:raylib"

vec_len :: proc(vec: rl.Vector2) -> f32{
	return math.sqrt(vec.x * vec.x + vec.y * vec.y)
}

vec_dot :: proc(vec1: rl.Vector2, vec2: rl.Vector2) -> f32{
	return vec1.x * vec2.x + vec1.y * vec2.y
}

vec_norm :: proc(vec: rl.Vector2) -> rl.Vector2{
	len := vec_len(vec)
	return rl.Vector2{vec.x / len, vec.y / len}
}

mouse_pos_at_screen_center :: proc() -> rl.Vector2{
	pos := rl.GetMousePosition()
	return rl.Vector2{pos.x - f32(WIDTH) / 2, pos.y - f32(HEIGHT) / 2}
}

//gets the angle between two vectors (in radians)
angle_btw_two_vecs :: proc(vec1: rl.Vector2, vec2: rl.Vector2) -> f32{
	len1 := vec_len(vec1)
	len2 := vec_len(vec2)
	dot := vec_dot(vec1, vec2)

	cos := dot / (len1 * len2)
	angle := math.acos(cos)
	return angle 
}

angle_btw_two_vecs_full_circle :: proc(vec1: rl.Vector2, vec2: rl.Vector2) -> f32{
    dot := vec_dot(vec1, vec2)
    det := vec1.x * vec2.y - vec1.y * vec2.x
    angle := math.atan2(det, dot)
    return angle
}

deg_to_rad :: proc(angle_deg: f32) -> f32{
    return angle_deg * 3.1415 / 180.0
}

rad_to_deg :: proc(angle_rad: f32) -> f32{
    return angle_rad * 180.0 / 3.1415
}

//rotating a vector in radians
vec_rotate_rad :: proc(vec: rl.Vector2, angle: f32) -> rl.Vector2{
    cos := math.cos(angle)
    sin := math.sin(angle)
    
    rotated_vec := rl.Vector2{0.0, 0.0}
    rotated_vec.x = vec.x * cos - vec.y * sin
    rotated_vec.y = vec.x * sin + vec.y * cos
    
    return rotated_vec
}

vec_rotate_from_origin :: proc(vec: rl.Vector2, origin: rl.Vector2, angle: f32) -> rl.Vector2{
    v := vec
    v.x -= origin.x
    v.y -= origin.y
    v = vec_rotate_rad(v, angle)
    v.x += origin.x
    v.y += origin.y
    return v
}