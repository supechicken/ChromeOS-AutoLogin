#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <linux/uinput.h>

struct uinput_setup usetup;
int    uinput_fd;

void init() {
  uinput_fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);

  // register keys
  ioctl(uinput_fd, UI_SET_EVBIT, EV_KEY);
  for (int i = 2; i <= 57; i++) ioctl(uinput_fd, UI_SET_KEYBIT, i);

  // setup uinput device
  memset(&usetup, 0, sizeof(usetup));

  usetup.id.bustype = BUS_USB;
  usetup.id.vendor  = 0xbeef;
  usetup.id.product = 0xbeef;

  strcpy(usetup.name, "Auto login dummy device");

  ioctl(uinput_fd, UI_DEV_SETUP, &usetup);
  ioctl(uinput_fd, UI_DEV_CREATE);
}

void emit_keyevent(int type, int code, int pressed) {
  struct input_event ie;

  ie.type  = type;
  ie.code  = code;
  ie.value = pressed;

  /* timestamp values below are ignored */
  ie.time.tv_sec  = 0;
  ie.time.tv_usec = 0;

  write(uinput_fd, &ie, sizeof(ie));
}

void destroy_device() {
  ioctl(uinput_fd, UI_DEV_DESTROY);
  close(uinput_fd);
}
