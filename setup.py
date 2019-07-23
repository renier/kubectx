from setuptools import setup
from setuptools import find_packages

setup(
    name="kubectx",
    version="0.1.0",
    author="Renier Morales",
    author_email="renierm@us.ibm.com",
    url="https://github.com/renier/kubectx",
    packages=find_packages(),
    py_modules=[
        "kubectx"
    ],
    entry_points={
        "console_scripts": ["kubectx=kubectx:main"]
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "License :: OSI Approved :: Apache Software License",
    ],
)

