"""Pylons environment configuration"""
import os

from mako.lookup import TemplateLookup
from pylons import config
from pylons.error import handle_mako_error
from pylons.configuration import PylonsConfig

import feed.lib.app_globals as app_globals
import feed.lib.helpers
from feed import lib
from feed.config.routing import make_map
from feed.model import init_model

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
    config.init_app(global_conf, app_conf, package='feed', paths=paths)

    config['routes.map'] = make_map(config)
    config['pylons.app_globals'] = app_globals.Globals(config)
    config['pylons.h'] = feed.lib.helpers
    config['pylons.strict_tmpl_context'] = False

    # Create the Mako TemplateLookup, with the default auto-escaping
    config['pylons.app_globals'].mako_lookup = TemplateLookup(
        directories=paths['templates'],
        error_handler=handle_mako_error,
        module_directory=os.path.join(app_conf['cache_dir'], 'templates'),
        input_encoding='utf-8', default_filters=['escape'],
        imports=['from webhelpers.html import escape', 
                       'from feed.model.group import Groups, SubGroups',])
    
    
    # Setup the mongo database engine

    init_model(config)
    
    lib.config = config
    
    return config
