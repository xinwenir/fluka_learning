# VS-Code 安装到 WSL：

## 打开 WSL 下的 Ubuntu 系统：

    code ..

# MD文件书写[格式](https://blog.csdn.net/carcarrot/article/details/119769300)

# 采用 WSL 的 ubuntu22.04 编译 flair：
## Locate to the program directory：
    cd /mnt/d/xinwenir/PostDoctor/Nuclear_Science/FLUKA/flair-geoviewer-2.3-main

# 安装 python

    sudo apt-get install python3-dev

Point the "python" command to python3."

    sudo ln -s /usr/bin/python3 /usr/bin/python

Point the "python-config" command to python3-config."

    sudo ln -s /usr/bin/python3-config /usr/bin/python-config
    
# 安装 tkinter

## 运行 apt 安装：

    sudo apt-get install python3-tk

## 测试

    python
    import tkinter
    tkinter._test()

## 出现错误：

    File "/usr/local/python3.8/lib/python3.8/tkinter/__init__.py", line 36, in <module>                                   
        import _tkinter # If this fails your Python may not be configured for Tk                                            
    ModuleNotFoundError: No module named '_tkinter' 

 - 创建目录：

        sudo mkdir /usr/local/lib/python3.8/lib-dynload


 - 拷贝文件：

        cd /usr/lib/python3.8/lib-dynload
        cp 



# [tk/tcl的安装]

下载[tk/tcl](http://www.tcl.tk/software/tcltk/download.html)

    tar －zvxf tclxxx.tar.gz
    cd tclxxx/unix
    ./configure
    make
    sudo make install

    tar －zvxf tkxxx.tar.gz
    cd tkxxx/unix
    ./configure
    make
    sudo make install


# FLUKA安装
64 bits, Linux, requires gcc/gfortran (version >=9.4)
  - Linux x86_64 (tar.gz packages): fluka2024.1-linux-gfor64bit-yy-glibczzAA.tar.gz fluka2024.1-data.tar.gz  

下载后操作如下：

    mkdir /home/zxw/fluka
    export FLUPRO=/home/zxw/fluka
    sudo apt install gfortran
    export FLUFOR=gfortran
    cp fluka2024.1-linux-gfor64bit-yy-glibczzAA.tar.gz $FLUPRO
    tar -zxvf fluka2024.1-linux-gfor64bit-yy-glibczzAA.tar.gz
    make

    nano ~/.bashrc

添加：

    export FLUPRO=/home/zxw/fluka
    export FLUFOR=gfortran







# 找到X11/Xlib.h：

    sudo apt-get install libx11-dev

# win11卸载Ubuntu 20.04 WSL 的[方法](https://blog.csdn.net/bmseven/article/details/129365761)

## 通过Windows终端卸载
### 1、查看当前环境安装的wsl

    wsl --list

### 2、注销（卸载）当前安装的Linux的Windows子系统（名称要与list获取的一致）

    wsl --unregister Ubuntu-20.04

### 3、卸载成功，查看当前安装的Linux的Windows子系统

    wsl --list


# 卸载python3.8

## 卸载python3.8：

    sudo apt-get remove python3.8

## 卸载python3.8及其依赖：

    sudo apt-get remove --auto-remove python3.8

## 清除python3.8：

    sudo apt-get purge --auto-remove python3.8

