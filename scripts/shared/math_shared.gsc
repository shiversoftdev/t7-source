// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

#namespace math;

/*
	Name: cointoss
	Namespace: math
	Checksum: 0x84ADC07
	Offset: 0xB8
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function cointoss()
{
	return randomint(100) >= 50;
}

/*
	Name: clamp
	Namespace: math
	Checksum: 0x59E381C5
	Offset: 0xE0
	Size: 0x68
	Parameters: 3
	Flags: Linked
*/
function clamp(val, val_min, val_max = val)
{
	if(val < val_min)
	{
		val = val_min;
	}
	else if(val > val_max)
	{
		val = val_max;
	}
	return val;
}

/*
	Name: linear_map
	Namespace: math
	Checksum: 0x823A56E0
	Offset: 0x150
	Size: 0x6A
	Parameters: 5
	Flags: Linked
*/
function linear_map(num, min_a, max_a, min_b, max_b)
{
	return clamp((num - min_a) / (max_a - min_a) * (max_b - min_b) + min_b, min_b, max_b);
}

/*
	Name: lag
	Namespace: math
	Checksum: 0x553D62C4
	Offset: 0x1C8
	Size: 0xA6
	Parameters: 4
	Flags: None
*/
function lag(desired, curr, k, dt)
{
	r = 0;
	if((k * dt) >= 1 || k <= 0)
	{
		r = desired;
	}
	else
	{
		err = desired - curr;
		r = curr + ((k * err) * dt);
	}
	return r;
}

/*
	Name: find_box_center
	Namespace: math
	Checksum: 0x28970463
	Offset: 0x278
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function find_box_center(mins, maxs)
{
	center = (0, 0, 0);
	center = maxs - mins;
	center = (center[0] / 2, center[1] / 2, center[2] / 2) + mins;
	return center;
}

/*
	Name: expand_mins
	Namespace: math
	Checksum: 0x40DC1D52
	Offset: 0x2F8
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function expand_mins(mins, point)
{
	if(mins[0] > point[0])
	{
		mins = (point[0], mins[1], mins[2]);
	}
	if(mins[1] > point[1])
	{
		mins = (mins[0], point[1], mins[2]);
	}
	if(mins[2] > point[2])
	{
		mins = (mins[0], mins[1], point[2]);
	}
	return mins;
}

/*
	Name: expand_maxs
	Namespace: math
	Checksum: 0xB6ECC46B
	Offset: 0x3D0
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function expand_maxs(maxs, point)
{
	if(maxs[0] < point[0])
	{
		maxs = (point[0], maxs[1], maxs[2]);
	}
	if(maxs[1] < point[1])
	{
		maxs = (maxs[0], point[1], maxs[2]);
	}
	if(maxs[2] < point[2])
	{
		maxs = (maxs[0], maxs[1], point[2]);
	}
	return maxs;
}

/*
	Name: vector_compare
	Namespace: math
	Checksum: 0xDE6E0AF6
	Offset: 0x4A8
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function vector_compare(vec1, vec2)
{
	return (abs(vec1[0] - vec2[0])) < 0.001 && (abs(vec1[1] - vec2[1])) < 0.001 && (abs(vec1[2] - vec2[2])) < 0.001;
}

/*
	Name: random_vector
	Namespace: math
	Checksum: 0xEF9A6139
	Offset: 0x568
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function random_vector(max_length)
{
	return (randomfloatrange(-1 * max_length, max_length), randomfloatrange(-1 * max_length, max_length), randomfloatrange(-1 * max_length, max_length));
}

/*
	Name: angle_dif
	Namespace: math
	Checksum: 0x3D4D486A
	Offset: 0x5E0
	Size: 0x76
	Parameters: 2
	Flags: None
*/
function angle_dif(oldangle, newangle)
{
	outvalue = (oldangle - newangle) % 360;
	if(outvalue < 0)
	{
		outvalue = outvalue + 360;
	}
	if(outvalue > 180)
	{
		outvalue = (outvalue - 360) * -1;
	}
	return outvalue;
}

