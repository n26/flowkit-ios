Pod::Spec.new do |s|
  s.name             = 'flowkit-ios'
  s.version          = '1.0.1'
  s.summary          = 'Dynamic and type-safe framework for building linear and non-linear flows'

  s.description      = "FlowKit is a dynamic flow framework capable of building a flow, based on conditions and ordered according to a logic of next steps"

  s.homepage         = 'https://github.com/n26/flowkit-ios/tree/main'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NA' => 'N26 GmbH' }
  s.source           = { :git => 'git@github.com:n26/flowkit-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.module_name = 'FlowKit'

  s.source_files = 'flowkit-ios/Classes/**/*'

  s.test_spec 'Tests' do |test_spec|
    test_spec.requires_app_host = false
    test_spec.dependency 'Quick'
    test_spec.dependency 'Nimble'
    test_spec.source_files = ['flowkit-ios/Tests/Classes/**/*.{swift}']
  end

  s.subspec 'Additions' do |sp|
    sp.source_files = 'flowkitAdditions/Classes/**/*'
  end

end
