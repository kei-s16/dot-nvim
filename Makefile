install:
	ln -sfnv $(CURDIR) $(HOME)/.config/nvim

.PHONY: skk
skk:
	curl -o ${HOME}/.skk/SKK-JISYO.L --create-dirs http://openlab.jp/skk/skk/dic/SKK-JISYO.L
	touch ${HOME}/.skk/USER.L

clean:
	unlink $(HOME)/.config/nvim
