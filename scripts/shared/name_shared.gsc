// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace name;

/*
	Name: setup
	Namespace: name
	Checksum: 0xE2D80747
	Offset: 0x968
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function setup()
{
	/#
		assert(!isdefined(level.names));
	#/
	level.names = [];
	level.namesindex = [];
	if(!isdefined(level.script))
	{
		level.script = tolower(getdvarstring("mapname"));
	}
	initialize_nationality("american");
}

/*
	Name: initialize_nationality
	Namespace: name
	Checksum: 0xCEB216E4
	Offset: 0xA08
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function initialize_nationality(str_nationality)
{
	if(!isdefined(level.names[str_nationality]))
	{
		level.names[str_nationality] = [];
		if(str_nationality != "civilian")
		{
			add_nationality_names(str_nationality);
		}
		randomize_name_list(str_nationality);
		level.nameindex[str_nationality] = 0;
	}
}

/*
	Name: add_nationality_names
	Namespace: name
	Checksum: 0xE7494A12
	Offset: 0xA90
	Size: 0x18E
	Parameters: 1
	Flags: Linked
*/
function add_nationality_names(str_nationality)
{
	switch(str_nationality)
	{
		case "american":
		{
			american_names();
			break;
		}
		case "chinese":
		{
			chinese_names();
			break;
		}
		case "egyptian":
		{
			egyptian_names();
			break;
		}
		case "russian":
		{
			russian_names();
			break;
		}
		case "agent":
		{
			agent_names();
			break;
		}
		case "police":
		{
			police_names();
			break;
		}
		case "seal":
		{
			seal_names();
			break;
		}
		case "navy":
		{
			navy_names();
			break;
		}
		case "security":
		{
			security_names();
			break;
		}
		case "singapore_police":
		{
			sing_police_names();
			break;
		}
		default:
		{
			/#
				assertmsg("" + str_nationality);
			#/
			break;
		}
	}
}

/*
	Name: american_names
	Namespace: name
	Checksum: 0xF0D1768D
	Offset: 0xC28
	Size: 0xC84
	Parameters: 0
	Flags: Linked
*/
function american_names()
{
	add_name("american", "Adams");
	add_name("american", "Alexander");
	add_name("american", "Allen");
	add_name("american", "Anderson");
	add_name("american", "Bailey");
	add_name("american", "Baker");
	add_name("american", "Barnes");
	add_name("american", "Bell");
	add_name("american", "Bennett");
	add_name("american", "Brooks");
	add_name("american", "Brown");
	add_name("american", "Bryant");
	add_name("american", "Butler");
	add_name("american", "Campbell");
	add_name("american", "Carter");
	add_name("american", "Clark");
	add_name("american", "Coleman");
	add_name("american", "Collins");
	add_name("american", "Cook");
	add_name("american", "Cooper");
	add_name("american", "Cox");
	add_name("american", "Davis");
	add_name("american", "Diaz");
	add_name("american", "Edwards");
	add_name("american", "Evans");
	add_name("american", "Flores");
	add_name("american", "Foster");
	add_name("american", "Garcia");
	add_name("american", "Gonzales");
	add_name("american", "Gonzalez");
	add_name("american", "Gray");
	add_name("american", "Green");
	add_name("american", "Griffin");
	add_name("american", "Hall");
	add_name("american", "Harris");
	add_name("american", "Hayes");
	add_name("american", "Henderson");
	add_name("american", "Hernandez");
	add_name("american", "Hill");
	add_name("american", "Howard");
	add_name("american", "Hughes");
	add_name("american", "Jackson");
	add_name("american", "James");
	add_name("american", "Jenkins");
	add_name("american", "Johnson");
	add_name("american", "Jones");
	add_name("american", "Kelly");
	add_name("american", "King");
	add_name("american", "Lee");
	add_name("american", "Lewis");
	add_name("american", "Long");
	add_name("american", "Lopez");
	add_name("american", "Martin");
	add_name("american", "Martinez");
	add_name("american", "Miller");
	add_name("american", "Mitchell");
	add_name("american", "Moore");
	add_name("american", "Morgan");
	add_name("american", "Morris");
	add_name("american", "Murphy");
	add_name("american", "Nelson");
	add_name("american", "Parker");
	add_name("american", "Patterson");
	add_name("american", "Perez");
	add_name("american", "Perry");
	add_name("american", "Peterson");
	add_name("american", "Phillips");
	add_name("american", "Powell");
	add_name("american", "Price");
	add_name("american", "Ramirez");
	add_name("american", "Reed");
	add_name("american", "Richardson");
	add_name("american", "Rivera");
	add_name("american", "Roberts");
	add_name("american", "Robinson");
	add_name("american", "Rodriguez");
	add_name("american", "Rogers");
	add_name("american", "Ross");
	add_name("american", "Russell");
	add_name("american", "Sanchez");
	add_name("american", "Sanders");
	add_name("american", "Scott");
	add_name("american", "Simmons");
	add_name("american", "Smith");
	add_name("american", "Stewart");
	add_name("american", "Taylor");
	add_name("american", "Thomas");
	add_name("american", "Thompson");
	add_name("american", "Torres");
	add_name("american", "Turner");
	add_name("american", "Walker");
	add_name("american", "Ward");
	add_name("american", "Washington");
	add_name("american", "Watson");
	add_name("american", "White");
	add_name("american", "Williams");
	add_name("american", "Wilson");
	add_name("american", "Wood");
	add_name("american", "Wright");
	add_name("american", "Young");
}

