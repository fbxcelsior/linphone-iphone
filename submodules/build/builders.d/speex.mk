

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
enable_speex?=yes

speex_project:=speex
speex_project_dir:=externals
speex_cmake_specific_options:=-DENABLE_STATIC=YES
ifeq (,$(findstring i386,$(host)))
	speex_cmake_specific_options += -ENABLE_FLOAT_API=NO -DENABLE_FIXED_POINT=YES
endif
ifneq (,$(findstring armv7,$(host)))
	speex_cmake_specific_options += -DENABLE_ARMV7_NEON_ASM=YES -DENABLE_ARM5E_ASM=YES
endif
ifneq (,$(findstring aarch64,$(host)))
	speex_cmake_specific_options += -DENABLE_ARMV7_NEON_ASM=YES
endif

speex_src_dir=$(BUILDER_SRC_DIR)/${speex_project_dir}/${speex_project}
speex_build_dir=$(BUILDER_BUILD_DIR)/${speex_project_dir}/${speex_project}

${speex_build_dir}/Makefile:
	rm -rf ${speex_build_dir}/CMakeCache.txt ${speex_build_dir}/CMakeFiles/ && \
	mkdir -p ${speex_build_dir} && \
	cd ${speex_build_dir} && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$(BUILDER_SRC_DIR)/build/toolchain.cmake -DIOS_ARCH=${ARCH} \
		-DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_MODULE_PATH=$(prefix)/share/cmake/Modules/ \
		${speex_cmake_specific_options} ${speex_src_dir}

ifeq ($(enable_${speex_project}),yes)
build-${speex_project}: ${speex_build_dir}/Makefile
	cd ${speex_build_dir} && \
	make && \
	make install
else
build-${speex_project}:
	@echo "${speex_project} is disabled"
endif


clean-${speex_project}:
	cd $(speex_build_dir) && \
	make clean

veryclean-${speex_project}:
	if [ -d $(speex_build_dir) ]; then grep -v $(prefix) $(speex_build_dir)/install_manifest.txt | xargs rm; fi && \
	rm -rf $(speex_build_dir)

clean-makefile-${speex_project}: veryclean-${speex_project}

