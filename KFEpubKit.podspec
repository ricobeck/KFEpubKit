Pod::Spec.new do |s|
  s.name             =  'KFEpubKit'
  s.version          =  '0.0.5'
  s.license          =  { :type => 'MIT', :file => 'LICENSE.txt' }
  s.summary          =  'An Objective-C epub extracting and parsing framework for OSX and iOS.'
  s.homepage         =  'https://pods.kf-interactive.com'
  s.author           =  { 'Rico Becker' => 'rico.becker@kf-interactive.com' }
  s.source           =  { :git => 'https://github.com/ricobeck/KFEpubKit.git', :tag => s.version.to_s }
  s.framework        =  'Foundation'
  s.requires_arc     =  true
  s.source_files     =  'KFEpubKit/Sources/*.{h,m}', 'KFEpubKit/LICENSE.txt'
  s.dependency 'SSZipArchive'
end