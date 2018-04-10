# CMake generated Testfile for 
# Source directory: C:/opencv/sources/modules/superres
# Build directory: C:/opencv/mingw-build/modules/superres
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(opencv_test_superres "C:/opencv/mingw-build/bin/opencv_test_superres.exe" "--gtest_output=xml:opencv_test_superres.xml")
set_tests_properties(opencv_test_superres PROPERTIES  LABELS "Main;opencv_superres;Accuracy" WORKING_DIRECTORY "C:/opencv/mingw-build/test-reports/accuracy")
add_test(opencv_perf_superres "C:/opencv/mingw-build/bin/opencv_perf_superres.exe" "--gtest_output=xml:opencv_perf_superres.xml")
set_tests_properties(opencv_perf_superres PROPERTIES  LABELS "Main;opencv_superres;Performance" WORKING_DIRECTORY "C:/opencv/mingw-build/test-reports/performance")
add_test(opencv_sanity_superres "C:/opencv/mingw-build/bin/opencv_perf_superres.exe" "--gtest_output=xml:opencv_perf_superres.xml" "--perf_min_samples=1" "--perf_force_samples=1" "--perf_verify_sanity")
set_tests_properties(opencv_sanity_superres PROPERTIES  LABELS "Main;opencv_superres;Sanity" WORKING_DIRECTORY "C:/opencv/mingw-build/test-reports/sanity")
