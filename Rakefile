# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'formotion'
require 'bundler/setup'
Bundler.require
require "sugarcube-repl"

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Errbit'
  app.version = "0.1"
  app.identifier = "com.dynomatix.errbit"
  app.xcode_dir = "/Applications/Xcode.app/Contents/Developer"
  app.sdk_version = "7.0"
  app.device_family = [:iphone, :ipad]
  app.frameworks += ['CoreData']
  app.codesign_certificate = "iPhone Developer: Yuri kovalov (GGMDWH2C3S)"
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'com.dynomatix.errbit',
      'CFBundleURLSchemes' => ['errbit']}
  ]
end

namespace :simulator do
  desc "Call 'Reset Content and Settings' in iOS Simulator menu"
  task :reset do
    %x{
      osascript <<-END
tell application "iPhone Simulator" to activate

tell application "System Events"
    tell process "iPhone Simulator"
        tell menu bar 1
            tell menu bar item "iOS Simulator"
              tell menu "iOS Simulator" to click menu item "Reset Content and Settings…"
            end tell
        end tell
        tell window 1 to click button "Reset"
    end tell
end tell

END
    }
  end
end
