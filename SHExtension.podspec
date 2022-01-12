Pod::Spec.new do |s|
    s.name         = "SHExtension"
    s.version      = "1.3.9"
    s.summary      = "常用类别方法，拓展"
    s.license      = "MIT"
    s.authors      = { "CCSH" => "624089195@qq.com" }
    s.platform     = :ios, "8.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHExtension"
    s.source       = { :git => "https://github.com/CCSH/SHExtension.git", :tag => s.version }
    s.source_files = "SHExtension/*.{h,m}"

    #部分功能
    s.subspec 'NSString' do |ss|
        ss.source_files = "SHExtension/NSString+SHExtension.{h,m}"
    end

    s.subspec 'UIButton' do |ss|
        ss.source_files = "SHExtension/SHButton.{h,m}","SHExtension/UIButton+SHExtension.{h,m}"
    end

    s.subspec 'UIColor' do |ss|
        ss.source_files = "SHExtension/UIColor+SHExtension.{h,m}"
    end

    s.subspec 'UIImage' do |ss|
        ss.source_files = "SHExtension/UIImage+SHExtension.{h,m}"
    end

    s.subspec 'UIImageView' do |ss|
        ss.source_files = "SHExtension/UIImageView+SHExtension.{h,m}"
    end

    s.subspec 'UIView' do |ss|
        ss.source_files = "SHExtension/UIView+SHExtension.{h,m}"
    end
    
    s.subspec 'UIButton' do |ss|
        ss.source_files = "SHExtension/UIButton+SHExtension.{h,m}"
    end

    s.subspec 'Tool' do |ss|
        ss.source_files = "SHExtension/SHTool.{h,m}"
    end
    
    s.subspec 'Safe' do |ss|
        ss.source_files = "SHExtension/NSArray+SHExtension.{h,m}","SHExtension/NSDictionary+SHExtension.{h,m}"
    end

    s.subspec 'Exception' do |ss|
        ss.source_files = "SHExtension/SHUncaughtExceptionHandler.{h,m}"
    end

end
