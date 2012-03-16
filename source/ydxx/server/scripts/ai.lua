------------------------------------------------汉风游戏AI------------------------------------------------
--巡视
VIEW = {
        [1] = {["hour"] = 36,     ["prestige"] = 4000,   ["money"] = 0,       ["gold"] = 0},
        [2] = {["hour"] = 1080,   ["prestige"] = 80000,  ["money"] = 1000000, ["gold"] = 0},
        [3] = {["hour"] = 4320,   ["prestige"] = 500000, ["money"] = 0,       ["gold"] = 300}
    }

--资源表
--1 粮食；2 木头；3 铁；4 马；5 皮革；6 钱；
RES = {
        [0] = {["factor"] = 0,    ["load"] = 0},
        [1] = {["factor"] = 2000, ["load"] = 2000},
        [2] = {["factor"] = 25,   ["load"] = 5000},
        [3] = {["factor"] = 500,  ["load"] = 1000},
        [4] = {["factor"] = 1,    ["load"] = 1000},
        [5] = {["factor"] = 50,   ["load"] = 500},
        [6] = {["factor"] = 50000,["load"] = 1}
    }

MAX_WEAPON = 20000

--职位表（联盟等级）
--0，白身；1，县令；2，太守；3，州牧；4，九卿；5，丞相；6，皇帝
OFFICE = {
            [0] = {["joins"] = 10,    ["city_num"] = 0  },
            [1] = {["joins"] = 20,   ["city_num"] = 1  },
            [2] = {["joins"] = 30,   ["city_num"] = 5  },
            [3] = {["joins"] = 50,   ["city_num"] = 15 },
            [4] = {["joins"] = 80,   ["city_num"] = 30 },
            [5] = {["joins"] = 120,  ["city_num"] = 50 },
            [6] = {["joins"] = 200,  ["city_num"] = 143}
            }

--爵位表
--0，平民；1，男；2，子；3，伯；4，侯；5，公；6，王
DIGNITIE = {
            [0] = {["prestige"] = 0,     ["follows"] = 1},
            [1] = {["prestige"] = 2000,  ["follows"] = 2},
            [2] = {["prestige"] = 4000,  ["follows"] = 3},
            [3] = {["prestige"] = 6000,  ["follows"] = 4},
            [4] = {["prestige"] = 8000,  ["follows"] = 5},
            [5] = {["prestige"] = 9000,  ["follows"] = 6},
            [6] = {["prestige"] = 10000, ["follows"] = 6}
            }

--官位表（受职位影响）
--1，威东将军；2，威南将军；3，威西将军；4，威北将军；5，郎中；6，从事郎中；7，长史；8，司马；
--9，军师将军；10，安国将军；11，破虏将军；12，讨逆将军；13，谒者仆射；14，都尉；15，黄门侍郎；16，太史令；
--17，左将军；18，右将军；19，前将军；20，后将军；21，秘书令；22，侍中；23，留府长史；24，太学博士；
--25，安东将军；26，安南将军；27，安西将军；28，安北将军；29，中书令；30，御史中丞；31，执金吾；32，少府；
--33，镇东将军；34，镇南将军；35，镇西将军；36，镇北将军；37，尚书令；38，太仆；39，太常；40，光禄大夫；
--41，征东将军；42，征南将军；43，征西将军；44，征北将军；45，光禄动；46，大司农；47，卫尉；48，延尉；

