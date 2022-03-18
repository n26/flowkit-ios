Pod::Spec.new do |s|
  s.name             = 'flowkit-ios'
  s.version          = '0.1.0'
  s.summary          = 'flowkit-ios core'

  s.description      = "This is the N26 flowkit core for the community"

  s.homepage         = 'https://github.com/n26/flowkit-ios/tree/main'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NA' => 'alejandro.martinez@n26.com' }
  s.source           = { :git => 'git@github.com:n26/flowkit-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.module_name = 'N26FlowKitCore'

  s.source_files = 'flowkit-ios/Classes/**/*'

  s.test_spec 'Tests' do |test_spec|
    test_spec.requires_app_host = false
    test_spec.dependency 'Quick'
    test_spec.dependency 'Nimble'
    test_spec.source_files = ['flowkit-ios/Tests/Classes/**/*.{swift}']
  end
end
