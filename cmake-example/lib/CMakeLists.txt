aux_source_directory(. LIB_SRCS)

#可以生成动态库或者静态库，动态库安装后可以放到/usr/lib及/usr/lib64
add_library(MYPOWFUNC SHARED ${LIB_SRCS})

#需要对库文件DEBUG就设置，不需要就使用编译器默认参数
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")

#设置动态库输出位置，install之后会丢失动态库链接信息(ldd查看)，有两个方法解决：
#1.不使用install，设置LIBRARY_OUTPUT_PATH，然后手动拷贝可执行程序到目的地，适用于临时项目
#2.使用install，如果动态库安装位置不是系统默认路径(/usr/lib,/lib,对于64位系统还有/lib64,/usr/lib64)，那么需要在/etc/ld.so.conf中添加位置，或者在ld.so.conf.d下面添加文件后再增加位置，推荐后者。然后使用ldconfig命令刷新新/etc/ld.so.cache缓存文件，就可以链接成功。
# SET(LIBRARY_OUTPUT_PATH /home/jk54/Tmp/lib)
install(TARGETS MYPOWFUNC LIBRARY DESTINATION lib)
