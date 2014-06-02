require 'formula'

class Pugixml < Formula
  homepage 'https://code.google.com/p/pugixml/'
  url 'http://pugixml.googlecode.com/files/pugixml-1.2.tar.gz'
  sha1 '1eee11df5d61fea31a977d98bd2dcc9421231f9e'

  depends_on 'cmake' => :build

  # The CMake file packaged with pugixml allows you to toggle between building
  # a static library or dynamic. This replacement script will build both for
  # convenience.
  def cmake_lists
      <<-SCRIPT
        project(pugixml)

        cmake_minimum_required(VERSION 2.6)

        # C++11
        set(CMAKE_CXX_FLAGS "-std=c++0x -stdlib=libc++ -g3 -Wall -O0")

        set(HEADERS ../src/pugixml.hpp ../src/pugiconfig.hpp)
        set(SOURCES ${HEADERS} ../src/pugixml.cpp)

        add_library(pugixml SHARED ${SOURCES})
        add_library(pugixml_static STATIC ${SOURCES})

        set_target_properties(pugixml PROPERTIES VERSION 1.2 SOVERSION 1.2)
        set_target_properties(pugixml_static PROPERTIES VERSION 1.2 SOVERSION 1.2)

        install(TARGETS pugixml LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
        install(TARGETS pugixml_static LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
        install(FILES ${HEADERS} DESTINATION include)
      SCRIPT
  end

  def install
    File.open('scripts/CMakeLists.txt', 'w') do |out|
      out << cmake_lists()
    end
    Dir.chdir(Dir.pwd + "/scripts")
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
