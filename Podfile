# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Caryta Messenger' do

  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  
  use_frameworks!

  # Pods for Caryta Messenger

  pod 'Alamofire'
  pod 'Auk'
  pod 'ChameleonFramework/Swift'
  pod 'DropDown'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'ImagePicker'
  pod 'MapleBacon'
  pod 'NAExpandableTableController’
  pod 'RealmSwift'
  pod 'SwiftyJSON'
  pod 'Toaster'
  pod 'VisualHumainNumber'
  pod 'XMSegmentedControl'
  pod 'Zip'
  pod 'moa'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

  target 'Caryta MessengerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Caryta MessengerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
