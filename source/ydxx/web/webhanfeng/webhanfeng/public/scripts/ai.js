var CYCLE_TIME = {"hour" : 1, "day" : 2, "month" : 3, "season" : 4, "year" : 5}
var RES = {1 : "food", 2 : "wood", 3 : "iron", 4 : "copper", 5 : "silver", 6 : "gold", 7 : "horse", 8 : "skin", 9 : "muscle", 10 : "money"}
var RES_CONSUME = {"people_def" : 0, "people_food" : 1, "solider_def" : 0, "solider_food" : 2}
var MAX_VALUES = {"trade_dev" : 100, "city_peace" : 100, "kongfu" : 100, "speed" : 100, "polity" : 100, "intelligence" : 100, "train" : 100, "spirit" : 100}
var WEAPON = {
            1 : {"name" : "sword", "iron" : 15, "wood" : 0, "skin" : 0, "muscle" : 0, "money" : 100, "made" : 10}, 
            2 : {"name" : "halberd", "iron" : 5, "wood" : 18, "skin" : 0, "muscle" : 0, "money" : 100, "made" : 15}, 
            3 : {"name" : "shield", "iron" : 3, "wood" : 5, "skin" : 0, "muscle" : 0, "money" : 300, "made" : 5}, 
            4 : {"name" : "leather", "iron" : 5, "wood" : 0, "skin" : 3, "muscle" : 0, "money" : 400, "made" : 20}, 
            5 : {"name" : "armour", "iron" : 25, "wood" : 0, "skin" : 1, "muscle" : 0, "money" : 1000, "made" : 50}, 
            6 : {"name" : "hnaid", "iron" : 0, "wood" : 5, "skin" : 0, "muscle" : 0, "money" : 1000, "made" : 50}, 
            7 : {"name" : "engine", "iron" : 100, "wood" : 200, "skin" : 0, "muscle" : 0, "money" : 10000, "made" : 500}, 
            8 : {"name" : "warship", "iron" : 500, "wood" : 3000, "skin" : 0, "muscle" : 0, "money" : 20000, "made" : 1000}, 
            9 : {"name" : "arrow", "iron" : 1, "wood" : 1, "skin" : 0, "muscle" : 0, "money" : 20, "made" : 1}
        }
