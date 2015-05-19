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
enable_srtp?=yes

srtp_project:=srtp
srtp_project_dir:=externals
srtp_cmake_specific_options:=-DENABLE_STATIC=YES

srtp_src_dir=$(BUILDER_SRC_DIR)/${srtp_project_dir}/${srtp_project}
srtp_build_dir=$(BUILDER_BUILD_DIR)/${srtp_project_dir}/${srtp_project}

${srtp_build_dir}/Makefile:
	rm -rf ${srtp_build_dir}/CMakeCache.txt ${srtp_build_dir}/CMakeFiles/ && \
	mkdir -p ${srtp_build_dir} && \
	cd ${srtp_build_dir} && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$(BUILDER_SRC_DIR)/build/toolchain.cmake -DIOS_ARCH=${ARCH} \
		-DCMAKE_INSTALL_PREFIX=$(prefix) -DCMAKE_PREFIX_PATH=$(prefix) -DCMAKE_MODULE_PATH=$(prefix)/share/cmake/Modules/ \
		${srtp_cmake_specific_options} ${srtp_src_dir}

ifeq ($(enable_${srtp_project}),yes)
build-${srtp_project}: ${srtp_build_dir}/Makefile
	cd ${srtp_build_dir} && \
	make && \
	make install
else
build-${srtp_project}:
	@echo "${srtp_project} is disabled"
endif


clean-${srtp_project}:
	cd $(srtp_build_dir) && \
	make clean

veryclean-${srtp_project}:
	if [ -d $(srtp_build_dir) ]; then grep -v $(prefix) $(srtp_build_dir)/install_manifest.txt | xargs rm; fi && \
	rm -rf $(srtp_build_dir)

clean-makefile-${srtp_project}: veryclean-${srtp_project}

