# Copyright (c) 2016, Loïc Hoguin <essen@ninenines.eu>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

.PHONY: lfe-shell lfe-test-dir

# Verbosity.

lfe_verbose_0 = @echo " LFE   " $(filter %.lfe,$(?F));
lfe_verbose = $(lfe_verbose_$(V))

# Core targets.

LFE_FILES = $(sort $(call core_find,src/,*.lfe))

ifneq ($(LFE_FILES),)

BEAM_FILES += $(addprefix ebin/,$(patsubst %.lfe,%.beam,$(notdir $(LFE_FILES))))

# Rebuild LFE modules when the Makefile changes.
$(LFE_FILES): $(MAKEFILE_LIST)
	@touch $@

ebin/$(PROJECT).app:: $(LFE_FILES) | ebin/
	$(if $(strip $?),$(lfe_verbose) PATH=$(PATH):$(DEPS_DIR)/lfe/bin lfec -o ebin/ $(LFE_FILES))

endif

LFE_TEST_FILES = $(sort $(call core_find,$(TEST_DIR),*.lfe))

ifneq ($(LFE_TEST_FILES),)
lfe-test-dir: $(LFE_TEST_FILES)
	$(lfe_verbose) PATH=$(PATH):$(DEPS_DIR)/lfe/bin lfec -o test/ $(LFE_TEST_FILES)

test-build:: lfe-test-dir
else
lfe-test-dir:
endif

# Shell.

lfe-shell: deps
	$(verbose) PATH=$(PATH):$(DEPS_DIR)/lfe/bin lfe
