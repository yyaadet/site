import meta
import traceback

def catch_exception(fun):
    def _func(*arg):
        try:
            ret = fun(*arg)
            meta.Session.commit()
            return ret
        except:
            traceback.print_exc()
            meta.Session.rollback()
            return None
    return _func

class Admin(object):
    pass

class User(object):
    pass

class Game(object):
    pass

class Line(object):
    pass

class Server(object):
    pass

class RechargeLog(object):
    pass

class ExchangeLog(object):
    pass

class OperationLog(object):
    pass

class SysSetting(object):
    pass

class ExpandPeople(object):
    pass

class ExpandLog(object):
    pass

class GameGift(object):
    pass

class RechargeRate(object):
    pass