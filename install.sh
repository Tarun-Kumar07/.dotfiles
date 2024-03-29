#!/bin/sh

sourceCode=/home/tarun/sourceCode

# python(){
#   sudo apt install software-properties-common -y
#   sudo add apt-repository ppa:deadsnakes/ppa
#   sudo apt install python3.10
#   sudo apt install python3-pip
# }

ccls(){
  cd $sourceCode 
  git clone --depth=1 --recursive https://github.com/MaskRay/ccls
  cd ccls
  sudo apt install -y zlib1g-dev libncurses-dev
  sudo apt install -y clang libclang-dev
  cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-7 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-7/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-7/
  cmake --build Release --target install

}

node(){
  cd $sourceCode
  # git clone -b v16.13.0 --single-branch https://github.com/nodejs/node.git
  # git checkout v16.13.0

  # # dependanices
  # sudo apt-get install python3 g++ make

  # # building
  # cd node
  # ./configure
  # make -j4
  
  # # install
  # sudo make install

  curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
  sudo bash nodesource_setup.sh
  sudo apt install nodejs

}

taskwarrior(){
  cd $sourceCode
  git clone --recursive -b stable https://github.com/GothenburgBitFactory/taskwarrior.git
  cd taskwarrior
  git checkout stable
  cmake -DCMAKE_BUILD_TYPE=release -DENABLE_SYNC=OFF .
  make
  # make test
  make install
}

nvim(){
  #Installing nvim from source
  cd $sourceCode
  git clone https://github.com/neovim/neovim.git
  cd neovim
 
  #Installing dependancies
  sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

  make
  sudo make install

  #for telescope
  sudo apt-get -y install ripgrep

  #for packer
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

}

alacritty(){
  cd $sourceCode
  git clone https://github.com/alacritty/alacritty.git
  cd alacritty
  git checkout v0.9.0

  ##Install rust
  # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  ##Dependanices
  sudo apt-get -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

  sudo apt-get install -y cargo
  cargo build --release

  #Add to path
  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  #Alacritty as default shell
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50		
  sudo update-alternatives --config x-terminal-emulator
}

i3(){
  sudo apt-get install -y i3 compton blueman feh scrot

  #Enables touch in i3
  #link = https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/
  sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
  Section "InputClass"
          Identifier "touchpad"
          MatchIsTouchpad "on"
          Driver "libinput"
          Option "Tapping" "on"
  EndSection

EOF
}

tmux(){
  sudo apt-get install -y tmux
}

zsh(){
  sudo apt-get install -y zsh	

  #change shell to zsh
  chsh -s $(which zsh)
}

fonts(){
  sudo apt-get install -y fonts-hack
  sudo apt-get install -y fonts-font-awesome

  # dir = ~/.local/share/fonts
  # cd /usr/share/fonts/truetype 
  # mkdir hack
  # cd hack

  # mkdir -p ~/.local/share/fonts
  # cd ~/.local/share/fonts

  # curl -fLo "Hack-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf
  # curl -fLo "Hack-Italic.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete.ttf
  # curl -fLo "Hack-BoldItalic.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/BoldItalic/complete/Hack%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
  # curl -fLo "Hack-Bold.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete.ttf
  # curl -fLo "Font-Awesome-5-Free-Regular-400.otf" https://github.com/FortAwesome/Font-Awesome/blob/master/otfs/Font%20Awesome%205%20Brands-Regular-400.otf 
  # curl -fLo "Font-Awesome-5-Brands-Regular-400.otf" https://github.com/FortAwesome/Font-Awesome/blob/master/otfs/Font%20Awesome%205%20Brands-Regular-400.otf
  # curl -fLo "Font-Awesome-5-Free-Solid-900.otf" https://github.com/FortAwesome/Font-Awesome/blob/master/otfs/Font%20Awesome%205%20Free-Solid-900.otf
  # fc-cache -f -v
}

configs(){
  cd $PWD
  sudo apt-get install -y stow	
  for path in $PWD/* ; do
    [ -d "${path}" ] || continue # if not a directory, skip
    dirname="$(basename "${path}")"
    stow -D $dirname
    stow $dirname
  done
  stow -D scripts	
}

brave(){
 sudo apt install -y apt-transport-https curl
 sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
 echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
 sudo apt update
 sudo apt install -y brave-browser
}

configs
# brave
# fonts
# nvim 
# ccls
# alacritty
# i3
# tmux
# zsh
# python
# node