/*
	Name: egyptian_names
	Namespace: name
	Checksum: 0xBBA18C97
	Offset: 0x18B8
	Size: 0xAC4
	Parameters: 0
	Flags: Linked
*/
function egyptian_names()
{
	add_name("egyptian", "Ababneh");
	add_name("egyptian", "Abba");
	add_name("egyptian", "Abbas");
	add_name("egyptian", "Abdel");
	add_name("egyptian", "Abdellah");
	add_name("egyptian", "Abdul");
	add_name("egyptian", "Abdulah");
	add_name("egyptian", "Abdullah");
	add_name("egyptian", "Abolhassan");
	add_name("egyptian", "Ahmad");
	add_name("egyptian", "Ahmed");
	add_name("egyptian", "Alam");
	add_name("egyptian", "Ali");
	add_name("egyptian", "Ameen");
	add_name("egyptian", "Amin");
	add_name("egyptian", "Armanjani");
	add_name("egyptian", "Awad");
	add_name("egyptian", "Ayasha");
	add_name("egyptian", "Aziz");
	add_name("egyptian", "Bari");
	add_name("egyptian", "Essa");
	add_name("egyptian", "Habib");
	add_name("egyptian", "Hadad");
	add_name("egyptian", "Haddad");
	add_name("egyptian", "Hamdan");
	add_name("egyptian", "Hamid");
	add_name("egyptian", "Hana");
	add_name("egyptian", "Hanna");
	add_name("egyptian", "Hasan");
	add_name("egyptian", "Hassan");
	add_name("egyptian", "Hossein");
	add_name("egyptian", "Hussain");
	add_name("egyptian", "Ibraheem");
	add_name("egyptian", "Ibrahim");
	add_name("egyptian", "Isa");
	add_name("egyptian", "Ismail");
	add_name("egyptian", "Issa");
	add_name("egyptian", "Jaber");
	add_name("egyptian", "Jabir");
	add_name("egyptian", "Karim");
	add_name("egyptian", "Khatib");
	add_name("egyptian", "Khoury");
	add_name("egyptian", "Mahmad");
	add_name("egyptian", "Mahmood");
	add_name("egyptian", "Mahmoud");
	add_name("egyptian", "Malik");
	add_name("egyptian", "Mansoor");
	add_name("egyptian", "Mansour");
	add_name("egyptian", "Mazin");
	add_name("egyptian", "Mousa");
	add_name("egyptian", "Murat");
	add_name("egyptian", "Musa");
	add_name("egyptian", "Mustafa");
	add_name("egyptian", "Najeeb");
	add_name("egyptian", "Najjar");
	add_name("egyptian", "Naser");
	add_name("egyptian", "Nasser");
	add_name("egyptian", "Omar");
	add_name("egyptian", "Omer");
	add_name("egyptian", "Ommar");
	add_name("egyptian", "Qasem");
	add_name("egyptian", "Qasim");
	add_name("egyptian", "Qassem");
	add_name("egyptian", "Rahman");
	add_name("egyptian", "Rasheed");
	add_name("egyptian", "Rashid");
	add_name("egyptian", "Saad");
	add_name("egyptian", "Sad");
	add_name("egyptian", "Salah");
	add_name("egyptian", "Saleh");
	add_name("egyptian", "Salih");
	add_name("egyptian", "Salman");
	add_name("egyptian", "Sam");
	add_name("egyptian", "Shadi");
	add_name("egyptian", "Shaheen");
	add_name("egyptian", "Shahriar");
	add_name("egyptian", "Shareef");
	add_name("egyptian", "Sharif");
	add_name("egyptian", "Sleiman");
	add_name("egyptian", "Sulaiman");
	add_name("egyptian", "Sulayman");
	add_name("egyptian", "Temiz");
	add_name("egyptian", "Turk");
	add_name("egyptian", "Yaseen");
	add_name("egyptian", "Yousef");
	add_name("egyptian", "Yousif");
}

