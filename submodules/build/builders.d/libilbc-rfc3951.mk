############################################################################
# Copyright (C) 2014  Belledonne Communications,Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
############################################################################
enable_libilbc-rfc3951?=yes

libilbc-rfc3951_project:=libilbc-rfc3951
libilbc-rfc3951_project_dir:=.
libilbc-rfc3951_cmake_specific_options:=-DENABLE_STATIC=YES

libilbc-rfc3951_src_dir=$(BUILDER_SRC_DIR)/${libilbc-rfc3951_project_dir}/${libilbc-rfc3951_project}
libilbc-rfc3951_build_dir=$(BUILDER_BUILD_DIR)/${libilbc-rfc3951_project_dir}/${libilbc-rfc3951_project}

${libilbc-rfc3951_build_dir}/Makefile:
	rm -rf ${libilbc-rfc3951_build_dir}/CMakeCache.txt ${libilbc-rfc3951_build_dir}/CMakeFiles/ && \
	mkdir -p ${libilbc-rfc3951_build_dir} && \
	cd ${libilbc-rfc3951_build_dir} && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$(BUILDER_SRC_DIR)/build/toolchain.cmake -DIOS_ARCH=${ARCH} \
		-DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_MODULE_PATH=$(prefix)/share/cmake/Modules/ \
		${libilbc-rfc3951_cmake_specific_options} ${libilbc-rfc3951_src_dir}

ifeq ($(enable_${libilbc-rfc3951_project}),yes)
build-${libilbc-rfc3951_project}: ${libilbc-rfc3951_build_dir}/Makefile
	cd ${libilbc-rfc3951_build_dir} && \
	make && \
	make install
else
build-${libilbc-rfc3951_project}:
	@echo "${libilbc-rfc3951_project} is disabled"
endif


clean-${libilbc-rfc3951_project}:
	cd $(libilbc-rfc3951_build_dir) && \
	make clean

veryclean-${libilbc-rfc3951_project}:
	if [ -d $(libilbc-rfc3951_build_dir) ]; then grep -v $(prefix) $(libilbc-rfc3951_build_dir)/install_manifest.txt | xargs rm; fi && \
	rm -rf $(libilbc-rfc3951_build_dir)

clean-makefile-${libilbc-rfc3951_project}: veryclean-${libilbc-rfc3951_project}