OFFICIAL = {
            [0]  = {["office_id"] = 0, ["type"] = 0, ["follows"] = 2000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 500 , ["feat"] =    0},
            [1]  = {["office_id"] = 1, ["type"] = 0, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [2]  = {["office_id"] = 1, ["type"] = 0, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [3]  = {["office_id"] = 1, ["type"] = 0, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [4]  = {["office_id"] = 1, ["type"] = 0, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [5]  = {["office_id"] = 1, ["type"] = 1, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [6]  = {["office_id"] = 1, ["type"] = 1, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [7]  = {["office_id"] = 1, ["type"] = 1, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [8]  = {["office_id"] = 1, ["type"] = 1, ["follows"] = 2200, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 0, ["salary"] = 800 , ["feat"] =  2000},
            [9]  = {["office_id"] = 2, ["type"] = 0, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1000, ["feat"] = 4000},
            [10] = {["office_id"] = 2, ["type"] = 0, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1000, ["feat"] = 4000},
            [11] = {["office_id"] = 2, ["type"] = 0, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1000, ["feat"] = 4000},
            [12] = {["office_id"] = 2, ["type"] = 0, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1000, ["feat"] = 4000},
            [13] = {["office_id"] = 2, ["type"] = 1, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 1, ["salary"] = 1000, ["feat"] = 4000},
            [14] = {["office_id"] = 2, ["type"] = 1, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 1, ["salary"] = 1000, ["feat"] = 4000},
            [15] = {["office_id"] = 2, ["type"] = 1, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 1, ["salary"] = 1000, ["feat"] = 4000},
            [16] = {["office_id"] = 2, ["type"] = 1, ["follows"] = 2400, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 1, ["intelligence"] = 1, ["salary"] = 1000, ["feat"] = 4000},
            [17] = {["office_id"] = 3, ["type"] = 0, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1200, ["feat"] = 6000},
            [18] = {["office_id"] = 3, ["type"] = 0, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1200, ["feat"] = 6000},
            [19] = {["office_id"] = 3, ["type"] = 0, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1200, ["feat"] = 6000},
            [20] = {["office_id"] = 3, ["type"] = 0, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1200, ["feat"] = 6000},
            [21] = {["office_id"] = 3, ["type"] = 1, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 1, ["salary"] = 1200, ["feat"] = 6000},
            [22] = {["office_id"] = 3, ["type"] = 1, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 1, ["salary"] = 1200, ["feat"] = 6000},
            [23] = {["office_id"] = 3, ["type"] = 1, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 1, ["salary"] = 1200, ["feat"] = 6000},
            [24] = {["office_id"] = 3, ["type"] = 1, ["follows"] = 2600, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 1, ["salary"] = 1200, ["feat"] = 6000},
            [25] = {["office_id"] = 4, ["type"] = 0, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1400, ["feat"] = 8000},
            [26] = {["office_id"] = 4, ["type"] = 0, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1400, ["feat"] = 8000},
            [27] = {["office_id"] = 4, ["type"] = 0, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1400, ["feat"] = 8000},
            [28] = {["office_id"] = 4, ["type"] = 0, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1400, ["feat"] = 8000},
            [29] = {["office_id"] = 4, ["type"] = 1, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 2, ["salary"] = 1400, ["feat"] = 8000},
            [30] = {["office_id"] = 4, ["type"] = 1, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 2, ["salary"] = 1400, ["feat"] = 8000},
            [31] = {["office_id"] = 4, ["type"] = 1, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 2, ["salary"] = 1400, ["feat"] = 8000},
            [32] = {["office_id"] = 4, ["type"] = 1, ["follows"] = 2800, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 2, ["intelligence"] = 2, ["salary"] = 1400, ["feat"] = 8000},
            [33] = {["office_id"] = 5, ["type"] = 0, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1800, ["feat"] = 9000},
            [34] = {["office_id"] = 5, ["type"] = 0, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1800, ["feat"] = 9000},
            [35] = {["office_id"] = 5, ["type"] = 0, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1800, ["feat"] = 9000},
            [36] = {["office_id"] = 5, ["type"] = 0, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 1800, ["feat"] = 9000},
            [37] = {["office_id"] = 5, ["type"] = 1, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 2, ["salary"] = 1800, ["feat"] = 9000},
            [38] = {["office_id"] = 5, ["type"] = 1, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 2, ["salary"] = 1800, ["feat"] = 9000},
            [39] = {["office_id"] = 5, ["type"] = 1, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 2, ["salary"] = 1800, ["feat"] = 9000},
            [40] = {["office_id"] = 5, ["type"] = 1, ["follows"] = 3000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 2, ["salary"] = 1800, ["feat"] = 9000},
            [41] = {["office_id"] = 6, ["type"] = 0, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 2200, ["feat"] = 10000},
            [42] = {["office_id"] = 6, ["type"] = 0, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 2200, ["feat"] = 10000},
            [43] = {["office_id"] = 6, ["type"] = 0, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 2200, ["feat"] = 10000},
            [44] = {["office_id"] = 6, ["type"] = 0, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 0, ["intelligence"] = 0, ["salary"] = 2200, ["feat"] = 10000},
            [45] = {["office_id"] = 6, ["type"] = 1, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 3, ["salary"] = 2200, ["feat"] = 10000},
            [46] = {["office_id"] = 6, ["type"] = 1, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 3, ["salary"] = 2200, ["feat"] = 10000},
            [47] = {["office_id"] = 6, ["type"] = 1, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 3, ["salary"] = 2200, ["feat"] = 10000},
            [48] = {["office_id"] = 6, ["type"] = 1, ["follows"] = 4000, ["kongfu"] = 0, ["speed"] = 0, ["polity"] = 3, ["intelligence"] = 3, ["salary"] = 2200, ["feat"] = 10000}
            }

--武将技能表
--1，突破；2，突进；3，突击；4，速攻；5，齐射；6，连射；7，连弩；8，火箭；
--9，奋战；10，奋斗；11，奋迅；12，乱战；13，骑射；14，奔射；15，飞射；16，回射；
--17，井栏；18，冲车；19，发石；20，强击；21，艨艟；22，楼船；23，战舰；24，强袭；
--25，无双；26，破阵；27，坚守；28，奇袭；29，混乱；30沉着；31，骂阵；32，鼓舞
--类型：1，骑兵系；2，弩兵系；3，步兵系；4，弓骑系；5弩车系；6，甲车系；0，特殊；

SKILL = {
            [1] =  {["price"] = 300,   ["effect"] = 0.2,   ["type"] = 1,  ["kongfu"] = 65,  ["intelligence"] = 0,   ["polity"] = 0},
            [2] =  {["price"] = 600,   ["effect"] = 0.4,   ["type"] = 1,  ["kongfu"] = 75,  ["intelligence"] = 0,   ["polity"] = 0},
            [3] =  {["price"] = 900,   ["effect"] = 0.6,   ["type"] = 1,  ["kongfu"] = 85,  ["intelligence"] = 0,   ["polity"] = 0},
            [4] =  {["price"] = 1200,  ["effect"] = 1.2,   ["type"] = 1,  ["kongfu"] = 90,  ["intelligence"] = 0,   ["polity"] = 0},
            [5] =  {["price"] = 200,   ["effect"] = 0.2,   ["type"] = 2,  ["kongfu"] = 0,   ["intelligence"] = 65,  ["polity"] = 0},
            [6] =  {["price"] = 400,   ["effect"] = 0.4,   ["type"] = 2,  ["kongfu"] = 0,   ["intelligence"] = 75,  ["polity"] = 0},
            [7] =  {["price"] = 600,   ["effect"] = 0.6,   ["type"] = 2,  ["kongfu"] = 0,   ["intelligence"] = 85,  ["polity"] = 0},
            [8] =  {["price"] = 800,   ["effect"] = 1.2,   ["type"] = 2,  ["kongfu"] = 0,   ["intelligence"] = 90,  ["polity"] = 0},
            [9] =  {["price"] = 100,   ["effect"] = 0.2,   ["type"] = 3,  ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 65},
            [10] = {["price"] = 200,   ["effect"] = 0.4,   ["type"] = 3,  ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 75},
            [11] = {["price"] = 300,   ["effect"] = 0.6,   ["type"] = 3,  ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 85},
            [12] = {["price"] = 400,   ["effect"] = 1.2,   ["type"] = 3,  ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 90},
            [13] = {["price"] = 400,   ["effect"] = 0.2,   ["type"] = 4,  ["kongfu"] = 65,  ["intelligence"] = 50,  ["polity"] = 0},
            [14] = {["price"] = 800,   ["effect"] = 0.4,   ["type"] = 4,  ["kongfu"] = 75,  ["intelligence"] = 60,  ["polity"] = 0},
            [15] = {["price"] = 1200,  ["effect"] = 0.6,   ["type"] = 4,  ["kongfu"] = 85,  ["intelligence"] = 70,  ["polity"] = 0},
            [16] = {["price"] = 1600,  ["effect"] = 1.2,   ["type"] = 4,  ["kongfu"] = 90,  ["intelligence"] = 80,  ["polity"] = 0},
            [17] = {["price"] = 600,   ["effect"] = 0.2,   ["type"] = 5,  ["kongfu"] = 0,   ["intelligence"] = 65,  ["polity"] = 50},
            [18] = {["price"] = 1200,  ["effect"] = 0.4,   ["type"] = 5,  ["kongfu"] = 0,   ["intelligence"] = 75,  ["polity"] = 60},
            [19] = {["price"] = 1800,  ["effect"] = 0.6,   ["type"] = 5,  ["kongfu"] = 0,   ["intelligence"] = 85,  ["polity"] = 70},
            [20] = {["price"] = 2400,  ["effect"] = 1.2,   ["type"] = 5,  ["kongfu"] = 0,   ["intelligence"] = 90,  ["polity"] = 80},
            [21] = {["price"] = 500,   ["effect"] = 0.2,   ["type"] = 6,  ["kongfu"] = 50,  ["intelligence"] = 0,   ["polity"] = 65},
            [22] = {["price"] = 1000,  ["effect"] = 0.4,   ["type"] = 6,  ["kongfu"] = 60,  ["intelligence"] = 0,   ["polity"] = 75},
            [23] = {["price"] = 1500,  ["effect"] = 0.6,   ["type"] = 6,  ["kongfu"] = 70,  ["intelligence"] = 0,   ["polity"] = 85},
            [24] = {["price"] = 2000,  ["effect"] = 1.2,   ["type"] = 6,  ["kongfu"] = 80,  ["intelligence"] = 0,   ["polity"] = 90},
            [25] = {["price"] = 50000, ["effect"] = 2,     ["type"] = 0,  ["kongfu"] = 98,  ["intelligence"] = 0,   ["polity"] = 0},
            [26] = {["price"] = 50000, ["effect"] = 1,     ["type"] = 0,  ["kongfu"] = 0,   ["intelligence"] = 98,  ["polity"] = 0},
            [27] = {["price"] = 50000, ["effect"] = 2,     ["type"] = 0,  ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 98},
            [28] = {["price"] = 30000, ["effect"] = 0.3,   ["type"] = 0,  ["kongfu"] = 90,  ["intelligence"] = 80,  ["polity"] = 80},
            [29] = {["price"] = 30000, ["effect"] = 1,     ["type"] = 0,  ["kongfu"] = 80,  ["intelligence"] = 90,  ["polity"] = 80},
            [30] = {["price"] = 30000, ["effect"] = 1,     ["type"] = 0,  ["kongfu"] = 80,  ["intelligence"] = 80,  ["polity"] = 90},
            [31] = {["price"] = 10000, ["effect"] = 10,    ["type"] = 0,  ["kongfu"] = 85,  ["intelligence"] = 70,  ["polity"] = 0},
            [32] = {["price"] = 10000, ["effect"] = 3,     ["type"] = 0,  ["kongfu"] = 70,  ["intelligence"] = 0,   ["polity"] = 85}
        }

--武将阵法表
--1，锥形；2，鹤翼；3，鱼鳞；4，雁行；5，锋矢；6，长蛇；7，衡轭；8，箕形；9，偃月；10，方圆；
ZHEN = {
            [0] =  {["price"] = 0,   ["attack"] = 0,   ["defense"] = 0,   ["speed"] = 0,  ["type1"] = 0, ["type2"] = 0, ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 0},
            [1] =  {["price"] = 200, ["attack"] = 3,   ["defense"] = 0,   ["speed"] = 1,  ["type1"] = 1, ["type2"] = 1, ["kongfu"] = 80,  ["intelligence"] = 0,   ["polity"] = 0},
            [2] =  {["price"] = 200, ["attack"] = 3,   ["defense"] = 1,   ["speed"] = 0,  ["type1"] = 2, ["type2"] = 2, ["kongfu"] = 0,   ["intelligence"] = 80,  ["polity"] = 0},
            [3] =  {["price"] = 200, ["attack"] = 1,   ["defense"] = 3,   ["speed"] = 0,  ["type1"] = 3, ["type2"] = 3, ["kongfu"] = 0,   ["intelligence"] = 0,   ["polity"] = 80},
            [4] =  {["price"] = 200, ["attack"] = 0,   ["defense"] = 3,   ["speed"] = 1,  ["type1"] = 4, ["type2"] = 4, ["kongfu"] = 80,  ["intelligence"] = 70,  ["polity"] = 0},
            [5] =  {["price"] = 200, ["attack"] = 4,   ["defense"] = 0,   ["speed"] = 0,  ["type1"] = 1, ["type2"] = 3, ["kongfu"] = 80,  ["intelligence"] = 0,   ["polity"] = 80},
            [6] =  {["price"] = 100, ["attack"] = 0,   ["defense"] = 0,   ["speed"] = 4,  ["type1"] = 0, ["type2"] = 0, ["kongfu"] = 70,  ["intelligence"] = 70,  ["polity"] = 70},
            [7] =  {["price"] = 100, ["attack"] = 2,   ["defense"] = 2,   ["speed"] = 0,  ["type1"] = 0, ["type2"] = 0, ["kongfu"] = 80,  ["intelligence"] = 80,  ["polity"] = 0},
            [8] =  {["price"] = 100, ["attack"] = 0,   ["defense"] = 2,   ["speed"] = 2,  ["type1"] = 0, ["type2"] = 0, ["kongfu"] =  0,  ["intelligence"] = 80,  ["polity"] = 80},
            [9] =  {["price"] = 100, ["attack"] = 2,   ["defense"] = 0,   ["speed"] = 2,  ["type1"] = 0, ["type2"] = 0, ["kongfu"] = 80,  ["intelligence"] = 0,   ["polity"] = 80},
            [10] = {["price"] = 100, ["attack"] = 0,   ["defense"] = 4,   ["speed"] = 0,  ["type1"] = 0, ["type2"] = 0, ["kongfu"] = 70,  ["intelligence"] = 70,  ["polity"] = 70}
        } 

--制造武器所需资源表
--1，剑；2，戟；3，弓；4，盾；5，皮甲；6，铁甲；7，冲车；8，战船；9，战马
--10，百炼刀；11，点钢枪；12，诸葛弩；13，虎纹盾；14，鱼鳞甲；15，乌孙马
--1 粮食；2 木头；3 铁；4 马；5 皮革；6 钱；
--武器多一级多20%效果base(1+0.2*level)
--w1 2|3 not w2 4;w4 7 not any
--site 装备位置
--div 多少个人装备一个装备flexible
WEAPON = {
            [0] =  {[1] = 0, [2] = 0,   [3] = 0,   [4] = 0, [5] = 0,  [6] = 0,     ["flexible"] = 0,  ["attack"] =  0, ["site"] = 0, ["defense"] =  0, ["div"] = 0, ["gongfang"] = 0,    ["made"] = 0},
            [1] =  {[1] = 0, [2] = 0,   [3] = 20,  [4] = 0, [5] = 0,  [6] = 1000,  ["flexible"] = 0,  ["attack"] =  5, ["site"] = 1, ["defense"] =  0, ["div"] = 1, ["gongfang"] = 0,    ["made"] = 25}, 
            [2] =  {[1] = 0, [2] = 2,   [3] = 10,  [4] = 0, [5] = 0,  [6] = 1000,  ["flexible"] = 0,  ["attack"] = 10, ["site"] = 1, ["defense"] =  0, ["div"] = 1, ["gongfang"] = 15,   ["made"] = 50}, 
            [3] =  {[1] = 0, [2] = 2,   [3] = 5,   [4] = 0, [5] = 0,  [6] = 1500,  ["flexible"] = 0,  ["attack"] = 10, ["site"] = 1, ["defense"] =  0, ["div"] = 1, ["gongfang"] = 30,   ["made"] = 50}, 
            [4] =  {[1] = 0, [2] = 1,   [3] = 5,   [4] = 0, [5] = 0,  [6] = 500,   ["flexible"] = 0,  ["attack"] =  0, ["site"] = 2, ["defense"] =  5, ["div"] = 1, ["gongfang"] = 15,   ["made"] = 25}, 
            [5] =  {[1] = 0, [2] = 0,   [3] = 5,   [4] = 0, [5] = 5,  [6] = 500,   ["flexible"] = 0,  ["attack"] =  0, ["site"] = 3, ["defense"] = 10, ["div"] = 1, ["gongfang"] = 30,   ["made"] = 50}, 
            [6] =  {[1] = 0, [2] = 0,   [3] = 80,  [4] = 0, [5] = 2,  [6] = 2000,  ["flexible"] = -5, ["attack"] =  0, ["site"] = 3, ["defense"] = 20, ["div"] = 1, ["gongfang"] = 45,   ["made"] = 100}, 
            [7] =  {[1] = 0, [2] = 5,   [3] = 20,  [4] = 0, [5] = 2,  [6] = 10000, ["flexible"] = 0,  ["attack"] = 10, ["site"] = 4, ["defense"] = 30, ["div"] = 1, ["gongfang"] = 60,   ["made"] = 200}, 
            [8] =  {[1] = 0, [2] = 5,   [3] = 20,  [4] = 0, [5] = 2,  [6] = 10000, ["flexible"] = 0,  ["attack"] = 20, ["site"] = 4, ["defense"] = 20, ["div"] = 1, ["gongfang"] = 60,   ["made"] = 200},
            [9] =  {[1] = 0, [2] = 2,   [3] = 10,  [4] = 1, [5] = 2,  [6] = 5000,  ["flexible"] = 10, ["attack"] = 10, ["site"] = 4, ["defense"] = 10, ["div"] = 1, ["gongfang"] = 45,   ["made"] = 200},
            [10] = {[1] = 0, [2] = 0,   [3] =  0,  [4] = 0, [5] = 0,  [6] =    0,  ["flexible"] = 0,  ["attack"] = 10, ["site"] = 1, ["defense"] =  0, ["div"] = 1, ["gongfang"] = 1000, ["made"] = 0},
            [11] = {[1] = 0, [2] = 0,   [3] =  0,  [4] = 0, [5] = 0,  [6] =    0,  ["flexible"] = 0,  ["attack"] = 20, ["site"] = 1, ["defense"] =  0, ["div"] = 1, ["gongfang"] = 1000, ["made"] = 0},
            [12] = {[1] = 0, [2] = 0,   [3] =  0,  [4] = 0, [5] = 0,  [6] =    0,  ["flexible"] = 0,  ["attack"] = 20, ["site"] = 1, ["defense"] =  0, ["div"] = 1, ["gongfang"] = 1000, ["made"] = 0},
            [13] = {[1] = 0, [2] = 0,   [3] =  0,  [4] = 0, [5] = 0,  [6] =    0,  ["flexible"] = 0,  ["attack"] = 0,  ["site"] = 2, ["defense"] = 10, ["div"] = 1, ["gongfang"] = 1000, ["made"] = 0},
            [14] = {[1] = 0, [2] = 0,   [3] =  0,  [4] = 0, [5] = 0,  [6] =    0,  ["flexible"] = 0,  ["attack"] = 0,  ["site"] = 3, ["defense"] = 30, ["div"] = 1, ["gongfang"] = 1000, ["made"] = 0},
            [15] = {[1] = 0, [2] = 0,   [3] =  0,  [4] = 0, [5] = 0,  [6] =    0,  ["flexible"] = 10, ["attack"] = 15, ["site"] = 4, ["defense"] = 15, ["div"] = 1, ["gongfang"] = 1000, ["made"] = 0}
        }

--建筑
--1，书院；2，民居；3，库房；4，工坊；5，农田；6，伐木场；7，矿山；8，牧场；9，革坊；10，集市；11，议事堂；12，医馆；13，军营；
--议事堂所需声望100*(level+1)
--所需议事堂等级BUILDING[id]["yishitang"]*level) 
--所需民居等级BUILDING[id]["minju"]*level)
--新的所需钱500*(level+1)*math.pow(1.6, math.ceil((level+1)/10))*BUILDING[id]["money"] 
--上限或者效果值 BUILDING[id]["effect"]*level
--库房BUILDING[id]["effect"]+level-1
--升级时间=钱/3200（时辰）
BUILDING = {
            [1]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 0,["money"] = 8, ["effect"] = 1},
            [2]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 0,["money"] = 8, ["effect"] = 100},
            [3]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 0,["money"] = 8, ["effect"] = 5},
            [4]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 8, ["effect"] = 1},
            [5]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 4, ["effect"] = 0.4},
            [6]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 4, ["effect"] = 0.4},
            [7]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 4, ["effect"] = 0.4},
            [8]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 4, ["effect"] = 0.4},
            [9]  = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 4, ["effect"] = 0.4},
            [10] = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 1, ["money"] = 4, ["effect"] = 0.4},
            [11] = {["max_lev"] = 100, ["yishitang"] = 0, ["minju"] = 0,["money"] = 4, ["effect"] = 1},
            [12] = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 0,["money"] = 8, ["effect"] = 20},
            [13] = {["max_lev"] = 100, ["yishitang"] = 1, ["minju"] = 0,["money"] = 8, ["effect"] = 20}
        }
