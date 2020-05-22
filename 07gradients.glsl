
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

	// Plot a line on Y using a value between 0.0-1.0
	float plot(vec2 st, float pct){
		return  smoothstep( pct-0.01, pct, st.y) -
						smoothstep( pct, pct+0.01, st.y);
	}


	// I mean this link is fucking incredible anyway - totally worth a read through http://www.iquilezles.org/www/articles/functions/functions.htm
	// There are a lot of links in this part of Book of Shaders and I went through a lot of them - I settle on replicating this page as it covers a lot in a small space

	// almost identity: anything below a threshold is set to a specific value, as running the change you want on these values causes strange numbers, anything above can be changed normally
	// TODO: I wonder if this can be done with anything _above_ a certain value
	// therefore, if p(x) is a cubic, then p(x) = (2n-m)(x/m)^3 + (2m-3n)(x/m)^2 + n

	float almostIdentity( float x, float m, float n )
	{
	    if( x>m ) return x;

	    // const float a = 2.0*n - m;
	    // const float b = 2.0*m - 3.0*n;
	    // const float t = st.x/m;

	    // return (a*t + b)*t*t + n;

	    return ((2.0*n - m)*(x/m) + (2.0*m - 3.0*n))*(x/m)*(x/m) + n;
	}

	// Great for triggering behaviours or making envelopes for music or animation, and for anything that grows fast and then slowly decays. Use k to control the stretching o the function. Btw, it's maximum, which is 1.0, happens at exactly x = 1/k.
	float impulse(float x, float k) {
		// const float h = k*st.x;
		// return h*exp(1.0-h);

		return (k*x)*exp(1.0-(k*x));
	}

	// haha this is what is happening above :)
	// Of course you found yourself doing smoothstep(c-w,c,x)-smoothstep(c,c+w,x) very often, probably cause you were trying to isolate some features. Then this cubicPulse() is your friend. Also, why not, you can use it as a cheap replacement for a gaussian.
	float cubicPulse(float x, float c, float w)
	{
	    x = abs(x - c);
	    if( x>w ) return 0.0;

	    x /= w;
	    return 1.0 - x*x*(3.0-2.0*x);
	}

	// A natural attenuation is an exponential of a linearly decaying quantity
	float expStep(float x, float k, float n )
	{
	    return exp( -k*pow(x,n) );
	}

	// Remapping the unit interval into the unit interval by expanding the sides and compressing the center, and keeping 1/2 mapped to 1/2, that can be done with the gain() function. This was a common function in RSL tutorials (the Renderman Shading Language). k=1 is the identity curve, k<1 produces the classic gain() shape, and k>1 produces "s" shaped curces. The curves are symmetric (and inverse) for k=a and k=1/a.
	float gain(float x, float k)
	{
	    float a = 0.5*pow(2.0*((x<0.5) ? x : 1.0-x), k);
	    return (x < 0.5) ? a : 1.0-a;
	}

	// A nice choice to remap the 0..1 interval into 0..1, such that the corners are remapped to 0 and the center to 1. In other words, parabola(0) = parabola(1) = 0, and parabola(1/2) = 1.
	float parabola(float x, float k)
	{
	    return pow( 4.0*x*(1.0-x), k );
	}

	// A nice choice to remap the 0..1 interval into 0..1, such that the corners are remapped to 0. Very useful to skew the shape one side or the other in order to make leaves, eyes, and many other interesting shapes
	float pcurve(float x, float a, float b)
	{
	    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
	    return k * pow( x, a ) * pow( 1.0-x, b );
	}

	// A phase shifter sinc curve can be useful if it starts at zero and ends at zero, for some bouncing behaviors (suggested by Hubert-Jan). Give k different integer values to tweak the amount of bounces. It peaks at 1.0, but that take negative values, which can make it unusable in some applications.
	float sinc(float x, float k)
	{
	    float a = PI * (float((k)*x-1.0));
	    return sin(a)/a;
	}

	vec3 colA = vec3(0.500, 0.100, 0.100);
	vec3 colB = vec3(0.200, 0.100, 0.500);

	// TODO refacotr plot function - alslo you can use cubicPulse

	void main() {

		// this gives us *st* which we're using for x & y coords - we're normalising the coords of the x and y by dividing them by the resolution
		vec2 st = gl_FragCoord.xy/u_resolution.xy;
		// vec2 st = gl_FragCoord.xy;

		vec3 color = vec3(0.0);

		vec3 pct = vec3(st.x);

    pct.r = smoothstep(0.0,1.0, st.x);
    pct.g = sin(st.x*PI);
    pct.b = pow(st.x,0.5);

		color = mix(colA, colB, pct);

		// Plot transition lines for each channel
    color = mix(color,vec3(1.0,0.0,0.0),plot(st,pct.r));
    color = mix(color,vec3(0.0,1.0,0.0),plot(st,pct.g));
    color = mix(color,vec3(0.0,0.0,1.0),plot(st,pct.b));

		gl_FragColor = vec4(color, 1.0);

	}
