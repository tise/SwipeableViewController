Pod::Spec.new do |s|
s.name             = 'SwipeableViewController'
s.version          = '0.1.2'
s.summary          = 'A small UI component to build UIPageViewController-y views in your app.'

s.description      = <<-DESC
A segmented header and a UIPageViewController all in one convenient package.
DESC

s.homepage         = 'https://github.com/tiseoslo/SwipeableViewController'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Oscar Apeland' => 'oscar@tiseit.com' }
s.source           = { :git => 'https://github.com/tiseoslo/SwipeableViewController.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'
s.source_files = 'SwipeableViewController/Source/*.{swift,xib}'

end
