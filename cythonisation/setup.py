from setuptools import setup
from Cython.Build import cythonize

setup(
    name='Sample Agentic App',
    #ext_modules = cythonize(["app.pyx","nodes.pyx"])
    ext_modules = cythonize(["obs_app.pyx","obs_nodes.pyx"])
)