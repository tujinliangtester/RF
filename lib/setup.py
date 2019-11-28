from distutils.core import setup
setup(name='myTestLib',
      version='1.0',
      description='test Lib',
      author='tjl',
      packages=['myTestLib'],
      )

#todo 打包安装后，执行时还说报错，找不到关键字  目前是用相对路径的方式解决的，后续有时间还是需要跟进解决