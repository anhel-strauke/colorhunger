extends Node


const d = [
	[
		[
			[1, 1, 1],
			[0.163, 0.373, 0.6]
		],
		[
			[1, 1, 0],
			[0, 0.66, 0.2],
		]
	],
	[
		[
			[1, 0, 0],
			[0.5, 0.5, 0]
		],
		[
			[1, 0.5, 0],
			[0.2, 0.094, 0]
		]
	]
]

const t = [
	[
		[
			[1, 1, 1],
			[0, 0, 1]
		],
		[
			[0, 1, 0.483],
			[0, 0.053, 0.21]
		]
	],
	[
		[
			[1, 0, 0],
			[0.309, 0, 0.469]
		],
		[
			[0, 1, 0],
			[0, 0, 0]
		]
	]
]


func ryb2rgb(ryb):
	var r = ryb[0]
	var y = ryb[1]
	var b = ryb[2]
	var rs = [0, 0, 0]
	for i in range(3):
		rs[i] = (d[0][0][0][i] * (1 - r) * (1 - y) * (1 - b) +
				d[0][0][1][i] * (1 - r) * (1 - y) * b +
				d[0][1][0][i] * (1 - r) * y * (1 - b) +
				d[1][0][0][i] * r * (1 - y) * (1 - b) +
				d[0][1][1][i] * (1 - r) * y * b +
				d[1][0][1][i] * r * (1 - y) * b +
				d[1][1][0][i] * r * y * (1 - b) +
				d[1][1][1][i] * r * y * b)
	return rs


func rgb2ryb(rgb):
	var r = rgb[0]
	var g = rgb[1]
	var b = rgb[2]
	var rs = [0, 0, 0]
	for i in range(3):
		rs[i] = (t[0][0][0][i] * (1 - r) * (1 - g) * (1 - b) +
				t[0][0][1][i] * (1 - r) * (1 - g) * b +
				t[0][1][0][i] * (1 - r) * g * (1 - b) +
				t[1][0][0][i] * r * (1 - g) * (1 - b) +
				t[0][1][1][i] * (1 - r) * g * b +
				t[1][0][1][i] * r * (1 - g) * b +
				t[1][1][0][i] * r * g * (1 - b) +
				t[1][1][1][i] * r * g * b)
	return rs
	
	
# Array of pairs [[R, Y, B], W]
func mix_ryb_colors(weighted_cols):
	var res = [0, 0, 0]
	for wc_pair in weighted_cols:
		var c = wc_pair[0]
		var w = wc_pair[1]
		for i in range(3):
			res[i] += c[i] * w
	var m = res.max()
	for i in range(3):
		res[i] = res[i] / m
	return res

# weighted_colors is array of [Color, weight]
func mix_colors(weighted_colors: Array) -> Color:
	var w_ryb = []
	for weighted_col in weighted_colors:
		var col: Color = weighted_col[0]
		var w: float = weighted_col[1]
		var rgb = [col.r, col.g, col.b]
		var ryb = rgb2ryb(rgb)
		w_ryb.append([ryb, w])
	var mix_ryb = mix_ryb_colors(w_ryb)
	var mix_rgb = ryb2rgb(mix_ryb)
	return Color(mix_rgb[0], mix_rgb[1], mix_rgb[2])
