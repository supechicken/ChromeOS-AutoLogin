@[Link(ldflags: "#{__DIR__}/uinput.c")]

lib Uinput
  EV_SYN = 0x00
  EV_KEY = 0x01

  fun init()
  fun emit_keyevent(type: Int32, code: Int32, pressed: Int32)
  fun destroy_device()
end
