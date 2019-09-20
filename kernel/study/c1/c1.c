#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

static int __init lkp_init( void )
{
	printk("Hello,World!\n");
	return 0;
}

static void __exit lkp_cleanup( void )
{
	printk("Goodbye, World!\n");
}

module_init(lkp_init);
module_exit(lkp_cleanup);