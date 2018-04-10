# CMake generated Testfile for 
# Source directory: C:/opencv/sources/modules/videostab
# Build directory: C:/opencv/mingw-build/modules/videostab
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(opencv_test_videostab "C:/opencv/mingw-build/bin/opencv_test_videostab.exe" "--gtest_output=xml:opencv_test_videostab.xml")
set_tests_properties(opencv_test_videostab PROPERTIES  LABELS "Main;opencv_videostab;Accuracy" WORKING_DIRECTORY "C:/opencv/mingw-build/test-reports/accuracy")