/*
	Name: sing_police_names
	Namespace: name
	Checksum: 0x89223C52
	Offset: 0x2388
	Size: 0x504
	Parameters: 0
	Flags: Linked
*/
function sing_police_names()
{
	add_name("singapore_police", "Ang");
	add_name("singapore_police", "Chan");
	add_name("singapore_police", "Chen");
	add_name("singapore_police", "Chia");
	add_name("singapore_police", "Chong");
	add_name("singapore_police", "Chua");
	add_name("singapore_police", "Feng");
	add_name("singapore_police", "He");
	add_name("singapore_police", "Ho");
	add_name("singapore_police", "Jau");
	add_name("singapore_police", "Kao");
	add_name("singapore_police", "Kiu");
	add_name("singapore_police", "Koh");
	add_name("singapore_police", "Lee");
	add_name("singapore_police", "Liang");
	add_name("singapore_police", "Lim");
	add_name("singapore_police", "Low");
	add_name("singapore_police", "Lu");
	add_name("singapore_police", "Ma");
	add_name("singapore_police", "Meng");
	add_name("singapore_police", "Ng");
	add_name("singapore_police", "Ong");
	add_name("singapore_police", "Pan");
	add_name("singapore_police", "Shi");
	add_name("singapore_police", "Sim");
	add_name("singapore_police", "Suen");
	add_name("singapore_police", "Sun");
	add_name("singapore_police", "Tan");
	add_name("singapore_police", "Tay");
	add_name("singapore_police", "Teo");
	add_name("singapore_police", "Toh");
	add_name("singapore_police", "Tuan");
	add_name("singapore_police", "Wong");
	add_name("singapore_police", "Wu");
	add_name("singapore_police", "Xie");
	add_name("singapore_police", "Yeo");
	add_name("singapore_police", "Yu");
	add_name("singapore_police", "Zhang");
	add_name("singapore_police", "Zhao");
	add_name("singapore_police", "Zhu");
}

