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
enable_belle-sip?=yes

belle-sip_project:=belle-sip
belle-sip_project_dir:=.
belle-sip_cmake_specific_options:=-DENABLE_STATIC=YES -DENABLE_TLS=YES -DENABLE_TUNNEL=YES -DENABLE_TESTS=NO

belle-sip_src_dir=$(BUILDER_SRC_DIR)/${belle-sip_project_dir}/${belle-sip_project}
belle-sip_build_dir=$(BUILDER_BUILD_DIR)/${belle-sip_project_dir}/${belle-sip_project}

#for some VERY ODD reason, we must use real absolute path for prefix (and note absolute/../somepath
# because otherwise cmake FindAntlr3.cmake will throw "Error: Unable to access jarfile ANTLR3_JAR_PATH-NOTFOUND"
${belle-sip_build_dir}/Makefile:
	rm -rf ${belle-sip_build_dir}/CMakeCache.txt ${belle-sip_build_dir}/CMakeFiles/ && \
	mkdir -p ${belle-sip_build_dir} && \
	cd ${belle-sip_build_dir} && \
	prefixabs=$(realpath ${prefix}) && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$(BUILDER_SRC_DIR)/build/toolchain.cmake -DIOS_ARCH=${ARCH} \
		-DCMAKE_INSTALL_PREFIX=$${prefixabs} -DCMAKE_PREFIX_PATH=$${prefixabs} -DCMAKE_MODULE_PATH=$${prefixabs}/share/cmake/Modules/ \
		${belle-sip_cmake_specific_options} ${belle-sip_src_dir}

ifeq ($(enable_${belle-sip_project}),yes)
build-${belle-sip_project}: ${belle-sip_build_dir}/Makefile
	cd ${belle-sip_build_dir} && \
	make && \
	make install
else
build-${belle-sip_project}:
	@echo "${belle-sip_project} is disabled"
endif


clean-${belle-sip_project}:
	cd $(belle-sip_build_dir) && \
	make clean

veryclean-${belle-sip_project}:
	if [ -d $(belle-sip_build_dir) ]; then grep -v $(prefix) $(belle-sip_build_dir)/install_manifest.txt | xargs rm; fi && \
	rm -rf $(belle-sip_build_dir)

clean-makefile-${belle-sip_project}: veryclean-${belle-sip_project}

