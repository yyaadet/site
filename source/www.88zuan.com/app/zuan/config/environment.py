"""Pylons environment configuration"""
import os

from mako.lookup import TemplateLookup
from pylons import config
from pylons.error import handle_mako_error
from sqlalchemy import engine_from_config
from pylons.configuration import PylonsConfig

import zuan.lib.app_globals as app_globals
import zuan.lib.helpers
from zuan import lib
from zuan.config.routing import make_map
from zuan.model import init_model, _mc
from zuan.model import cache

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

    config = PylonsConfig()
    
    # Initialize config with the basic options
    config.init_app(global_conf, app_conf, package='zuan', paths=paths)

    config['routes.map'] = make_map(config)
    config['pylons.app_globals'] = app_globals.Globals(config)
    config['pylons.h'] = zuan.lib.helpers
    config['pylons.strict_tmpl_context'] = False

    # Create the Mako TemplateLookup, with the default auto-escaping
    config['pylons.app_globals'].mako_lookup = TemplateLookup(
        directories=paths['templates'],
        error_handler=handle_mako_error,
        module_directory=os.path.join(app_conf['cache_dir'], 'templates'),
        input_encoding='utf-8', default_filters=['escape'],
        imports=['from webhelpers.html import escape'])
    
    
    # Setup the SQLAlchemy database engine

    init_model(config)
    
    lib.config = config
    
    return config
