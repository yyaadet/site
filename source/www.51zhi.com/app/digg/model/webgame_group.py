# coding=utf-8


'''
define schema 
'''

WebgameGroup = [{'id': 1, 'name': u'战争策略'},
                                {'id': 2, 'name': u'角色扮演'},
                                {'id': 3, 'name': u'模拟经营'},
                                {'id': 4, 'name': u'社区养成'},
                                {'id': 5, 'name': u'休闲竞技'},
                                {'id': 6, 'name': u'儿童游戏'},
                                {'id': 7, 'name': u'SNS游戏'},
                                {'id': 8, 'name': u'应用服务'},
                                {'id': 9, 'name': u'IPhone'},
                                {'id': 10, 'name': u'IPad'},
                                ]
                                    
def get_webgame_group(id):
    for group in WebgameGroup:
        if group['id'] == id:
            return group
    return group