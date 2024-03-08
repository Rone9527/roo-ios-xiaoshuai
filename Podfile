# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'RooWallet' do

 pod 'HBDNavigationBar'
pod 'AFNetworking’
pod 'SDWebImage'
pod 'MJRefresh'
pod 'MJExtension'
pod 'MBProgressHUD'
pod 'JXCategoryView'
pod  'Masonry'
pod 'IQKeyboardManager'
pod 'AvoidCrash', '~> 2.5.2'
pod 'BGFMDB'
pod 'ZWPlaceHolder'
pod 'lottie-ios', '~> 2.5.2'
   
pod 'SocketRocket'
pod 'SGQRCode', '~> 3.5.0'
pod 'CoreBitcoin', :git => 'https://github.com/singer1026/CoreBitcoin.git'
pod 'YYModel' 
pod 'Bugly'


pod 'JPush', '3.7.0' 


pod 'SDCycleScrollView'




post_install do |installer|
  installer.pods_project.targets.each do |target|
   
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end

end


end
