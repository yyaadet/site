try:
    from setuptools import setup, find_packages
except ImportError:
    from ez_setup import use_setuptools
    use_setuptools()
    from setuptools import setup, find_packages
    

setup(
    name='zuan',
    version='1.0',
    description='',
    author='',
    author_email='',
    url='',
    install_requires=[
        "Pylons>=1.0.0",
        "SQLAlchemy>=0.6.7",
#        "mysql-python>=1.2.2",
        "simplejson>=2.1.3"
    ],
    setup_requires=["PasteScript>=1.6.3"],
    packages=find_packages(exclude=['ez_setup']),
    include_package_data=True,
    test_suite='nose.collector',
    package_data={'zuan': ['i18n/*/LC_MESSAGES/*.mo']},
    #message_extractors={'zuan': [
    #        ('**.py', 'python', None),
    #        ('templates/**.mako', 'mako', {'input_encoding': 'utf-8'}),
    #        ('public/**', 'ignore', None)]},
    zip_safe=False,
    paster_plugins=['PasteScript', 'Pylons'],
    entry_points="""
    [paste.paster_command]
    run = zuan.commands:RunCommand
    
    [paste.app_factory]
    main = zuan.config.middleware:make_app

    [paste.app_install]
    main = pylons.util:PylonsInstaller
    """,
)

#import shutil
#shutil.rmtree("build")
#shutil.rmtree("dist")

