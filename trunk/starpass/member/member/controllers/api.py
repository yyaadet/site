import logging
import md5

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to
from pylons.templating import render_mako as render

from member.model import *
from member.lib.utils import *

from member.lib.base import BaseController


log = logging.getLogger(__name__)

class ApiController(BaseController):

    def index(self):
        # Return a rendered template
        #return render('/api.mako')
        # or, return a response
        return 'Hello World'

    def check_valid(self):
        username = get_params("username", "")
        hash_id = get_params("hashid", "")
        user = get_user_by_name(username)
        if user == None:
            return "0"
        else:
            if user.hash_id == hash_id:
                return "1"
            else:
                return "0"
            
    def valid_password(self):
        username = get_params("username", "")
        password = get_params("password", "")
        
        user = get_user_by_name(username)
        if user == None:
            return '0'
        else:
            if user.password !=  md5.md5(password).hexdigest():
                return '0'
            else:
                return '1'

    def recharge_interface(self):
        ip = get_client_ip()
        just_ip = get_interface_ip()
        if ip != just_ip:
            return "ip_wrong"
        
        key = get_interface_key()
        uid =  force_int(get_params("uid", 0))
        rmb =  force_int(get_params("rmb", 0))
        gold =  force_int(get_params("gold", 0))
        sign = get_params("sign", "")
        request_parmas = get_all_params()
        params = {}
        for k, v in request_parmas.items():
            if k not in ('sign', 'sign_type'):
                params[k] = v
        valid_sign = validate_url(params,key)
        if sign == valid_sign:
            user = get_user_by_id(uid)
            if user == None:
                return "user_wrong"
            else:
                recharge_gold(user.id,rmb,gold)
                expand_people = get_expand_people_by_id(user.expand_id)
                if expand_people is not None:
                    rate = force_int(get_expand_rate())
                    rmb2 = rmb * rate/100
                    update_expand_people(expand_people.id,rmb2)
                    new_expand_log(user.id,expand_people.id,rmb2)
                recharge_log = new_recharge_log(uid,100,rmb,gold)
                update_recharge_log_state(recharge_log.id)
                return 'true'
        else:
            return 'sign_wrong'