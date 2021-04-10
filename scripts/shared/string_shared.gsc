// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;

#namespace string;

/*
	Name: rfill
	Namespace: string
	Checksum: 0xA8CCE6FE
	Offset: 0x98
	Size: 0x10A
	Parameters: 3
	Flags: Linked
*/
function rfill(str_input, n_length, str_fill_char)
{
	/#
		if(!isdefined(str_fill_char))
		{
			str_fill_char = "";
		}
		if(str_fill_char == "")
		{
			str_fill_char = "";
		}
		/#
			assert(str_fill_char.size == 1, "");
		#/
		str_input = "" + str_input;
		n_fill_count = n_length - str_input.size;
		str_fill = "";
		if(n_fill_count > 0)
		{
			for(i = 0; i < n_fill_count; i++)
			{
				str_fill = str_fill + str_fill_char;
			}
		}
		return str_fill + str_input;
	#/
}

