LINPHONE_SRC_DIR=$(BUILDER_SRC_DIR)/linphone
LINPHONE_BUILD_DIR=$(BUILDER_BUILD_DIR)/linphone

$(LINPHONE_SRC_DIR)/configure:
	cd $(LINPHONE_SRC_DIR) && ./autogen.sh

$(LINPHONE_BUILD_DIR)/Makefile: $(LINPHONE_SRC_DIR)/configure
	mkdir -p $(LINPHONE_BUILD_DIR)
	@echo -e "\033[1mPKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
        $(LINPHONE_SRC_DIR)/configure -prefix=$(prefix) --host=$(host) ${library_mode} \
        ${linphone_configure_controls}\033[0m"
	cd $(LINPHONE_BUILD_DIR) && \
	PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
	$(LINPHONE_SRC_DIR)/configure -prefix=$(prefix) --host=$(host) ${library_mode} \
	${linphone_configure_controls}


build-linphone: $(LINPHONE_BUILD_DIR)/Makefile
	cd $(LINPHONE_BUILD_DIR) && \
	export PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig && \
	export CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) && \
	make newdate && make all && make install
	mkdir -p $(prefix)/share/linphone/tutorials && cp -f $(LINPHONE_SRC_DIR)/coreapi/help/*.c $(prefix)/share/linphone/tutorials/

clean-linphone:
	cd  $(LINPHONE_BUILD_DIR) && make clean

veryclean-linphone:
#-cd $(LINPHONE_BUILD_DIR) && make distclean
	-cd $(LINPHONE_SRC_DIR) && rm -f configure

clean-makefile-linphone:
	cd $(LINPHONE_BUILD_DIR) && rm -f Makefile && rm -f oRTP/Makefile && rm -f mediastreamer2/Makefile