--科技
--1，铸剑；2，制戟；3，机括；4，制盾；5，鞣皮；6，浇铸；7，机械；8，造船；9，驯马；
--10，种植；11，伐木；12，采矿；13，放牧；14，制革；15，贸易；
--书院等级要求TECH[id]["shuyuan"]*level)
--所需金钱TECH[id]["money"]*(TECH[id]["next"]**level)
--上限或者效果值 TECH[id]["effect"]*level
TECH = {
        [1]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [2]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [3]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [4]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [5]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [6]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [7]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [8]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [9]  = {["max_lev"] = 10, ["shuyuan"] = 10, ["money"] = 4,  ["effect"] = 1},
        [10] = {["max_lev"] = 20, ["shuyuan"] = 5,  ["money"] = 3,  ["effect"] = 0.05},
        [11] = {["max_lev"] = 20, ["shuyuan"] = 5,  ["money"] = 3,  ["effect"] = 0.05},
        [12] = {["max_lev"] = 20, ["shuyuan"] = 5,  ["money"] = 3,  ["effect"] = 0.05},
        [13] = {["max_lev"] = 20, ["shuyuan"] = 5,  ["money"] = 3,  ["effect"] = 0.05},
        [14] = {["max_lev"] = 20, ["shuyuan"] = 5,  ["money"] = 3,  ["effect"] = 0.05},
        [15] = {["max_lev"] = 20, ["shuyuan"] = 5,  ["money"] = 3,  ["effect"] = 0.05}
    }

--兵种类型
--1，骑兵系；2，弩兵系；3，步兵系；4，弓骑系；5攻城系；6，水战系；0，特殊；
SOLIDER_TYPE = {
                [0]  = {["type"] = 0, ["speed"] = 5,  ["distance"] = 1}, 
                [1]  = {["type"] = 1, ["speed"] = 20, ["distance"] = 1}, 
                [2]  = {["type"] = 2, ["speed"] = 10, ["distance"] = 2}, 
                [3]  = {["type"] = 3, ["speed"] = 10, ["distance"] = 1},  
                [4]  = {["type"] = 4, ["speed"] = 20, ["distance"] = 2},  
                [5]  = {["type"] = 5, ["speed"] = 5,  ["distance"] = 1},  
                [6]  = {["type"] = 6, ["speed"] = 15, ["distance"] = 2},  
                }       

function get_new_fight_factor(defense)
--    0:无;1:城市;2:关隘;3:大路;4:小路;5:山路;6:河流;7:江海;8:平原;
--    9:草原;10:森林;11:沙漠;12:丘陵;13:山地;14:高地;15:高原;16:攻城;17:守城;
--1:骑兵;2:弩兵;3:步兵;4:弓骑;5:冲车;6:水军
    local gong = 1-defense/500
    local shou = 1+defense/500
    local NEW_FIGHT_FACTOR = {
                            [1]  = {[0] = 0, [1] = 0.8, [2] = 0.5, [3] = 2,   [4] = 1, [5] = 0.8, [6] = 0.5, [7] = 0, [8] = 1,   [9] = 2,   [10] = 0.5, [11] = 1.5, [12] = 1,   [13] = 0.8, [14] = 0.5, [15] = 1.5, [16] = gong, [17] = shou},
                            [2]  = {[0] = 0, [1] = 2,   [2] = 2,   [3] = 1,   [4] = 1, [5] = 1.5, [6] = 1,   [7] = 0, [8] = 1,   [9] = 1,   [10] = 0.5, [11] = 1,   [12] = 1,   [13] = 1.5, [14] = 2,   [15] = 1,   [16] = 1,    [17] = shou},
                            [3]  = {[0] = 0, [1] = 1.5, [2] = 1.5, [3] = 1,   [4] = 1, [5] = 1,   [6] = 1,   [7] = 0, [8] = 1,   [9] = 1,   [10] = 1.5, [11] = 1,   [12] = 1.5, [13] = 1.5, [14] = 1,   [15] = 1,   [16] = gong, [17] = shou},
                            [4]  = {[0] = 0, [1] = 0.8, [2] = 0.5, [3] = 1.5, [4] = 1, [5] = 0.8, [6] = 1,   [7] = 0, [8] = 1,   [9] = 1.5, [10] = 0.5, [11] = 1.5, [12] = 1,   [13] = 1,   [14] = 1,   [15] = 1.5, [16] = 1,    [17] = shou},
                            [5]  = {[0] = 0, [1] = 0,   [2] = 0,   [3] = 0,   [4] = 0, [5] = 0,   [6] = 0,   [7] = 0, [8] = 1,   [9] = 0,   [10] = 0,   [11] = 0,   [12] = 0,   [13] = 0,   [14] = 0,   [15] = 0,   [16] = 1,    [17] = shou},
                            [6]  = {[0] = 0, [1] = 2,   [2] = 1,   [3] = 1,   [4] = 1, [5] = 1,   [6] = 1.5, [7] = 2, [8] = 1,   [9] = 1,   [10] = 1,   [11] = 1,   [12] = 1,   [13] = 1,   [14] = 1,   [15] = 1,   [16] = 1,    [17] = shou},
                            }
    return NEW_FIGHT_FACTOR
end

