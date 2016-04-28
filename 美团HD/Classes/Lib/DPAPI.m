//
//  DPAPI.m
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import "DPAPI.h"
#import "DPConstants.h"

@interface DPAPI ()<DPRequestDelegate>
{
    NSMutableSet *requests;
}
@end


@implementation DPAPI

#pragma mark -- 单例方法
static id _instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedRequest{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)init {
	self = [super init];
    if (self) {
        requests = [[NSMutableSet alloc] init];
    }
    return self;
}
// 封装的block回调
- (DPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params success:(void(^)(id result))success failure:(void(^)(NSError *error))failure{
    
    DPRequest *request = [self requestWithURL:urlString params:params delegate:self];
    
    request.success = success;
    request.failure = failure;
    
    return request;
}
// 失败的代理方法
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    DPFailure fail = request.failure;
    fail(error);
}
// 成功的代理方法
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    DPSuccess suc = request.success;
    suc(result);
}


- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate {
	if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
	NSString *fullURL = [kDPAPIDomain stringByAppendingString:url];
	
	DPRequest *_request = [DPRequest requestWithURL:fullURL
											 params:params
										   delegate:delegate];
	_request.dpapi = self;
	[requests addObject:_request];
	[_request connect];
	return _request;
}

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate {
    return [self requestWithURL:[NSString stringWithFormat:@"%@?%@", url, paramsString] params:nil delegate:delegate];

 }

- (void)requestDidFinish:(DPRequest *)request
{
    [requests removeObject:request];
    request.dpapi = nil;
}

- (void)dealloc
{
    for (DPRequest* _request in requests)
    {
        _request.dpapi = nil;
    }
}

@end
