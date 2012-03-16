"""Pylons environment configuration"""
import os

from mako.lookup import TemplateLookup
from pylons import config
from sqlalchemy import engine_from_config
from pylons.error import handle_mako_error
from sqlalchemy import engine_from_config

import webhanfeng.lib.app_globals as app_globals
import webhanfeng.lib.helpers
from webhanfeng.config.routing import make_map
from webhanfeng.model import init_model

def load_environment(global_conf, app_conf):
    """Configure the Pylons environment via the ``pylons.config``
    object
    """
    # Pylons paths
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    paths = dict(root=root,
                 controllers=os.path.join(root, 'controllers'),
                 static_files=os.path.join(root, 'public'),
                 templates=[os.path.join(root, 'templates')])

    # Initialize config with the basic options
    config.init_app(global_conf, app_conf, package='webhanfeng', paths=paths)

    config['routes.map'] = make_map()
    config['pylons.app_globals'] = app_globals.Globals()
    config['pylons.h'] = webhanfeng.lib.helpers
    
    config['pylons.app_globals'].mako_lookup = TemplateLookup(
        directories=paths['templates'],
        error_handler=handle_mako_error,
        module_directory=os.path.join(app_conf['cache_dir'], 'templates'),
        input_encoding='utf-8', default_filters=['escape'],
        imports=[
                'from webhelpers.html import escape',
                'from webhanfeng.lib.utils import readable_time, \
                                            cut_string,force_int,read_game_time'
                ])
    
    # Setup the SQLAlchemy database engine
    engine = engine_from_config(config, 'sqlalchemy.')
    init_model(engine)

    # CONFIGURATION OPTIONS HERE (note: all config options will override
    # any Pylons config options)