function get_new_defense_factor(defense)
--    0:无;1:城市;2:关隘;3:大路;4:小路;5:山路;6:河流;7:江海;8:平原;
--    9:草原;10:森林;11:沙漠;12:丘陵;13:山地;14:高地;15:高原;16:攻城;17:守城;
    local x = 1
    local shou = (4+defense/100)/x
    local NEW_FIGHT_FACTOR = {
                            [1]  = {[0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1, [15] = 1, [16] = 1,   [17] = shou},
                            [2]  = {[0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1, [15] = 1, [16] = 1,   [17] = shou},
                            [3]  = {[0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1, [15] = 1, [16] = 1,   [17] = shou},
                            [4]  = {[0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1, [15] = 1, [16] = 1,   [17] = shou},
                            [5]  = {[0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1, [15] = 1, [16] = 1,   [17] = shou},
                            [6]  = {[0] = 0, [1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1, [14] = 1, [15] = 1, [16] = 1,   [17] = shou},
                            }
    return NEW_FIGHT_FACTOR
end


--新手指引
--GUID = {
--        [1] = {["class"] = 1, ["category"] = 1, ["level"] = 0, ["num"] = 0, ["prestige"] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0},
--    }

--资源转换钱
function res_to_money(type)
    return RES[6]["factor"]/RES[type]["factor"]
end

--随机数
math.randomseed(os.time())
tmp = math.random(1000000)


--概率
function get_lucky(s,e,point)
    local lucky = math.random(s,e)
    if lucky <= point then
        return true
    else
        return false
    end
end

--攻击加成
function get_skill_valid(skill,kongfu,intelligence,polity)
    if skill == 31 then
        if (kongfu >= 85 and intelligence >= 75) or (intelligence >= 85 and polity >= 75) or (polity >= 85 and kongfu >= 75) then
            return true
        end
    elseif skill == 32 then
        if (kongfu >= 75 and intelligence >= 85) or (intelligence >= 75 and polity >= 85) or (polity >= 75 and kongfu >= 85) then
            return true
        end
    elseif skill == 28 then
        if kongfu >= 90 and (intelligence >= 80 or polity >= 80) then
            return true
        end
    elseif skill == 29 then
        if intelligence >= 90 and (kongfu >= 80 or polity >= 80) then
            return true
        end
    elseif skill == 30 then
        if polity >= 90 and (intelligence >= 80 or kongfu >= 80) then
            return true
        end
    elseif kongfu >= SKILL[skill]["kongfu"] and intelligence >= SKILL[skill]["intelligence"] and polity >= SKILL[skill]["polity"] then
        return true
    else
        return false
    end
end


--职位
function get_sphere_change(level,city_num,prestige,t,is_vip)
    local sphere_level = level
    local nexts = (level + 1) > 6 and 6 or (level + 1)
    sphere_level = (city_num >= OFFICE[nexts]["city_num"]) and nexts or sphere_level
    return sphere_level,OFFICE[sphere_level]["joins"]
end

--爵位
function get_dignitie_info(id,prestige,is_vip)
    local dignitie_id = id
    local nexts = (dignitie_id + 1) > 6 and 6 or (dignitie_id + 1)
    dignitie_id = (prestige >= DIGNITIE[nexts]["prestige"]) and nexts or dignitie_id
    return DIGNITIE[dignitie_id]["follows"],dignitie_id
end

--解析时间戳
function read_time(t)
    DAY = 12
    MONTH = 30 * 12
    YEAR = 12 * 30 * 12
    year = math.floor(t / YEAR);
    month = math.floor((t - year * YEAR) / MONTH)
    day = math.floor((t - year * YEAR - month * MONTH) / DAY)
    hour = t - year * YEAR - month * MONTH - day * DAY
    return year+1,month+1,day+1,hour+1
end

--坞堡
--参数：1-6资源,1-13建筑等级,1-15科技等级,人口35,户数36,已募兵数37,当前兵源38,声望39,爵位id40,已用制造力41,已治疗伤兵42,是否vip43,时间戳44
--返回：变化1-6资源,变化人口,变化户数,变化兵源,爵位变化,最大武将数目,已使用制造力,已治疗伤兵

function get_wubao_change(...)
--    print ("get_wubao_change")
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
--    增长的资源
    local res1_in = (BUILDING[5]["effect"]*arg[11] ) * RES[1]["factor"] * (1 + TECH[10]["effect"]*arg[28]) * 12
    local res2_in = (BUILDING[6]["effect"]*arg[12] ) * RES[2]["factor"] * (1 + TECH[11]["effect"]*arg[29])
    local res3_in = (BUILDING[7]["effect"]*arg[13] ) * RES[3]["factor"] * (1 + TECH[12]["effect"]*arg[30])
    local res4_in = (BUILDING[8]["effect"]*arg[14] ) * RES[4]["factor"] * (1 + TECH[13]["effect"]*arg[31])
    local res5_in = (BUILDING[9]["effect"]*arg[15] ) * RES[5]["factor"] * (1 + TECH[14]["effect"]*arg[32])
    local res6_in = (BUILDING[10]["effect"]*arg[16]) * RES[6]["factor"] * (1 + TECH[15]["effect"]*arg[33])
    
--    vip资源增长20%
    if arg[43] == 1 then
        res1_in = res1_in * 1.2
        res2_in = res2_in * 1.2
        res3_in = res3_in * 1.2
        res4_in = res4_in * 1.2
        res5_in = res5_in * 1.2
        res6_in = res6_in * 1.2
    end
--    消耗的资源
    local res1_de = arg[35] * 12
    local res2_de = 0
    local res3_de = 0
    local res4_de = 0
    local res5_de = 0
    local res6_de = 0
--    资源变化每月
    local res1_change = res1_in - res1_de
    local res2_change = res2_in - res2_de
    local res3_change = res3_in - res3_de
    local res4_change = res4_in - res4_de
    local res5_change = res5_in - res5_de
    local res6_change = res6_in - res6_de
--    兵源变化每天
    local solider_change = arg[36] / 10 / 30
    local max_solider = BUILDING[13]["effect"]*arg[19] + 500
    solider_change = (arg[38] + solider_change > 0) and solider_change or (0 - arg[38])
    solider_change = (arg[38] + solider_change < max_solider) and solider_change or 0
--    solider_change = (arg[38] + solider_change < max_solider) and solider_change or (max_solider - arg[38])
    
--    户数增长每月
    local family_in = arg[36] * 0.1
--    人口增长每月
    local people_in = family_in * 5 - solider_change
--    人口减少每月
    local people_de = 0
--    户数减少
    local family_de = 0
--    人口和户数变化
    local people_change = people_in - people_de
    local family_change = family_in - family_de
--    爵位变化
    local follows, dignitie_id = get_dignitie_info(arg[40],arg[39],arg[43])
    local dignitie_change = dignitie_id - arg[40]
--    时间戳
    local year,month,day,hour = read_time(arg[44])
    --伤兵和制造力
    local gf_level = arg[10]
    local used_made = 0
    local cure_solider = 0
    local per_made = (gf_level == 0) and 50 or math.floor(gf_level*50)
    used_made = arg[41] - per_made
    if used_made < 0 then
        used_made = 0
    end
    --上下限控制
    local max_res1 = RES[1]["factor"] * arg[11] * BUILDING[5]["effect"] * 120
    local max_res2 = RES[2]["factor"] * arg[12] * BUILDING[6]["effect"] * 120
    local max_res3 = RES[3]["factor"] * arg[13] * BUILDING[7]["effect"] * 120
    local max_res4 = RES[4]["factor"] * arg[14] * BUILDING[8]["effect"] * 120
    local max_res5 = RES[5]["factor"] * arg[15] * BUILDING[9]["effect"] * 120
    local max_res6 = RES[6]["factor"] * arg[16] * BUILDING[10]["effect"] * 120
    
    if max_res1 == 0 then
        max_res1 = RES[1]["factor"] * 24
    end                             
    if max_res2 == 0 then           
        max_res2 = RES[2]["factor"] * 24
    end                             
    if max_res3 == 0 then           
        max_res3 = RES[3]["factor"] * 24
    end                             
    if max_res4 == 0 then           
        max_res4 = RES[4]["factor"] * 24
    end                             
    if max_res5 == 0 then           
        max_res5 = RES[5]["factor"] * 24
    end                             
    if max_res6 == 0 then           
        max_res6 = RES[6]["factor"] * 24
    end
    
    
    
    res1_change = math.floor((arg[1] + res1_change > 0) and res1_change or (0 - arg[1]))
    if (arg[1] >= max_res1) then
        res1_change = 0
    elseif (res1_change + arg[1] >= max_res1) then
        res1_change = math.floor(max_res1 - arg[1])
    else
        res1_change = math.floor(res1_change)
    end
    
    res2_change = math.floor((arg[2] + res2_change > 0) and res2_change or (0 - arg[2]))
    if (arg[2] >= max_res2) then
        res2_change = 0
    elseif (res2_change + arg[2] >= max_res2) then
        res2_change = math.floor(max_res2 - arg[2])
    else
        res2_change = math.floor(res2_change)
    end
    
    res3_change = math.floor((arg[3] + res3_change > 0) and res3_change or (0 - arg[3]))
    if (arg[3] >= max_res3) then
        res3_change = 0
    elseif (res3_change + arg[3] >= max_res3) then
        res3_change = math.floor(max_res3 - arg[3])
    else
        res3_change = math.floor(res3_change)
    end
    
    
    res4_change = math.floor((arg[4] + res4_change > 0) and res4_change or (0 - arg[4]))
    if (arg[4] >= max_res4) then
        res4_change = 0
    elseif (res4_change + arg[4] >= max_res4) then
        res4_change = math.floor(max_res4 - arg[4])
    else
        res4_change = math.floor(res4_change)
    end
    
    
    res5_change = math.floor((arg[5] + res5_change > 0) and res5_change or (0 - arg[5]))
    if (arg[5] >= max_res5) then
        res5_change = 0
    elseif (res5_change + arg[5] >= max_res5) then
        res5_change = math.floor(max_res5 - arg[5])
    else
        res5_change = math.floor(res5_change)
    end
    
    res6_change = math.floor((arg[6] + res6_change > 0) and res6_change or (0 - arg[6]))
    if (arg[6] >= max_res6) then
        res6_change = 0
    elseif (res6_change + arg[6] >= max_res6) then
        res6_change = math.floor(max_res6 - arg[6])
    else
        res6_change = math.floor(res6_change)
    end
    
    local max_family = (BUILDING[2]["effect"]*arg[8] > 50) and BUILDING[2]["effect"]*arg[8] or 50
    local max_people = max_family * 5
    people_change = (arg[35] + people_change > 250) and people_change or (250 - arg[35])
    people_change = (arg[35] + people_change < max_people) and people_change or (max_people - arg[35])
    family_change = (arg[36] + family_change > 50) and family_change or (50 - arg[36])
    family_change = (arg[36] + family_change < max_family) and family_change or (max_family - arg[36])
    
    if day ~= 1 then
        res1_change = 0
        res2_change = 0
        res3_change = 0
        res4_change = 0
        res5_change = 0
        res6_change = 0
--        follows = DIGNITIE[arg[40]]["follows"]
--        dignitie_change = 0
    end
    if month ~= 9 then
        res1_change = 0
    end
--    print (res1_change,res2_change,res3_change,res4_change,res5_change,res6_change,people_change,family_change,solider_change,dignitie_change,follows,used_made,cure_solider)
--    io.flush()
    return res1_change,res2_change,res3_change,res4_change,res5_change,res6_change,people_change,family_change,solider_change,dignitie_change,follows,used_made,cure_solider
end

--武将
--参数：
--1,武将类型;2,出生年份;3,出场年份;4,所在;5,武力;6,智力;7,政治;8,移动;
--9,忠诚度;10,官位;11,技能标志位;12,阵法;
--13,当前使用阵法;14,所带兵数量;15,伤兵数目;16,所带兵种训练度;
--17,所带兵种士气;18,杀敌数目;
--19,所需最小友好度
--20,主武器;21,主武器等级;22,副武器;
--23,副武器等级;24,护甲;25,护甲等级;26,特殊物品;27,特殊物品等级;
--28,钱;29,粮;30,当前时间戳;31,是否vip;32,是否npc
--返回
--消耗钱,消耗粮,忠诚度变化,可带兵数,士气变化,训练度变化,士兵数目变化

function get_general_wubao(...)
--    print ("get_general_wubao")
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
    local year,month,day,hour = read_time(arg[30])
    local money = 0
    local food = 0
    local faith = 0
    local spirit = 0
    local train = 0
    local solider = 0
    local follows = OFFICIAL[arg[10]]["follows"]
    if day == 1 then
        money = (OFFICIAL[arg[10]]["salary"] + follows*3)/2 * res_to_money(1)
        food = (OFFICIAL[arg[10]]["salary"] + follows*3)/2
        
        if arg[28] < money or arg[29] < food then
            faith = faith - math.random(1, 5)
            spirit = spirit - math.random(10, 30)
        end
--        if arg[1] == 1 then
--            faith = faith - arg[23]/5000
--        end
        if arg[17] <= 0 then
            solider = solider - follows*math.random(30, 50)/100
        end
    end
    
    if arg[32] == 1 then
        faith = 0
    end
    --上下限控制
    money = (arg[28] > money) and money or arg[28]
    food = (arg[29] > food) and food or arg[29]
    faith = (arg[9] + faith > 0) and faith or (0 - arg[9])
    spirit = (arg[17] + spirit > 0) and spirit or (0 - arg[17])
--    train = (arg[16] + train > 0) and train or (0 - arg[16])
    solider = (arg[14] + solider > 0) and solider or (0 - arg[14])
--    print (money,food,faith,follows,spirit,train,-solider)
--    io.flush()
    return money,food,faith,follows,spirit,train,-solider
end

function get_general_army(...)
--    print ("get_general_army")
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
    local money = (arg[14] + arg[15]) * 10
    local food = (arg[14] + arg[15]) * 0.1
    local faith = 0
    local spirit = 0
    local train = 0
    local solider = 0
    if arg[28] <= 0 or arg[29] <= 0 then
        spirit = spirit - math.random(10, 30)
    end 
    local follows = OFFICIAL[arg[10]]["follows"]
    if arg[17] <= 0 then
        solider = solider - follows*math.random(30, 50)/100
    end
    --上下限控制
    money = (arg[28] > money) and money or arg[28]
    food = (arg[29] > food) and food or arg[29]
    faith = (arg[9] + faith > 0) and faith or (0 - arg[9])
    spirit = (arg[17] + spirit > 0) and spirit or (0 - arg[17])
--    train = (arg[16] + train > 0) and train or (0 - arg[16])
    solider = (arg[14] + solider > 0) and solider or (0 - arg[14])
--    print (money,food,faith,follows,spirit,train,-solider)
--    io.flush()
    return money,food,faith,follows,spirit,train,-solider
end


--升级
--1-6资源,1-13建筑等级,1-15科技等级,人口35,户数36,已募兵数37,当前兵源38,声望39,爵位id40,是否vip41,时间戳42,升级类型(1建筑2科技)43,类型44
--返回：是否可升级，1-6资源消耗，所需时辰

--议事堂所需声望100*(level+1)
--所需议事堂等级BUILDING[id]["yishitang"]*level) 
--所需民居等级BUILDING[id]["minju"]*level)
--新的所需钱500*(level+1)*math.pow(1.6, math.ceil((level+1)/10))*BUILDING[id]["money"] 
--上限或者效果值 BUILDING[id]["effect"]*level
--库房BUILDING[id]["effect"]+level-1
--升级时间=钱/3200（时辰）取整

--书院等级要求TECH[id]["shuyuan"]*level)
--所需金钱500*(level+1)*math.pow(1.6, math.ceil((level+1)/10))*TECH[id]["money"]
--上限或者效果值 TECH[id]["effect"]*level

function level_up(...)
--    print ("level_up")
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
    local yishitang = arg[17]
    local minju = arg[8]
    local shuyuan = arg[7]
    local money = arg[6]
    local prestige = arg[39]
    local is_ok = 0
    local res1 = 0
    local res2 = 0
    local res3 = 0
    local res4 = 0
    local res5 = 0
    local res6 = 0
    local hour = 0
    local id = arg[44]
    local building = id + 6
    local tech = id + 19
    local level = 0
    local hour = 0
    if arg[43] == 1 then
        level = arg[building]
        if level >= BUILDING[id]["max_lev"] then
            is_ok = 0
        else
            res6 = 500*(level+1)*math.pow(1.6, math.ceil((level+1)/10))*BUILDING[id]["money"]
            hour = math.ceil(res6/3200)
            if id == 11 then
                if prestige >= (level+1)*100
                    and minju >= BUILDING[id]["minju"]*level
                    and money >= res6 then
                    is_ok = 1
                end
            else
                if yishitang > BUILDING[id]["yishitang"]*level 
                    and minju >= BUILDING[id]["minju"]*(level+1)
                    and money >= res6 then
                    is_ok = 1
                end
            end
        end
    else
        level = arg[tech]
        if level >= TECH[id]["max_lev"] then
            is_ok = 0
        else
            res6 = 6400 * math.pow((level+1),TECH[id]["money"])
            factor = math.log10(shuyuan + 10)
            hour = math.ceil(res6/3200/factor)
            if shuyuan >= TECH[id]["shuyuan"]*level and money >= res6 then
                is_ok = 1
            end
        end
    end
--    print (is_ok,res1,res2,res3,res4,res5,res6,hour)
--    io.flush()
    return is_ok,res1,res2,res3,res4,res5,res6,hour
end


--征战加速
function get_war_acc_money(hour)
--    print ("get_war_acc_money")
--    print (hour)
--    io.flush()
    return math.ceil(hour/3)
end

--建筑加速
function get_acc_money(hour)
--    print ("get_acc_money")
--    print (hour)
--    io.flush()
    return math.ceil(hour/12)
end

--生产
--1-6资源,户数7,是否vip8,已使用生产力9,物资类型10,物资数量11,工坊等级12,库房等级13,已用库存14
--返回：是否可生产，1-6资源数目，消耗制造力
function made_weapon(...)
--    print ("made_weapon")
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
    local gongfang = arg[12]
    local kufang = BUILDING[3]["effect"] + arg[13] - 1
    local made = (gongfang == 0) and (1000-arg[9]) or (gongfang*1500 - arg[9])
    local id = arg[10]
    local num = arg[11]
    local res1 = WEAPON[id][1]*num
    local res2 = WEAPON[id][2]*num
    local res3 = WEAPON[id][3]*num
    local res4 = WEAPON[id][4]*num
    local res5 = WEAPON[id][5]*num
    local res6 = WEAPON[id][6]*num
    local need_made = WEAPON[id]["made"]*num
    local is_ok = 0
    if made >= need_made 
        and arg[1] >= res1
        and arg[2] >= res2
        and arg[3] >= res3
        and arg[4] >= res4
        and arg[5] >= res5
        and arg[6] >= res6
        and gongfang >= WEAPON[id]["gongfang"]
        and kufang - arg[14] >= 1 then
        is_ok = 1
    end
--    print (is_ok,res1,res2,res3,res4,res5,res6,need_made)
--    io.flush()
    return is_ok,res1,res2,res3,res4,res5,res6,need_made
end

--销毁
function destroy(type,level, num)
--    print ("destroy")
--    print (type,level, num)
    local money = WEAPON[type][6]
    for i = 1,5 do
        money = money + res_to_money(i)*WEAPON[type][i] /2
    end
    money = money * math.pow(2,level) * num
--    print (math.floor(money))
--    io.flush()
    return math.floor(money)
end

--合成
--参数：装备类型1,装备等级2,装备数量3,装备总数量4,1-15科技等级
--是否可以合成,合成等级,合成数量
function combin(...)
--    print ("combin")
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
    local id = arg[1]
    local tech_lev = arg[4+id]
    local level = arg[2]
    local num = arg[3]
    local total = arg[4]
    local is_ok = 0
    local become_lev = level + 1
    local become_num = math.floor(num/2)
    if id > 9 then
        is_ok = 1
    else
        if total >= num and tech_lev >= become_lev then
            is_ok = 1
        end
    end
--    print (is_ok,become_lev,become_num)
--    io.flush()
    return is_ok,become_lev,become_num
end

--武装
--w1 2|3 not w2 4;w4 7,8 not any
--参数：1-4装备类型
--返回：是否可装配
--1，剑；2，戟；3，弓；4，盾；5，皮甲；6，铁甲；7，冲车；8，战船；9，战马；
--10，百炼刀；11，点钢枪；12，神臂弩；13，精铁盾；14，鱼鳞甲；15，大宛马

function config_sol(w1,w2,w3,w4,sol_num)
    local is_ok = 0
    if (w1~=0 and WEAPON[w1]["site"]~=1)
        or (w2~=0 and WEAPON[w2]["site"]~=2)
        or (w3~=0 and WEAPON[w3]["site"]~=3)
        or (w4~=0 and WEAPON[w4]["site"]~=4) then
        is_ok = 0
    else
        if (w1 == 2 or w1 == 3 or w1 == 11 or w1 == 12) and (w2 == 4 or w2 == 13) then
            is_ok = 0
        elseif (w4 == 7 or w4 == 8) and (w1~=0 or w2~=0 or w3~=0) then
            is_ok = 0
        else
            is_ok = 1
        end
    end
    local num1 = (w1==0) and 0 or math.ceil(sol_num/WEAPON[w1]["div"])
    local num2 = (w2==0) and 0 or math.ceil(sol_num/WEAPON[w2]["div"])
    local num3 = (w3==0) and 0 or math.ceil(sol_num/WEAPON[w3]["div"])
    local num4 = (w4==0) and 0 or math.ceil(sol_num/WEAPON[w4]["div"])
    return is_ok, num1, num2, num3, num4
end

function get_sol_per_weapon(id)
    return WEAPON[id]["div"]
end


--出征
function create_army(money,food,type,days,solider)
    local is_ok = 0
    local need_money = math.ceil(solider * days * 10)
    local need_food = math.ceil(solider * days * 0.1)
    if type == 1 and days > 10 then
        is_ok = 0
    elseif money<need_money or food<need_food then
        is_ok = 0
    else
        is_ok = 1
    end
    return is_ok,need_money,need_food
end

--治疗
function cure_solider(level,hurt,cur_hurt,is_vip)
    local max_cure = BUILDING[12]["effect"]*level + 500
    local solider = max_cure - cur_hurt
    if solider > hurt then
        solider = hurt
    end
    return solider
end

--招募
--type:0,普通;1,历史
function get_general(gen_type,friendly,need_friendly,is_vip)
--    print ("get_general")
--    print (gen_type,friendly,need_friendly,is_vip)
    local is_ok = 0
    if gen_type == 1 then
        if (friendly >= need_friendly) then
            is_ok = 1
        elseif (friendly > need_friendly*0.8) then
            lucky = math.random(0,(need_friendly - friendly))
            if lucy == 0 then
                is_ok = 1
            end
        end
    else
        is_ok = 1
    end
--    print ("is_ok" .. is_ok)
--    io.flush()
    return is_ok
end

--创建势力
function create_sphere(yst_level, is_vip)
    if yst_level >= 30 then
        return 1
    else
        return 0
    end
end

--加入势力
function join_sphere(yst_level, office, people, is_vip)
    if yst_level >= 10 then
        if OFFICE[office]["joins"] <= people then
            return 0
        else
            return 1
        end
    else
        return 0
    end

end

--申请官位
function apply_official(id, feat)
    if feat >= OFFICIAL[id]["feat"] then
        return 1
    else
        return 0
    end
end


--战争回合时辰数
function get_war_time()
    return 1
end

--解析技能
function dec_bin(n,len)
    a = ''
    while(n>0) do
        a = (n % 2)..a
        n = math.floor(n / 2)
    end
    if len ~= nil then
        lenth = string.len(a)
        add = string.rep('0',(len - lenth))
        a = add..a
    end
    return a
end

--治疗效果(去掉)
function get_zhiliao_effect(skill,hurt)
    local str_skill = dec_bin(skill,32)
    local sol = 0
    if string.sub(str_skill,5,5) == "1" then
        sol = math.floor(hurt * SKILL[28]["effect"])
    end
    return sol
end

--触发技能
function get_nb_skill(spirit,skill,kongfu,intelligence,polity)
    local str_skill = dec_bin(skill,32)
    local flag = 0
    --士气大于80鼓舞触发几率
    local guwu = false
    local nb_skill = 0
    if spirit < 80 then
        if get_lucky(1,100,5) then
            if string.sub(str_skill,1,1) == "1" and get_skill_valid(32,kongfu,intelligence,polity) then 
                nb_skill = 32
            end
        end
        if get_lucky(1,100,5) and nb_skill==0 then
            if string.sub(str_skill,5,5) == "1" and get_skill_valid(28,kongfu,intelligence,polity) then
                nb_skill = 28
            end
        end
    else
        local lucky = spirit - 80
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,8,8) == "1" and get_skill_valid(25,kongfu,intelligence,polity) then
                nb_skill = 25
            end
        end
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,7,7) == "1" and get_skill_valid(26,kongfu,intelligence,polity) then
                nb_skill = 26
            end
        end
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,6,6) == "1" and get_skill_valid(27,kongfu,intelligence,polity) then
                nb_skill = 27
            end
        end
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,5,5) == "1" and get_skill_valid(28,kongfu,intelligence,polity) then
                nb_skill = 28
            end
        end
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,4,4) == "1" and get_skill_valid(29,kongfu,intelligence,polity) then
                nb_skill = 29
            end
        end
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,2,2) == "1" and get_skill_valid(31,kongfu,intelligence,polity) then
                nb_skill = 31
            end
        end
        if get_lucky(1,100,lucky) and nb_skill==0 then
            if string.sub(str_skill,1,1) == "1" and get_skill_valid(32,kongfu,intelligence,polity) then
                nb_skill = 32
            end
        end
    end
    return nb_skill
