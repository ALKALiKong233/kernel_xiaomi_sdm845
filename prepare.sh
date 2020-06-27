sudo apt-get update
sudo apt-get install -y build-essential bc python curl git zip ftp libssl-dev
git fetch --all
git checkout origin/ten

cd $HOME
rm -rf AnyKernel3
rm -rf proton-clang
git clone --depth=1 https://github.com/NoobLiROM/AnyKernel3.git
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git

