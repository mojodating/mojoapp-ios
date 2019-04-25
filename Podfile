# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

target 'mojo_test' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

   # Pods for mojo_test

pod 'Firebase/Firestore', '~>5.10.0'
pod 'Firebase/Auth','~>5.10.0'
pod 'Firebase/Storage','~>5.10.0'
pod 'Firebase/Core'
pod 'Firebase/Functions'
pod 'Firebase/Messaging'
pod 'SDWebImage','~>4.4.2'
pod 'JGProgressHUD','~>2.0.3'
pod 'GoogleAppMeasurement', '~> 5.2.0'
pod 'Cosmos', '~> 18.0'
pod 'TinyConstraints'

end