end


--战争辅助函数

--1，剑；2，戟；3，弓；4，盾；5，皮甲；6，铁甲；7，甲车；8，弩车；9，战马；
--10，百炼刀；11，点钢枪；12，诸葛弩；13，虎纹盾；14，鱼鳞甲；15，乌孙马
--1，骑兵系；2，弩兵系；3，步兵系；4，弓骑系；5弩车系；6，甲车系；0，特殊；
function get_solider_type(w1,w2,w3,w4)
    local solider_type = 3
    if w4 == 8 then
        solider_type = 5
    elseif w4 == 7 then
        solider_type = 6
    elseif w4 == 9 or w4 == 15 then
        if w1 == 3 or w1 == 12 then
            solider_type = 4
        else
            solider_type = 1
        end
    else
        if w1 == 3 or w1 == 12 then
            solider_type = 2
        else
            solider_type = 3
        end
    end
    return solider_type
end

--判断阵法是否有效
function get_zhen_valid(zhen,kongfu,intelligence,polity)
    if zhen == 0 then
        return true
    elseif zhen == 1 and kongfu >= ZHEN[zhen]["kongfu"] then
        return true
    elseif zhen == 2 and intelligence >= ZHEN[zhen]["intelligence"] then
        return true
    elseif zhen == 3 and polity >= ZHEN[zhen]["polity"] then
        return true
    elseif zhen == 4 and kongfu >= ZHEN[zhen]["kongfu"] and intelligence >= ZHEN[zhen]["intelligence"] then
        return true
    elseif zhen == 5 and (kongfu >= ZHEN[zhen]["kongfu"] or polity >= ZHEN[zhen]["polity"]) and intelligence >= ZHEN[zhen]["intelligence"] then
        return true
    elseif zhen == 6 and (polity >= ZHEN[zhen]["polity"] or kongfu >= ZHEN[zhen]["kongfu"] or intelligence >= ZHEN[zhen]["intelligence"]) then
        return true
    elseif zhen == 7 and kongfu >= ZHEN[zhen]["kongfu"] and intelligence >= ZHEN[zhen]["intelligence"] then
        return true
    elseif zhen == 8 and polity >= ZHEN[zhen]["polity"] and intelligence >= ZHEN[zhen]["intelligence"] then
        return true
    elseif zhen == 9 and polity >= ZHEN[zhen]["polity"] and kongfu >= ZHEN[zhen]["kongfu"] then
        return true
    elseif zhen == 10 and polity >= ZHEN[zhen]["polity"] and kongfu >= ZHEN[zhen]["kongfu"] and intelligence >= ZHEN[zhen]["intelligence"] then
        return true
    else
        return false
    end
end

