# 1. 前言
鉴于VS本身体积的庞大和项目依赖管理方式的不便，所以本文采用Clion通过CMake进行项目结构管理。

# 2. 准备工作
* Windows 7 + （本文环境为 win7 x64）
* [Clion](http://www.jetbrains.com/clion/download/#section=windows) 
* [MinGW](http://tdm-gcc.tdragon.net/download) （本文环境 tdm-gcc-5.1.0-3）
* [CMake](https://cmake.org/download/) (本文环境 cmake-3.7.2)
* [OpenCV](https://opencv.org/releases.html)（本文环境 opencv-3.4.1）

安装以上软件，基本都是一路 next ，最后做一下系统环境变量的配置(右击我点电脑->属性->高级系统设置->环境变量->系统变量->编辑Path，添加对应软件bin所在目录，中间分号分隔)。最后打开Clion，依次进入Setting->Build,Execution,Deployment->Toolchains，设置编译用工具链：

![工具链设置][1]

ps：编译好的OpenCV MSVC版及 MinGW版

* MSVC版

	下载的 OpenCV 文件夹会有：
	
	* build （已编译好的库）
	* sources （源码）
	
	使用 MSVC 的话，直接在
	
		build/x64/vc14
	
	里面就有了，配置好路径即可使用
	
* MinGW版

	OpenCV 没有为我们编译好 MinGW 版，所以只能用户自行编译，下面就是介绍 MinGW 版的编译流程以及中间可能遇到的错误的排除

	这里有需要的话可以直接下载使用我编译好了的 [OpenCV-3.4.1 x64](https://github.com/zxxf18/OpenCV341-MinGW-Build-x64)
	
# 3. 编译
1. 解压OpenCV，然后在解压后source同级目录下创建一个新的mingw-build文件夹用于存放编译后的内容。

	（ps：这里如果你之前安装了Anaconda或者Python，请把这两个软件暂时从环境变量中删除，只是删除系统Path中的存在即可，不是卸载软件。原因是后面编译会有冲突）
	
2. 然后这里选择用cmake图形化界面操作，比较直观一些，采用命令行注意下命令参数同理。source和binary目录按如下图选择：

	![cmake][2]

	其中：source目录对应你的opencv/sources目录，binary目录就是之前新建的那个mingw-build存放目录

	此处需要复制opencv->build->bin下的两个文件：opencv_ffmpegxxx.dll、opencv_ffmpegxxx_64.dll到opencv/sources/3rdparty/ffmpeg/目录下

3. 选好目录，点击configure选择选择MinGW Makefiles，如上图所示。 
注意：遇见红色之后再次点击Configure(等于是要点两次)，等到所有列表变白，没有红色一片的时候才表示成功

4. configure成功后点击generate
5. 进入刚才创建的mingw-build目录，直接右键Git bash here（如果没装git windows，直接在cmd下进行），然后使用make命令进行编译：

	`mingw32-make -j2 # 以2线程进行编译，这个数字根据自己硬件合理选择`
	
	![make_install][3]
	
6. 漫长的make到达100%后进行install：

	`mingw32-make install`

7. 添加环境变量
	* 为系统变量 Path 添加 C:\opencv\mingw-build\install\x64\mingw\bin
	* 添加 OpenCV_DIR （注意大小写，部分情况这个可以不加，不过我这里不加Cmake会报找不到OpenCV的错误），变量值为之前编译的build路径：C:\opencv\mingw-build (实质是告知Cmake 包含OpenCV库文件和include文件配置文件的OpenCVConfig.cmake所在)

![opencv_dir][4]

# 4. 调用
至此，OpenCV编译和相关设置已经完成，只需要正常调用即可使用。下面给一个简单摄像头调用示例：

CMakeLists.txt

	cmake_minimum_required(VERSION 3.0)
	project(detect)

	set(CMAKE_CXX_STANDARD 11)

	add_executable(detect main.cpp)

	FIND_PACKAGE(OpenCV REQUIRED)
	IF (OpenCV_FOUND)
		INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIRS})
		TARGET_LINK_LIBRARIES(detect ${OpenCV_LIBS})
	ELSE (OpenCV_FOUND)
		MESSAGE(FATAL_ERROR "OpenCV library not found")
	ENDIF (OpenCV_FOUND)

main.cpp

	#include <opencv2/highgui.hpp>
	#include <opencv2/imgproc.hpp>
	#include <iostream>

	int main() {
    cv::VideoCapture capture(0);

    if (!capture.isOpened()) {
        std::cout << "open camera error!" << std::endl;
        return -1;
    }

    cv::Mat frame;
    while (1) {
        capture >> frame;
        if (frame.empty()) {
            std::cout << "capture empty frame" << std::endl;
            continue;
        }

        cv::Mat shrink_frame;
        cv::resize(frame, shrink_frame,
                   cv::Size(frame.cols / 2, frame.rows / 2),
                   0, 0, 3);

        cv::imshow("detect", shrink_frame);

        int key = cv::waitKey(1);
        if (key == 'q') {
            break;
        }
    }
    return 0;
	}

![detect][5]

# 5. 编译常见错误排除
* 多线程编译错误信息不明确

	**表现：**

	如果使用了多线程编译，导致错误，但是错误信息不明确，如：
	
		Makefile:161: recipe for target 'all' failed
		mingw32-make: *** [all] Error 2
		
	![多线程错误](http://ojlsgreog.bkt.clouddn.com/MakeOpenCV_cap_dshow.png)
	
	**解决：**
	
	使用单线程make，以查看详细的错误提示，再根据具体情况解决
	
		mingw32-make
		
* RC 错误

	**表现：**
	
		... windres.exe: unknown option -- W ...
	
	或者：
		
		FORMAT is one of rc, res, or coff, and is deduced from the file name
		extension if not specified.  A single file name is an input file.
		No input-file is stdin, default rc.  No output-file is stdout, default rc.
		
	![RC错误](http://ojlsgreog.bkt.clouddn.com/MakeOpenCVRCError.png)
	
	**解决：**
	
	在 cmake-gui 编译配置中：不勾选 **ENABLE PRECOMPILED HEADERS**，然后重新Configure-Generate-mingw32-make
	
* sprintf instead use StringCbPrintfA or StringCchPrintfA 错误

	**表现：**

		...opencv/sources/modules/videoio/src/cap_dshow.cpp...
		... 'sprintf_instead_use_StringCbPrintfA_or_StringCchPrintfA' was not declared in this scope ...
		
	![sprintf错误](http://ojlsgreog.bkt.clouddn.com/MakeOpenCV_cap_dshow.png)
	
	**解决：**
	
	修改E:\OpenCV_3.3.1\opencv\sources\modules\videoio\src\cap_dshow.cpp文件，在#include "DShow.h"这行的上面加一行#define NO_DSHOW_STRSAFE，如：
	
		#define NO_DSHOW_STRSAFE
		#include "DShow.h"
		
	然后重新Configure-Generate-mingw32-make
	
* identifier ‘nullptr’ is a keyword in C++11 错误

	**表现：**

		D:\opencv-3.4.1\opencv-3.4.1\3rdparty\protobuf\src\google\protobuf\stubs\io_win32.cc:94:3: warning: identifier 'nullptr' is a keyword in C++11 [-Wc++0x-compat]
		return s == nullptr || *s == 0;
   
		D:\opencv-3.4.1\opencv-3.4.1\3rdparty\protobuf\src\google\protobuf\stubs\io_win32.cc: In function 'bool google::protobuf::internal::win32::{anonymous}::null_or_empty(const char_type*)':
		D:\opencv-3.4.1\opencv-3.4.1\3rdparty\protobuf\src\google\protobuf\stubs\io_win32.cc:94:15: error: 'nullptr' was not declared in this scope
		   return s == nullptr || *s == 0;
               ^
		3rdparty\protobuf\CMakeFiles\libprotobuf.dir\build.make:412: recipe for target '3rdparty/protobuf/CMakeFiles/libprotobuf.dir/src/google/protobuf/stubs/io_win32.cc.obj' failed
		mingw32-make[2]: *** [3rdparty/protobuf/CMakeFiles/libprotobuf.dir/src/google/protobuf/stubs/io_win32.cc.obj] Error 1
		CMakeFiles\Makefile2:710: recipe for target '3rdparty/protobuf/CMakeFiles/libprotobuf.dir/all' failed
		mingw32-make[1]: *** [3rdparty/protobuf/CMakeFiles/libprotobuf.dir/all] Error 2
		Makefile:161: recipe for target 'all' failed
		mingw32-make: *** [all] Error 2		
	![KEY错误](http://ojlsgreog.bkt.clouddn.com/MakeOpenCV_nullptr_Error.png)
	
	**解决：**
	
	在 cmake-gui 编译配置中：

	勾选 ENABLE_CXX11
	
	然后重新Configure-Generate-mingw32-make
	
* dnn build error (Assembler messages)

	**表现：**

		C:\Users\ADMINI~1\AppData\Local\Temp\ccHIQxbw.s: Assembler messages:
		C:\Users\ADMINI~1\AppData\Local\Temp\ccHIQxbw.s:21800: Error: invalid register for .seh_savexmm
		...
		modules\dnn\CMakeFiles\opencv_dnn.dir\build.make:1741: recipe for target 'modules/dnn/CMakeFiles/opencv_dnn.dir/layers/layers_common.avx512_skx.cpp.obj' failed
		mingw32-make[2]: *** [modules/dnn/CMakeFiles/opencv_dnn.dir/layers/layers_common.avx512_skx.cpp.obj] Error 1
		CMakeFiles\Makefile2:4124: recipe for target 'modules/dnn/CMakeFiles/opencv_dnn.dir/all' failed
		mingw32-make[1]: *** [modules/dnn/CMakeFiles/opencv_dnn.dir/all] Error 2
		Makefile:159: recipe for target 'all' failed
		mingw32-make: *** [all] Error 2
		
	![dnn error][6]
	
	**解决：**
	
	在 cmake-gui 编译配置中：

	DCPU_DISPATCH 选空白
	
	然后重新Configure-Generate-mingw32-make
	
	（ps：这个错误在最新的OpenCV master分支已修复）
	
ref：
>>[dnn build error via Mingw64](http://opencv116.rssing.com/browser.php?indx=61564201&item=205)

>>[OpenCV使用CMake和MinGW的编译安装](https://blog.csdn.net/huihut/article/details/78701814)


  [1]: https://segmentfault.com/img/bV754q
  [2]: https://segmentfault.com/img/bV755z
  [3]: https://segmentfault.com/img/bV755J
  [4]: https://segmentfault.com/img/bV755V
  [5]: https://segmentfault.com/img/bV756k
  [6]: https://segmentfault.com/img/bV756A