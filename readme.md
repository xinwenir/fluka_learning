configure flair and FLUKA on Ubuntu

fluka文件请到官网自行下载，并独立此文件。
例如命令的目录为：`/home/xxx/fluka/fluka_learning`，
则fluka文件`fluka2024.1-linux-gfor64bit-10.5-glibc2.17-AA.tar.gz`的目录为：`/home/zxw/fluka`。

注：运行`flair-fluka-cfg-ubuntu.sh`时，请保证`fluka2024.1-linux-gfor64bit-xxx.tar.gz`已存在。

running：
```
chmod +777 flair-fluka-cfg-ubuntu.sh
./flair-fluka-cfg-ubuntu.sh &> running.log
```