Pod::Spec.new do |s|
  s.name         = "KIF"
  s.version      = "2.0.0"
  s.summary      = "Keep It Functional - iOS UI acceptance testing in an OCUnit harness."
  s.homepage     = "https://github.com/kif-framework/KIF/"
  s.license      = 'Apache 2.0'
  s.authors      = 'Eric Firestone', 'Jim Puls', 'Brian Nickel'
  s.source       = { :git => "https://github.com/kif-framework/KIF.git", :tag => "v2.0.0" }
  s.platform     = :ios, '4.3'
  s.frameworks  = 'CoreGraphics'
  s.prefix_header_contents = '#import <CoreGraphics/CoreGraphics.h>'
  s.default_subspec = 'XCTest'

  s.subspec 'OCUnit' do |sentest|
    sentest.framework = 'SenTestingKit'
    sentest.dependency 'KIF/Core'
    sentest.xcconfig = { 'OTHER_CFLAGS' => '-DKIF_SENTEST' }
    sentest.source_files = 'Additions/SenTestCase-KIFAdditions.{h,m}'
  end

  s.subspec 'XCTest' do |xctest|
    xctest.framework = 'XCTest'
    xctest.dependency 'KIF/Core'
    xctest.xcconfig = { 'OTHER_CFLAGS' => '-DKIF_XCTEST' }
    xctest.source_files = 'Additions/XCTestCase-KIFAdditions.{h,m}'
  end

  s.subspec 'Core' do |core|
    core.source_files = 'Classes', 'Additions'
    core.public_header_files = 'Classes/**/*.h', 'Additions/**/*-KIFAdditions.h'
    core.exclude_files = 'Additions/SenTestCase-KIFAdditions.{h,m}', 'Additions/XCTestCase-KIFAdditions.{h,m}'
  end
end
