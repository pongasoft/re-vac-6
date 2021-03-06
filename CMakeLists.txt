# Copyright (c) 2020 pongasoft
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#
# @author Yan Pujante

cmake_minimum_required(VERSION 3.13)

# Using RE SDK version 4.2.0
set(RE_SDK_VERSION 4.2.0)

set(RE_CMAKE_ROOT_DIR "")
#set(RE_CMAKE_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/../../pongasoft/re-cmake")

# If RE_CMAKE_ROOT_DIR is undefined/empty, it will fetch/download it from github
# If RE_CMAKE_ROOT_DIR is defined, it should point to the (local) folder where re-cmake is located
include(cmake/fetch_re-cmake.cmake)

# Default options provided by re-cmake
include("${RE_CMAKE_ROOT_DIR}/cmake/RECMakeOptions.cmake")

# Setting up project (note that the version is defined in lua.info)
project(re-vac-6 LANGUAGES CXX)

# Using C++17
set(CMAKE_CXX_STANDARD 17)

# we include the framework itself
include("${RE_CMAKE_ROOT_DIR}/sdk.cmake")

# Including re-common
set(RE_COMMON_ROOT_DIR "")
#set(RE_COMMON_ROOT_DIR "../../pongasoft/re-common")
include(cmake/re-common.cmake)

# Defining where the sources of the plugin live
set(RE_CPP_SRC_DIR "${CMAKE_CURRENT_LIST_DIR}/src/cpp")

# Defining all the source files for the project
# Although you could use a file(GLOB ...) pattern, it is NOT recommended as the CMake generation would happen on
# every single build!
set(re_sources_cpp
    ${RE_CPP_SRC_DIR}/Device.cpp
    ${RE_CPP_SRC_DIR}/DeviceFactory.cpp
    ${RE_CPP_SRC_DIR}/DeviceState.cpp
    ${RE_CPP_SRC_DIR}/Motherboard.cpp
)

# Defining where the local GUI2D files live
set(RE_2D_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/GUI2D)

# Defining all the 2D source files
# Although you could use a file(GLOB ...) pattern, it is NOT recommended as the CMake generation would happen on
# every single build!
set(re_sources_2d

    # lua files describing the GUI
    ${RE_2D_SRC_DIR}/device_2D.lua
    ${RE_2D_SRC_DIR}/hdgui_2D.lua

    # Images for the device
    ${RE_2D_SRC_DIR}/Display_23_1frames.png
    ${RE_2D_SRC_DIR}/Display_23_1frames_Background.png
    ${RE_2D_SRC_DIR}/Fader_Bypass_3frames.png
    ${RE_2D_SRC_DIR}/Knob_Max1_64frames.png
    ${RE_2D_SRC_DIR}/Knob_Max2_64frames.png
    ${RE_2D_SRC_DIR}/Knob_Max3_64frames.png
    ${RE_2D_SRC_DIR}/Knob_Volume_64frames.png
    ${RE_2D_SRC_DIR}/Knob_Volume_Small_64frames.png
    ${RE_2D_SRC_DIR}/Knob_text_Max1.png
    ${RE_2D_SRC_DIR}/Knob_text_Max2.png
    ${RE_2D_SRC_DIR}/Knob_text_Max3.png
    ${RE_2D_SRC_DIR}/Knob_text_ValueDisplay.png
    ${RE_2D_SRC_DIR}/Knob_text_background.png
    ${RE_2D_SRC_DIR}/Knob_w150_64frames.png
    ${RE_2D_SRC_DIR}/Main_LCD.png
    ${RE_2D_SRC_DIR}/Main_LCD_Background.png
    ${RE_2D_SRC_DIR}/Panel_Back.png
    ${RE_2D_SRC_DIR}/Panel_Folded_Back.png
    ${RE_2D_SRC_DIR}/Panel_Folded_Front.png
    ${RE_2D_SRC_DIR}/Panel_Front.png
    ${RE_2D_SRC_DIR}/Placeholder.png
    ${RE_2D_SRC_DIR}/SharedAudioJack.png
    ${RE_2D_SRC_DIR}/TapeHoriz.png
    ${RE_2D_SRC_DIR}/TapeVert.png
  )

# Adding the RE plugin
add_re_plugin(
    RE_SDK_VERSION ${RE_SDK_VERSION}
    RE_SDK_ROOT ${RE_SDK_ROOT}
    RE_2D_RENDER_ROOT ${RE_2D_RENDER_ROOT}
    BUILD_SOURCES ${re_sources_cpp} ${re-common_BUILD_SOURCES}
    NATIVE_BUILD_SOURCES ${re-common_NATIVE_BUILD_SOURCES}
    RENDER_2D_SOURCES ${re_sources_2d}
    INCLUDE_DIRECTORIES ${re-common_INCLUDE_DIRECTORIES}
    COMPILE_OPTIONS -Wall
    ENABLE_DEBUG_LOGGING # turn on JBOX_TRACE and loguru
)
