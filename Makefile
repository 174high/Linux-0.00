# Makefile for the simple example kernel.
AS86	=as86 -0 -a
LD86	=ld86 -0
AS	=as
LD	=ld -Ttext=0x00
LDFLAGS	=-s -x -M

all:	Image

Image: boot system
	dd bs=32 if=boot of=Image skip=1
	objcopy -O binary system head
	dd bs=512 if=head of=Image  seek=1
	sync

disk: Image
	dd bs=8192 if=Image of=/dev/fd0
	sync;sync;sync

head.o: head.s

system:	head.o
	$(LD) $(LDFLAGS) head.o  -o system > System.map

boot:	boot.s
	$(AS86) -o boot.o boot.s
	$(LD86) -s -o boot boot.o

clean:
	rm -f Image System.map core boot *.o system head
