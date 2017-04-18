Pod::Spec.new do |s|
  s.name         = "base"
  s.version      = "1.1.6"
  s.summary      = "Azazie Fundamentals"
  s.homepage     = "https://g.digi800.com/azios/base"

  s.author       = { "Taylor" => "com.taylortang@gmail.com" }

  s.platform     = :ios, "8.0"
	s.license      = "Copyright (c) 2017-present Azazie, Inc. All rights reserved."

  s.source       = { :git => "https://g.digi800.com/azios/base.git", :tag => s.version }

  s.source_files  			= "base/Classes", "base/Classes/**/*.{h,m}"
  s.public_header_files = "base/Classes/**/*.h"
	s.resource_bundles    = {'Base' => 'base/Resources/Base.bundle/*'}

  s.requires_arc = true

  s.dependency "ReactiveObjC"
  s.dependency "Masonry"
  s.dependency "JSONModel"
  s.dependency "SMPageControl"
  s.dependency "TXFire"
  s.dependency "AFNetworking"
	s.dependency "SDWebImage"

end
