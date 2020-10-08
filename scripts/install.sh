VERSION=`cat VERSION`
RELEASE="https://github.com/lpmatos/gen/releases/download/$VERSION/gen_v0.0.1_Linux-x86_64.tar.gz"

echo "Getting Last Release"
wget $RELEASE

echo "Extract to /usr/local/bin"
sudo tar -xzvf gen_v0.0.1_Linux-x86_64.tar.gz -C /usr/local/bin

echo "Cleanning"

rm -rf gen_v0.0.1_Linux-x86_64.tar.gz
