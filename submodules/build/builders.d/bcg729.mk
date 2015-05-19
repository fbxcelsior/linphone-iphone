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
enable_bcg729?=yes

bcg729_project:=bcg729
bcg729_project_dir:=.
bcg729_cmake_specific_options:=-DENABLE_STATIC=YES

bcg729_src_dir=$(BUILDER_SRC_DIR)/${bcg729_project_dir}/${bcg729_project}
bcg729_build_dir=$(BUILDER_BUILD_DIR)/${bcg729_project_dir}/${bcg729_project}

${bcg729_build_dir}/Makefile:
	rm -rf ${bcg729_build_dir}/CMakeCache.txt ${bcg729_build_dir}/CMakeFiles/ && \
	mkdir -p ${bcg729_build_dir} && \
	cd ${bcg729_build_dir} && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$(BUILDER_SRC_DIR)/build/toolchain.cmake -DIOS_ARCH=${ARCH} \
		-DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_MODULE_PATH=$(prefix)/share/cmake/Modules/ \
		${bcg729_cmake_specific_options} ${bcg729_src_dir}

ifeq ($(enable_${bcg729_project}),yes)
build-${bcg729_project}: ${bcg729_build_dir}/Makefile
	cd ${bcg729_build_dir} && \
	make && \
	make install
else
build-${bcg729_project}:
	@echo "${bcg729_project} is disabled"
endif


clean-${bcg729_project}:
	cd $(bcg729_build_dir) && \
	make clean

veryclean-${bcg729_project}:
	if [ -d $(bcg729_build_dir) ]; then grep -v $(prefix) $(bcg729_build_dir)/install_manifest.txt | xargs rm; fi && \
	rm -rf $(bcg729_build_dir)

clean-makefile-${bcg729_project}: veryclean-${bcg729_project}


