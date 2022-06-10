Pod::Spec.new do |s|
  s.name          = "TokenCoreDep"
  s.version       = "0.0.1"
  s.summary       = "The libraries token core need"

  s.description   = <<-DESC
  The libaray contains the CoreBitcoin and libscrypt.
  DESC

  s.homepage      = "https://token.im"
  s.license       = {
    type: "Apache License, Version 2.0",
    file: "LICENSE"
  }

  s.author        = { "Neal Xu" => "imxuneal@gmail.com" }
  s.platform      = :ios, "9.0"

  s.source        = { :git => "git@github.com:consenlabs/token-core-ios-dep.git", :tag => "#{s.version}" }
  s.source_files  = "CoreBitcoin/*.{h,m,c}", "libscrypt/*.{h,m,c}"
  s.public_header_files = "CoreBitcoin/*.h", "libscrypt/*.h"
  s.exclude_files = ['*+Tests.{h,m}']
  s.requires_arc = true
  s.framework    = 'Foundation'
  s.ios.framework = 'UIKit'
  s.osx.framework = 'AppKit'
  s.dependency "GRKOpenSSLFramework"
end
