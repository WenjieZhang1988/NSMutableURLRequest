//
//  NSMutableURLRequest+Multipart.m
//  Frame
//
//  Created by Kevin on 13/1/14.
//  Copyright (c) 2012年 Kevin. All rights reserved.
//

#import "NSMutableURLRequest+Multipart.h"

/** boundary 变量是保存在静态区，只有一个副本，字符串内容是保存在常量区的 */
static NSString *boundary = @"heimaupload";
/** userfile 是提交给服务器的脚本中的字段，可以咨询后台程序员，或者用 firebug 拦截 */
static NSString *serverField = @"userfile";

@implementation NSMutableURLRequest (Multipart)

+ (instancetype)requestWithURL:(NSURL *)URL fileName:(NSString *)fileName localFilePath:(NSString *)localFilePath {
    // 2.requets
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:0 timeoutInterval:15.0f];
    
    // 请求方式
    request.HTTPMethod = @"POST";
    
    /**
     设置上传数据的格式：以下内容是在 iOS 中，如果要上传文件，需要拼接的数据格式！
     
     \n--同上\n
     Content-Disposition: form-data; name="userfile"; filename="demo.html" \n
     Content-Type: text/html \n\n
     
     // 要上传文件的二进制数据
     
     \n\n--同上--\n
     */
    
    // 生成请求体的二进制数据
    NSMutableData *data = [NSMutableData data];
    // 2.1. \n--同上\n
    NSString *bodyStr = [NSString stringWithFormat:@"\n--%@\n", boundary];
    [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2.2. Content-Disposition: form-data; name="userfile"; filename="demo.html" \n
    bodyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \n", serverField, fileName];
    [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2.3 Content-Type: text/html \n\n
    bodyStr = @"Content-Type: application/stream\n\n";;
    [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2.4 追加要上传文件的二进制数据
    NSString *loaclfilePath = [[NSBundle mainBundle] pathForResource:@"demo.jpg" ofType:nil];
    [data appendData:[NSData dataWithContentsOfFile:loaclfilePath]];
    
    // 2.5 \n\n--同上--\n
    bodyStr = [NSString stringWithFormat:@"\n--%@--\n", boundary];
    [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置HTTP的请求题
    request.HTTPBody = data;
    
    // 2.6 告诉服务器客户端要上传文件！要告诉服务器的附加信息，都是通过这个方法 forHTTPHeaderField
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

@end
