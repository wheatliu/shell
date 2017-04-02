# Install openresty

set -x 
set -e

if [[ $# -lt 1 ]]; then
    echo 'usgae: install.sh 1.2.1'
    exit 1
fi

OPENRESTY_VERSION=$1
WORKSPACE=/tmp
CPUS=`lscpu | awk -F'[: ]+' '/^CPU\(s\):/{print $2}'`

# Depends
sudo apt-get install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev libreadline-dev perl make build-essential curl -y

# openresty
wget https://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz -P $WORKSPACE
tar xf $WORKSPACE/openresty-$OPENRESTY_VERSION.tar.gz -C $WORKSPACE

cd $WORKSPACE/openresty-$OPENRESTY_VERSION
./configure --with-pcre-jit --with-http_sub_module --with-http_flv_module --with-http_mp4_module --with-http_v2_module --with-http_realip_module --with-http_image_filter_module
sudo make install
sudo ln -s /usr/local/openresty/luajit/bin/luajit /usr/local/openresty/luajit/bin/lua

# luarocks
cd $WORKSPACE
git clone https://github.com/luarocks/luarocks.git

cd luarocks
./configure --with-lua=/usr/local/openresty/luajit --with-lua-bin=/usr/local/openresty/luajit/bin --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1/
make build
sudo make install

# REPL lua 
/usr/local/bin/luarocks install luaprompt