--获取攻击和防御以及机动加成
function get_all_gain(solider_type,skill,zhen,kongfu,intelligence,polity,speed)
    local str_skill = dec_bin(skill,32)
    local fight = 1
    local defense = 1
    local flex = 1
    
    if string.sub(str_skill,30,30) == "1" and get_skill_valid(3,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[3]["type"] then
            fight = fight * (1 + SKILL[3]["effect"])
        end
    elseif string.sub(str_skill,31,31) == "1" and get_skill_valid(2,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[2]["type"] then
            fight = fight * (1 + SKILL[2]["effect"])
        end
    elseif string.sub(str_skill,32,32) == "1" and get_skill_valid(1,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[1]["type"] then
            fight = fight * (1 + SKILL[1]["effect"])
        end
    end
    
    if string.sub(str_skill,29,29) == "1" and get_skill_valid(4,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[4]["type"] then
            fight = fight * SKILL[4]["effect"]
        end
    end
    if string.sub(str_skill,26,26) == "1" and get_skill_valid(7,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[7]["type"] then
            fight = fight * (1 + SKILL[7]["effect"])
        end
    elseif string.sub(str_skill,27,27) == "1" and get_skill_valid(6,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[6]["type"] then
            fight = fight * (1 + SKILL[6]["effect"])
        end
    elseif string.sub(str_skill,28,28) == "1" and get_skill_valid(5,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[5]["type"] then
            fight = fight * (1 + SKILL[5]["effect"])
        end
    end
    if string.sub(str_skill,25,25) == "1" and get_skill_valid(8,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[8]["type"] then
            fight = fight * SKILL[8]["effect"]
        end
    end
    if string.sub(str_skill,22,22) == "1" and get_skill_valid(11,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[11]["type"] then
            fight = fight * (1 + SKILL[11]["effect"])
        end
    elseif string.sub(str_skill,23,23) == "1" and get_skill_valid(10,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[10]["type"] then
            fight = fight * (1 + SKILL[10]["effect"])
        end
    elseif string.sub(str_skill,24,24) == "1" and get_skill_valid(9,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[9]["type"] then
            fight = fight * (1 + SKILL[9]["effect"])
        end
    end
    if string.sub(str_skill,21,21) == "1" and get_skill_valid(12,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[12]["type"] then
            fight = fight * SKILL[12]["effect"]
        end
    end
    if string.sub(str_skill,18,18) == "1" and get_skill_valid(15,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[15]["type"] then
            fight = fight * (1 + SKILL[15]["effect"])
        end
    elseif string.sub(str_skill,19,19) == "1" and get_skill_valid(14,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[14]["type"] then
            fight = fight * (1 + SKILL[14]["effect"])
        end
    elseif string.sub(str_skill,20,20) == "1" and get_skill_valid(13,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[13]["type"] then
            fight = fight * (1 + SKILL[13]["effect"])
        end
    end
    if string.sub(str_skill,17,17) == "1" and get_skill_valid(16,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[16]["type"] then
            fight = fight * SKILL[16]["effect"]
        end
    end
    if string.sub(str_skill,14,14) == "1" and get_skill_valid(19,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[19]["type"] then
            fight = fight * (1 + SKILL[19]["effect"])
        end
    elseif string.sub(str_skill,15,15) == "1" and get_skill_valid(18,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[18]["type"] then
            fight = fight * (1 + SKILL[18]["effect"])
        end
    elseif string.sub(str_skill,16,16) == "1" and get_skill_valid(17,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[17]["type"] then
            fight = fight * (1 + SKILL[17]["effect"])
        end
    end
    if string.sub(str_skill,13,13) == "1" and get_skill_valid(20,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[20]["type"] then
            fight = fight * SKILL[20]["effect"]
        end
    end
    if string.sub(str_skill,10,10) == "1" and get_skill_valid(23,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[23]["type"] then
            defense = defense * (1 + SKILL[23]["effect"])
        end
    elseif string.sub(str_skill,11,11) == "1" and get_skill_valid(22,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[22]["type"] then
            defense = defense * (1 + SKILL[22]["effect"])
        end
    elseif string.sub(str_skill,12,12) == "1" and get_skill_valid(21,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[21]["type"] then
            defense = defense * (1 + SKILL[21]["effect"])
        end
    end
    if string.sub(str_skill,9,9) == "1" and get_skill_valid(24,kongfu,intelligence,polity) then
        if SOLIDER_TYPE[solider_type]["type"] == SKILL[24]["type"] then
            defense = defense * SKILL[24]["effect"]
        end
    end
    
    --阵的攻防加成
    if get_zhen_valid(zhen,kongfu,intelligence,polity) then
        fight = fight * (4 + ZHEN[zhen]["attack"])/4
        defense = defense * (4 + ZHEN[zhen]["defense"])/4
        flex = flex * (4 + ZHEN[zhen]["speed"])/4
    else
        fight = fight * (4 + ZHEN[0]["attack"])/4
        defense = defense * (4 + ZHEN[0]["defense"])/4
        flex = flex * (4 + ZHEN[0]["speed"])/4
    end
    
    --武将属性加成
    fight = fight * (math.log10((kongfu-30)/20) + 1)
    defense = defense * (math.log10((intelligence-30)/20) + 1)
    flex = flex * (math.log10((polity-30)/20) + 1)
    flex = flex * (1+(speed-25)/100)
    return fight, defense,flex
end

--0:无;1:城市;2:关隘;3:大路;4:小路;5:山路;6:河流;7:江海;8:平原;
--    9:草原;10:森林;11:沙漠;12:丘陵;13:山地;14:高地;15:高原;16:攻城;17:守城;
function get_solider_fight(area,city_defense,train,w1_type,w1_level,w2_type,w2_level,w3_type,w3_level,w4_type,w4_level)
    local fight = 5
    local solider_type = get_solider_type(w1_type,w2_type,w3_type,w4_type)
    local factor = get_new_fight_factor(city_defense)
    fight = fight + WEAPON[w1_type]["attack"]*(1+w1_level)
    fight = fight + WEAPON[w2_type]["attack"]*(1+w2_level)
    fight = fight + WEAPON[w3_type]["attack"]*(1+w3_level)
    fight = fight + WEAPON[w4_type]["attack"]*(1+w4_level)
    train = train + 5
    fight = factor[solider_type][area] * fight * train / 100
    return fight
end

function get_solider_defense(area,city_defense,train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level)
    local defense = 5
    local solider_type = get_solider_type(w1_type,w2_type,w3_type,w4_type)
    local factor = get_new_defense_factor(city_defense)
    defense = defense + WEAPON[w1_type]["defense"]*(1+w1_level)
    defense = defense + WEAPON[w2_type]["defense"]*(1+w2_level)
    defense = defense + WEAPON[w3_type]["defense"]*(1+w3_level)
    defense = defense + WEAPON[w4_type]["defense"]*(1+w4_level)
    train = train + 5
    defense = factor[solider_type][area] * defense * train / 100
    return defense
end

function get_wild_fight(area, solider_num, train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_levle,w4_type,w4_level,zhen,skill,other_skill,self_skill,kongfu,intelligence,polity,speed)
    local str_skill = dec_bin(skill,32)
    local solider_type = get_solider_type(w1_type,w2_type,w3_type,w4_type)
    local change_spirit = 0
    --己方技能影响
    local wushuang = 1
    if self_skill == 25 then
        wushuang = 2
    elseif self_skill == 28 then
        wushuang = 1.3
    elseif self_skill == 32 then
        change_spirit =  change_spirit + 3
    end
    --对方技能的影响
    if other_skill == 31 then
        if string.sub(str_skill,3,3) ~= "1" then
            change_spirit =  change_spirit - 10
        end
    elseif other_skill == 26 then
        zhen = 0
    elseif other_skill == 27 then
        wushuang = wushuang * 0.5
    elseif other_skill == 29 then
        if string.sub(str_skill,3,3) ~= "1" then
            return 0,change_spirit
        end
    end
    local solider_fight = get_solider_fight(area,0,train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_levle,w4_type,w4_level)
    --攻击加成
    local attack_gain,defense_gain,speed_gain = get_all_gain(solider_type,skill,zhen,kongfu,intelligence,polity,speed)
    
    --系数
    local fac = math.log10(math.ceil(solider_num/10))
    if fac <= 0 then
        fac = 0.2
    end
    local fight = solider_fight * solider_num * wushuang * attack_gain/fac
    return fight,change_spirit
end

function get_attack_city_fight(city_defense, city_level, solider_num, train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level,zhen,skill,self_skill,kongfu,intelligence,polity,speed)
    local str_skill = dec_bin(skill,32)
    local solider_type = get_solider_type(w1_type,w2_type,w3_type,w4_type)
    local change_spirit = 0
    --己方技能影响
    local wushuang = 1
    if self_skill == 25 then
        wushuang = 2
    elseif self_skill == 32 then
        change_spirit = change_spirit + 3
    end
    local solider_fight = get_solider_fight(16,city_defense,train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level)
    --攻击加成
    local attack_gain, defense_gain, speed_gain = get_all_gain(solider_type,skill,0,kongfu,intelligence,polity,speed)
    if solider_num > (city_level*200) then
        solider_num = city_level * 200
    end 
    local fight = solider_fight * solider_num * wushuang * attack_gain
    
    return fight,change_spirit
end

function get_keep_city_fight(city_defense, city_level, solider_num, other_skill)
    local change_spirit = 0
    --对方技能的影响
    local wushuang = 1
    if other_skill == 31 then
        change_spirit =  change_spirit - 10
    elseif other_skill == 26 then
        zhen = 0
    elseif other_skill == 27 then
        wushuang = wushang * 0.5
    elseif other_skill == 29 then
        return 0,change_spirit
    end
    local solider_fight = get_solider_fight(17,city_defense,30,3,0,0,0,0,0,0,0)
    if solider_num > (city_level*200) then
        solider_num = city_level * 200
    end  
    local fight = solider_fight * solider_num * wushuang
    return fight, change_spirit
end


function get_war_consume(area,city_defense,train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level,attack,num,zhen,skill,kongfu,intelligence,polity,speed,other_skill)
    local x = 0.25
    local lucky = math.random(0,num/10) / 20000
    local defense = get_solider_defense(area,city_defense,train,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level)
    local str_skill = dec_bin(skill,32)
    if other_skill == 26 then
        zhen = 0
    end
    
    --技能和阵法的防御加成
    local solider_type = get_solider_type(w1_type,w2_type,w3_type,w4_type)
    local attack_gain,defense_gain,speed_gain = get_all_gain(solider_type,skill,zhen,kongfu,intelligence,polity,speed)
    defense = defense * defense_gain
    local consume = math.ceil(attack / ( defense * (1 + lucky)) * x)
     
    return (consume > num) and num or consume
end


--机动力
function get_solider_flexible(skill,zhen,w1_type,w2_type,w3_type, w4_type,kongfu,intelligence,polity,speed)
    local flex = 10
    local solider_type = get_solider_type(w1_type,w2_type,w3_type,w4_type)
    flex = flex + WEAPON[w1_type]["flexible"] + WEAPON[w2_type]["flexible"] + WEAPON[w3_type]["flexible"] + WEAPON[w4_type]["flexible"]
    local attack_gain,defense_gain,speed_gain = get_all_gain(solider_type,skill,zhen,kongfu,intelligence,polity,speed)
    flex = flex * speed_gain
    return flex
end


--军团战争
--返回
--A士兵损耗,A触发技能,A士气变化,B士兵损耗,B触发技能,B士气变化
function get_war_army(skill1,zhen1,sol1_num,sol1_hurt,spirit1,train1,area1,wa1_type,wa1_level,
        wa2_type,wa2_level,wa3_type,wa3_level,wa4_type,wa4_level,kongfu1,intelligence1,polity1,speed1,is_vip1,
        skill2,zhen2,sol2_num,sol2_hurt,spirit2,train2,area2,wb1_type,wb1_level,
        wb2_type,wb2_level,wb3_type,wb3_level,wb4_type,wb4_level,kongfu2,intelligence2,polity2,speed2,is_vip2)
    
--    print ("get_war_army")
--    print (
--    "skill1         = " .. skill1         .. "\n" ..
--    "zhen1          = " .. zhen1          .. "\n" ..
--    "sol1_num       = " .. sol1_num       .. "\n" ..
--    "spirit1        = " .. spirit1        .. "\n" ..
--    "train1         = " .. train1         .. "\n" ..
--    "area1          = " .. area1          .. "\n" ..
--    "wa1_type       = " .. wa1_type       .. "\n" ..
--    "wa1_level      = " .. wa1_level      .. "\n" ..
--    "wa2_type       = " .. wa2_type       .. "\n" ..
--    "wa2_level      = " .. wa2_level      .. "\n" ..
--    "wa3_type       = " .. wa3_type       .. "\n" ..
--    "wa3_level      = " .. wa3_level      .. "\n" ..
--    "wa4_type       = " .. wa4_type       .. "\n" ..
--    "wa4_level      = " .. wa4_level      .. "\n" ..
--    "kongfu1        = " .. kongfu1        .. "\n" ..
--    "intelligence1  = " .. intelligence1  .. "\n" ..
--    "polity1        = " .. polity1        .. "\n" ..
--    "speed1        = " .. speed1        .. "\n" ..
--    "is_vip1        = " .. is_vip1        .. "\n" ..
--    "skill2         = " .. skill2         .. "\n" ..
--    "zhen2          = " .. zhen2          .. "\n" ..
--    "sol2_num       = " .. sol2_num       .. "\n" ..
--    "spirit2        = " .. spirit2        .. "\n" ..
--    "train2         = " .. train2         .. "\n" ..
--    "area2          = " .. area2          .. "\n" ..
--    "wb1_type       = " .. wb1_type       .. "\n" ..
--    "wb1_level      = " .. wb1_level      .. "\n" ..
--    "wb2_type       = " .. wb2_type       .. "\n" ..
--    "wb2_level      = " .. wb2_level      .. "\n" ..
--    "wb3_type       = " .. wb3_type       .. "\n" ..
--    "wb3_level      = " .. wb3_level      .. "\n" ..
--    "wb4_type       = " .. wb4_type       .. "\n" ..
--    "wb4_level      = " .. wb4_level      .. "\n" ..
--    "kongfu2        = " .. kongfu2        .. "\n" ..
--    "intelligence2  = " .. intelligence2  .. "\n" ..
--    "polity2        = " .. polity2        .. "\n" ..
--    "speed2        = " .. speed2        .. "\n" ..
--    "is_vip2        = " .. is_vip2        .. "\n" 
--    )
     if speed1 < 25 then
        speed1 = 25
     end
     if speed2 < 25 then
        speed2 = 25
     end
    local nb_skill1 = get_nb_skill(spirit1,skill1,kongfu1,intelligence1,polity1)
    local nb_skill2 = get_nb_skill(spirit2,skill2,kongfu2,intelligence2,polity2)
    local fight1,change_spirit1 = get_wild_fight(area1, sol1_num, train1,wa1_type,wa1_level,wa2_type,wa2_level,wa3_type, wa3_level,wa4_type,wa4_level,zhen1,skill1,nb_skill2,nb_skill1,kongfu1,intelligence1,polity1,speed1)
    local fight2,change_spirit2 = get_wild_fight(area2, sol2_num, train2,wb1_type,wb1_level,wb2_type,wb2_level,wb3_type, wb3_level,wb4_type,wb4_level,zhen2,skill2,nb_skill1,nb_skill2,kongfu2,intelligence2,polity2,speed2)
    --武器相克
    --1，w1剑；2，w1戟；3，w1弓；4，w2盾；5，w3皮甲；6，w3铁甲；7，w4甲车；8，w4弩车；9，w4战马
--    10，百炼刀；11，点钢枪；12，诸葛弩；13，虎纹盾；14，鱼鳞甲；15，乌孙马
    if (wa1_type == 3 or wa1_type == 12) and (wb2_type == 4 or wb2_type == 13) then
        fight1 = fight1 * 0.8
    elseif (wa1_type == 2 or wa1_type == 11) and (wb2_type == 4 or wb2_type == 13) then
        fight1 = fight1 * 1.25
    elseif (wa1_type == 3 or wa1_type == 12) and (wb1_type == 2 or wb1_type == 11) then
        fight1 = fight1 * 1.25
    elseif wa4_type == 8 and wb4_type == 7 then
        fight1 = fight1 * 1.25
    elseif wa4_type ~= 8 and wb4_type == 7 then
        fight1 = fight1 * 0.8
    elseif wa4_type ~= 7  and wb4_type == 8 then
        fight1 = fight1 * 1.25
    end
    
    if (wb1_type == 3 or wb1_type == 12) and (wa2_type == 4 or wa2_type == 13) then
        fight2 = fight2 * 0.8
    elseif (wb1_type == 2 or wb1_type == 11) and (wa2_type == 4 or wa2_type == 13) then
        fight2 = fight2 * 1.25
    elseif (wb1_type == 3 or wb1_type == 12) and (wa1_type == 2 or wa1_type == 11) then
        fight2 = fight2 * 1.25
    elseif wb4_type == 8 and wa4_type == 7 then
        fight2 = fight2 * 1.25
    elseif wb4_type ~= 8 and wa4_type == 7 then
        fight2 = fight2 * 0.8
    elseif wb4_type ~= 7 and wa4_type == 8 then
        fight2 = fight2 * 1.25
    end
    
    
    --机动力 机动力差的攻击为80%
    local flex1 = get_solider_flexible(skill1,zhen1,wa1_type,wa2_type,wa3_type, wa4_type,kongfu1,intelligence1,polity1,speed1)
    local flex2 = get_solider_flexible(skill2,zhen2,wb1_type,wb2_type,wb3_type, wb4_type,kongfu2,intelligence2,polity2,speed2)
    if flex1 > flex2 then
        fight2 = fight2 * 0.8
    elseif flex1 < flex2 then
        fight1 = fight1 * 0.8
    end
    
    
    local consume1 = get_war_consume(area1,0,train1,wa1_type,wa1_level,wa2_type,wa2_level,wa3_type, wa3_level,wa4_type,wa4_level,fight2,sol1_num,zhen1,skill1,kongfu1,intelligence1,polity1,speed1,nb_skill2)
    local consume2 = get_war_consume(area2,0,train2,wb1_type,wb1_level,wb2_type,wb2_level,wb3_type, wb3_level,wb4_type,wb4_level,fight1,sol2_num,zhen2,skill2,kongfu2,intelligence2,polity2,speed2,nb_skill1)
    local hurt1 = math.floor(consume1*0.98)
    local hurt2 = math.floor(consume2*0.98)
    if is_vip1 == 1 then
        hurt1 = consume1*0.99
    end
    if is_vip2 == 1 then
        hurt2 = consume2*0.99
    end
    local xx = 1
    local change_train1 = 0
    local change_train2 = 0
    change_spirit1 = change_spirit1 + (consume2/800 - consume1/1000)
    change_spirit2 = change_spirit2 + (consume1/800 - consume2/1000)
    
--    local max_spirit1 = 100
--    local max_spirit2 = 100
--    local max_train1 = 100
--    local max_train2 = 100
--    change_spirit1 = (spirit1 + change_spirit1)>max_spirit1 and (max_spirit1-spirit1) or change_spirit1
--    change_spirit2 = (spirit2 + change_spirit2)>max_spirit2 and (max_spirit2-spirit2) or change_spirit2
--    change_spirit1 = (spirit1 + change_spirit1)<0 and (-spirit1) or change_spirit1
--    change_spirit2 = (spirit2 + change_spirit2)<0 and (-spirit2) or change_spirit2
    
--    change_train1 = (train1 + change_train1)>max_train1 and (max_train1-train1) or change_train1
--    change_train2 = (train2 + change_train2)>max_train2 and (max_train2-train2) or change_train2
--    print (consume1,hurt1,nb_skill1,change_spirit1,change_train1,consume2,hurt2,nb_skill2,change_spirit2,change_train2)
--    io.flush()
    return consume1,hurt1,nb_skill1,change_spirit1,change_train1,consume2,hurt2,nb_skill2,change_spirit2,change_train2
end

--攻城战争
--返回
--攻城方士兵损耗，攻城方触发技能，攻城方士气变化，守城方士兵损耗，守城方触发技能，守城方士气变化
function get_war_city(city_defense,city_level,skill,zhen,sol1_num,sol1_hurt,spirit1,train1,
        w1_type,w1_level,w2_type,w2_level,w3_type,w3_level,w4_type,w4_level,kongfu,intelligence,polity,speed,is_vip1,
        sol2_num,spirit2,train2,is_vip2)
--    print ("get_war_city")
--    print ( "city_defense="   ..  city_defense .. "\n" ..
--            "city_level  ="   ..  city_level   .. "\n" ..
--            "skill       ="   ..  skill        .. "\n" ..
--            "zhen        ="   ..  zhen         .. "\n" ..
--            "sol1_num    ="   ..  sol1_num     .. "\n" ..
--            "spirit1     ="   ..  spirit1      .. "\n" ..
--            "train1      ="   ..  train1       .. "\n" ..
--            "w1_type     ="   ..  w1_type      .. "\n" ..
--            "w1_level    ="   ..  w1_level     .. "\n" ..
--            "w2_type     ="   ..  w2_type      .. "\n" ..
--            "w2_level    ="   ..  w2_level     .. "\n" ..
--            "w3_type     ="   ..  w3_type      .. "\n" ..
--            "w3_level    ="   ..  w3_level     .. "\n" ..
--            "w4_type     ="   ..  w4_type      .. "\n" ..
--            "w4_level    ="   ..  w4_level     .. "\n" ..
--            "kongfu      ="   ..  kongfu       .. "\n" ..
--            "intelligence="   ..  intelligence .. "\n" ..
--            "polity      ="   ..  polity       .. "\n" ..
--            "speed      ="   ..  speed       .. "\n" ..
--            "is_vip1     ="   ..  is_vip1      .. "\n" ..
--            "sol2_num    ="   ..  sol2_num     .. "\n" ..
--            "spirit2     ="   ..  spirit2      .. "\n" ..
--            "train2      ="   ..  train2       .. "\n" ..
--            "is_vip2     ="   ..  is_vip2      )
    
    if w4_type == 9 or w4_type == 15 then
        w4_type = 0
    end
    local nb_skill = get_nb_skill(spirit1,skill,kongfu,intelligence,polity)
    if nb_skill == 27 or nb_skill == 26 then
        nb_skill = 0
    end
    local dec_defense = 0
    local fight1,change_spirit1 = get_attack_city_fight(city_defense, city_level, sol1_num, train1,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level,0,skill,nb_skill,kongfu,intelligence,polity,speed)
    local fight2,change_spirit2 = get_keep_city_fight(city_defense, city_level, sol2_num, nb_skill)
    
    --如果盾，守城攻击力减半
    if w2_type == 4 then
        fight2 = fight2 * 0.5
    end
    
    --机动力 机动力差的攻击为80%
    fight2 = fight2 * 0.8
    
    local consume1 = get_war_consume(16,city_defense,train1,w1_type,w1_level,w2_type,w2_level,w3_type, w3_level,w4_type,w4_level,fight2,sol1_num,0,skill,kongfu,intelligence,polity,speed,0)
    local consume2 = get_war_consume(17,city_defense,30,0,0,0,0,5, 0,0,0,fight1,sol2_num,0,0,50,50,50,0,0)
    local hurt1 = math.floor(consume1*0.98)
    local hurt2 = math.floor(consume2*0.98)
    if is_vip1 == 1 then
        hurt1 = consume1*0.99
    end
    if is_vip2 == 1 then
        hurt2 = consume2*0.99
    end
    local xx = 1
    local change_train1 = 0
    local change_train2 = 0
    change_spirit1 = change_spirit1 + (consume2/800 - consume1/1000)
    change_spirit2 = change_spirit2 + (consume1/800 - consume2/1000)
    
--    local max_spirit1 = 100
--    local max_spirit2 = 100
--    local max_train1 = 100
--    local max_train2 = 100
--    change_spirit1 = (spirit1 + change_spirit1)>max_spirit1 and (max_spirit1-spirit1) or change_spirit1
--    change_spirit2 = (spirit2 + change_spirit2)>max_spirit2 and (max_spirit2-spirit2) or change_spirit2
--    change_spirit1 = (spirit1 + change_spirit1)<0 and (-spirit1) or change_spirit1
--    change_spirit2 = (spirit2 + change_spirit2)<0 and (-spirit2) or change_spirit2
    
--    change_train1 = (train1 + change_train1)>max_train1 and (max_train1-train1) or change_train1
--    change_train2 = (train2 + change_train2)>max_train2 and (max_train2-train2) or change_train2
--    print (consume1,hurt1,nb_skill,change_spirit1,change_train1,consume2,hurt2,0,change_spirit2,change_train2,dec_defense  )
--    io.flush()
    return consume1,hurt1,nb_skill,change_spirit1,change_train1,consume2,hurt2,0,change_spirit2,change_train2,dec_defense
end


--军团速度
function get_army_speed(type, zhen, skill, treasure, w1, w2, w3, w4)
--    print ("get_army_speed")
--    print (type, zhen, skill, treasure, w1, w2, w3, w4)
    local str_skill = dec_bin(skill,32)
    local sol_type = get_solider_type(w1,w2,w3,w4)
    local speed = SOLIDER_TYPE[sol_type]["speed"]
    local x = 1
    if type == 1 then
        speed = speed * (4 + ZHEN[zhen]["speed"])/4
    elseif type == 2 then 
        if string.sub(str_skill,6,6) == "1" then
            speed = speed * (4 + ZHEN[zhen]["speed"])/4 * SKILL[27]["effect"]
        else
            speed = 5
        end 
    elseif type == 3 then
        return 15
    elseif type == 4 then
        speed = 2
    end
--    print (speed * x * (1 + treasure/100))
--    io.flush()
    return speed * x * (1 + treasure/100)
end

--获取兵种装备
function get_sol_weap(solider_type)
    if solider_type == 1 then
        return 1,1,4,5,5,1,9,1
    elseif solider_type == 2 then
        return 3,5,0,0,6,3,0,0
    elseif solider_type == 3 then
        return 2,3,0,0,6,5,0,0
    elseif solider_type == 4 then
        return 3,1,0,0,5,5,9,1
    else
        return 0,0,0,0,0,0,0,0
    end
end

--获取兵种行动力速度
function get_sol_prop(zhen,w1,lev1,w2,lev2,w3,lev3,w4,lev4)
--    print ("get_sol_prop")
--    print (zhen,w1,lev1,w2,lev2,w3,lev3,w4,lev4)
    local id = get_solider_type(w1,w2,w3,w4)
    local speed = SOLIDER_TYPE[id]["speed"]
    local distance = SOLIDER_TYPE[id]["distance"]
    local x = 2
    local action = speed * x * (4 + ZHEN[zhen]["speed"])
--    print (action, distance)
--    io.flush()
    return action, distance
end

--修炼效果
function get_learn_effect(learn_type,learn_id,is_win,is_vip)
    local point = 5
    if is_win == 1 then
        point = 10
    end
    if is_vip == 1 then
        point = point * 2
    end
    return point
end

--修行
function get_learn_gold()
    return 100, 20
end

--系统交易
--res_to_money(type)
--1,买；2，卖
--res1,res2,res3,res4,res5,res6,type,res,num
function sys_trade(...)
--    for i,v in pairs(arg) do
--        print ("arg_" .. i .. " is " .. v)
--    end
    local res = arg[8]
    local type = arg[7]
    local num = arg[9]
    local money = 0
    local is_ok = 0
    if type == 1 then
        money = res_to_money(res)*num
        if arg[6] >= money then
            is_ok = 1
            money = -money
        end
    else
        if arg[res] >= num then
            is_ok = 1
            money = res_to_money(res)*num/2
        end
    end
--    print (is_ok,money)
--    io.flush()
    return is_ok, money
end

--获取坞堡格子
--库房BUILDING[id]["effect"]+level-1
function get_grid(kufang)
    local grid =  BUILDING[3]["effect"] + kufang - 1
    return grid
end

--获取初始武将
--vip 65-85,随到85后40%保留否则84
--65-75
function get_init_general(is_vip)
    kongfu = math.random(65,85)
    if kongfu == 85 then
        if get_lucky(1,100,60) then
            kongfu = 84
        end
    end
    if is_vip == 0 and kongfu >= 75 then
        if get_lucky(1,100,70) then
            kongfu = kongfu -10
        end
    end
    
    intelligence = math.random(65,85)
    if intelligence == 85 then
        if get_lucky(1,100,60) then
            intelligence = 84
        end
    end
    if is_vip == 0 and intelligence >= 75 then
        if get_lucky(1,100,70) then
            intelligence = intelligence -10
        end
    end
    
    polity = math.random(65,85)
    if polity == 85 then
        if get_lucky(1,100,60) then
            polity = 84
        end
    end
    if is_vip == 0 and polity >= 75 then
        if get_lucky(1,100,70) then
            polity = polity -10
        end
    end
    
    skill = get_general_skill(kongfu,intelligence,polity)
    return kongfu,intelligence,polity,skill
end

--获取初始武将技能
function get_general_skill(kongfu,intelligence,polity)
    local maxs = kongfu
    local skill = 0
    maxs = (maxs >= intelligence) and maxs or intelligence
    maxs = (maxs >= polity) and maxs or polity
    if maxs == kongfu then
        if kongfu >= 85 then
            skill = 3
        elseif kongfu >= 75 then
            skill = 2
        elseif kongfu >= 65 then
            skill = 1
        else
        
        end
    elseif maxs == intelligence then
        if intelligence >= 85 then
            skill = 7
        elseif intelligence >= 75 then
            skill = 6
        elseif intelligence >= 65 then
            skill = 5
        else
        
        end
    else
        if polity >= 85 then
            skill = 11
        elseif polity >= 75 then
            skill = 10
        elseif polity >= 65 then
            skill = 9
        else
        
        end
    end
    return skill
end

--获取联盟福利
function get_welfare(sum, official,dignitie,last_time,cur_time)
    local res1 = 0
    local res2 = 0
    local res3 = 0
    local res4 = 0
    local res5 = 0
    local res6 = 0
    local gold = 0
    local flag = 0
    local year1,month1,day1,hour1 = read_time(last_time)
    local year2,month2,day2,hour2 = read_time(cur_time)
    local x = dignitie*0.05
    if year1 ~= year2 then
        flag = 1
        res1 = RES[1]["factor"]*sum*OFFICIAL[official]["salary"]*x
        res2 = RES[2]["factor"]*sum*OFFICIAL[official]["salary"]*x
        res3 = RES[3]["factor"]*sum*OFFICIAL[official]["salary"]*x
        res4 = RES[4]["factor"]*sum*OFFICIAL[official]["salary"]*x
        res5 = RES[5]["factor"]*sum*OFFICIAL[official]["salary"]*x
        res6 = RES[6]["factor"]*sum*OFFICIAL[official]["salary"]*x
        gold = 10
        if math.random(1,2) == 1 then
            gold = gold + 0.001*sum*OFFICIAL[official]["salary"]*x
        end
        if math.random(1,2) == 1 then
            gold = 0
        end
    end
    return flag,0,0,0,0,0,0,gold
end

--掠夺
function get_plunder(solider,first,second,three,four,five,six,res1,res2,res3,res4,res5,res6,times)
    local cd = 120
    if times > 12 or solider == 0 then
        return 0,0,0,0,0,0,0,cd
    else
        local load = solider * 10000
        max_res = {
                   [0] = 0 ,
                   [1] = res1 * 0.05 ,
                   [2] = res2 * 0.05 ,
                   [3] = res3 * 0.05 ,
                   [4] = res4 * 0.05 ,
                   [5] = res5 * 0.05 ,
                   [6] = res6 * 0.05 
                }
        return_res = {
                   [1] = 0,
                   [2] = 0,
                   [3] = 0,
                   [4] = 0,
                   [5] = 0,
                   [6] = 0
                }
        if max_res[first] * RES[first]["load"] >= load then
            return_res[first] = load/RES[first]["load"]
            load = 0
        else
            return_res[first] = max_res[first]
            load = load - max_res[first] * RES[first]["load"]
        end
        
        if max_res[second] * RES[second]["load"] >= load then
            return_res[second] = load/RES[second]["load"]
            load = 0
        else
            return_res[second] = max_res[second]
            load = load - max_res[second] * RES[second]["load"]
        end
        if max_res[three] * RES[three]["load"] >= load then
            return_res[three] = load/RES[three]["load"]
            load = 0
        else
            return_res[three] = max_res[three]
            load = load - max_res[three] * RES[three]["load"]
        end
        
        if max_res[four] * RES[four]["load"] >= load then
            return_res[four] = load/RES[four]["load"]
            load = 0
        else
            return_res[four] = max_res[four]
            load = load - max_res[four] * RES[four]["load"]
        end
        
        if max_res[five] * RES[five]["load"] >= load then
            return_res[five] = load/RES[five]["load"]
            load = 0
        else
            return_res[five] = max_res[five]
            load = load - max_res[first] * RES[first]["load"]
        end
        
        if max_res[six] * RES[six]["load"] >= load then
            return_res[six] = load/RES[six]["load"]
            load = 0
        else
            return_res[six] = max_res[six]
            load = load - max_res[six] * RES[six]["load"]
        end
        return return_res[1],return_res[2],return_res[3],return_res[4],return_res[5],return_res[6], cd
    end
    
end

--迁城
function moving_city()
    return 100
end

--巡视
function view_city(id)
    return VIEW[id]["hour"],VIEW[id]["prestige"],VIEW[id]["money"],VIEW[id]["gold"]
end

--学习AI
function learn_zhen_skill(type,id,gx,kongfu,intelligence,polity)
--    print ("learn_zhen_skill")
--    print (type,id,gx,kongfu,intelligence,polity)
    local is_ok = 0
    local need_gx = 0
    if type == 1 then
        if get_skill_valid(id,kongfu,intelligence,polity) and gx>=SKILL[id]["price"] then
            is_ok = 1
            need_gx = SKILL[id]["price"]
        end
    else
        if id == 5 then 
            if (kongfu>=ZHEN[id]["kongfu"] or polity>=ZHEN[id]["polity"]) 
                 and intelligence>=ZHEN[id]["intelligence"] and gx>=ZHEN[id]["price"] then
                is_ok = 1
                need_gx = ZHEN[id]["price"]
            end
        elseif id ==6 then
            if (kongfu>=ZHEN[id]["kongfu"] or intelligence>=ZHEN[id]["intelligence"] 
                or polity>=ZHEN[id]["polity"]) and gx>=ZHEN[id]["price"] then
                is_ok = 1
                need_gx = ZHEN[id]["price"]
            end
        else
            if kongfu>=ZHEN[id]["kongfu"] and intelligence>=ZHEN[id]["intelligence"] 
                and polity>=ZHEN[id]["polity"] and gx>=ZHEN[id]["price"] then
                is_ok = 1
                need_gx = ZHEN[id]["price"]
            end
        end
    end
--    print (is_ok,need_gx)
--    io.flush()
    return is_ok,need_gx
end

function get_all_solider_type(w1,w2,w3,w4)
    return 1
end

--队列
function get_building_queue(is_vip)
    local queue = 1
    if is_vip == 1 then
        queue = queue + 1
    end
    return queue
end

function get_tech_queue(is_vip)
    local queue = 1
    return queue
end

--工时
function add_made()
    return 10000, 10
end

--兵力
function add_sol()
    return 500, 10
end

--新的修炼
function level_up_general(jingyan, level,yishitang)
    local need_jingyan = 500*(level+1)*math.pow(1.2, math.floor((level+1)/10))
    if yishitang > level then
        if jingyan < need_jingyan then
            return jingyan, level
        else
            return level_up_general((jingyan-need_jingyan), (level+1), yishitang)
        end
    else
        if jingyan < need_jingyan then
            return jingyan, level
        else
            return need_jingyan, level
        end
    end
end

function get_train_info(yishitang, junying, level, cur_jingyan, is_double)
--    print ("get_train_info")
--    print (yishitang, junying, level, cur_jingyan, is_double)
    local gain = (is_double == 0) and 1 or 2
    local need_gold = (is_double == 0) and 0 or 10
    local cd = 120
    local jingyan = 500 + junying*100
    jingyan = jingyan * gain + cur_jingyan
    jingyan, level = level_up_general(jingyan, level,yishitang)
--    print (jingyan, level, need_gold, cd)
--    io.flush()
    return jingyan, level, need_gold, cd
end

--军令
function get_junling_info()
    return 25, 5
end

--游戏初始化
function get_game_info()
    local kongfu = 80
    local zhili = 80
    local zhengzhi = 85
    local skill = 512
    local zhen = 0
    local solider = 100
    local w1_type = 1
    local w1_level = 0
    local w2_type = 0
    local w2_level = 0
    local w3_type = 0
    local w3_level = 0
    local w4_type = 0
    local w4_level = 0
    local cur_zhen = 0
    local spirit = 50
    local level = 0
    return kongfu,zhili,zhengzhi,skill,zhen,solider,w1_type,w1_level,w2_type,w2_level,w3_type,w3_level,w4_type,w4_level,cur_zhen,spirit,level
end

--挑战
function get_tiaozhan_info()
    cd = 30
    return cd
end

--更替盟主
function become_boss(boss_sw,self_sw,cur_time,last_time)
    local three_day = 3*24*60*60
    if self_sw < boss_sw then
        return 0
    elseif (cur_time - last_time) < three_day then
        return 0
    else
        return 1
    end
end

--扩充库房
function level_up_kufang(level)
    local gold = level * 5 + 5
    local is_ok = 1
    if level >= 20 then
        is_ok = 0
    end
    return gold, is_ok
end

--装备掉落
function gain_weapon(lucky,ku_level,used)
    local kufang = BUILDING[3]["effect"] + ku_level - 1
    if kufang <= used then
        return 0
    elseif get_lucky(1,100,lucky) then
        return 1
    else
        return 0
    end
end

--拜访 cd时辰数
function visit_a_general(need_f)
    local cd = 1080
    if get_lucky(1,100,50) then
        return math.log10(need_f+10)*2, cd
    else
        return math.log10(need_f+10), cd
    end
end

--资源交易
function trade_resource(level)
    is_ok = 0
    gold = 5
    if level >= 40 then
        is_ok = 1
        gold = 0
    elseif level >= 20 then
        is_ok = 1
    end
    return is_ok, gold
end

--物资交易
function trade_weapon(level)
    is_ok = 0
    if level >= 20 then
        is_ok = 1
    end
    return is_ok
end