require 'formula'

class ArtecOmesh < Formula
  homepage 'http://openmesh.org'
  url 'http://www.openmesh.org/fileadmin/openmesh-files/2.3/OpenMesh-2.3.tar.gz'
  sha1 '3cccb46afd6f8b0c60dfbdcd883806f77efd14c3'

  head 'http://openmesh.org/svnrepo/OpenMesh/trunk/', :using => :svn

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'glew'
  conflicts_with 'omesh'

  option 'with-c++11', 'Compile using Clang, std=c++11 and stdlib=libc++' if MacOS.version >= :lion

  def install

    args = ["-DCMAKE_INSTALL_PREFIX='#{prefix}'",
            "-DCMAKE_BUILD_TYPE=Release"]

    if MacOS.version >= :lion and build.include? 'with-c++11'
      args << "-DCMAKE_CXX_FLAGS=-stdlib=libc++"
      args << "-DCMAKE_CXX_COMPILER=clang++"
      # Unfortunately applications can't be built now with libc++
      # so we are switching their compilation off
      args << "-DBUILD_APPS=OFF"
    end
    args << ".."

    mkdir 'openmesh-build' do
      system "cmake", *args
      #system "make install VERBOSE=1"
      system "make install"
    end
  end

  test do
    system "#{bin}/mconvert", "-help"
  end
end
