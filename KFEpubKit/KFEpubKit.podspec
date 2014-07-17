Pod::Spec.new do |s|
  s.name             =  'KFEpubKit'
  s.version          =  '0.0.2'
  s.license          =  { :type => 'MIT', :file => 'LICENSE.txt' }
  s.summary          =  'An Objective-C epub extracting and parsing framework.'
  s.homepage         =  'https://pods.kf-interactive.com'
  s.author           =  { 'Rico Becker' => 'rico.becker@kf-interactive.com' }
  s.source           =  { :git => 'git@codebasehq.com:kfi/kfpods/kfepubkit.git', :tag => '0.0.2' }
  s.platform         =  :osx, 10.7
  s.framework        =  'Foundation'
  s.requires_arc     =  true
  s.source_files     =  'KFEpubKit/Sources/*.{h,m}', 'KFEpubKit/LICENSE.txt', 'KFEpubKit/'
  s.dependency 'SSZipArchive'
end