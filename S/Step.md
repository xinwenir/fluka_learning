# 采用 WSL 的 ubuntu22.04 编译 flair：
## Locate to the program directory：
    cd /mnt/d/xinwenir/PostDoctor/Nuclear_Science/FLUKA/flair-geoviewer-2.3-main


# Install python3.10.8: 

** 参考[博客](https://blog.csdn.net/weixin_46584887/article/details/120701003)

## 一、apt 安装相关依赖库

执行以下命令更新源：

    sudo apt-get update

执行以下命令安装 Python3 的一些依赖库：

    sudo apt-get install libqgispython3.10.4
    sudo apt-get install libpython3.10-stdlib


## 二、下载源码包

大家可以前往 Python 官网下载：Welcome to Pyhton! ，这里下载 gz 包和 xz 包都可以，下载链接如下：XZ compressed source tarball

也可使用 wget 下载，选一种方法即可：

    wget -P ~/Downloads https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tar.xz


接着解压 tar 包：

    cd ~/Downloads
    tar xvJf Python-3.10.8.tar.xz

    
到此，准备工作就做好啦！

## 三、源码包安装 Python3.10.8
### 1. 编译安装
首先进入我们刚才解压的文件目录下：

    cd ~/Downloads/Python-3.10.8

安装 GCC编译器：

    sudo apt-get install gcc

设置编译参数，即输出文件目录：

    ./configure --prefix=/usr/local/python3.10


接着实施编译：

    make


上面两步都会有大量输出，可能需要等待两三分钟，编译完成后安装：

    sudo make install


若出现如下输出，则说明安装成功：

    Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
    Successfully installed pip-21.2.3 setuptools-57.4.0
    WARNING: Running pip as the ‘root’ user can result in broken permissions and conflicting behaviour with the system package      manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv


### 2. 设置软连接
这一步即让我们的 python 命令能够链接到我们新安装的 Python3.10.0 的执行程序而不是更低的版本，我们首先进入到 /usr/bin 目录下：

    cd /usr/bin

输入以下命令可以查看 Python 命令之前的链接情况：

    ll | grep python

在 Ubuntu 下，系统默认是安装了 Python2.7 版本的，所以我的电脑上 python 命令是对应 Python2.7 版本，而 python3 命令才是对应的 Python3* 版本，这里我们做出如下修改：

    sudo rm ./python # 删除原有的软连接文件
    sudo rm ./pip
    sudo rm ./pip3

接着再设置新的软连接到我们的 Python3.10 版本：

    sudo ln -s /usr/local/python3.10/bin/python3.10 /usr/bin/python
    sudo ln -s /usr/local/python3.10/bin/pip3.10 /usr/bin/pip
    sudo ln -s /usr/local/python3.10/bin/pip3.10 /usr/bin/pip3

注：这里我们不能将系统中的 python3 命令链接到 python3.10 版本（这里我已经踩坑），因为 python3.10 版本还是发型版本，并不是稳定版本，若更改后则会导致 Ubuntu 系统下的很多 python 文件无法打开（比如你的 gnome 终端）！

### 3. 检验
输入以下命令，检验 Python 配置是否成功：

    python -V

输出如下：

    zq@fzqs-computer:/usr/bin$ python -V
    Python 3.10.0

输入以下命令，检验 Python 配置是否成功：

    pip3 -V

输出如下：

    zq@fzqs-computer:/usr/bin$ pip3 -V
    pip 21.2.3 from /usr/local/python3/lib/python3.10/site-packages/pip (python 3.10)

到这里我们的 Python3.10 就安装配置完成啦！

### 4. 更改 pip 依赖
在安装后，若出现报错（可先执行 pip list 命令），则还需要修改 pip 的相关配置文件：

    sudo vim /usr/bin/lsb_release

修改第一行的 Python3 为 Python3.10 即可，接着再执行 pip list 命令：

    zq@fzqs-computer:/usr/bin$ pip list
    Package Version
    - - - - - - - - - - - - -
    pip 21.2.3 setuptools 57.4.0

输出正确，大工告成！

总结
match-case 语句算是为 Python 的语法又增添了一份独有的魅力吧，以下是一段 match-case 代码：

def http_error(status):
    match status:
        case 400:
            return "Bad request"
        case 401 | 402 | 403:
            return "Not allowed"
        case 404:
            return "Not found"
        case 418:
            return "I'm a teapot"
        case _:
            return "Something must be wrong!"