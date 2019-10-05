extends Node

# Based on solution from
# https://web.archive.org/web/20130525061042/www.insanit.net/tag/rgb-to-ryb/

func _rgb2ryb(rgb):
	var r = rgb[0]
	var g = rgb[1]
	var b = rgb[2]
	# Remove the whiteness from the color.
	var w = [r, g, b].min()
	r = r - w
	g = g - w
	b = b - w

	var mg = [r, g, b].max()

	# Get the yellow out of the red+green.
	var y = min(r, g)
	r -= y
	g -= y

	# If this unfortunate conversion combines blue and green, then cut each in half to preserve the value's maximum range.
	if b > 0.0 and g > 0.0:
		b /= 2.0
		g /= 2.0

	# Redistribute the remaining green.
	y += g
	b += g

	# Normalize to values.
	var my = [r, y, b].max()
	if my > 0.0:
		var n = mg / my
		r *= n
		y *= n
		b *= n

	# Add the white back in.
	r += w
	y += w
	b += w

	# And return back the ryb typed accordingly.
	return [r, y, b]


# Convert a red-yellow-blue system to a red-green-blue system.
func _ryb2rgb(ryb):
	var r = ryb[0]
	var y = ryb[1]
	var b = ryb[2]
	# Remove the whiteness from the color.
	var w = [r, y, b].min()
	r = r - w
	y = y - w
	b = b - w

	var my = [r, y, b].max()

	# Get the green out of the yellow and blue
	var g = min(y, b)
	y -= g
	b -= g

	if b > 0.0 and g > 0.0:
		b *= 2.0
		g *= 2.0

	# Redistribute the remaining yellow.
	r += y
	g += y

	# Normalize to values.
	var mg = [r, g, b].max()
	if mg > 0.0:
		var n = my / mg
		r *= n
		g *= n
		b *= n

	# Add the white back in.
	r += w
	g += w
	b += w

	# And return back the ryb typed accordingly.
	return [r, g, b]

# Array of pairs [[R, Y, B], W]
func _mix_ryb_colors(weighted_cols):
	var res = [0, 0, 0]
	for wc_pair in weighted_cols:
		var c = wc_pair[0]
		var w = wc_pair[1]
		for i in range(3):
			res[i] += c[i] * w
	var m = res.max()
	if m > 0:
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
		var ryb = _rgb2ryb(rgb)
		w_ryb.append([ryb, w])
	var mix_ryb = _mix_ryb_colors(w_ryb)
	var mix_rgb = _ryb2rgb(mix_ryb)
	return Color(mix_rgb[0], mix_rgb[1], mix_rgb[2])
