
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

	float almostIdentity( float x, float m, float n )
	{
	    if( x>m ) return x;

	    float a = 2.0*n - m;
	    float b = 2.0*m - 3.0*n;
	    float t = x/m;

	    return (a*t + b)*t*t + n;

	    // return ((2.0*n - m)*(x/m) + (2.0*m - 3.0*n))*(x/m)*(x/m) + n;
	}


	// make a colour for each function
	vec3 red = vec3(1.0, 0.0, 0.0);
	vec3 orange = vec3(0.8, 0.3, 0.0);
	vec3 yellow = vec3(0.7, 0.7, 0.2);
	vec3 green = vec3(0.0, 1.0, 0.0);
	vec3 cyan = vec3(0.0, 0.5, 0.5);
	vec3 blue = vec3(0.0, 0.0, 1.0);
	vec3 purple = vec3(0.5, 0.0, 0.5);
	vec3 pink = vec3(0.8, 0.0, 0.3);

	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
		vec2 st = gl_FragCoord.xy/u_resolution.xy;

		vec3 color = vec3(0.0, 0.0, 0.0);

		color.r = almostIdentity(st.x, 0.5, 1.0);
		color.g = smoothstep(0.05, 0.3, st.x) * (1.0 - smoothstep(0.5, 0.9, st.x) );
		color.b = smoothstep(0.3, 0.7, st.x);

		gl_FragColor = vec4(color, 1.0);

	}
