#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'openinstall_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.static_framework = true
  s.ios.deployment_target = '8.0'

  # Conditionally include libOpenInstallSDK only for device builds
  # The Objective-C code uses TARGET_OS_SIMULATOR preprocessor for conditional compilation
  # This allows building for simulator without the SDK (which lacks simulator architecture slices)
  # 
  # To skip OpenInstallSDK for simulator builds, run:
  #   SKIP_OPENINSTALL_SDK=1 pod install
  #
  # Or modify the dependency in your Podfile's pre_install hook
  unless ENV['SKIP_OPENINSTALL_SDK'] == '1'
    s.dependency 'libOpenInstallSDK'
  end
end

