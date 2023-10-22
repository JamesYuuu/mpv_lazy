// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//!DESC RAVU-Zoom-AR (yuv, r2, compute)
//!HOOK NATIVE
//!BIND HOOKED
//!BIND ravu_zoom_lut2
//!BIND ravu_zoom_lut2_ar
//!WIDTH OUTPUT.w
//!HEIGHT OUTPUT.h
//!OFFSET ALIGN
//!WHEN LUMA.w 0 > HOOKED.w OUTPUT.w < * HOOKED.h OUTPUT.h < *
//!COMPUTE 32 8
#define LUTPOS(x, lut_size) mix(0.5 / (lut_size), 1.0 - 0.5 / (lut_size), (x))
shared vec3 samples[432];
void hook() {
ivec2 group_begin = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
ivec2 group_end = group_begin + ivec2(gl_WorkGroupSize) - ivec2(1);
ivec2 rectl = ivec2(floor(HOOKED_size * HOOKED_map(group_begin) - 0.5)) - 1;
ivec2 rectr = ivec2(floor(HOOKED_size * HOOKED_map(group_end) - 0.5)) + 2;
ivec2 rect = rectr - rectl + 1;
for (int id = int(gl_LocalInvocationIndex); id < rect.x * rect.y; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
int y = id / rect.x, x = id % rect.x;
samples[x + y * 36] = HOOKED_tex(HOOKED_pt * (vec2(rectl + ivec2(x, y)) + vec2(0.5,0.5) + HOOKED_off)).xyz;
}
barrier();
vec2 pos = HOOKED_size * HOOKED_map(ivec2(gl_GlobalInvocationID));
vec2 subpix = fract(pos - 0.5);
pos -= subpix;
subpix = LUTPOS(subpix, vec2(9.0));
vec2 subpix_inv = 1.0 - subpix;
subpix /= vec2(2.0, 288.0);
subpix_inv /= vec2(2.0, 288.0);
ivec2 ipos = ivec2(floor(pos)) - rectl;
int lpos = ipos.x + ipos.y * 36;
vec3 sample0 = samples[-37 + lpos];
vec3 sample1 = samples[-1 + lpos];
vec3 sample2 = samples[35 + lpos];
vec3 sample3 = samples[71 + lpos];
vec3 sample4 = samples[-36 + lpos];
vec3 sample5 = samples[0 + lpos];
vec3 sample6 = samples[36 + lpos];
vec3 sample7 = samples[72 + lpos];
vec3 sample8 = samples[-35 + lpos];
vec3 sample9 = samples[1 + lpos];
vec3 sample10 = samples[37 + lpos];
vec3 sample11 = samples[73 + lpos];
vec3 sample12 = samples[-34 + lpos];
vec3 sample13 = samples[2 + lpos];
vec3 sample14 = samples[38 + lpos];
vec3 sample15 = samples[74 + lpos];
vec3 abd = vec3(0.0);
float gx, gy;
gx = (sample4.x-sample0.x);
gy = (sample1.x-sample0.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (sample5.x-sample1.x);
gy = (sample2.x-sample0.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample6.x-sample2.x);
gy = (sample3.x-sample1.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample7.x-sample3.x);
gy = (sample3.x-sample2.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (sample8.x-sample0.x)/2.0;
gy = (sample5.x-sample4.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample9.x-sample1.x)/2.0;
gy = (sample6.x-sample4.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (sample10.x-sample2.x)/2.0;
gy = (sample7.x-sample5.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (sample11.x-sample3.x)/2.0;
gy = (sample7.x-sample6.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample12.x-sample4.x)/2.0;
gy = (sample9.x-sample8.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample13.x-sample5.x)/2.0;
gy = (sample10.x-sample8.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (sample14.x-sample6.x)/2.0;
gy = (sample11.x-sample9.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
gx = (sample15.x-sample7.x)/2.0;
gy = (sample11.x-sample10.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample12.x-sample8.x);
gy = (sample13.x-sample12.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
gx = (sample13.x-sample9.x);
gy = (sample14.x-sample12.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample14.x-sample10.x);
gy = (sample15.x-sample13.x)/2.0;
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
gx = (sample15.x-sample11.x);
gy = (sample15.x-sample14.x);
abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
float a = abd.x, b = abd.y, d = abd.z;
float T = a + d, D = a * d - b * b;
float delta = sqrt(max(T * T / 4.0 - D, 0.0));
float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
float lambda = sqrtL1;
float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
float angle = floor(theta * 24.0 / 3.141592653589793);
float strength = mix(mix(0.0, 1.0, lambda >= 0.004), mix(2.0, 3.0, lambda >= 0.05), lambda >= 0.016);
float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
float coord_y = ((angle * 4.0 + strength) * 3.0 + coherence) / 288.0;
vec3 res = vec3(0.0);
vec4 w;
mat4x3 cg, cg1;
vec3 lo = vec3(0.0), hi = vec3(0.0);
vec3 lo2 = vec3(0.0), hi2 = vec3(0.0);
w = texture(ravu_zoom_lut2, vec2(0.0, coord_y) + subpix);
res += sample0 * w[0];
res += sample1 * w[1];
res += sample2 * w[2];
res += sample3 * w[3];
w = texture(ravu_zoom_lut2, vec2(0.5, coord_y) + subpix);
res += sample4 * w[0];
res += sample5 * w[1];
res += sample6 * w[2];
res += sample7 * w[3];
w = texture(ravu_zoom_lut2, vec2(0.0, coord_y) + subpix_inv);
res += sample15 * w[0];
res += sample14 * w[1];
res += sample13 * w[2];
res += sample12 * w[3];
w = texture(ravu_zoom_lut2, vec2(0.5, coord_y) + subpix_inv);
res += sample11 * w[0];
res += sample10 * w[1];
res += sample9 * w[2];
res += sample8 * w[3];
w = texture(ravu_zoom_lut2_ar, vec2(0.0, coord_y) + subpix);
cg = mat4x3(0.5 + sample0, 1.5 - sample0, 0.5 + sample1, 1.5 - sample1);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[0] + cg[2] * w[1];
lo += cg[1] * w[0] + cg[3] * w[1];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[0] + cg[2] * w[1];
lo2 += cg[1] * w[0] + cg[3] * w[1];
cg = mat4x3(0.5 + sample2, 1.5 - sample2, 0.5 + sample3, 1.5 - sample3);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[2] + cg[2] * w[3];
lo += cg[1] * w[2] + cg[3] * w[3];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[2] + cg[2] * w[3];
lo2 += cg[1] * w[2] + cg[3] * w[3];
w = texture(ravu_zoom_lut2_ar, vec2(0.5, coord_y) + subpix);
cg = mat4x3(0.5 + sample4, 1.5 - sample4, 0.5 + sample5, 1.5 - sample5);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[0] + cg[2] * w[1];
lo += cg[1] * w[0] + cg[3] * w[1];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[0] + cg[2] * w[1];
lo2 += cg[1] * w[0] + cg[3] * w[1];
cg = mat4x3(0.5 + sample6, 1.5 - sample6, 0.5 + sample7, 1.5 - sample7);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[2] + cg[2] * w[3];
lo += cg[1] * w[2] + cg[3] * w[3];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[2] + cg[2] * w[3];
lo2 += cg[1] * w[2] + cg[3] * w[3];
w = texture(ravu_zoom_lut2_ar, vec2(0.0, coord_y) + subpix_inv);
cg = mat4x3(0.5 + sample15, 1.5 - sample15, 0.5 + sample14, 1.5 - sample14);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[0] + cg[2] * w[1];
lo += cg[1] * w[0] + cg[3] * w[1];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[0] + cg[2] * w[1];
lo2 += cg[1] * w[0] + cg[3] * w[1];
cg = mat4x3(0.5 + sample13, 1.5 - sample13, 0.5 + sample12, 1.5 - sample12);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[2] + cg[2] * w[3];
lo += cg[1] * w[2] + cg[3] * w[3];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[2] + cg[2] * w[3];
lo2 += cg[1] * w[2] + cg[3] * w[3];
w = texture(ravu_zoom_lut2_ar, vec2(0.5, coord_y) + subpix_inv);
cg = mat4x3(0.5 + sample11, 1.5 - sample11, 0.5 + sample10, 1.5 - sample10);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[0] + cg[2] * w[1];
lo += cg[1] * w[0] + cg[3] * w[1];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[0] + cg[2] * w[1];
lo2 += cg[1] * w[0] + cg[3] * w[1];
cg = mat4x3(0.5 + sample9, 1.5 - sample9, 0.5 + sample8, 1.5 - sample8);
cg1 = cg;
cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);cg = matrixCompMult(cg, cg);
hi += cg[0] * w[2] + cg[2] * w[3];
lo += cg[1] * w[2] + cg[3] * w[3];
cg = matrixCompMult(cg, cg1);
hi2 += cg[0] * w[2] + cg[2] * w[3];
lo2 += cg[1] * w[2] + cg[3] * w[3];
hi = hi2 / hi - 0.5;
lo = 1.5 - lo2 / lo;
res = mix(res, clamp(res, lo, hi), 0.800000);
imageStore(out_image, ivec2(gl_GlobalInvocationID), vec4(res, 1.0));
}
//!TEXTURE ravu_zoom_lut2
//!SIZE 18 2592
//!FORMAT rgba16f
//!FILTER LINEAR
//!TEXTURE ravu_zoom_lut2_ar
//!SIZE 18 2592
//!FORMAT rgba16f
//!FILTER LINEAR