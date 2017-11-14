# Linux-0.00
Linux-0.00  for learning x86 assemble language 
on ubuntu 14.04 

编译
make 
使用WINIMAGE 拷贝到软盘
使用 mcopy a:Image . 拷贝到平台目录上
把Image 安装到平台
dd bs=8192 if=Image of=/dev/fd0 
sync 


代码的说明看 clk011c-3.0.pdf 第三章



编译出错 解决方案： 

http://blog.sina.com.cn/s/blog_9b59ac040101dm7k.html

编译：
1.
boot/head.s:231: Error: alignment not a power of 2

出错原因：.align 2 是汇编语言指示符，其含义是指存储边界对齐调整；
“2”表示把随后的代码或数据的偏移位置调整到地址值最后2比特位为零的位置（2^2），即按4字节对齐内存地址。不过现在GNU as直接是写出对齐的值而非2的次方值了。
.align 2 应该改为 .align 4
 .align 3 应该改为 .align 8
 
 2. 
 出现问题：
warning: cannot find entry symbol _start; defaulting to 0000000008048054
boot.o: In function `start':
(.text+0x1): relocation truncated to fit: R_386_16 against `.text'
boot.o: In function `ok_load':
(.text+0x3f): relocation truncated to fit: R_386_16 against `.text'
boot.o: In function `ok_load':
(.text+0x44): relocation truncated to fit: R_386_16 against `.text'
boot.o: In function `gdt_48':
(.text+0x71): relocation truncated to fit: R_386_16 against `.text'

把head.s中的startup_32标志改为_start(还要改.global _start)
ld的参数加上-Ttext=0x00


3. 
仿真环境屏幕没有反应，只是Booting from floppy.....
网上查了好久都没有找到解决方法，后来想到书中说head是a.out文件格式，要去掉1024字节的文件头，终于发现了问题。

其实在ubuntu12.04中编译链接出来的head是elf格式而不是较老的a.out格式，用以下命令可查看head文件的elf文件头信息
readelf -h head
那么如何去除head的文件头呢？

这回百度终于发挥作用，用objcopy就可以了（不过我还是不会用objcopy)
objcopy -O(注意是英文字母大写o) binary -S -R .comment -R .note  head  head.bin
生成的head.bin就是去除文件头等信息的head文件

4.  进入boot后，又退出。 

  dd bs=32 if=boot of=Image skip=1
  objcopy -O binary system head
  dd bs=512 if=head of=Image  seek=1
  
  boot =512字节 
  seek=1 bs=512 跳过image 的前512 字节把head 贴到 image 的512 字节之后
  
        
        
