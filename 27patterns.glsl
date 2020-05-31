
// This is the default floating point precision - you can make this more precise
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

	// uniform is like 'variable' - all of these are actually set in the js below - we could probably set some more :D
	// vec2 is a vector containing two floats
	uniform vec2 u_resolution;
	uniform float u_time;
	uniform vec2 u_mouse;

	// colour =============================
	vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0), 6.0)-3.0)-1.0, 0.0, 1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
	}

	float plot(vec2 _st, float pct){
		return  smoothstep( pct-0.01, pct, _st.y) -
						smoothstep( pct, pct+0.01, _st.y);
	}

	// shape one and shape two go in here, if there is an overlap a cutout effect will take place
	float cutout(float v,float pct){
		return mix(v,1.-v,pct);
	}

	// shape drawing ========================
	float polarShape(vec2 _st, int noSides, int angleOffset, float scale) {

		// get st to run from -1 to 1
		_st = _st*2. - 1.;
		// _st.x *= u_resolution.x/u_resolution.y;

		// change angle from degrees to rad
		float deg = float(angleOffset);
		float rotateRad = radians(deg);

		float a = atan(_st.x, _st.y)+PI+rotateRad;

		// calculate radius
		float r = TWO_PI/float(noSides);

		// return d which is the value used in fragshader color
		float d = cos(floor(0.5+a/r)*r-a)*length(_st)/scale;
		return d;
	}

	float box(in vec2 _st,in vec2 _size){

		_size = vec2(.5)-_size*.5;
		vec2 uv = smoothstep(_size, _size+vec2(.001), _st);

		uv *= smoothstep(_size, _size+vec2(.001), vec2(1.)-_st);

		return uv.x*uv.y;
	}

	float cross(in vec2 _st,float _size){
		return box(_st,vec2(_size,_size/4.))+
		box(_st,vec2(_size/4.,_size));
	}

	float rect(vec2 _st, vec2 s){
		_st = _st*2.-1.;
		return max(abs(_st.x/s.x),
		abs(_st.y/s.y));
	}

	float cross2(vec2 _st, float s) {
		vec2 size = vec2(.25,s);
		return min(rect(_st,size.xy),
		rect(_st,size.yx));
	}

	float circle(vec2 _st){
		return (length(_st-0.5)/0.5);
	}


	float vesica(vec2 _st, float w){
		vec2 offset = vec2(w*.5,0.);
		return max(circle(_st-offset),
		circle(_st+offset));
	}


	// params: st.x or st.y, position, width
	// you can make a bar wavy by adding cos/sin to pos
	// you can make xOrY, both or mod it for interesting results
	// for instance st.x+st.y && st.x-st.y will give you a cross
	// using a shape function like circle in xOrY will give you a stroked circle
	float stroke(float xOrY, float pos, float w) {
		float d = step(pos, xOrY+w * .5) - step(pos, xOrY - w*.5);
		return clamp(d,0.,1.);
	}
	// use like color+=fill(circleSDF(st),.65);
	float fill(float x,float size){
		return 1.-step(size,x);
	}
	// use both of the above to get lined effect
	// float sdf=rectSDF(st,vec2(1.));
	// color+=stroke(sdf,.5,.125);
	// color+=fill(sdf,.1);


	// transform functions ==================
	// args: st, two floats of x & y
	vec2 scale(vec2 _st, vec2 _scale){
		// move coords to bottom left
		_st -= .5;
		// use a matrix transform on st
		_st = mat2(_scale.x,0.,0.,_scale.y) * _st;
		// move coords back
		_st += .5;
		// make sure this is passed into st
		return _st;
	}
	// args: st, integer angle in degrees
	vec2 rotate2D(vec2 _st, int _angle){
		// change degrees to radians
		float rad = radians(float(_angle));
		// move the coords to bottom left
		_st -= .5;
		// use a matrix transform on st
		_st = mat2(cos(rad),-sin(rad),
		sin(rad),cos(rad))*_st;
		// move coords back
		_st+=.5;
		// make sure this is passed into st
		return _st;
	}
	//args: st, two floats x & y movement
	vec2 translate(vec2 _st, vec2 _translate) {
		return _st += _translate;
	}


	// tiling ============================
	// params are st & vec2 of x & y count
	vec2 tile(vec2 _st, vec2 repeat) {
		_st *= repeat;
		_st = fract(_st);
		return _st;
	}

	// to make a tile square -> square grid
	// I want to know what the aspect ratio is, how many y's to make if I specify x count
	// if y is 0.8 of x, then I'll need 0.8 x xcount
	float aspectRatio = u_resolution.y/u_resolution.x;
	float x_count = 5.0;
	float y_count = x_count*aspectRatio;

	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
		vec2 st = gl_FragCoord.xy/u_resolution.xy;

		// make our tiles
		st = tile(st, vec2(x_count, y_count));

		// add any transforms & draw
		// st = translate(st, vec2(0.5, -0.5));
		// float cr=cross(st,.5);

		// st=translate(st,vec2(-0.5,0.5));

		st=(st-.5)*1.2+.5;

		// draw vec2 st,int noSides,int angleOffset,float scale
		float dd = polarShape(st,5,20,1.5);
		float bo = box(st,vec2(.4,.5));
		float circ = circle(st);

		// TODO I think polar shape is based on -1 -> 1
		// add colour
		vec3 colour = vec3(0.0);
		// colour += mix(
		// 	colour,
		// 	hsb2rgb(vec3(.5,.8,.8)),
		// 	smoothstep(.4,.41,circ));
		// colour += mix(
		// 	hsb2rgb(vec3(0.7, 0.5, 0.6)),
		// 	colour,
		// 	smoothstep(.4,.41,dd));

		st = rotate2D(st, -45);
		float off=.2;
		vec2 s = vec2(1.7);
		colour+=fill(rect(st+off,s),.2);
		colour+=fill(rect(st-off,s),.2);
		float r=rect(st,s);
		colour*=step(.35,r);
		colour+=fill(r,.3);
		colour*=step(.25,r);
		colour+=fill(r,.2);
		colour*=step(.15,r);
		colour+=fill(r,.1);
    gl_FragColor = vec4(colour, 1.0);

	}
