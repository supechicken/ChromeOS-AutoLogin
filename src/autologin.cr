require "./lib/keycode.cr"
require "./lib/uinput.cr"

LOG = File.open("/tmp/cros-autologin.log", "w")

LOG.puts "cros-autologin: Initializing uinput dummy device..."
Uinput.init

password     = File.read("/usr/local/etc/cros-autologin/password")
dbus_monitor = Process.new "dbus-monitor", ["--system", "--monitor", "type='signal',interface='org.chromium.SessionManagerInterface',member='LoginPromptVisible'"], output: :pipe, error: STDERR

dbus_monitor.output.read(Bytes.new(1024))

dbus_monitor.output.gets()
sleep(1.5)

LOG.puts "cros-autologin: Autotyping password..."

password.each_char do |char|
  keycode = KEYCODE_MAP[char.upcase.to_s]

  Uinput.emit_keyevent(Uinput::EV_KEY, 42, 1) if char.uppercase?
  keycode.each { |code| Uinput.emit_keyevent(Uinput::EV_KEY, code, 1) }
  Uinput.emit_keyevent(Uinput::EV_SYN, 0, 0)

  sleep(0.05)

  keycode.each { |code| Uinput.emit_keyevent(Uinput::EV_KEY, code, 0) }
  Uinput.emit_keyevent(Uinput::EV_KEY, 42, 0)
  Uinput.emit_keyevent(Uinput::EV_SYN, 0, 0)
end

sleep(0.05)

# press enter
Uinput.emit_keyevent(Uinput::EV_KEY, 28, 1)
Uinput.emit_keyevent(Uinput::EV_SYN, 0, 0)
Uinput.emit_keyevent(Uinput::EV_KEY, 28, 0)
Uinput.emit_keyevent(Uinput::EV_SYN, 0, 0)

LOG.puts "cros-autologin: Goodbye and cleanup..."
Uinput.destroy_device
