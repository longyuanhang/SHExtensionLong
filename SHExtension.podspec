Pod::Spec.new do |s|
    s.name         = "SHExtension"
    s.version      = "1.1.1"
    s.summary      = "常用类别方法，拓展"
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "6.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHExtension"
    s.source       = { :git => "https://github.com/CCSH/SHExtension.git", :tag => s.version }
    s.source_files = "SHExtension/*.{h,m}"

    #部分功能
    s.subspec 'NSString' do |ns|
        ns.source_files = "SHExtension/NSString+SHExtension.{h,m}"
    end

    s.subspec 'UIButton' do |btn|
        btn.source_files = "SHExtension/UIButton+SHExtension.{h,m}"
    end

    s.subspec 'UIColor' do |color|
        color.source_files = "SHExtension/UIColor+SHExtension.{h,m}"
    end

    s.subspec 'UIImage' do |img|
        img.source_files = "SHExtension/UIImage+SHExtension.{h,m}"
    end

    s.subspec 'UIImageView' do |imgv|
        imgv.source_files = "SHExtension/UIImageView+SHExtension.{h,m}"
    end

    s.subspec 'UIView' do |view|
        view.source_files = "SHExtension/UIView+SHExtension.{h,m}"
    end

    s.subspec 'Tool' do |tool|
        tool.source_files = "SHExtension/SHTool.{h,m}"
    end

end
