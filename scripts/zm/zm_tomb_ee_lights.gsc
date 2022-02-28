// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_tomb_quest_crypt;

#namespace zm_tomb_ee_lights;

/*
	Name: main
	Namespace: zm_tomb_ee_lights
	Checksum: 0xB7B91082
	Offset: 0x388
	Size: 0x3DE
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("world", "light_show", 21000, 2, "int");
	level flag::init("show_morse_code");
	init_morse_code();
	while(!level flag::exists("start_zombie_round_logic"))
	{
		wait(0.5);
	}
	level flag::wait_till("start_zombie_round_logic");
	chamber_discs = getentarray("crypt_puzzle_disc", "script_noteworthy");
	lit_discs = [];
	foreach(disc in chamber_discs)
	{
		if(isdefined(disc.script_int))
		{
			lit_discs[disc.script_int - 1] = disc;
		}
	}
	level flag::wait_till_any(array("ee_all_staffs_upgraded", "show_morse_code"));
	while(true)
	{
		clientfield::set("light_show", 1);
		if(randomint(100) < 10)
		{
			turn_all_lights_off(lit_discs);
			wait(10);
			clientfield::set("light_show", 3);
			light_show_morse(lit_discs, "GIOVAN BATTISTA BELLASO");
			clientfield::set("light_show", 1);
		}
		turn_all_lights_off(lit_discs);
		wait(10);
		clientfield::set("light_show", 2);
		light_show_morse(lit_discs, level.cipher_key);
		foreach(message in level.morse_messages)
		{
			clientfield::set("light_show", 1);
			cipher = phrase_convert_to_cipher(message, level.cipher_key);
			turn_all_lights_off(lit_discs);
			wait(10);
			light_show_morse(lit_discs, cipher);
		}
	}
}

/*
	Name: init_morse_code
	Namespace: zm_tomb_ee_lights
	Checksum: 0xAF88A798
	Offset: 0x770
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function init_morse_code()
{
	level.morse_letters = [];
	level.morse_letters["A"] = ".-";
	level.morse_letters["B"] = "-...";
	level.morse_letters["C"] = "-.-.";
	level.morse_letters["D"] = "-..";
	level.morse_letters["E"] = ".";
	level.morse_letters["F"] = "..-.";
	level.morse_letters["G"] = "--.";
	level.morse_letters["H"] = "....";
	level.morse_letters["I"] = "..";
	level.morse_letters["J"] = ".---";
	level.morse_letters["K"] = "-.-";
	level.morse_letters["L"] = ".-..";
	level.morse_letters["M"] = "--";
	level.morse_letters["N"] = "-.";
	level.morse_letters["O"] = "---";
	level.morse_letters["P"] = ".--.";
	level.morse_letters["Q"] = "--.-";
	level.morse_letters["R"] = ".-.";
	level.morse_letters["S"] = "...";
	level.morse_letters["T"] = "-";
	level.morse_letters["U"] = "..-";
	level.morse_letters["V"] = "...-";
	level.morse_letters["W"] = ".--";
	level.morse_letters["X"] = "-..-";
	level.morse_letters["Y"] = "-.--";
	level.morse_letters["Z"] = "--..";
	level.morse_messages = [];
	level.morse_messages[0] = "WARN MESSINES";
	level.morse_messages[1] = "SOMETHING BLUE IN THE EARTH";
	level.morse_messages[2] = "NOT CLAY";
	level.morse_messages[3] = "WE GREW WEAK";
	level.morse_messages[4] = "THOUGHT IT WAS FLU";
	level.morse_messages[5] = "MEN BECAME BEASTS";
	level.morse_messages[6] = "BLOOD TURNED TO ASH";
	level.morse_messages[7] = "LIBERATE TUTE DE INFERNIS";
	level.cipher_key = "INFERNO";
}

/*
	Name: turn_all_lights_off
	Namespace: zm_tomb_ee_lights
	Checksum: 0x8B90E740
	Offset: 0xB38
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function turn_all_lights_off(a_discs)
{
	foreach(disc in a_discs)
	{
		disc zm_tomb_quest_crypt::bryce_cake_light_update(0);
	}
}

/*
	Name: turn_all_lights_on
	Namespace: zm_tomb_ee_lights
	Checksum: 0xF8128BC9
	Offset: 0xBD8
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function turn_all_lights_on(a_discs)
{
	foreach(disc in a_discs)
	{
		disc zm_tomb_quest_crypt::bryce_cake_light_update(1);
	}
}

/*
	Name: phrase_convert_to_cipher
	Namespace: zm_tomb_ee_lights
	Checksum: 0xA8CEC5F8
	Offset: 0xC78
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function phrase_convert_to_cipher(str_phrase, str_key)
{
	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	alphabet_vals = [];
	num = 0;
	for(i = 0; i < alphabet.size; i++)
	{
		letter = alphabet[i];
		alphabet_vals[letter] = num;
		num++;
	}
	encrypted_phrase = [];
	j = 0;
	for(i = 0; i < str_phrase.size; i++)
	{
		cipher_letter = str_key[j % str_key.size];
		original_letter = str_phrase[i];
		n_original_letter = alphabet_vals[original_letter];
		if(!isdefined(n_original_letter))
		{
			encrypted_phrase[encrypted_phrase.size] = original_letter;
			continue;
		}
		n_cipher_offset = alphabet_vals[cipher_letter];
		n_ciphered_letter = (n_original_letter + n_cipher_offset) % alphabet.size;
		encrypted_phrase[encrypted_phrase.size] = alphabet[n_ciphered_letter];
		j++;
	}
	return encrypted_phrase;
}

/*
	Name: light_show_morse
	Namespace: zm_tomb_ee_lights
	Checksum: 0xB4E90173
	Offset: 0xE30
	Size: 0x12E
	Parameters: 2
	Flags: Linked
*/
function light_show_morse(a_discs, message)
{
	for(i = 0; i < message.size; i++)
	{
		letter = message[i];
		letter_code = level.morse_letters[letter];
		if(isdefined(letter_code))
		{
			for(j = 0; j < letter_code.size; j++)
			{
				turn_all_lights_on(a_discs);
				if(letter_code[j] == ".")
				{
					wait(0.2);
				}
				else if(letter_code[j] == ("-"))
				{
					wait(1);
				}
				turn_all_lights_off(a_discs);
				wait(0.5);
			}
		}
		else
		{
			wait(2);
		}
		wait(1.5);
	}
}

