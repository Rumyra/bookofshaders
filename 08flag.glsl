
// This is the default floating point precision - you can make this more precise
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

	// uniform is like 'variable' - all of these are actually set in the js below - we could probably set some more :D
	// vec2 is a variable containing two floats
	uniform vec2 u_resolution;
	uniform float u_time;
	uniform vec2 u_mouse;

	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
		vec2 st = gl_FragCoord.xy/u_resolution.xy;

		vec3 color = vec3(0.0);

		color.r = step(0.33, st.y);
		color.b = 1.0 - step(0.66, st.y);
		color.g = (1.0 - step(0.66, st.y) ) * step(0.33, st.y);

		// color = step(color, vec3(st.y, 0.0, 0.0))

		// color.g = smoothstep(0.05, 0.3, st.x) * (1.0 - smoothstep(0.5, 0.9, st.x) );
		// color.b = smoothstep(0.3, 0.7, st.x);

		gl_FragColor = vec4(color, 1.0);

	}
