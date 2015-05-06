Pod::Spec.new do |s|
  s.name            = "KIF"
  s.version         = "4.0.0"
  s.summary         = "Keep It Functional - iOS UI acceptance testing in an XCUnit harness."
  s.homepage        = "https://github.com/kif-framework/KIF/"
  s.license         = 'Apache 2.0'
  s.authors         = 'Eric Firestone', 'Jim Puls', 'Brian Nickel'
  s.source          = { :git => "https://github.com/kif-framework/KIF.git", :tag => "v4.0.0" }
  s.platform        = :ios, '7.0'
  s.frameworks      = 'CoreGraphics', 'IOKit', 'XCTest'
  s.requires_arc    = true
  s.prefix_header_contents = '#import <CoreGraphics/CoreGraphics.h>'
  s.source_files         = 'Classes', 'Additions', 'IdentifierTests'
  s.public_header_files  = 'Classes/**/*.h', 'Additions/**/*-KIFAdditions.h', 'IdentifierTests/**/*.h'
  s.xcconfig             = { 'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/Frameworks' }
end
