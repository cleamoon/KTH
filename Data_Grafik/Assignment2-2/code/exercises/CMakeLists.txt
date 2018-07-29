#Add all subdirectories to build
FILE(GLOB sub-dirs RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *)
FOREACH(dir ${sub-dirs})
  IF(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${dir} AND NOT ${dir} MATCHES "assets")
    ADD_SUBDIRECTORY(${dir})
  ENDIF()
ENDFOREACH()