var SOLIDER_TYPE = {
				0 :  {"name" : "none",       "res1_id" : 0,  "res1_num" : 0,    "res2_id" : 0, "res2_num" : 0, "weapon1_id" : 0, "weapon1_num" : 0,   "weapon2_id" : 0, "weapon2_num" : 0, "weapon3_id" : 0, "weapon3_num" : 0, "food" : 0,   "money" : 0,    "speed" : 5,  "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1}, 
				1 :  {"name" : "sword",      "res1_id" : 10, "res1_num" : 60,   "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 1, "weapon1_num" : 1,   "weapon2_id" : 3, "weapon2_num" : 1, "weapon3_id" : 4, "weapon3_num" : 1, "food" : 2,   "money" : 20,   "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1}, 
				2 :  {"name" : "halberd",    "res1_id" : 10, "res1_num" : 90,   "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 2, "weapon1_num" : 1,   "weapon2_id" : 3, "weapon2_num" : 0, "weapon3_id" : 5, "weapon3_num" : 1, "food" : 2,   "money" : 20,   "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1}, 
				3 :  {"name" : "hnaid",      "res1_id" : 10, "res1_num" : 90,   "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 6, "weapon1_num" : 1,   "weapon2_id" : 1, "weapon2_num" : 1, "weapon3_id" : 4, "weapon3_num" : 1, "food" : 2,   "money" : 30,   "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 3},  
				4 :  {"name" : "cavalry",    "res1_id" : 10, "res1_num" : 180,  "res2_id" : 7, "res2_num" : 1, "weapon1_id" : 2, "weapon1_num" : 1,   "weapon2_id" : 1, "weapon2_num" : 1, "weapon3_id" : 5, "weapon3_num" : 1, "food" : 2,   "money" : 60,   "speed" : 20, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				5 :  {"name" : "engine",     "res1_id" : 10, "res1_num" : 1800, "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 4, "weapon1_num" : 20,  "weapon2_id" : 7, "weapon2_num" : 1, "weapon3_id" : 8, "weapon3_num" : 0, "food" : 40,  "money" : 600,  "speed" : 5,  "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				6 :  {"name" : "warship",    "res1_id" : 10, "res1_num" : 6000, "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 6, "weapon1_num" : 100, "weapon2_id" : 8, "weapon2_num" : 1, "weapon3_id" : 1, "weapon3_num" : 0, "food" : 200, "money" : 2000, "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 3},  
				7 :  {"name" : "tengjia",    "res1_id" : 10, "res1_num" : 180,  "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 1, "weapon1_num" : 1,   "weapon2_id" : 3, "weapon2_num" : 1, "weapon3_id" : 4, "weapon3_num" : 0, "food" : 2,   "money" : 60,   "speed" : 15, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				8 :  {"name" : "huangjin",   "res1_id" : 10, "res1_num" : 30,   "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 1, "weapon1_num" : 1,   "weapon2_id" : 3, "weapon2_num" : 0, "weapon3_id" : 4, "weapon3_num" : 1, "food" : 1,   "money" : 10,   "speed" : 15, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				9 :  {"name" : "qingzhou",   "res1_id" : 10, "res1_num" : 90,   "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 1, "weapon1_num" : 1,   "weapon2_id" : 3, "weapon2_num" : 1, "weapon3_id" : 4, "weapon3_num" : 1, "food" : 3,   "money" : 30,   "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				10 : {"name" : "xiliang",    "res1_id" : 10, "res1_num" : 270,  "res2_id" : 7, "res2_num" : 1, "weapon1_id" : 2, "weapon1_num" : 1,   "weapon2_id" : 1, "weapon2_num" : 1, "weapon3_id" : 5, "weapon3_num" : 1, "food" : 3,   "money" : 90,   "speed" : 20, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				11 : {"name" : "zhuge",      "res1_id" : 10, "res1_num" : 135,  "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 6, "weapon1_num" : 1,   "weapon2_id" : 1, "weapon2_num" : 1, "weapon3_id" : 4, "weapon3_num" : 1, "food" : 3,   "money" : 45,   "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 3},  
				12 : {"name" : "mangonel",   "res1_id" : 10, "res1_num" : 2700, "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 4, "weapon1_num" : 20,  "weapon2_id" : 7, "weapon2_num" : 1, "weapon3_id" : 8, "weapon3_num" : 0, "food" : 60,  "money" : 900,  "speed" : 5,  "attack" : 0, "defense" : 0, "life" : 0, "distance" : 1},  
				13 : {"name" : "battleship", "res1_id" : 10, "res1_num" : 9000, "res2_id" : 7, "res2_num" : 0, "weapon1_id" : 6, "weapon1_num" : 100, "weapon2_id" : 8, "weapon2_num" : 1, "weapon3_id" : 1, "weapon3_num" : 0, "food" : 300, "money" : 3000, "speed" : 10, "attack" : 0, "defense" : 0, "life" : 0, "distance" : 3}
			}

var SOLIDER_TYPE_REQ = {
                    1 : {"money" : 60, "horse" : 0, "sword" : 1,"halberd" : 0,"shield" : 1,"leather" : 1,"armour" : 0,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    2 : {"money" : 60, "horse" : 0, "sword" : 0,"halberd" : 1,"shield" : 0,"leather" : 1,"armour" : 0,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    3 : {"money" : 90, "horse" : 0, "sword" : 0,"halberd" : 0,"shield" : 0,"leather" : 1,"armour" : 0,"hnaid" : 1,"engine" : 0,"warship" : 0,"arrow" : 1},
                    4 : {"money" : 180, "horse" : 1, "sword" : 1,"halberd" : 0,"shield" : 0,"leather" : 0,"armour" : 1,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    5 : {"money" : 1800, "horse" : 0, "sword" : 0,"halberd" : 0,"shield" : 0,"leather" : 20,"armour" : 0,"hnaid" : 0,"engine" : 1,"warship" : 0,"arrow" : 0},
                    6 : {"money" : 6000, "horse" : 0, "sword" : 0,"halberd" : 0,"shield" : 0,"leather" : 0,"armour" : 0,"hnaid" : 100,"engine" : 0,"warship" : 1,"arrow" : 100},
                    7 : {"money" : 180, "horse" : 0, "sword" : 1,"halberd" : 0,"shield" : 1,"leather" : 0,"armour" : 0,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    8 : {"money" : 30, "horse" : 0, "sword" : 1,"halberd" : 0,"shield" : 0,"leather" : 1,"armour" : 0,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    9 : {"money" : 90, "horse" : 0, "sword" : 0,"halberd" : 1,"shield" : 0,"leather" : 0,"armour" : 1,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    10 : {"money" : 270, "horse" : 1, "sword" : 0,"halberd" : 1,"shield" : 0,"leather" : 0,"armour" : 1,"hnaid" : 0,"engine" : 0,"warship" : 0,"arrow" : 0},
                    11 : {"money" : 135, "horse" : 0, "sword" : 0,"halberd" : 0,"shield" : 0,"leather" : 1,"armour" : 0,"hnaid" : 1,"engine" : 0,"warship" : 0,"arrow" : 3},
                    12 : {"money" : 2700, "horse" : 0, "sword" : 0,"halberd" : 0,"shield" : 0,"leather" : 20,"armour" : 0,"hnaid" : 0,"engine" : 1,"warship" : 0,"arrow" : 0},
                    13 : {"money" : 9000, "horse" : 0, "sword" : 0,"halberd" : 0,"shield" : 0,"leather" : 0,"armour" : 0,"hnaid" : 100,"engine" : 0,"warship" : 1,"arrow" : 300}
                    }
			
var PLAN = {
		1 : {"name" : "hg", "money" : 2000, "food" : 0, "wood" : 10, "iron" : 0},
		2 : {"name" : "mf", "money" : 0, "food" : 0, "wood" : 0, "iron" : 0},
		3 : {"name" : "fj", "money" : 1000, "food" : 0, "wood" : 0, "iron" : 0},
		4 : {"name" : "yy", "money" : 1000, "food" : 0, "wood" : 0, "iron" : 0},
		5 : {"name" : "xj", "money" : 0, "food" : 0, "wood" : 0, "iron" : 0},
		6 : {"name" : "rm", "money" : 1000, "food" : 0, "wood" : 0, "iron" : 0},
		7 : {"name" : "gw", "money" : 2000, "food" : 0, "wood" : 0, "iron" : 0},
		8 : {"name" : "dhls", "money" : 0, "food" : 0, "wood" : 0, "iron" : 0},
		9 : {"name" : "jctq", "money" : 0, "food" : 0, "wood" : 0, "iron" : 0},
		10 : {"name" : "sdjx", "money" : 0, "food" : 0, "wood" : 0, "iron" : 0},
		11 : {"name" : "ay", "money" : 0, "food" : 0, "wood" : 0, "iron" : 0}
		}
	
DIGNITIE = {
			1 : {"name" : "wu", "point" : 0, "office_id" : 2, "follows" : 2000},
			2 : {"name" : "nan", "point" : 5, "office_id" : 2, "follows" : 2500},
			3 : {"name" : "zi", "point" : 20, "office_id" : 2, "follows" : 3000},
			4 : {"name" : "bo", "point" : 40, "office_id" : 2, "follows" : 3500},
			5 : {"name" : "hou", "point" : 75, "office_id" : 3, "follows" : 4000},
			6 : {"name" : "gong", "point" : 150, "office_id" : 3, "follows" : 4500},
			7 : {"name" : "wang", "point" : 250, "office_id" : 4, "follows" : 5000}
			}

OFFICE = {
			1 : {"name" : "xianling", "max_general" : 0, "min_jun" : 0},
			2 : {"name" : "taishou", "max_general" : 25, "min_jun" : 1},
			3 : {"name" : "zhoumu", "max_general" : 150, "min_jun" : 8},
			4 : {"name" : "wang", "max_general" : 450, "min_jun" : 50},
			5 : {"name" : "king", "max_general" : 5000, "min_jun" : 100}
			}

OFFICIAL = {
			1 : {"dignitie_id" : 2, "type" : 0,  "follows" : 1500, "kongfu" : 1, "speed" : 0, "polity" : 0, "intelligence" : 0},
			2 : {"dignitie_id" : 2, "type" : 0,  "follows" : 1500, "kongfu" : 1, "speed" : 0, "polity" : 0, "intelligence" : 0},
			3 : {"dignitie_id" : 2, "type" : 0,  "follows" : 1500, "kongfu" : 1, "speed" : 0, "polity" : 0, "intelligence" : 0},
			4 : {"dignitie_id" : 2, "type" : 0,  "follows" : 1500, "kongfu" : 1, "speed" : 0, "polity" : 0, "intelligence" : 0},
			5 : {"dignitie_id" : 2, "type" : 1,  "follows" : 1500, "kongfu" : 0, "speed" : 0, "polity" : 1, "intelligence" : 0},
			6 : {"dignitie_id" : 2, "type" : 1,  "follows" : 1500, "kongfu" : 0, "speed" : 0, "polity" : 1, "intelligence" : 0},
			7 : {"dignitie_id" : 2, "type" : 1,  "follows" : 1500, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 1},
			8 : {"dignitie_id" : 2, "type" : 1,  "follows" : 1500, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 1},
			9 : {"dignitie_id" : 3, "type" : 0,  "follows" : 2000, "kongfu" : 2, "speed" : 0, "polity" : 0, "intelligence" : 0},
			10 : {"dignitie_id" : 3, "type" : 0, "follows" : 2000, "kongfu" : 2, "speed" : 0, "polity" : 0, "intelligence" : 0},
			11 : {"dignitie_id" : 3, "type" : 0, "follows" : 2000, "kongfu" : 2, "speed" : 0, "polity" : 0, "intelligence" : 0},
			12 : {"dignitie_id" : 3, "type" : 0, "follows" : 2000, "kongfu" : 2, "speed" : 0, "polity" : 0, "intelligence" : 0},
			13 : {"dignitie_id" : 3, "type" : 1, "follows" : 2000, "kongfu" : 0, "speed" : 0, "polity" : 2, "intelligence" : 0},
			14 : {"dignitie_id" : 3, "type" : 1, "follows" : 2000, "kongfu" : 0, "speed" : 0, "polity" : 2, "intelligence" : 0},
			15 : {"dignitie_id" : 3, "type" : 1, "follows" : 2000, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 2},
			16 : {"dignitie_id" : 3, "type" : 1, "follows" : 2000, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 2},
			17 : {"dignitie_id" : 4, "type" : 0, "follows" : 2500, "kongfu" : 3, "speed" : 0, "polity" : 0, "intelligence" : 0},
			18 : {"dignitie_id" : 4, "type" : 0, "follows" : 2500, "kongfu" : 3, "speed" : 0, "polity" : 0, "intelligence" : 0},
			19 : {"dignitie_id" : 4, "type" : 0, "follows" : 2500, "kongfu" : 3, "speed" : 0, "polity" : 0, "intelligence" : 0},
			20 : {"dignitie_id" : 4, "type" : 0, "follows" : 2500, "kongfu" : 3, "speed" : 0, "polity" : 0, "intelligence" : 0},
			21 : {"dignitie_id" : 4, "type" : 1, "follows" : 2500, "kongfu" : 0, "speed" : 0, "polity" : 3, "intelligence" : 0},
			22 : {"dignitie_id" : 4, "type" : 1, "follows" : 2500, "kongfu" : 0, "speed" : 0, "polity" : 3, "intelligence" : 0},
			23 : {"dignitie_id" : 4, "type" : 1, "follows" : 2500, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 3},
			24 : {"dignitie_id" : 4, "type" : 1, "follows" : 2500, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 3},
			25 : {"dignitie_id" : 5, "type" : 0, "follows" : 3000, "kongfu" : 4, "speed" : 0, "polity" : 0, "intelligence" : 0},
			26 : {"dignitie_id" : 5, "type" : 0, "follows" : 3000, "kongfu" : 4, "speed" : 0, "polity" : 0, "intelligence" : 0},
			27 : {"dignitie_id" : 5, "type" : 0, "follows" : 3000, "kongfu" : 4, "speed" : 0, "polity" : 0, "intelligence" : 0},
			28 : {"dignitie_id" : 5, "type" : 0, "follows" : 3000, "kongfu" : 4, "speed" : 0, "polity" : 0, "intelligence" : 0},
			29 : {"dignitie_id" : 5, "type" : 1, "follows" : 3000, "kongfu" : 0, "speed" : 0, "polity" : 4, "intelligence" : 0},
			30 : {"dignitie_id" : 5, "type" : 1, "follows" : 3000, "kongfu" : 0, "speed" : 0, "polity" : 4, "intelligence" : 0},
			31 : {"dignitie_id" : 5, "type" : 1, "follows" : 3000, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 4},
			32 : {"dignitie_id" : 5, "type" : 1, "follows" : 3000, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 4},
			33 : {"dignitie_id" : 6, "type" : 0, "follows" : 3500, "kongfu" : 5, "speed" : 0, "polity" : 0, "intelligence" : 0},
			34 : {"dignitie_id" : 6, "type" : 0, "follows" : 3500, "kongfu" : 5, "speed" : 0, "polity" : 0, "intelligence" : 0},
			35 : {"dignitie_id" : 6, "type" : 0, "follows" : 3500, "kongfu" : 5, "speed" : 0, "polity" : 0, "intelligence" : 0},
			36 : {"dignitie_id" : 6, "type" : 0, "follows" : 3500, "kongfu" : 5, "speed" : 0, "polity" : 0, "intelligence" : 0},
			37 : {"dignitie_id" : 6, "type" : 1, "follows" : 3500, "kongfu" : 0, "speed" : 0, "polity" : 5, "intelligence" : 0},
			38 : {"dignitie_id" : 6, "type" : 1, "follows" : 3500, "kongfu" : 0, "speed" : 0, "polity" : 5, "intelligence" : 0},
			39 : {"dignitie_id" : 6, "type" : 1, "follows" : 3500, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 5},
			40 : {"dignitie_id" : 6, "type" : 1, "follows" : 3500, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 5},
			41 : {"dignitie_id" : 7, "type" : 0, "follows" : 4000, "kongfu" : 6, "speed" : 0, "polity" : 0, "intelligence" : 0},
			42 : {"dignitie_id" : 7, "type" : 0, "follows" : 4000, "kongfu" : 6, "speed" : 0, "polity" : 0, "intelligence" : 0},
			43 : {"dignitie_id" : 7, "type" : 0, "follows" : 4000, "kongfu" : 6, "speed" : 0, "polity" : 0, "intelligence" : 0},
			44 : {"dignitie_id" : 7, "type" : 0, "follows" : 4000, "kongfu" : 6, "speed" : 0, "polity" : 0, "intelligence" : 0},
			45 : {"dignitie_id" : 7, "type" : 1, "follows" : 4000, "kongfu" : 0, "speed" : 0, "polity" : 6, "intelligence" : 0},
			46 : {"dignitie_id" : 7, "type" : 1, "follows" : 4000, "kongfu" : 0, "speed" : 0, "polity" : 6, "intelligence" : 0},
			47 : {"dignitie_id" : 7, "type" : 1, "follows" : 4000, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 6},
			48 : {"dignitie_id" : 7, "type" : 1, "follows" : 4000, "kongfu" : 0, "speed" : 0, "polity" : 0, "intelligence" : 6}
			}


var SKILL = {
            1 :  {"name" : "tupo",        "effect" : 1,   "type" : 1,  "kongfu" : 70,  "intelligence" : 0,   "polity" : 0},
            2 :  {"name" : "tujin",       "effect" : 2,   "type" : 1,  "kongfu" : 80,  "intelligence" : 0,   "polity" : 0},
            3 :  {"name" : "tuji",        "effect" : 3,   "type" : 1,  "kongfu" : 90,  "intelligence" : 0,   "polity" : 0},
            4 :  {"name" : "sugong",      "effect" : 1.2, "type" : 1,  "kongfu" : 95,  "intelligence" : 0,   "polity" : 0},
            5 :  {"name" : "qishe",       "effect" : 1,   "type" : 2,  "kongfu" : 70,  "intelligence" : 0,   "polity" : 0},
            6 :  {"name" : "lianshe",     "effect" : 2,   "type" : 2,  "kongfu" : 80,  "intelligence" : 0,   "polity" : 0},
            7 :  {"name" : "liannu",      "effect" : 3,   "type" : 2,  "kongfu" : 90,  "intelligence" : 0,   "polity" : 0},
            8 :  {"name" : "huojian",     "effect" : 1.2, "type" : 2,  "kongfu" : 95,  "intelligence" : 0,   "polity" : 0},
            9 :  {"name" : "fenzhan",     "effect" : 1,   "type" : 3,  "kongfu" : 70,  "intelligence" : 0,   "polity" : 0},
            10 : {"name" : "fendou",      "effect" : 2,   "type" : 3,  "kongfu" : 80,  "intelligence" : 0,   "polity" : 0},
            11 : {"name" : "fenxun",      "effect" : 3,   "type" : 3,  "kongfu" : 90,  "intelligence" : 0,   "polity" : 0},
            12 : {"name" : "luanzhan",    "effect" : 1.2, "type" : 3,  "kongfu" : 95,  "intelligence" : 0,   "polity" : 0},
            13 : {"name" : "qishe",       "effect" : 1,   "type" : 4,  "kongfu" : 70,  "intelligence" : 70,  "polity" : 0},
            14 : {"name" : "benshe",      "effect" : 2,   "type" : 4,  "kongfu" : 80,  "intelligence" : 70,  "polity" : 0},
            15 : {"name" : "feishe",      "effect" : 3,   "type" : 4,  "kongfu" : 90,  "intelligence" : 70,  "polity" : 0},
            16 : {"name" : "huishe",      "effect" : 1.2, "type" : 4,  "kongfu" : 95,  "intelligence" : 80,  "polity" : 0},
            17 : {"name" : "jinglan",     "effect" : 1,   "type" : 5,  "kongfu" : 0,   "intelligence" : 70,  "polity" : 70},
            18 : {"name" : "chongche",    "effect" : 2,   "type" : 5,  "kongfu" : 0,   "intelligence" : 80,  "polity" : 70},
            19 : {"name" : "fashi",       "effect" : 3,   "type" : 5,  "kongfu" : 0,   "intelligence" : 90,  "polity" : 70},
            20 : {"name" : "qiangji",     "effect" : 1.2, "type" : 5,  "kongfu" : 0,   "intelligence" : 95,  "polity" : 80},
            21 : {"name" : "mengtong",    "effect" : 1,   "type" : 6,  "kongfu" : 70,  "intelligence" : 0,   "polity" : 70},
            22 : {"name" : "louchuan",    "effect" : 2,   "type" : 6,  "kongfu" : 70,  "intelligence" : 0,   "polity" : 80},
            23 : {"name" : "zhanjian",    "effect" : 3,   "type" : 6,  "kongfu" : 70,  "intelligence" : 0,   "polity" : 90},
            24 : {"name" : "qiangxi",     "effect" : 1.2, "type" : 6,  "kongfu" : 80,  "intelligence" : 0,   "polity" : 95},
            25 : {"name" : "wushuang",    "effect" : 2,   "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            26 : {"name" : "pozhen",      "effect" : 1,   "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            27 : {"name" : "mazhen",      "effect" : 10,  "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            28 : {"name" : "qiangxing",   "effect" : 1,   "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            29 : {"name" : "zhiliao",     "effect" : 0.2, "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            30 : {"name" : "hunluan",     "effect" : 1,   "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            31 : {"name" : "guwu",        "effect" : 10,  "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200},
            32 : {"name" : "chenzhuo",    "effect" : 1,   "type" : 0,  "kongfu" : 200, "intelligence" : 200, "polity" : 200}
        }

var ZHEN = {
            0 :  {"name" : "wu",         "attack" : 0,  "defense" : 0,  "speed" : 0,   "type1" : 0, "type2" : 0, "kongfu" : 0,   "intelligence" : 0,   "polity" : 0},
            1 :  {"name" : "zhuixing",   "attack" : 4,  "defense" : -1, "speed" : 1,   "type1" : 1, "type2" : 1, "kongfu" : 80,  "intelligence" : 0,   "polity" : 0},
            2 :  {"name" : "heyi",       "attack" : 5,  "defense" : 0,  "speed" : -1,  "type1" : 2, "type2" : 2, "kongfu" : 0,   "intelligence" : 80,  "polity" : 0},
            3 :  {"name" : "yulin",      "attack" : 4,  "defense" : 1,  "speed" : -1,  "type1" : 3, "type2" : 3, "kongfu" : 0,   "intelligence" : 0,   "polity" : 80},
            4 :  {"name" : "yanxing",    "attack" : 3,  "defense" : 0,  "speed" : 1,   "type1" : 4, "type2" : 4, "kongfu" : 85,  "intelligence" : 70,  "polity" : 0},
            5 :  {"name" : "fengshi",    "attack" : 6,  "defense" : -1, "speed" : -1,  "type1" : 1, "type2" : 3, "kongfu" : 80,  "intelligence" : 80,  "polity" : 70},
            6 :  {"name" : "changshe",   "attack" : 1,  "defense" : 1,  "speed" : 2,   "type1" : 0, "type2" : 0, "kongfu" : 70,  "intelligence" : 70,  "polity" : 70},
            7 :  {"name" : "henge",      "attack" : 2,  "defense" : 2,  "speed" : 0,   "type1" : 0, "type2" : 0, "kongfu" : 80,  "intelligence" : 80,  "polity" : 0},
            8 :  {"name" : "jixing",     "attack" : 1,  "defense" : 2,  "speed" : 1,   "type1" : 0, "type2" : 0, "kongfu" :  0,  "intelligence" : 80,  "polity" : 80},
            9 :  {"name" : "yanyue",     "attack" : 2,  "defense" : 1,  "speed" : 1,   "type1" : 0, "type2" : 0, "kongfu" : 80,  "intelligence" : 0,   "polity" : 80},
            10 : {"name" : "fangyuan",   "attack" : -1, "defense" : 6,  "speed" : -1,  "type1" : 0, "type2" : 0, "kongfu" : 70,  "intelligence" : 70,  "polity" : 70}
        } 

//////////////////////////////function
//people
function get_people_incr_time(){
	peopele_incr_time = CYCLE_TIME["year"]
	return peopele_incr_time
}

function get_people_incr_num(people_num){
	var people_incr_num = people_num * 0.01
	var deve_decr = people_incr_num / 500
	return [people_incr_num, deve_decr]
}

function get_people_decr_time(){
	var people_decr_time = CYCLE_TIME["year"]
	return people_decr_time
}

function get_people_decr_num(people_num){
	var people_decr_num = people_num * 0.02
	return people_decr_num
}

//resource
function get_res_incr_time(res_id){
	var res_incr_time = CYCLE_TIME["month"]
	if (RES[res_id] == "food"){
		res_incr_time = CYCLE_TIME["season"]
	}
	return res_incr_time
}

function get_res_incr_num(development, base, is_war, polity, peace, tax_rate){
	var incr_num = development * base * (1 - is_war / 2)
	var tax_num = incr_num * (tax_rate / 100) * ((70 + polity * 0.2 + peace * 0.1) / 100)
	var people_num = incr_num - tax_num
	return [people_num, tax_num]
}

function get_res_consume_time(res_id){
	var res_consume_time = CYCLE_TIME["month"]
	return res_consume_time
}

function get_resident_res_consume(res_id, people_num){
	var resident_res_consume = RES_CONSUME["people_def"]
	if (RES[res_id] == "food"){
		resident_res_consume = RES_CONSUME["people_food"]
	}
	return resident_res_consume * people_num
}

function get_solider_res_consume(res_id, solider_type, solider_num, is_war){
	var solider_res_consume = RES_CONSUME["solider_def"]
	if (RES[res_id] == "food") {
		solider_res_consume = SOLIDER_TYPE[solider_type]["food"]
	}
	else if (RES[res_id] == "money") {
		solider_res_consume = SOLIDER_TYPE[solider_type]["money"]
	}
	if (is_war == 1) {
		solider_res_consume = solider_res_consume * 2
	}
	return solider_res_consume * solider_num
}

//made incr
function get_made_incr_time(){
	var made_incr_time = CYCLE_TIME["month"]
	return made_incr_time
}

function get_made_incr_num(development, city_lev, cur_made_num){
	var max_made_num = development * city_lev * 100
	var made_incr_num
	if (cur_made_num >= max_made_num) {
		made_incr_num = 0
	}
	else if (max_made_num - cur_made_num <= max_made_num / 30) {
		made_incr_num = max_made_num - cur_made_num
	}
	else{
		made_incr_num = max_made_num / 30
	}
	return made_incr_num
}

//view city
function get_cmd_view_city_money(cur_peace){
	var cmd_view_city_money = 0
	if (cur_peace >= MAX_VALUES["city_peace"]){
		cmd_view_city_money = 0
	}
	return cmd_view_city_money
}

function get_cmd_view_city_time(){
	var cmd_view_city_time = 30
	return cmd_view_city_time
}

function get_cmd_view_city_effect(polity, cur_peace_num){
	var peace_incr_num
	if (cur_peace_num >= MAX_VALUES["city_peace"]) {
		peace_incr_num = 0
	}
	else if (MAX_VALUES["city_peace"] - cur_peace_num <= 5 * polity / MAX_VALUES["polity"]) { 
		peace_incr_num = MAX_VALUES["city_peace"] - cur_peace_num
	}
	else{
		peace_incr_num = 5 * polity / MAX_VALUES["polity"]
	}
	return peace_incr_num
}

//repair city
function get_cmd_repair_money(cur_defense, city_lev){
	var max_defense = city_lev * 100
	var cmd_repair_money = 5000 * (1 + cur_defense / max_defense)
	if (cur_defense >= max_defense){
		cmd_repair_money = 0
	}
	return cmd_repair_money
}

function get_cmd_repair_time(){
	var cmd_repair_time = 30
	return cmd_repair_time
}

function get_cmd_repair_effect(kongfu, cur_defense, city_lev){
	var defense_incr_num
	var max_defense = city_lev * 100
	if (cur_defense >= max_defense) {
		defense_incr_num = 0
	}
	else if (max_defense - cur_defense <= 5 * kongfu / MAX_VALUES["kongfu"]) { 
		defense_incr_num = max_defense - cur_defense
	}
	else{
		defense_incr_num = 5 * kongfu / MAX_VALUES["kongfu"]
	}
	return defense_incr_num
}

//development resource
function get_cmd_dev_money(trade_id, cur_dev){
	var cmd_dev_money = 5000 * (1 + cur_dev / MAX_VALUES["trade_dev"])
	if (cur_dev >= MAX_VALUES["trade_dev"]){
		cmd_dev_money = 0
	}
	return cmd_dev_money
}

function get_cmd_dev_time(trade_id){
	var cmd_dev_time = 30
	return cmd_dev_time
}

function get_cmd_dev_effect(trade_id, intelligence, cur_dev){
	var dev_incr_num
	if (cur_dev >= MAX_VALUES["trade_dev"]) {
		dev_incr_num = 0
	}
	else if (MAX_VALUES["trade_dev"] - cur_dev <= 3 * intelligence / MAX_VALUES["intelligence"]) { 
		dev_incr_num = MAX_VALUES["trade_dev"] - cur_dev
	}
	else{
		dev_incr_num = 3 * intelligence / MAX_VALUES["intelligence"]
	}
	return dev_incr_num
}

//development resource
function get_cmd_dev_money(trade_id, cur_dev){
	var cmd_dev_money = 5000 * (1 + cur_dev / MAX_VALUES["trade_dev"])
	if (cur_dev >= MAX_VALUES["trade_dev"]) {
		cmd_dev_money = 0
	}
	return cmd_dev_money
}

function get_cmd_dev_time(trade_id){
	var cmd_dev_time = 30
	return cmd_dev_time
}

function get_cmd_dev_effect(trade_id, intelligence, cur_dev){
	var dev_incr_num
	if (cur_dev >= MAX_VALUES["trade_dev"]) {
		dev_incr_num = 0
	}
	else if (MAX_VALUES["trade_dev"] - cur_dev <= 3 * intelligence / MAX_VALUES["intelligence"]) { 
		dev_incr_num = MAX_VALUES["trade_dev"] - cur_dev
	}
	else{
		dev_incr_num = 3 * intelligence / MAX_VALUES["intelligence"]
	}
	return dev_incr_num
}
//made weapon
function get_cmd_made_weapon_time(num1, num2, num3, num4, num5, num6, num7, num8, num9, city_lev, development){
    var max_made_num = development * city_lev * 100
    var need_made_num = 0
    need_made_num = need_made_num + WEAPON[1]["made"] * num1
    need_made_num = need_made_num + WEAPON[2]["made"] * num2
    need_made_num = need_made_num + WEAPON[3]["made"] * num3
    need_made_num = need_made_num + WEAPON[4]["made"] * num4
    need_made_num = need_made_num + WEAPON[5]["made"] * num5
    need_made_num = need_made_num + WEAPON[6]["made"] * num6
    need_made_num = need_made_num + WEAPON[7]["made"] * num7
    need_made_num = need_made_num + WEAPON[8]["made"] * num8
    need_made_num = need_made_num + WEAPON[9]["made"] * num9
    var cmd_made_weapon_time = need_made_num / max_made_num * 30 * 12
    return cmd_made_weapon_time
}

function get_weapon_require_res(weapon_id){
	return [WEAPON[weapon_id]["iron"],WEAPON[weapon_id]["wood"],WEAPON[weapon_id]["skin"],WEAPON[weapon_id]["muscle"],WEAPON[weapon_id]["money"],WEAPON[weapon_id]["made"]]
}

//new army
function get_cmd_go_out_prerequire(solider_type){
	var min_solider_num = 500
	var min_food_num = 0
	var min_money_num = 0
	var min_wood_num = 0
	var min_iron_num = 0
	return [min_solider_num,min_food_num,min_money_num,min_wood_num,min_iron_num]
}

//train
function get_cmd_train_money(cur_solider_num,cur_train,cur_spirit){
	var cmd_train_money = cur_solider_num * 10
	if (cur_train >= MAX_VALUES["train"] && cur_spirit >= MAX_VALUES["spirit"]) {
		cmd_train_money = 0
	}
	return cmd_train_money
}

function get_cmd_train_time(){
	var cmd_train_time = 30
	return cmd_train_time
}
//call back
function get_cmd_recall_money(){
	var cmd_recall_money = 5000
	return cmd_recall_money
}
//war
function get_general_follows(dignitie_id, official_id){
	if (dignitie_id != 0){
	    return DIGNITIE[dignitie_id]["follows"]
		
	}
	else{
		if (official_id == 0){
			return 1000
		}
		else{
			return 	OFFICIAL[official_id]["follows"]
		}
		
	}
}

function get_campaign_days(money, food, id1, num1, id2, num2, id3, num3, id4, num4){
	var solider1_money = (id1 == 0) ? 0 : SOLIDER_TYPE[id1]["money"] / 30
	var solider1_food = (id1 == 0) ? 0 : SOLIDER_TYPE[id1]["food"] / 30
	var solider2_money = (id2 == 0) ? 0 : SOLIDER_TYPE[id2]["money"] / 30
	var solider2_food = (id2 == 0) ? 0 : SOLIDER_TYPE[id2]["food"] / 30
	var solider3_money = (id3 == 0) ? 0 : SOLIDER_TYPE[id3]["money"] / 30
	var solider3_food = (id3 == 0) ? 0 : SOLIDER_TYPE[id3]["food"] / 30
	var solider4_money = (id4 == 0) ? 0 : SOLIDER_TYPE[id4]["money"] / 30
	var solider4_food = (id4 == 0) ? 0 : SOLIDER_TYPE[id4]["food"] / 30
	var solider_money = solider1_money * num1 + solider2_money * num2 + solider3_money * num3 + solider4_money * num4
	var solider_food = solider1_food * num1 + solider2_food * num2 + solider3_food * num3 + solider4_food * num4
	var money_days = money /  solider_money
	var food_days = food / solider_food
	return money_days < food_days ? money_days : food_days
}

function get_war_money_food(solider_type, solider_num, days){
	var food = SOLIDER_TYPE[solider_type]["food"] * solider_num * days / 30
	var money = SOLIDER_TYPE[solider_type]["money"] * solider_num * days / 30
	return [money, food]
}
//get solider
function get_cmd_get_solider_req(solider_type){
	return [SOLIDER_TYPE_REQ[solider_type]["money"], SOLIDER_TYPE_REQ[solider_type]["horse"], SOLIDER_TYPE_REQ[solider_type]["sword"],SOLIDER_TYPE_REQ[solider_type]["halberd"],SOLIDER_TYPE_REQ[solider_type]["shield"],SOLIDER_TYPE_REQ[solider_type]["leather"],SOLIDER_TYPE_REQ[solider_type]["armour"],SOLIDER_TYPE_REQ[solider_type]["hnaid"],SOLIDER_TYPE_REQ[solider_type]["engine"],SOLIDER_TYPE_REQ[solider_type]["warship"],SOLIDER_TYPE_REQ[solider_type]["arrow"]]
}
//policy
function get_cmd_policy_time(policy_id){
	var cmd_policy_time = 30
	return cmd_policy_time
}

function get_cmd_policy_money(policy_id){
	var cmd_policy_money = 30000
	return cmd_policy_money
}

//plan
function get_cmd_plan_require(plan_id){
	return [PLAN[plan_id]["money"], PLAN[plan_id]["food"], PLAN[plan_id]["wood"], PLAN[plan_id]["iron"]]
}

//find_general
function get_cmd_find_general_time(){
	var find_general_time = 30
	return find_general_time
}

//use_general
function get_cmd_use_general_time(){
	var use_general_time = 30
	return use_general_time
}

//get max value
function get_max_defense(city_lev){
	return city_lev * 100
}

function get_max_peace(){
	return MAX_VALUES["city_peace"]
}

function get_max_development(dev_id){
	return MAX_VALUES["trade_dev"]
}

function get_max_train(){
	return MAX_VALUES["train"]
}

function get_max_spirit(){
	return MAX_VALUES["spirit"]
}

//speed
function get_sol_speed(){
	return [SOLIDER_TYPE[0]["speed"], SOLIDER_TYPE[1]["speed"], SOLIDER_TYPE[2]["speed"], SOLIDER_TYPE[3]["speed"], SOLIDER_TYPE[4]["speed"], SOLIDER_TYPE[5]["speed"], SOLIDER_TYPE[6]["speed"], SOLIDER_TYPE[7]["speed"], SOLIDER_TYPE[8]["speed"], SOLIDER_TYPE[9]["speed"], SOLIDER_TYPE[10]["speed"], SOLIDER_TYPE[11]["speed"], SOLIDER_TYPE[12]["speed"], SOLIDER_TYPE[13]["speed"]]
}

function get_army_speed(general_speed, solider_type1, solider_type2, solider_type3, solider_type4){
	var cmp1 = (SOLIDER_TYPE[solider_type1]["speed"] < SOLIDER_TYPE[solider_type2]["speed"]) ? SOLIDER_TYPE[solider_type1]["speed"] : SOLIDER_TYPE[solider_type2]["speed"]
	var cmp2 = (cmp1 < SOLIDER_TYPE[solider_type3]["speed"]) ? cmp1 : SOLIDER_TYPE[solider_type3]["speed"]
	var cmp3 = (cmp2 < SOLIDER_TYPE[solider_type4]["speed"]) ? cmp2 : SOLIDER_TYPE[solider_type4]["speed"]
	return cmp3 * (1 + general_speed * 0.01)
}

function get_sol_prop(id,zhen){
    var speed = SOLIDER_TYPE[id]["speed"]
    var distance = SOLIDER_TYPE[id]["distance"]
    var x = 2
    var action = speed * x * (4 + ZHEN[zhen]["speed"])
    return [action, distance]
}

function re_load(){
    window.top.location.reload()
//    window.location.href=window.location.href;
}
////////////TEST