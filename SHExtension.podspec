Pod::Spec.new do |s|
s.name         = "SHExtension"
s.version      = "1.0.0"
s.summary      = "常用方法类别"
s.license      = "MIT"
s.authors      = { "CSH" => "624089195@qq.com" }
s.platform     = :ios, "6.0"
s.requires_arc = true
s.homepage     = "https://github.com/CCSH/SHExtension"
s.source       = { :git => "https://github.com/CCSH/SHExtension.git", :tag => s.version }
s.source_files = "SHExtension/*.{h,m}"
end
