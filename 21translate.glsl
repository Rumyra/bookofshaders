
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

	float plot(vec2 st, float pct){
		return  smoothstep( pct-0.01, pct, st.y) -
						smoothstep( pct, pct+0.01, st.y);
	}

	float polarShape(vec2 st, int noSides, int angleOffset, float scale) {

		// change angle from degrees to rad
		float deg = float(angleOffset);
		float rotateRad = radians(deg);

		float a = atan(st.x, st.y)+PI+rotateRad;

		// calculate radius
		float r = TWO_PI/float(noSides);

		// return d which is the value used in fragshader color
		float d = cos(floor(0.5+a/r)*r-a)*length(st)/scale;
		return d;
	}

	float box(in vec2 _st,in vec2 _size){

		_size=vec2(.5)-_size*.5;
		vec2 uv=smoothstep(_size, _size+vec2(.001), _st);

		uv*=smoothstep(_size, _size+vec2(.001), vec2(1.)-_st);

		return uv.x*uv.y;
	}

	float cross(in vec2 _st,float _size){
		return box(_st,vec2(_size,_size/4.))+
		box(_st,vec2(_size/4.,_size));
	}

	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
		vec2 st = gl_FragCoord.xy/u_resolution.xy;

		vec2 translate = vec2(cos(u_time), sin(u_time));
		st += translate*0.5;

		float dd = polarShape(st,3,20,1.2);
		float box = box(st,vec2(.5,.5));
		float cr = cross(st, 0.5);

		vec3 color = vec3(1.-smoothstep(.4,.41,cr));

    gl_FragColor = vec4(color, 1.0);

	}
