
// This is the default floating point precision - you can make this more precise

#ifdef GL_ES
precision mediump float;
#endif

	// uniform is like 'variable'
	// vec2 is a variable containing two floats

	uniform vec2 u_resolution;

	// a float is a float right :)
	uniform float u_time;

	uniform vec2 u_mouse;

	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution

		vec2 st = gl_FragCoord.xy/u_resolution.xy;

		// convert mouse pixels into a float from 0.0 -> 1.0

		vec2 mst = u_mouse.xy/u_resolution.xy;

		gl_FragColor = vec4(mst.x*st.x*abs(sin(u_time/4.0)), mst.y*st.y*abs(cos(u_time/2.0)), mst.y/mst.x, 0.8);

	}
