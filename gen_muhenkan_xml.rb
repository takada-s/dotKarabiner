#!/usr/bin/env ruby

user = (ENV['USER'] || `whoami`).chomp

# format:
# key     app name
out_xml_ary = []
out_def_ary = []

while line=gets
  next if line.start_with? '#'
  key, app = line.split(" ", 2)
  next if (key.nil? or key.empty?)
  next if (app.nil? or app.empty?)
  app.chomp!

  direct_launch_mode = false
  if app.end_with? '!'
    app.chomp!('!')
    direct_launch_mode = true
  end

  vkey_event_name = "KeyCode::VK_OPEN_URL_SHELL_activate_by_#{key}"

  _xml = <<_EOT_
  <vkopenurldef>
    <name>#{vkey_event_name}</name>
    <url type="shell">
      <![CDATA[ /usr/bin/osascript -e "tell application \\"#{app}\\" to activate" >/dev/null 2>/dev/null ]]>
    </url>
  </vkopenurldef>
_EOT_
  out_xml_ary << _xml unless direct_launch_mode

  keycode="KeyCode::#{key.upcase}"
  _def = <<_EOT_
    <item>
      <name>Activate #{app} by MUHENKAN + #{key}</name>
      <identifier>#{user}.muhenkan.hotkeys.#{key}</identifier>
      <autogen>--KeyOverlaidModifier-- KeyCode::JIS_EISUU, KeyCode::VK_MODIFIER_EXTRA1, KeyCode::JIS_EISUU</autogen>
      <autogen>
        __KeyToKey__
        #{keycode}, ModifierFlag::EXTRA1,
        #{vkey_event_name}
      </autogen>
    </item>
_EOT_
  out_def_ary << _def
end

puts <<_EOT_
<?xml version="1.0"?>
<root>
_EOT_
puts out_xml_ary.join("\n")

puts; puts

puts <<_EOT_
  <item>
    <name>Muhenkan Application Shortcuts</name>
_EOT_
puts out_def_ary.join("\n")
puts <<_EOT_
  </item>
</root>
_EOT_





