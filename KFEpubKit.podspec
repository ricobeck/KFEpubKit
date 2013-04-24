Pod::Spec.new do |s|
  s.name             =  'KFSimKey'
  s.version          =  '0.0.1'
  s.license          =  { :type => 'MIT', :file => 'LICENSE.txt' }
  s.summary          =  'An Objective-C key generation and checking framework.'
  s.homepage         =  'https://pods.kf-interactive.com'
  s.author           =  { 'Rico Becker' => 'rico.becker@kf-interactive.com' }
  s.source           =  { :git => 'git@codebasehq.com:kfi/kfpods/kfsimkey.git', :tag => '0.0.1' }
  s.platform         =  :osx
  s.framework        =  'Foundation'
  s.requires_arc     =  true

  s.subspec 'Common' do |ss|
    ss.source_files     =  'KFSimKeyGen/Sources/KFIntegerConverter.{h,m}', 'KFSimKeyGen/Sources/KFSimKeyCalculator.{h,m}', 'KFSimKeyGen/Sources/models/KFSimKeyConfigModel.{h,m}', 'KFSimKeyGen/LICENSE.txt'
  end
  
  s.subspec 'KeyGen' do |ss|
    ss.source_files = 'KFSimKeyGen/Sources/KFSimKeyGenerator.{h,m}'
    ss.dependencies = 'KFSimKey/Common'
  end

  s.subspec 'KeyCheck' do |ss|
    ss.source_files = 'KFSimKeyGen/Sources/KFSimKeyCheck.{h,m}'
    ss.dependencies = 'KFSimKey/Common'
  end
  
end