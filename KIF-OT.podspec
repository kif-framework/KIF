version = "2.0.4"

Pod::Spec.new do |s|
  s.name         = "KIF-OT"
  s.version      = version
  s.summary      = "Keep It Functional - iOS UI acceptance testing in an OCUnit harness."
  s.homepage     = "https://github.com/kif-framework/KIF/"
  s.license      = 'Apache 2.0'
  s.authors      = 'Eric Firestone', 'Jim Puls', 'Brian Nickel'
  s.source       = { :git => "git@github.com:opentable/KIF.git", :tag => "v#{version}-OT" }
  s.platform     = :ios, '6.1'
  s.source_files = 'Classes', 'Additions'
  s.public_header_files = 'Classes/**/*.h', 'Additions/**/*-KIFAdditions.h'
  s.frameworks  = 'SenTestingKit', 'CoreGraphics'
  s.prefix_header_contents = '#import <CoreGraphics/CoreGraphics.h>'
  s.header_dir = 'KIF'
end
