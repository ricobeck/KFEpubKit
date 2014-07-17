Pod::Spec.new do |s|
  s.name             =  'KFEpubKit'
  s.version          =  '0.0.7'
  s.license          =  { :type => 'MIT', :file => 'LICENSE.txt' }
  s.summary          =  'An Objective-C epub extracting and parsing framework for OSX and iOS.'
  s.homepage         =  'https://pods.kf-interactive.com'
  s.author           =  { 'Rico Becker' => 'rico.becker@kf-interactive.com', "Andrea Aresu" => "andrea.aresu@xorovo.com" }
  s.source           =  { :git => 'https://github.com/aaresu/KFEpubKit.git', :tag => "#{s.version}" }
  s.framework        =  'Foundation'
  s.requires_arc     =  true
  s.ios.deployment_target = "5.1"
  s.osx.deployment_target = "10.7"
  s.source_files     =  'KFEpubKit/Sources/*.{h,m}', 'KFEpubKit/LICENSE.txt', 'KFEpubKit/KissXML/*', 'KFEpubKit/KissXML/Additions', 'KFEpubKit/KissXML/Categories', 'KFEpubKit/KissXML/Private'
  s.dependency 'SSZipArchive'
  s.library      = 'xml2'
  s.xcconfig     = { 'HEADER_SEARCH_PATHS' => '"$(SDKROOT)/usr/include/libxml2"' }
end