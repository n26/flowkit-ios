#
#  Be sure to run `pod spec lint Shared.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "Shared"
  spec.version      = "0.0.1"
  spec.summary      = "Shared components"
  spec.homepage     = 'https://github.com/n26/flowkit-ios/tree/main'
  spec.description  = "FlowKitAdditions Shared components"
  spec.license      = "MIT"
  spec.author       = { 'NA' => 'N26 GmbH' }
  spec.platform     = :ios, "13.0"
  spec.source       = { :path => "." }
  spec.source_files = "**/*.swift"
  spec.dependency 'flowkit-ios/Additions'
  spec.resource_bundles = { 'SharedResources' => ['**/*.{json}'] }
end
