include config.mk

TOOLS=$(shell ls ff-*.c | sed 's/\.c//g')
DEPS= tools.h

.PHONY: all
all: options $(OUT) $(addprefix $(OUT)/,$(TOOLS)) man

.PHONY: options
options:
	@echo "LIBS   = $(LIBS)"
	@echo "CFLAGS = $(CFLAGS)"
	@echo "CC     = $(CC)"
	@echo "OUT    = $(OUT)"

.PHONY: clean
clean:
	@rm -rf $(OUT) 2>/dev/null >/dev/null
	@echo " → Cleaned workspace directory"

install: $(addprefix $(PREFIX)/bin/,$(TOOLS))

$(PREFIX)/bin/%: $(OUT)/%.o tools.o
	@$(CC) $(LIBS) $(CFLAGS) $(CFLAGS_ADD) -o $@ $< tools.o
	@echo " → Installed tools"

.PHONY: dist
dist: clean
	@echo " → make distribution pack"
	@mkdir -p ff-tools-$(VERSION)
	@cp -R Makefile Readme.md config.mk *.c *.h ff-tools-$(VERSION)
	@tar -cf ff-tools-$(VERSION).tar ff-tools-$(VERSION)
	@gzip ff-tools-$(VERSION).tar
	@rm -rf ff-tools-$(VERSION)

.PHONY: test
test: all
	@echo " → testing binaries"
	@./test.sh $(OUT)

demo.png: demo.sh
	@echo " → creating $@"
	@./$< $(OUT) | ff2png > $@

$(OUT):
	@mkdir -p $@

man: $(OUT)/ff-tools.l $(OUT)/ff-tools.1

$(OUT)/ff-tools.l: ff-tools.l.in
	@cat $< | sed -e "s/VNUM/$(VERSION)/g" | sed -e "s/DATE/$(DATE)/g" > $@
	@echo " → $@ compiled"

$(OUT)/ff-tools.1: ff-tools.1.in
	@cat $< | sed -e "s/VNUM/$(VERSION)/g" | sed -e "s/DATE/$(DATE)/g" > $@
	@echo " → $@ compiled"

$(OUT)/tools.o: tools.c tools.h
	@$(CC) $(LIBS) $(CFLAGS) $(CFLAGS_ADD) -o $@ -c $<
	@echo " → $@ compiled"

$(OUT)/%.o: %.c $(DEPS)
	@$(CC) $(LIBS) $(CFLAGS) $(CFLAGS_ADD) -o $@ -c $<
	@echo " → $@ compiled"

$(OUT)/%: $(OUT)/%.o tools.o
	@$(CC) $(LIBS) $(CFLAGS) $(CFLAGS_ADD) -o $@ $< tools.o
