// steamdeck_hwmon_shim.c
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/hwmon.h>
#include <linux/hwmon-sysfs.h>
#include <linux/slab.h>

static char *real_path = "/sys/class/hwmon/hwmon6/fan1_input";
module_param(real_path, charp, 0444);
MODULE_PARM_DESC(real_path, "Path to real fan input");

static ssize_t fan1_input_show(struct device *dev,
                               struct device_attribute *attr,
                               char *buf)
{
    struct file *f;
    loff_t pos = 0;
    ssize_t ret;
    char tmp[32];

    f = filp_open(real_path, O_RDONLY, 0);
    if (IS_ERR(f))
        return PTR_ERR(f);

    ret = kernel_read(f, tmp, sizeof(tmp) - 1, &pos);
    filp_close(f, NULL);

    if (ret < 0)
        return ret;

    tmp[ret] = '\0';
    return scnprintf(buf, PAGE_SIZE, "%s", tmp);
}

static SENSOR_DEVICE_ATTR_RO(fan1_input, fan1_input, 0);

static struct attribute *attrs[] = {
    &sensor_dev_attr_fan1_input.dev_attr.attr,
    NULL,
};

static const struct attribute_group group = {
    .attrs = attrs,
};

static const struct attribute_group *groups[] = {
    &group,
    NULL,
};

static struct device *hwmon_dev;

static int __init shim_init(void)
{
    hwmon_dev = hwmon_device_register_with_groups(NULL,
                                                  "steamdeck_hwmon",
                                                  NULL,
                                                  groups);
    if (IS_ERR(hwmon_dev))
        return PTR_ERR(hwmon_dev);

    pr_info("steamdeck hwmon shim loaded\n");
    return 0;
}

static void __exit shim_exit(void)
{
    hwmon_device_unregister(hwmon_dev);
    pr_info("steamdeck hwmon shim unloaded\n");
}

module_init(shim_init);
module_exit(shim_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("You");
MODULE_DESCRIPTION("SteamDeck hwmon fan shim");
