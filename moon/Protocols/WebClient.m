//
//  WebClient.m
//  HomeSearch
//
//  Created by Jack chen on 12/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WebClient.h"
#import "Configure.h"
#import "SvUDIDTools.h"


@implementation WebClient

@synthesize _requestParam;
@synthesize _method;
@synthesize statues_code;
@synthesize _httpMethod;

@synthesize _failBlock;
@synthesize _successBlock;
@synthesize _progressBlock;

@synthesize _body;

- (id)initWithDelegate:(id)aDelegate {
	if((self = [super init]))
	{
		// Store reference to delegate
		//delegate = aDelegate;
		
		_httpAdmin = [[iHttpAdmin alloc] init];
		_httpAdmin.delegate_ = self;
		
		_method = nil;
		
	}
	return self;
}

- (void) releaseDelegate{
	delegate = nil;
	_httpAdmin.delegate_ = nil;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Request Managment
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)requestBodyWithSusessBlock:(RequestBlock) susessBlock FailBlock:(RequestBlock)failBlock{
    
    
    self._successBlock = susessBlock;
    self._failBlock = failBlock;
    
	if(_method==nil)_method=@"";
	
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_requestParam];
    [dic removeObjectForKey:@"method"];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    [dic setObject:[SvUDIDTools UDID] forKey:@"device_id"];
    [dic setObject:version forKey:@"app_ver"];
    [dic setObject:device.systemVersion forKey:@"ios_ver"];
    [dic setObject:device.model forKey:@"model"];
    
    
    NSString *rootApi = WEB_API_URL;
	NSString *url = [NSString stringWithFormat:@"%@%@", rootApi, _method];
	
	NSString *baseUrl = [dic objectForKey:@"baseUrl"];
	if(baseUrl){
		url = [NSString stringWithFormat:@"%@", baseUrl];
		[dic removeObjectForKey:@"baseUrl"];
	}
	
    [_httpAdmin postUrlRequestWithBody:url body:_body];
    
}

- (void)requestWithSusessBlock:(RequestBlock) susessBlock FailBlock:(RequestBlock)failBlock{
    
    self._successBlock = susessBlock;
    self._failBlock = failBlock;
    
	if(_method==nil)_method=@"";
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_requestParam];
	[dic removeObjectForKey:@"method"];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    
    [dic setObject:[SvUDIDTools UDID] forKey:@"device_id"];
    
    [dic setObject:version forKey:@"app_ver"];
    [dic setObject:device.systemVersion forKey:@"ios_ver"];
    [dic setObject:device.model forKey:@"model"];
    
    
    NSString *rootApi = WEB_API_URL;
	NSString *url = [NSString stringWithFormat:@"%@%@", rootApi, _method];
	
	NSString *baseUrl = [dic objectForKey:@"baseUrl"];
	if(baseUrl){
		url = [NSString stringWithFormat:@"%@", baseUrl];
		[dic removeObjectForKey:@"baseUrl"];
	}
	
    if([_httpMethod isEqualToString:@"POST"])
        [_httpAdmin postUrlRequest:url param:dic];
    else
        [_httpAdmin sendUrlRequest:url param:dic];
    
}



- (void)requestDealersWithInfo:(NSDictionary*)info{
	self._method = @"dealers";
	
	return;
	
	
}


- (void)postImageWithInfo:(NSDictionary*)info{
    self._method = [info objectForKey:@"method"];
	
	if(_method==nil)_method=@"";
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
	[dic removeObjectForKey:@"method"];
	
    NSString *rootApi = WEB_API_URL;
	NSString *url = [NSString stringWithFormat:@"%@", rootApi];
	
	NSString *baseUrl = [info objectForKey:@"baseUrl"];
	if(baseUrl){
		url = [NSString stringWithFormat:@"%@", baseUrl];
        [dic removeObjectForKey:@"baseUrl"];
	}
	[_httpAdmin postPhotoWithUrlRequest:url param:dic];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark AsyncSocket Delegate Methods:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) didReceiveStringData:(NSString*)resultString{
	
    
    if(_httpAdmin._httpStatusCode == 500)
    {
        NSString *code = @"\"code\":4102";
        
        NSRange r = [resultString rangeOfString:code];
        if(r.location != NSNotFound)
        {
            
            //Over，退出到登录
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Device_ID_Error" object:nil];
        }
    }

    
    
    if(_successBlock)
    {
        _successBlock(resultString, self);
    }
	
}

- (void) didLoadingPerProgress:(id)object progress:(float)progress
{
    
    if(_progressBlock)
    {
        _progressBlock([NSNumber numberWithFloat:progress], self);
    }
    
    
    
}

- (void)sendMessage:(id)sender didFailWithError:(NSString*)error{
	//[self onDidReceiveError:error];
    
    if(_failBlock)
    {
        _failBlock(error, self);
    }
    
}

- (void)dealloc {
	
	delegate = nil;
	_httpAdmin.delegate_ = nil;
	
}
@end
