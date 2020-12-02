# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ElMohaseb Soft' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ElMohaseb Soft
  pod 'DropDown'
  pod 'IQKeyboardManagerSwift'
  pod 'YCActionSheetDatePicker'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'RappleProgressHUD'
  pod 'ProgressHUD'
  
  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
  end

end