/*
	Name: sign
	Namespace: math
	Checksum: 0x46F22169
	Offset: 0x660
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function sign(x)
{
	return (x >= 0 ? 1 : -1);
}

/*
	Name: randomsign
	Namespace: math
	Checksum: 0x13951D4E
	Offset: 0x690
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function randomsign()
{
	return ((randomintrange(-1, 1)) >= 0 ? 1 : -1);
}

/*
	Name: get_dot_direction
	Namespace: math
	Checksum: 0xEE08EFD7
	Offset: 0x6C8
	Size: 0x384
	Parameters: 5
	Flags: Linked
*/
function get_dot_direction(v_point, b_ignore_z, b_normalize, str_direction, b_use_eye)
{
	/#
		assert(isdefined(v_point), "");
	#/
	if(!isdefined(b_ignore_z))
	{
		b_ignore_z = 0;
	}
	if(!isdefined(b_normalize))
	{
		b_normalize = 1;
	}
	if(!isdefined(str_direction))
	{
		str_direction = "forward";
	}
	if(!isdefined(b_use_eye))
	{
		b_use_eye = 0;
		if(isplayer(self))
		{
			b_use_eye = 1;
		}
	}
	v_angles = self.angles;
	v_origin = self.origin;
	if(b_use_eye)
	{
		v_origin = self util::get_eye();
	}
	if(isplayer(self))
	{
		v_angles = self getplayerangles();
		if(level.wiiu)
		{
			v_angles = self getgunangles();
		}
	}
	if(b_ignore_z)
	{
		v_angles = (v_angles[0], v_angles[1], 0);
		v_point = (v_point[0], v_point[1], 0);
		v_origin = (v_origin[0], v_origin[1], 0);
	}
	switch(str_direction)
	{
		case "forward":
		{
			v_direction = anglestoforward(v_angles);
			break;
		}
		case "backward":
		{
			v_direction = anglestoforward(v_angles) * -1;
			break;
		}
		case "right":
		{
			v_direction = anglestoright(v_angles);
			break;
		}
		case "left":
		{
			v_direction = anglestoright(v_angles) * -1;
			break;
		}
		case "up":
		{
			v_direction = anglestoup(v_angles);
			break;
		}
		case "down":
		{
			v_direction = anglestoup(v_angles) * -1;
			break;
		}
		default:
		{
			/#
				assertmsg(str_direction + "");
			#/
			v_direction = anglestoforward(v_angles);
			break;
		}
	}
	v_to_point = v_point - v_origin;
	if(b_normalize)
	{
		v_to_point = vectornormalize(v_to_point);
	}
	n_dot = vectordot(v_direction, v_to_point);
	return n_dot;
}

/*
	Name: get_dot_right
	Namespace: math
	Checksum: 0x994EB935
	Offset: 0xA58
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function get_dot_right(v_point, b_ignore_z, b_normalize)
{
	/#
		assert(isdefined(v_point), "");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, "right");
	return n_dot;
}

/*
	Name: get_dot_up
	Namespace: math
	Checksum: 0xF6EFC644
	Offset: 0xAE0
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function get_dot_up(v_point, b_ignore_z, b_normalize)
{
	/#
		assert(isdefined(v_point), "");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, "up");
	return n_dot;
}

/*
	Name: get_dot_forward
	Namespace: math
	Checksum: 0x21434A0A
	Offset: 0xB68
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function get_dot_forward(v_point, b_ignore_z, b_normalize)
{
	/#
		assert(isdefined(v_point), "");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, "forward");
	return n_dot;
}

/*
	Name: get_dot_from_eye
	Namespace: math
	Checksum: 0xBA8DB492
	Offset: 0xBF0
	Size: 0xE4
	Parameters: 4
	Flags: None
*/
function get_dot_from_eye(v_point, b_ignore_z, b_normalize, str_direction)
{
	/#
		assert(isdefined(v_point), "");
	#/
	/#
		assert(isplayer(self) || isai(self), ("" + self.classname) + "");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, str_direction, 1);
	return n_dot;
}

