CC 	= arm-linux-gnueabi-gcc
CFLAGS	= -march=armv6zk -nostdlib

.SUFFIXES: .s .img

.PHONY: all clean

kernel.img: game_of_life.s
	rm -f kernel.img	
	$(CC) $(CFLAGS) game_of_life.s -o kernel.img
 
clean:
	rm -f kernel.img
