//
//  DPAPI.h
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRequest.h"

#define kDPAppKey             @"975791789"
#define kDPAppSecret          @"5e4dcaf696394707b9a0139e40074ce9"

#ifndef kDPAppKey
#error
#endif

#ifndef kDPAppSecret
#error
#endif

@interface DPAPI : NSObject
+ (instancetype)sharedRequest;


- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate;

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate;
// 封装一个 通过回调Block 传数据的对象方法
- (DPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure;

@end
