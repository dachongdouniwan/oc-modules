//
//  UIWebView+loadURL.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIWebView+Load.h"

@implementation UIWebView ( Load )

- (void)loadURL:(NSString*)URLString {
    NSString *encodedUrl = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes (NULL, (__bridge CFStringRef) URLString, NULL, NULL,kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:encodedUrl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self loadRequest:req];
}

- (void)loadLocalHtml:(NSString*)htmlName {
    [self loadLocalHtml:htmlName inBundle:[NSBundle mainBundle]];
}

- (void)loadLocalHtml:(NSString*)htmlName inBundle:(NSBundle*)inBundle {
    NSString *filePath = [inBundle pathForResource:htmlName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

- (void)loadHTMLStringPartially:(NSString *)htmls {
    NSUInteger margin = 4;
//    NSUInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;
    NSString *html = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no\">"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;margin:%ldpx;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                      "<script type='text/javascript'>"
                      "window.onload = function(){\n"
                      "var $img = document.getElementsByTagName('img');\n"
                      "for(var p in  $img){\n"
                      "$img[p].style.width = '100%%';\n"
                      "$img[p].style.height ='auto';\n"
                      "}\n"
                      "}"
                      "</script>%@"

//                       "%@"
                       "</body>"
                       "</html>", margin, htmls]; // 这里的webInfo就是原始的HTML字符串。
//    self.scalesPageToFit = YES;
    [self loadHTMLString:html baseURL:nil];
}

- (void)clearCookies {
    NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    
    for (NSHTTPCookie *cookie in storage.cookies)
        [storage deleteCookie:cookie];
    
    [NSUserDefaults.standardUserDefaults synchronize];
}
@end
