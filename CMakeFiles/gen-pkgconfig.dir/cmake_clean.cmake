file(REMOVE_RECURSE
  "unix-install/opencv.pc"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/gen-pkgconfig.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
