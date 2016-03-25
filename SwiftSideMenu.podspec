#
#  Be sure to run `pod spec lint SwiftSideMenu.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SwiftSideMenu"
  s.version      = "0.0.4"
  s.summary      = "UI library for iOS in swift."
  s.description  = <<-DESC
  UI Library to make side menu that is written in swift. configuration is able to edit on storyboard.
                   DESC
  s.homepage     = "https://github.com/guccyon/SwiftSideMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = "Tetsuro Higuchi"
  s.social_media_url   = "http://twitter.com/guccyon"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/guccyon/SwiftSideMenu.git", :tag => "#{s.version}" }
  s.source_files  = "SwiftSideMenu/**/*.{swift,h}"
  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
end