/*
	Name: russian_names
	Namespace: name
	Checksum: 0x5D31FAE2
	Offset: 0x2898
	Size: 0x3C4
	Parameters: 0
	Flags: Linked
*/
function russian_names()
{
	add_name("russian", "Avtamonov");
	add_name("russian", "Barzilovich");
	add_name("russian", "Blyakher");
	add_name("russian", "Bulenkov");
	add_name("russian", "Datsyuk");
	add_name("russian", "Diakov");
	add_name("russian", "Dvilyansky");
	add_name("russian", "Dymarsky");
	add_name("russian", "Fedorova");
	add_name("russian", "Gerasimov");
	add_name("russian", "Ilyin");
	add_name("russian", "Ikonnikov");
	add_name("russian", "Kosteltsev");
	add_name("russian", "Krasilnikov");
	add_name("russian", "Lukin");
	add_name("russian", "Maximov");
	add_name("russian", "Melnikov");
	add_name("russian", "Nesterov");
	add_name("russian", "Pelov");
	add_name("russian", "Polubencev");
	add_name("russian", "Pokrovsky");
	add_name("russian", "Repin");
	add_name("russian", "Romanenko");
	add_name("russian", "Saslovsky");
	add_name("russian", "Sidorenko");
	add_name("russian", "Touevsky");
	add_name("russian", "Vakhitov");
	add_name("russian", "Yakubov");
	add_name("russian", "Yoslov");
	add_name("russian", "Zubarev");
}

/*
	Name: agent_names
	Namespace: name
	Checksum: 0xB24D179D
	Offset: 0x2C68
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function agent_names()
{
	add_name("agent", "Bailey");
	add_name("agent", "Campbell");
	add_name("agent", "Collins");
	add_name("agent", "Cook");
	add_name("agent", "Cooper");
	add_name("agent", "Edwards");
	add_name("agent", "Evans");
	add_name("agent", "Gray");
	add_name("agent", "Howard");
	add_name("agent", "Morgan");
	add_name("agent", "Morris");
	add_name("agent", "Murphy");
	add_name("agent", "Phillips");
	add_name("agent", "Rivera");
	add_name("agent", "Roberts");
	add_name("agent", "Rogers");
	add_name("agent", "Stewart");
	add_name("agent", "Torres");
	add_name("agent", "Turner");
	add_name("agent", "Ward");
}

/*
	Name: chinese_names
	Namespace: name
	Checksum: 0x16AFD882
	Offset: 0x2EF8
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function chinese_names()
{
	add_name("chinese", "Chan");
	add_name("chinese", "Cheng");
	add_name("chinese", "Chiang");
	add_name("chinese", "Feng");
	add_name("chinese", "Guan");
	add_name("chinese", "Hu");
	add_name("chinese", "Lai");
	add_name("chinese", "Leung");
	add_name("chinese", "Wu");
	add_name("chinese", "Zheng");
}

/*
	Name: navy_names
	Namespace: name
	Checksum: 0x1EED7813
	Offset: 0x3048
	Size: 0x264
	Parameters: 0
	Flags: Linked
*/
function navy_names()
{
	add_name("navy", "Buckner");
	add_name("navy", "Coffey");
	add_name("navy", "Dashnaw");
	add_name("navy", "Dobson");
	add_name("navy", "Frank");
	add_name("navy", "Frey");
	add_name("navy", "Howe");
	add_name("navy", "Johns");
	add_name("navy", "Lee");
	add_name("navy", "Lockhart");
	add_name("navy", "Moon");
	add_name("navy", "Paiser");
	add_name("navy", "Preston");
	add_name("navy", "Reyes");
	add_name("navy", "Slater");
	add_name("navy", "Waller");
	add_name("navy", "Wong");
	add_name("navy", "Velasquez");
	add_name("navy", "York");
}

