global deployment_service
PATH=[getenv('HOME') deployment_service.tools];
PATH_PYTHON = [getenv('HOME') '/Library/Enthought/Canopy_64bit/User/lib/python2.7/site-packages'];
setenv('PATH', [getenv('PATH') ':' PATH]);
setenv('PYTHONPATH', PATH_PYTHON);