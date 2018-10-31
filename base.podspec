Pod::Spec.new do |s|
  s.name         = "base"
  s.version      = "1.9.5"
  s.summary      = "Leqee Fundamentals"
  s.homepage     = "https://g.digi800.com/azios/base"

  s.author       = { "Jocer" => "com.pjocer@outlook.com" }

  s.platform     = :ios, "9.0"
	s.license      = "Copyright (c) 2017-present Azazie, Inc. All rights reserved."

  s.source       = { :git => "https://g.digi800.com/azios/base.git", :tag => s.version }

  s.source_files  			= "base/Classes", "base/Classes/**/*.{h,m}"
  s.public_header_files = "base/Classes/**/*.h"
	s.resource_bundles    = {'Base' => 'base/Resources/Base.bundle/*'}

  s.requires_arc = true
  s.dependency "TTTAttributedLabel"
  s.dependency "ReactiveObjC"
  s.dependency "Masonry"
  s.dependency "SMPageControl"
  s.dependency "TXFire"
  s.dependency "AFNetworking"
  s.dependency "YYModel"
    s.dependency "SDWebImage"
    s.dependency "MBProgressHUD"
    s.dependency "MJRefresh"
    s.dependency "DebugBall"
  s.dependency "SDWebImage/GIF"
  s.dependency "FLAnimatedImage"
  s.dependency "Braintree"
  s.dependency "CardIO"
  s.dependency "YTKKeyValueStore"
end
