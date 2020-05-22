// This is the default floating point precision - you can make this more precise
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

// uniform is like 'variable' - all of these are actually set in the js below - we could probably set some more :D
// vec2 is a variable containing two floats
uniform vec2 u_resolution;
// a float is a float right :)
uniform float u_time;
uniform vec2 u_mouse;

// Plot a line on Y using a value between 0.0-1.0
// This is a function - that's cool.
float plot(vec2 st,float pct){
return smoothstep(pct-.02,pct,st.y)-
smoothstep(pct,pct+.02,st.y);
}

float normalCurve(vec2 st,float powNum){
return 1.-pow(abs(st.x),powNum);
}

float sCurve(vec2 st,float powNum){
return pow(cos(PI*st.x/2.),powNum);
}

void main(){

// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
vec2 st=gl_FragCoord.xy/u_resolution.xy;

// little bit confusing, like why not call this x?
// float y = pow(st.x, 2.6);
// float y = normalCurve(st, 0.5);
float y=sCurve(st,.5);
vec3 color=vec3(y);

float pct=plot(st,y);
color=(1.-pct)*color+pct*vec3(0.,1.,0.);

gl_FragColor=vec4(color,1.);

}