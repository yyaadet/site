import memcache
    
def init_cache(server, debug=1):
    _mc = memcache.Client(server, debug=debug)
    if not _mc:
        print "failed to init cache"
    return _mc