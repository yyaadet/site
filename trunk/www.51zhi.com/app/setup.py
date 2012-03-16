try:
    from setuptools import setup, find_packages
except ImportError:
    from ez_setup import use_setuptools
    use_setuptools()
    from setuptools import setup, find_packages
    

setup(
    name='digg',
    version='1.0',
    description='',
    author='',
    author_email='',
    url='',
    install_requires=[
        "Pylons>=1.0.0",
        "simplejson>=2.1.3",
        "pymongo>=1.11",
        "BeautifulSoup>=3.2.0",
    ],
    setup_requires=["PasteScript>=1.6.3"],
    packages=find_packages(exclude=['ez_setup']),
    include_package_data=True,
    test_suite='nose.collector',
    package_data={'digg': ['i18n/*/LC_MESSAGES/*.mo']},
    zip_safe=False,
    paster_plugins=['PasteScript', 'Pylons'],
    entry_points="""
    [paste.paster_command]
    run = digg.commands:RunCommand
    
    [paste.app_factory]
    main = digg.config.middleware:make_app

    [paste.app_install]
    main = pylons.util:PylonsInstaller
    """,
)
