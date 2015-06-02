#
# Be sure to run `pod lib lint TXViewKeyboardResizer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TXViewKeyboardResizer"
  s.version          = "0.9.0"
  s.summary          = "UIView category to allow the target view to resize itself according to UIKeyboardView size"
  s.description      = <<-DESC

# TXViewKeyboardResizer

It automatically resizes you UIView when keyboard appears.

It can be used with any kind of UIViews.

If your view extends a UIScrollView, you need to adjust your UIScrollView.contentSize.

## Usage

First, choose the UIView that is going to be resized when keyboards appears.

![Controller](https://github.com/rtoshiro/TXViewKeyboardResizer/blob/master/readme/01.png)

Then, you need to check your Autolayout configuration or Autoresize values.

Here, i am going to use Autoresize as it is a little bit easier in that case.

![Autoresize](https://github.com/rtoshiro/TXViewKeyboardResizer/blob/master/readme/02.png)

With autoresize configured, when UIView resizes, our UITextField is positioned automaticaly.

Now we can call startKeyboardObserver(WithDelegate:) inside our UIViewController:

```
- (void)viewDidLoad
{
[super viewDidLoad];

[self.scrollView startKeyboardObserverWithDelegate:self];
}
```
We must remember stop observing when we are done with keyboard:

```
- (void)viewWillDisappear:(BOOL)animated
{
[super viewWillDisappear:animated];

[self.scrollView stopKeyboardObserver];
}
```

## Delegate

And then, you can adjust your view per need:

```
- (void)viewWillResize:(UIView *)view;
- (void)viewDidResize:(UIView *)view;
- (void)viewDidTap:(UIView *)view;
```

We can close the keyboard, for example:

```
- (void)viewDidTap:(UIView *)view
{
for (UIView *subview in self.scrollView.subviews)
{
if ([subview isMemberOfClass:[UITextField class]])
[((UITextField *)subview) resignFirstResponder];
}
}
```

![Resize](https://github.com/rtoshiro/TXViewKeyboardResizer/blob/master/readme/01.gif)



## Requirements

iOS 6.+

## Installation

TXViewKeyboardResizer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TXViewKeyboardResizer"
```

## License

TXViewKeyboardResizer is available under the MIT license. See the LICENSE file for more info.

                       DESC
  s.homepage         = "https://github.com/rtoshiro/TXViewKeyboardResizer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "rtoshiro" => "rtoshiro@gmail.com" }
  s.source           = { :git => "https://github.com/rtoshiro/TXViewKeyboardResizer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TXViewKeyboardResizer' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
