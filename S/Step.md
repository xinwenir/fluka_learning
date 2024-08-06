# ���� WSL �� ubuntu22.04 ���� flair��
## Locate to the program directory��
    cd /mnt/d/xinwenir/PostDoctor/Nuclear_Science/FLUKA/flair-geoviewer-2.3-main


# Install python3.10.8: 

** �ο�[����](https://blog.csdn.net/weixin_46584887/article/details/120701003)

### һ��apt ��װ���������

ִ�������������Դ��

    sudo apt-get update

ִ���������װ Python3 ��һЩ�����⣺

    sudo apt-get install libqgispython3.10.4
    sudo apt-get install libpython3.10-stdlib


### ��������Դ���

��ҿ���ǰ�� Python �������أ�Welcome to Pyhton! ���������� gz ���� xz �������ԣ������������£�XZ compressed source tarball

Ҳ��ʹ�� wget ���أ�ѡһ�ַ������ɣ�

    wget -P ~/Downloads https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tar.xz


���Ž�ѹ tar ����


    cd ~/Downloads
    tar xvJf Python-3.10.8.tar.xz

    
���ˣ�׼����������������

����Դ�����װ Python3.10.8
1. ���밲װ
���Ƚ������ǸղŽ�ѹ���ļ�Ŀ¼�£�

    ```
    cd ~/Downloads/Python-3.10.8
    ```

���ñ��������������ļ�Ŀ¼��
    ```
    ./configure --prefix=/usr/local/python3.10
    ```

����ʵʩ���룺

    ```
    make
    ```

�������������д��������������Ҫ�ȴ��������ӣ�������ɺ�װ��
    ```
    sudo make install
    ```

�����������������˵����װ�ɹ���

    ```
    Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
    Successfully installed pip-21.2.3 setuptools-57.4.0
    WARNING: Running pip as the ��root�� user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
    ```

2. ����������
��һ���������ǵ� python �����ܹ����ӵ������°�װ�� Python3.10.0 ��ִ�г�������Ǹ��͵İ汾���������Ƚ��뵽 /usr/bin Ŀ¼�£�

cd /usr/bin
1
��������������Բ鿴 Python ����֮ǰ�����������

ll | grep python
1
�� Ubuntu �£�ϵͳĬ���ǰ�װ�� Python2.7 �汾�ģ������ҵĵ����� python �����Ƕ�Ӧ Python2.7 �汾���� python3 ������Ƕ�Ӧ�� Python3* �汾�������������������޸ģ�

sudo rm ./python # ɾ��ԭ�е��������ļ�
sudo rm ./pip
sudo rm ./pip3
1
2
3
�����������µ������ӵ����ǵ� Python3.10 �汾��

sudo ln -s /usr/local/python3.10/bin/python3.10 /usr/bin/python
sudo ln -s /usr/local/python3.10/bin/pip3.10 /usr/bin/pip
sudo ln -s /usr/local/python3.10/bin/pip3.10 /usr/bin/pip3
1
2
3
ע���������ǲ��ܽ�ϵͳ�е� python3 �������ӵ� python3.10 �汾���������Ѿ��ȿӣ�����Ϊ python3.10 �汾���Ƿ��Ͱ汾���������ȶ��汾�������ĺ���ᵼ�� Ubuntu ϵͳ�µĺܶ� python �ļ��޷��򿪣�������� gnome �նˣ���

3. ����
��������������� Python �����Ƿ�ɹ���

python -V
1
������£�

zq@fzqs-computer:/usr/bin$ python -V
Python 3.10.0

��������������� Python �����Ƿ�ɹ���

pip3 -V
1
������£�

zq@fzqs-computer:/usr/bin$ pip3 -V
pip 21.2.3 from /usr/local/python3/lib/python3.10/site-packages/pip (python 3.10)

���������ǵ� Python3.10 �Ͱ�װ�����������

4. ���� pip ����
�ڰ�װ�������ֱ���������ִ�� pip list ���������Ҫ�޸� pip ����������ļ���

sudo vim /usr/bin/lsb_release
1
�޸ĵ�һ�е� Python3 Ϊ Python3.10 ���ɣ�������ִ�� pip list ���

zq@fzqs-computer:/usr/bin$ pip list
Package Version
- - - - - - - - - - - - -
pip 21.2.3 setuptools 57.4.0

�����ȷ���󹤸�ɣ�

�ܽ�
match-case �������Ϊ Python ���﷨��������һ�ݶ��е������ɣ�������һ�� match-case ���룺

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