/*
	Name: array_average
	Namespace: math
	Checksum: 0x80C85E22
	Offset: 0xCE0
	Size: 0xB8
	Parameters: 1
	Flags: None
*/
function array_average(array)
{
	/#
		assert(isarray(array));
	#/
	/#
		assert(array.size > 0);
	#/
	total = 0;
	for(i = 0; i < array.size; i++)
	{
		total = total + array[i];
	}
	return total / array.size;
}

/*
	Name: array_std_deviation
	Namespace: math
	Checksum: 0x78DCDE4F
	Offset: 0xDA0
	Size: 0x132
	Parameters: 2
	Flags: None
*/
function array_std_deviation(array, mean)
{
	/#
		assert(isarray(array));
	#/
	/#
		assert(array.size > 0);
	#/
	tmp = [];
	for(i = 0; i < array.size; i++)
	{
		tmp[i] = (array[i] - mean) * (array[i] - mean);
	}
	total = 0;
	for(i = 0; i < tmp.size; i++)
	{
		total = total + tmp[i];
	}
	return sqrt(total / array.size);
}

/*
	Name: random_normal_distribution
	Namespace: math
	Checksum: 0x5CCC166B
	Offset: 0xEE0
	Size: 0x19E
	Parameters: 4
	Flags: None
*/
function random_normal_distribution(mean, std_deviation, lower_bound, upper_bound)
{
	x1 = 0;
	x2 = 0;
	w = 1;
	y1 = 0;
	while(w >= 1)
	{
		x1 = (2 * randomfloatrange(0, 1)) - 1;
		x2 = (2 * randomfloatrange(0, 1)) - 1;
		w = (x1 * x1) + (x2 * x2);
	}
	w = sqrt(-2 * log(w) / w);
	y1 = x1 * w;
	number = mean + (y1 * std_deviation);
	if(isdefined(lower_bound) && number < lower_bound)
	{
		number = lower_bound;
	}
	if(isdefined(upper_bound) && number > upper_bound)
	{
		number = upper_bound;
	}
	return number;
}

/*
	Name: closest_point_on_line
	Namespace: math
	Checksum: 0x132AE5B1
	Offset: 0x1088
	Size: 0x1C0
	Parameters: 3
	Flags: None
*/
function closest_point_on_line(point, linestart, lineend)
{
	linemagsqrd = lengthsquared(lineend - linestart);
	t = (point[0] - linestart[0]) * (lineend[0] - linestart[0]) + (point[1] - linestart[1]) * (lineend[1] - linestart[1]) + (point[2] - linestart[2]) * (lineend[2] - linestart[2]) / linemagsqrd;
	if(t < 0)
	{
		return linestart;
	}
	if(t > 1)
	{
		return lineend;
	}
	start_x = linestart[0] + (t * (lineend[0] - linestart[0]));
	start_y = linestart[1] + (t * (lineend[1] - linestart[1]));
	start_z = linestart[2] + (t * (lineend[2] - linestart[2]));
	return (start_x, start_y, start_z);
}

/*
	Name: get_2d_yaw
	Namespace: math
	Checksum: 0x7C8D97AF
	Offset: 0x1250
	Size: 0x62
	Parameters: 2
	Flags: None
*/
function get_2d_yaw(start, end)
{
	vector = (end[0] - start[0], end[1] - start[1], 0);
	return vec_to_angles(vector);
}

/*
	Name: vec_to_angles
	Namespace: math
	Checksum: 0xDD2B0AD7
	Offset: 0x12C0
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function vec_to_angles(vector)
{
	yaw = 0;
	vecx = vector[0];
	vecy = vector[1];
	if(vecx == 0 && vecy == 0)
	{
		return 0;
	}
	if(vecy < 0.001 && vecy > -0.001)
	{
		vecy = 0.001;
	}
	yaw = atan(vecx / vecy);
	if(vecy < 0)
	{
		yaw = yaw + 180;
	}
	return 90 - yaw;
}

/*
	Name: pow
	Namespace: math
	Checksum: 0xDAEB5FF
	Offset: 0x13A8
	Size: 0x7A
	Parameters: 2
	Flags: None
*/
function pow(base, exp)
{
	if(exp == 0)
	{
		return 1;
	}
	result = base;
	for(i = 0; i < (exp - 1); i++)
	{
		result = result * base;
	}
	return result;
}

