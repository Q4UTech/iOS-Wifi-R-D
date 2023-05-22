# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
def shared_pods
  use_frameworks!
  pod 'OpenVPNAdapter', :git => 'https://github.com/deneraraujo/OpenVPNAdapter.git'
end
target 'WiFiProvider' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WiFiProvider
  pod "PlainPing"
  pod 'lottie-ios'
  pod 'Alamofire', '~> 4.0'
  pod 'CryptoSwift', '~> 1.0'
  pod 'Toast-Swift'
  pod 'WMGaugeView'
  pod 'MASegmentedControl'
  pod 'SDWebImage', '~> 4.0'
  pod 'Charts'
  pod 'HGRippleRadarView'
  end

  target 'TunnelProvider' do
    shared_pods
end
