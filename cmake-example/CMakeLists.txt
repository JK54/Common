#本文件参考https://www.hahack.com/codes/cmake/
#更详细的在https://www.zybuluo.com/khan-lau/note/254724
#官方文档https://cmake.org/cmake/help/v3.0/manual/cmake-variables.7.html
#cmake常用的自带变量
#PROJECT_SOURCE_DIR,源码文件顶层目录
#PROJECT_BINARY_DIR，编译位置的顶层目录

#限制cmake最低版本
cmake_minimum_required(VERSION 2.8.1)

#项目信息
project(POW)

#将当前目录的源码文件收集起来放到DIR_SRCS变量中
aux_source_directory(. DIR_SRCS)

#添加头文件搜索路径
include_directories("${PROJECT_BINARY_DIR}")

#自定义编译选项，跟configure_file和cmakedefine配合使用
#版本3.13.3观察，如果option和set写在configure_file后面，就不会向configure_file中更新预编译选项
#保险起见，可以把configure_file写在文件末尾
option(USE_MYMATH "use modified pow fuinction" ON)
#自定义版本号,写到头文件才生效
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)


if(USE_MYMATH)

	#包含子目录进行递归编译,子目录必须也要拥有CMakeLists.txt文件
	add_subdirectory(lib)

	#添加头文件搜索路径，添加库文件则是link_directories()
	# include_directories("${PROJECT_SOURCE_DIR}"/lib)

	#EXTRA_LIBS不是cmake自带变量，这样写代表将MYPOWFUNC加入到EXTRA_LIBS变量中(EXTRA_LIBS为空时自动创建)。
	set(EXTRA_LIBS ${EXTRA_LIBS} MYPOWFUNC)

endif(USE_MYMATH)

#找不到pow，不知道为什么
#环境检查,这边用来检查能否在连接阶段找到系统的pow函数
include (${CMAKE_ROOT}/Modules/CheckFunctionExists.cmake)

#将检查结果放到HAVE_POW，可以用来做预编译选项。
check_function_exists (pow HAVE_POW)

#设定编译参数，TYPE是CMAKE_CXX_FLAGS_xx中的xx指定的，可以自定义
#仅对本层目录生效，想要对子目录DEBUG，相应的也要添加配置。
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")

#制定生成目标
add_executable(POW ${DIR_SRCS})

#链接库文件,关于instal后动态库链接的问题查看子目录lib下面的CMakeLists.txt的注释
target_link_libraries(POW ${EXTRA_LIBS})

#安装位置默认是/usr/local
set(CMAKE_INSTALL_PREFIX /home/jk54/Tmp)
#安装规则,如果不是绝对路径就会带默认前缀
#更多参数查看https://cmake.org/cmake/help/v3.13/command/install.html#targets
#默认参数一般已经够用
install(TARGETS POW RUNTIME DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/config.h" DESTINATION include)

#将源码顶层目录下的config.h.in输出到编译路径的config.h，配合option或者set来改变宏定义
configure_file(  
	"${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
	)

#启用测试
enable_testing()

#根据返回值判断测试结果
add_test(test_run POW)
#对比输出信息来判断结果
# set_tests_properties (test_run PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent")

#编写宏实现批量测试
# macro (do_test arg1 arg2 result)
	# add_test (test_${arg1}_${arg2} POW ${arg1} ${arg2})
  # set_tests_properties (test_${arg1}_${arg2}
    # PROPERTIES PASS_REGULAR_EXPRESSION ${result})
# endmacro (do_test)

#打包
include (InstallRequiredSystemLibraries)
set (CPACK_RESOURCE_FILE_LICENSE
  "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set (CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
include (CPack)


