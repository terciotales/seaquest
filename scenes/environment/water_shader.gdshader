shader_type canvas_item;

uniform vec2 strength = vec2(2.0, 2.0);
uniform float speed = 1.0;
uniform float seed = 0.0;

float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(12.98, 78.23))) * 43758.54) + seed;
}

void vertex() {
	float random = rand(VERTEX);
	VERTEX.x += cos(TIME + VERTEX.y * speed + random) * strength.x;
	VERTEX.y += sin(TIME + VERTEX.x * speed + random) * strength.y;
}
