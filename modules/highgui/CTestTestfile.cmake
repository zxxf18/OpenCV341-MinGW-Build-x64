# CMake generated Testfile for 
# Source directory: C:/opencv/sources/modules/highgui
# Build directory: C:/opencv/mingw-build/modules/highgui
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(opencv_test_highgui "C:/opencv/mingw-build/bin/opencv_test_highgui.exe" "--gtest_output=xml:opencv_test_highgui.xml")
set_tests_properties(opencv_test_highgui PROPERTIES  LABELS "Main;opencv_highgui;Accuracy" WORKING_DIRECTORY "C:/opencv/mingw-build/test-reports/accuracy")
