#pragma header

#define texture flixel_texture2D
#define iResolution openfl_TextureSize
#define iChannel0 bitmap

// compSize - 4.7
// sampleDist - 2

float compSize = 2.2;
float sampleDist = 1;

bool activated = true;

float pixelate(in float x)
{
    if (!activated)
        return x;

    return (floor(x / compSize)) * compSize;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 rounded = vec2(pixelate(fragCoord.x), pixelate(fragCoord.y));
	vec2 uv = rounded / iResolution.xy;

    vec2 above = (vec2(pixelate(fragCoord.x), pixelate(fragCoord.y - sampleDist))) / iResolution.xy;
    vec2 below = (vec2(pixelate(fragCoord.x), pixelate(fragCoord.y + sampleDist))) / iResolution.xy;
    vec2 left = (vec2(pixelate(fragCoord.x - sampleDist), pixelate(fragCoord.y))) / iResolution.xy;
    vec2 right = (vec2(pixelate(fragCoord.x + sampleDist), pixelate(fragCoord.y))) / iResolution.xy;

	vec4 col = texture(iChannel0, uv).xyzw;
	vec4 colAbove = texture(iChannel0, above).xyzw;
	vec4 colBelow = texture(iChannel0, below).xyzw;
	vec4 colLeft = texture(iChannel0, left).xyzw;
	vec4 colRight = texture(iChannel0, right).xyzw;

    if (colAbove.w == 0)
        colAbove = vec4(0, 0, 0, 1);

    if (colBelow.w == 0)
        colBelow = vec4(0, 0, 0, 1);

    if (colLeft.w == 0)
        colLeft = vec4(0, 0, 0, 1);

    if (colRight.w == 0)
        colRight = vec4(0, 0, 0, 1);

    vec3 mixHorizontal = mix(colLeft.xyz, colRight.xyz, 0.5);
    vec3 mixVertical = mix(colAbove.xyz, colBelow.xyz, 0.5);
    vec3 final = mix(mixVertical, mixHorizontal, 0.5);

	fragColor = vec4(final, col.w);
}

void main() 
{
	mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}