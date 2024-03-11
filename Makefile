DENOPS_DIR := ${HOME}/.cache/dpp/repos/github.com/vim-denops/denops.vim
DPP_DIR := ${HOME}/.cache/dpp/repos/github.com/Shougo/dpp.vim
DPP_EXT_INSTALLER_DIR := ${HOME}/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer
DPP_PROTOCOL_GIT_DIR := ${HOME}/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git
DPP_EXT_LAZY_DIR := ${HOME}/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy
DPP_EXT_TOML_DIR := ${HOME}/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml
DPP_EXT_LOCAL_DIR := ${HOME}/.cache/dpp/repos/github.com/Shougo/dpp-ext-local

install:
	ln -sfnv $(CURDIR) $(HOME)/.config/nvim

.PHONY: dpp
dpp:
	mkdir -p ${HOME}/.cache/dpp/repos/local
	mkdir -p ${HOME}/.cache/dpp/repos/github.com/vim-denops
	mkdir -p ${HOME}/.cache/dpp/repos/github.com/Shougo
	if [ ! -d "$(DENOPS_DIR)" ]; then git clone git@github.com:vim-denops/denops.vim.git $(DENOPS_DIR); fi
	if [ ! -d "$(DPP_DIR)" ]; then git clone git@github.com:Shougo/dpp.vim.git $(DPP_DIR); fi
	if [ ! -d "$(DPP_PROTOCOL_GIT_DIR)" ]; then git clone git@github.com:Shougo/dpp-protocol-git.git $(DPP_PROTOCOL_GIT_DIR); fi
	if [ ! -d "$(DPP_EXT_INSTALLER_DIR)" ]; then git clone git@github.com:Shougo/dpp-ext-installer.git $(DPP_EXT_INSTALLER_DIR); fi
	if [ ! -d "$(DPP_EXT_LAZY_DIR)" ]; then git clone git@github.com:Shougo/dpp-ext-lazy.git $(DPP_EXT_LAZY_DIR); fi
	if [ ! -d "$(DPP_EXT_TOML_DIR)" ]; then git clone git@github.com:Shougo/dpp-ext-toml.git $(DPP_EXT_TOML_DIR); fi
	if [ ! -d "$(DPP_EXT_LOCAL_DIR)" ]; then git clone git@github.com:Shougo/dpp-ext-local.git $(DPP_EXT_LOCAL_DIR); fi

.PHONY: skk
skk:
	curl -o ${HOME}/.skk/SKK-JISYO.L --create-dirs http://openlab.jp/skk/skk/dic/SKK-JISYO.L
	touch ${HOME}/.skk/USER.L

clean:
	unlink $(HOME)/.config/nvim
