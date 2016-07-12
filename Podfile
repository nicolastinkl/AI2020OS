source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

inhibit_all_warnings!


# SYSTEM OPATIONS

use_frameworks!

def aiveris_pods
    
    # HTTP-NET-ENGINE
    
    pod 'Alamofire', '~> 3.1.4'
    
    # JSON TOOL
    
    pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
    
    # UI/UX
    
    pod 'Spring', :git => 'https://github.com/asiainfomobile/Spring.git', :branch => 'swift2'
    
    pod 'Cartography', '~> 0.6.0'
    
    pod 'SnapKit', '~> 0.18.0'
    
    pod 'AIAlertView', :git => 'https://github.com/asiainfomobile/AIAlertView.git'
    
    pod 'YYImage', '~> 1.0.1'
    
    # iOS Debug
    
    pod 'IQKeyboardManagerSwift'
    
    pod 'SVProgressHUD', '~> 1.0'

    pod 'UMengSocialCOM', '~> 5.2.1'
    
end

target 'AIVeris' do
    aiveris_pods
end

target 'VerisTests' do
    aiveris_pods
end
