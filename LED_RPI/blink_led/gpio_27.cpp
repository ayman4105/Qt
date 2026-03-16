#include "gpio_27.h"

#include <unistd.h>
#include <fcntl.h>
#include <iostream>
#include <string>

gpio_pin::gpio_pin(int num, gpio_mode_t _mode)
{
    pin_num = num + 512;
    mode = _mode;

    // Export the GPIO pin
    int export_fd = open("/sys/class/gpio/export", O_WRONLY);
    if (export_fd < 0) {
        perror("export error");
    }
    std::string s = std::to_string(pin_num);
    write(export_fd, s.c_str(), s.size());
    close(export_fd);

    // Set direction (in or out)
    std::string dir_path = "/sys/class/gpio/gpio" + std::to_string(pin_num) + "/direction";
    int direction_fd = open(dir_path.c_str(), O_WRONLY);
    if (direction_fd < 0) {
        perror("direction error");
    }

    if (mode == gpio_in)
        write(direction_fd, "in", 2);
    else
        write(direction_fd, "out", 3);

    close(direction_fd);

    // Open the value file for read or write
    std::string val_path = "/sys/class/gpio/gpio" + std::to_string(pin_num) + "/value";
    if (mode == gpio_in)
        fd = open(val_path.c_str(), O_RDONLY);
    else
        fd = open(val_path.c_str(), O_WRONLY);

    if (fd < 0) {
        perror("value open error");
    }
}

gpio_pin::~gpio_pin()
{
    close(fd);

    // Unexport the GPIO pin
    int unexport_fd = open("/sys/class/gpio/unexport", O_WRONLY);
    if (unexport_fd < 0) {
        perror("unexport error");
        return;
    }
    else {
        std::string s = std::to_string(pin_num);
        write(unexport_fd, s.c_str(), s.size());
        close(unexport_fd);
    }
}

int gpio_pin::read_value()
{
    if (mode != gpio_in) return -1;

    // Reopen the value file to get fresh data
    std::string val_path = "/sys/class/gpio/gpio" + std::to_string(pin_num) + "/value";
    close(fd);
    fd = open(val_path.c_str(), O_RDONLY);
    if (fd < 0) {
        perror("value reopen error");
        return -1;
    }

    char buf = 0;
    if (read(fd, &buf, 1) <= 0)
        return -1;

    return (buf == '1') ? 1 : 0;
}

void gpio_pin::write_value(int value)
{
    if (mode != gpio_out) return;

    if (value)
        write(fd, "1", 1);
    else
        write(fd, "0", 1);
}