/*
	Name: police_names
	Namespace: name
	Checksum: 0x1923C5C0
	Offset: 0x32B8
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function police_names()
{
	add_name("police", "Anderson");
	add_name("police", "Brown");
	add_name("police", "Davis");
	add_name("police", "Garcia");
	add_name("police", "Harris");
	add_name("police", "Jackson");
	add_name("police", "Johnson");
	add_name("police", "Jones");
	add_name("police", "Martin");
	add_name("police", "Martinez");
	add_name("police", "Miller");
	add_name("police", "Moore");
	add_name("police", "Robinson");
	add_name("police", "Smith");
	add_name("police", "Taylor");
	add_name("police", "Thomas");
	add_name("police", "Thompson");
	add_name("police", "White");
	add_name("police", "Williams");
	add_name("police", "Wilson");
}

/*
	Name: security_names
	Namespace: name
	Checksum: 0xEC0784FF
	Offset: 0x3548
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function security_names()
{
	add_name("security", "Anderson");
	add_name("security", "Brown");
	add_name("security", "Davis");
	add_name("security", "Garcia");
	add_name("security", "Harris");
	add_name("security", "Jackson");
	add_name("security", "Johnson");
	add_name("security", "Jones");
	add_name("security", "Martin");
	add_name("security", "Martinez");
	add_name("security", "Miller");
	add_name("security", "Moore");
	add_name("security", "Robinson");
	add_name("security", "Smith");
	add_name("security", "Taylor");
	add_name("security", "Thomas");
	add_name("security", "Thompson");
	add_name("security", "White");
	add_name("security", "Williams");
	add_name("security", "Wilson");
}

/*
	Name: seal_names
	Namespace: name
	Checksum: 0xCA84922B
	Offset: 0x37D8
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function seal_names()
{
	add_name("seal", "Adams");
	add_name("seal", "Carter");
	add_name("seal", "Gonzalez");
	add_name("seal", "Green");
	add_name("seal", "Hall");
	add_name("seal", "Hill");
	add_name("seal", "Hernandez");
	add_name("seal", "King");
	add_name("seal", "Lee");
	add_name("seal", "Lewis");
	add_name("seal", "Lopez");
	add_name("seal", "Maestas");
	add_name("seal", "Mitchell");
	add_name("seal", "Nelson");
	add_name("seal", "Rodriguez");
	add_name("seal", "Scott");
	add_name("seal", "Walker");
	add_name("seal", "Weichert");
	add_name("seal", "Wright");
	add_name("seal", "Young");
}

/*
	Name: add_name
	Namespace: name
	Checksum: 0x69BF28A4
	Offset: 0x3A68
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function add_name(nationality, thename)
{
	level.names[nationality][level.names[nationality].size] = thename;
}

/*
	Name: randomize_name_list
	Namespace: name
	Checksum: 0x9F423341
	Offset: 0x3AA8
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function randomize_name_list(nationality)
{
	size = level.names[nationality].size;
	for(i = 0; i < size; i++)
	{
		switchwith = randomint(size);
		temp = level.names[nationality][i];
		level.names[nationality][i] = level.names[nationality][switchwith];
		level.names[nationality][switchwith] = temp;
	}
}

/*
	Name: get
	Namespace: name
	Checksum: 0x70E58162
	Offset: 0x3B88
	Size: 0x362
	Parameters: 1
	Flags: Linked
*/
function get(override)
{
	if(!isdefined(override) && level.script == "credits")
	{
		self.airank = "private";
		self notify(#"hash_47341e47");
		return;
	}
	if(isdefined(self.script_friendname))
	{
		if(self.script_friendname == "none")
		{
			self.propername = "";
		}
		else
		{
			self.propername = self.script_friendname;
			getrankfromname(self.propername);
		}
		self notify(#"hash_47341e47");
		return;
	}
	/#
		assert(isdefined(level.names));
	#/
	str_classname = self get_ai_classname();
	str_nationality = "american";
	if(issubstr(str_classname, "_civilian_"))
	{
		self.airank = "none";
		str_nationality = "civilian";
	}
	else
	{
		if(self is_special_agent_member(str_classname))
		{
			str_nationality = "agent";
		}
		else
		{
			if(issubstr(str_classname, "_sco_"))
			{
				self.airank = "none";
				str_nationality = "chinese";
			}
			else
			{
				if(issubstr(str_classname, "_egypt_"))
				{
					str_nationality = "egyptian";
				}
				else
				{
					if(self is_police_member(str_classname))
					{
						str_nationality = "police";
					}
					else
					{
						if(self is_seal_member(str_classname))
						{
							str_nationality = "seal";
						}
						else
						{
							if(self is_navy_member(str_classname))
							{
								str_nationality = "navy";
							}
							else
							{
								if(self is_security_member(str_classname))
								{
									str_nationality = "security";
								}
								else
								{
									if(issubstr(str_classname, "_soviet_"))
									{
										self.airank = "none";
										str_nationality = "russian";
									}
									else if(issubstr(str_classname, "_ally_sing_"))
									{
										str_nationality = "singapore_police";
									}
								}
							}
						}
					}
				}
			}
		}
	}
	initialize_nationality(str_nationality);
	get_name_for_nationality(str_nationality);
	self notify(#"hash_47341e47");
}

/*
	Name: get_ai_classname
	Namespace: name
	Checksum: 0x87EB8E50
	Offset: 0x3EF8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function get_ai_classname()
{
	if(isdefined(self.dr_ai_classname))
	{
		str_classname = tolower(self.dr_ai_classname);
	}
	else
	{
		str_classname = tolower(self.classname);
	}
	return str_classname;
}

/*
	Name: add_override_name_func
	Namespace: name
	Checksum: 0x21AAC143
	Offset: 0x3F60
	Size: 0x6E
	Parameters: 2
	Flags: None
*/
function add_override_name_func(nationality, func)
{
	if(!isdefined(level._override_name_funcs))
	{
		level._override_name_funcs = [];
	}
	/#
		assert(!isdefined(level._override_name_funcs[nationality]), "");
	#/
	level._override_name_funcs[nationality] = func;
}

/*
	Name: get_name_for_nationality
	Namespace: name
	Checksum: 0x87CDB0D9
	Offset: 0x3FD8
	Size: 0x458
	Parameters: 1
	Flags: Linked
*/
function get_name_for_nationality(nationality)
{
	/#
		assert(isdefined(level.nameindex[nationality]), nationality);
	#/
	if(isdefined(level._override_name_funcs) && isdefined(level._override_name_funcs[nationality]))
	{
		self.propername = [[level._override_name_funcs[nationality]]]();
		self.airank = "";
		return;
	}
	if(nationality == "civilian")
	{
		self.propername = "";
		return;
	}
	level.nameindex[nationality] = (level.nameindex[nationality] + 1) % level.names[nationality].size;
	lastname = level.names[nationality][level.nameindex[nationality]];
	if(!isdefined(lastname))
	{
		lastname = "";
	}
	if(isdefined(level._override_rank_func))
	{
		self [[level._override_rank_func]](lastname);
	}
	else
	{
		if(isdefined(self.airank) && self.airank == "none")
		{
			self.propername = lastname;
			return;
		}
		rank = randomint(100);
		if(nationality == "seal")
		{
			if(rank > 20)
			{
				fullname = "PO " + lastname;
				self.airank = "petty officer";
			}
			else
			{
				if(rank > 10)
				{
					fullname = "CPO " + lastname;
					self.airank = "chief petty officer";
				}
				else
				{
					fullname = "Lt. " + lastname;
					self.airank = "lieutenant";
				}
			}
		}
		else
		{
			if(nationality == "navy")
			{
				if(rank > 60)
				{
					fullname = "SN " + lastname;
					self.airank = "seaman";
				}
				else
				{
					if(rank > 20)
					{
						fullname = "PO " + lastname;
						self.airank = "petty officer";
					}
					else
					{
						fullname = "CPO " + lastname;
						self.airank = "chief petty officer";
					}
				}
			}
			else
			{
				if(nationality == "police")
				{
					fullname = "Officer " + lastname;
					self.airank = "police officer";
				}
				else
				{
					if(nationality == "agent")
					{
						fullname = "Agent " + lastname;
						self.airank = "special agent";
					}
					else
					{
						if(nationality == "security")
						{
							fullname = "Officer " + lastname;
						}
						else
						{
							if(nationality == "singapore_police")
							{
								fullname = "Officer " + lastname;
								self.airank = "police officer";
							}
							else
							{
								if(rank > 20)
								{
									fullname = "Pvt. " + lastname;
									self.airank = "private";
								}
								else
								{
									if(rank > 10)
									{
										fullname = "Cpl. " + lastname;
										self.airank = "corporal";
									}
									else
									{
										fullname = "Sgt. " + lastname;
										self.airank = "sergeant";
									}
								}
							}
						}
					}
				}
			}
		}
		self.propername = fullname;
	}
}

/*
	Name: is_seal_member
	Namespace: name
	Checksum: 0x60767386
	Offset: 0x4438
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_seal_member(str_classname)
{
	if(issubstr(str_classname, "_seal_"))
	{
		return true;
	}
	return false;
}

/*
	Name: is_navy_member
	Namespace: name
	Checksum: 0x679CBBB5
	Offset: 0x4480
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_navy_member(str_classname)
{
	if(issubstr(str_classname, "_navy_"))
	{
		return true;
	}
	return false;
}

/*
	Name: is_police_member
	Namespace: name
	Checksum: 0x373B55B4
	Offset: 0x44C8
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function is_police_member(str_classname)
{
	if(issubstr(str_classname, "_lapd_") || issubstr(str_classname, "_swat_"))
	{
		return true;
	}
	return false;
}

/*
	Name: is_security_member
	Namespace: name
	Checksum: 0xBF058CA
	Offset: 0x4530
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function is_security_member(str_classname)
{
	if(issubstr(str_classname, "_security_"))
	{
		return true;
	}
	return false;
}

/*
	Name: is_special_agent_member
	Namespace: name
	Checksum: 0x670E11E2
	Offset: 0x4570
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_special_agent_member(str_classname)
{
	if(issubstr(str_classname, "_sstactical_"))
	{
		return true;
	}
	return false;
}

/*
	Name: getrankfromname
	Namespace: name
	Checksum: 0x91AE2455
	Offset: 0x45B8
	Size: 0x186
	Parameters: 1
	Flags: Linked
*/
function getrankfromname(name)
{
	if(!isdefined(name))
	{
		self.airank = "private";
	}
	tokens = strtok(name, " ");
	/#
		assert(tokens.size);
	#/
	shortrank = tokens[0];
	switch(shortrank)
	{
		case "Pvt.":
		{
			self.airank = "private";
			break;
		}
		case "Pfc.":
		{
			self.airank = "private";
			break;
		}
		case "Cpl.":
		{
			self.airank = "corporal";
			break;
		}
		case "Sgt.":
		{
			self.airank = "sergeant";
			break;
		}
		case "Lt.":
		{
			self.airank = "lieutenant";
			break;
		}
		case "Cpt.":
		{
			self.airank = "captain";
			break;
		}
		default:
		{
			/#
				println(("" + shortrank) + "");
			#/
			self.airank = "private";
			break;
		}
	}
}

/*
	Name: issubstr_match_any
	Namespace: name
	Checksum: 0x1522352F
	Offset: 0x4748
	Size: 0xCC
	Parameters: 2
	Flags: None
*/
function issubstr_match_any(str_match, str_search_array)
{
	/#
		assert(str_search_array.size, "");
	#/
	foreach(str_search in str_search_array)
	{
		if(issubstr(str_match, str_search))
		{
			return true;
		}
	}
	return false;
}

