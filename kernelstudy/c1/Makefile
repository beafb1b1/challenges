KERNAL_DIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
obj-m := c1.o

modules:

	$(MAKE) -C $(KERNAL_DIR) M=$(PWD) modules
	@make clear

clear:

	@rm -f *.o *.cmd *.mod.c
	@rm -rf *~ core .depend .tmp_versions Module.symvers modules.order -f
	@rm -f .*ko.cmd .*.o.cmd .*.o.d
	@rm -f *.unsigned

clean:

	@rm -f c1.ko