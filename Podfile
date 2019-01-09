platform :ios, '12.0'

project 'NewsFeed'

use_frameworks!
inhibit_all_warnings!
install! 'cocoapods', :deterministic_uuids => false

def system_pods
    pod 'SwiftLint', '0.27.0'
end

def specs_pods
    pod 'Quick', '~> 1.3.2'
    pod 'Nimble', '~> 7.3.1'
end

def shared_pods
    pod 'Moya', '~> 11.0'
    pod 'PromiseKit', '~> 6.0'
    pod 'RealmSwift', '~> 3.11'
end

target 'NewsFeed' do
    system_pods
    shared_pods
    pod 'Swinject', '2.5.0'
    pod 'ReachabilitySwift', '4.3.0'
    pod 'SVProgressHUD', '2.2.5'
    pod 'Moya', '~> 11.0'
    pod 'SDWebImage', '~> 4.4.2'
end

target 'NewsFeedTests' do
    system_pods
    specs_pods
    shared_pods
    inherit! :search_paths
end
