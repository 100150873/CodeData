Pod::Spec.new do |s|
  s.name             = 'SFIMMapLocation'
  s.version          = '0.1.0'
  s.summary          = '丰声标准版地图组件(位置预览、地图位置选择、导航).'
  s.homepage         = 'https://fslinker.sf-express.com'
  s.license          = {
    :type => 'Copyright',
    :text => <<-LICENSE
    Copyright (c) 2019, SF-Technology Co. Ltd. All rights reserved.
    LICENSE
  }
  s.author           = { 'zengjing' => 'JingCeng@sf-express.com' }
  s.ios.deployment_target = '8.0'
  # 变量配置
  sf_source_git_url       = "http://git.sf-express.com/scm/fs-base/fs-base-ios-maplocation.git"
  sf_source_class_prefix  = "#{s.name}/#{s.name}/Classes"
  sf_source_assets_prefix = "#{s.name}/#{s.name}/Assets"
  sf_source_framework_prefix = "#{s.name}/#{s.name}/Frameworks"
  sf_branch               = "feature/V#{s.version}"
  # 资源路径 :branch分支 :tag标签 :commit提交记录
  s.source                = { :git => "#{sf_source_git_url}", :branch => "#{sf_branch}"}
  s.public_header_files   = "#{sf_source_class_prefix}/**/*.h"
  s.source_files          = "#{sf_source_class_prefix}/**/*.{h,m,mm,c,cpp}"
  s.resource_bundle       = {
    "#{s.name}" => "#{sf_source_assets_prefix}/**/*"
  }
  s.resources             = "#{sf_source_framework_prefix}/MAMapKit.framework/AMap.bundle"
  s.frameworks            = "SystemConfiguration", "CoreTelephony", "Security", "CoreLocation",  "QuartzCore", "OpenGLES", "CoreText", "CoreGraphics", "GLKit", "ExternalAccessory"
  s.libraries             = "z", "c++"
  s.vendored_frameworks   = "#{sf_source_framework_prefix}/**/*.framework"
  s.dependency "SFIMUIKit/Library"
  s.dependency "SFIMUIKit/HUD"
  # 引用静态库文件 s.vendored_libraries = "#{sf_source_class_prefix}/Libraries/**/*.a"
  # 引用的Framework文件 s.vendored_frameworks = "#{sf_source_class_prefix}/Frameworks/**/*.framework"
  # 依赖系统的Framework s.frameworks = 'UIKit', 'MapKit'
  # 资源文件 s.resource = "#{sf_source_assets_prefix}/#{s.name}.bundle"
  # 添加依赖库 s.dependency 'SFIMFoundation'
end
