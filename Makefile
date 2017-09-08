LUALIB=-I/usr/include/lua5.1 -lpcap -ldl -lm -llua5.1 

.PHONY: all win linux

all:
	@echo Please do \'make PLATFORM\' where PLATFORM is one of these:
	@echo win linux

win:

linux: watch

watch : watch.c
	 gcc $^ -o$@ $(LUALIB) 
clean:
	rm -f watch 
