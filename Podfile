# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
target 'BDsoSharpenImage' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BDsoSharpenImage
  pod 'LookinServer', :configurations => ['Debug']
  pod 'SnapKit'
  pod 'KRProgressHUD'
  pod 'SwifterSwift'
  pod 'SwiftyStoreKit'
  pod 'TPInAppReceipt'
  pod 'SwiftyJSON'
  pod 'Moya'
  pod 'MoyaSugar'
  pod 'Alamofire'
  pod 'DeviceKit'
  pod 'LGSideMenuController'
  pod 'ScalingCarousel'
  pod 'EllipsePageControl'
  pod 'SwiftyTimer'
  pod "TLPhotoPicker"
#  pod 'TenjinSDK'
end
