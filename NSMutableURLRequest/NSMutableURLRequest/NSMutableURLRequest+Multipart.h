//
//  NSMutableURLRequest+Multipart.h
//  Frame
//
//  Created by Kevin on 13/1/14.
//  Copyright (c) 2012年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Multipart)

/**
 *  生成上传文件的请求
 *
 *  @param URL           负责上传文件的脚本路径
 *  @param fileName      保存到服务器上的文件名
 *  @param localFilePath 本地要上传文件的全路径
 *
 *  @return 生成好的请求
 */
+ (instancetype)requestWithURL:(NSURL *)URL fileName:(NSString *)fileName localFilePath:(NSString *)localFilePath;

@end
