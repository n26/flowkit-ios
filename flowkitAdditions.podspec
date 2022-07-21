Pod::Spec.new do |s|
  s.name             = 'flowkitAdditions'
  s.version          = '1.0.0'
  s.summary          = 'FlowKit Additions are a set of default models to use flowkit-ios library out of the box'

  s.description      = "FlowKit Additions are a set of default models to use flowkit-ios library out of the box"

  s.homepage         = 'https://github.com/n26/flowkit-ios/tree/main'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NA' => 'N26 GmbH' }
  s.source           = { :git => 'git@github.com:n26/flowkit-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.module_name = 'FlowKitAdditions'

  s.source_files = 'flowkitAdditions/Classes/**/*'

  s.dependency 'flowkit-ios'
end
