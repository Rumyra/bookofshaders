
// This is the default floating point precision - you can make this more precise
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

	// uniform is like 'variable' - all of these are actually set in the js below - we could probably set some more :D
	// vec2 is a variable containing two floats
	uniform vec2 u_resolution;
	uniform float u_time;
	uniform vec2 u_mouse;

	// vec3 rgb2hsb( in vec3 c ) {
 //    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
 //    vec4 p = mix(vec4(c.bg, K.wz),
 //                 vec4(c.gb, K.xy),
 //                 step(c.b, c.g));
 //    vec4 q = mix(vec4(p.xyw, c.r),
 //                 vec4(c.r, p.yzx),
 //                 step(p.x, c.r));
 //    float d = q.x - min(q.w, q.y);
 //    float e = 1.0e-10;
 //    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	// }

	vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0), 6.0)-3.0)-1.0, 0.0, 1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
	}

	float parabola(float x, float k)
	{
	    return pow( 4.0*x*(1.0-x), k );
	}

	float impulse(float x, float k) {
		// const float h = k*st.x;
		// return h*exp(1.0-h);

		return (k*x)*exp(1.0-(k*x));
	}


	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
		vec2 st = gl_FragCoord.xy/u_resolution.xy;

		vec3 color = vec3(0.0);

		float leftBord = step(0.1, st.x); // similar to  X greater than 0.1
		float botBord = step(0.1, st.y); // similar to Y greater than 0.1 (remember y comes from bottom)

		// This is equal to:
		vec2 borders = step(vec2(0.1), st);

		// pct I think is percentage, which is like percentage of threads to colour
		// float pct = borders.x * borders.y;

		// we can do all four sides, but we have to do bottom-left *and* top-right
		vec2 botLeft = smoothstep(vec2(0.1), vec2(0.2), st);
		float pct = botLeft.x * botLeft.y;
		vec2 topRight = floor(st-0.9);
		pct *= topRight.x * topRight.y;

		// color = vec3(leftBord*botBord);
		color = vec3(pct);
		gl_FragColor = vec4(color, 1.0);

	}
