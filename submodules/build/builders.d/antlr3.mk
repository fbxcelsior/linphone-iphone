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
enable_antlr3?=yes

antlr3_project:=antlr3
antlr3_project_dir:=externals
antlr3_cmake_specific_options:=-DENABLE_STATIC=YES

antlr3_src_dir=$(BUILDER_SRC_DIR)/${antlr3_project_dir}/${antlr3_project}
antlr3_build_dir=$(BUILDER_BUILD_DIR)/${antlr3_project_dir}/${antlr3_project}

${antlr3_build_dir}/Makefile:
	rm -rf ${antlr3_build_dir}/CMakeCache.txt ${antlr3_build_dir}/CMakeFiles/ && \
	mkdir -p ${antlr3_build_dir} && \
	cd ${antlr3_build_dir} && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$(BUILDER_SRC_DIR)/build/toolchain.cmake -DIOS_ARCH=${ARCH} \
		-DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_MODULE_PATH=$(prefix)/share/cmake/Modules/ \
		${antlr3_cmake_specific_options} ${antlr3_src_dir}

ifeq ($(enable_${antlr3_project}),yes)
build-${antlr3_project}: ${antlr3_build_dir}/Makefile
	cd ${antlr3_build_dir} && \
	make && \
	make install
else
build-${antlr3_project}:
	@echo "${antlr3_project} is disabled"
endif


clean-${antlr3_project}:
	cd $(antlr3_build_dir) && \
	make clean

veryclean-${antlr3_project}:
	if [ -d $(antlr3_build_dir) ]; then grep -v $(prefix) $(antlr3_build_dir)/install_manifest.txt | xargs rm; fi && \
	rm -rf $(antlr3_build_dir)

clean-makefile-${antlr3_project}: veryclean-${antlr3_project}

