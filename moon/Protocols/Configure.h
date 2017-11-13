//
//  Configure.h
//  HomeSearch
//
//  Created by Jack chen on 12/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define POSTDataSeparator			@"----------sadkfjaskdjfkjsadfjj3234234"

#define WEB_API_URL		@"http://cma.sibiscorp.com"//


//max_id=0
#define API_LOGIN               @"/api/v1/auth/signin"
#define API_VIDEO_LISTING       @"/api/v1/video/listing"

#define API_CHECK_UPDATE        @"/api/v1/mazda/car/show"
#define API_CAR_PARAM           @"/api/v2/car"

#define API_REGISTER_DEVICE     @"/api/v1/device/register"
#define API_CMA_CAR             @"/api/v1/mazda/car"

#define API_CAR_LISTING         @"/api/v1/car/listing"

#define API_PR_VERSION          @"/api/v1/mazda"

///精品加装
#define API_JP_ASSETS           @"/api/v1/accessory/listing"

///培训素材
#define API_BOOK_ASSETS         @"/api/v1/material/listing"

///新闻
#define API_NEWS_ASSETS         @"/api/v1/news/listing"

///培训素材
#define API_SURVEY_ASSETS        @"/api/v1/survey/listing"
#define API_SURVEY_CONTENT       @"/api/v1/survey/"

#define API_ASSISTANT_INFO       @"/api/v1/assistant/info"

#define API_EVENT_F              @"/api/v1/coupon/listing"

#define API_FEEDBACK             @"/api/v1/material/feedback"

#define API_SURVEY_SUBMIT        @"/api/v1/survey/"

#define API_UPDATE_LOG           @"/api/v1/mazda/car/updatelog"

#define API_MATERIAL_LOG         @"/api/v1/stats/material"
#define API_DEMO_LOG             @"/api/v1/stats/demo"
#define API_VIDEO_LOG            @"/api/v1/stats/video"

/*
 1: 视频
 2: 车型展示
 3: CX－5
 4: Axela
 5: 车型对比
 6: 购车助手
 7: 培训学习
 8: 调查问卷
 9: 新闻
 10: 精品加装
 */
#define API_USING_LOG            @"/api/v1/stats/module"

#define API_CMA_OTHER_CARS       @"/api/v1/mazda/cmacar/listing"


#define API_BOOK_USING_LOG            @"/api/v1/stats/duration"

typedef void(^RequestBlock)(id lParam,id rParam);


#define   HOME_LIST_CELL_COLOR   [UIColor colorWithRed:0xe1/255.0 green:0xe1/255.0 blue:0xe1/255.0 alpha:1.0]
#define   ASK_ANSWER_CELL_COLOR  [UIColor colorWithRed:0xee/255.0 green:0xf3/255.0 blue:0xf6/255.0 alpha:1.0]
#define   REPLY_CELL_COLOR       [UIColor colorWithRed:199.0/255.0 green:202.0/255.0 blue:204.0/255.0 alpha:1.0]


#define   DRAG_OFF_SET		70

#import <CommonCrypto/CommonDigest.h>


static inline NSString *md5Encode( NSString *str ) {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *string = [NSString stringWithFormat:
						@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
						result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
						result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
						];
    return [string lowercaseString];
}


//EEE MMM dd HH:mm:ss z yyyy
static inline NSDate* nsstringToNSDate(NSString *datestring)
{
	NSString *tmpdateString = datestring;
		
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// set default time zone by device own zone.
	[formatter setTimeZone:[NSTimeZone defaultTimeZone]];
	
	// convert the time keep on 24-hour
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
	[formatter setLocale:usLocale];

	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [formatter dateFromString:tmpdateString];

	return date;
}

static inline BOOL dayDiff(NSDate* today, NSDate* other)
{
	int iToday = 0;
	int iOther = 0;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd"];
	iToday = [[formatter stringFromDate:today] intValue];
	iOther = [[formatter stringFromDate:other] intValue];

	return iToday == iOther;
}

//~!@#$%^&*()_-+=\/?.,<>
static inline BOOL checkPassword(int minLength, int maxLength, NSString* text)
{
	//33-47
	//58-64
	//91-96
	//123-126
	//65－90 A-Z
	//97-122  a-z
	//48-57 0-9
	
	if([text length] < minLength || [text length] > maxLength){
		return NO;
	}
	const char* ch = [text UTF8String];
	
	for(int i = 0; i < [text length]; i++){
		
		int chv = ch[i];
		
		if(chv>=33 && chv<=126)
		{
			continue;
		}
		else 
		{
			return NO;
		}

	}
	
	return YES;
}

static inline BOOL checkAccount(int minLength, int maxLength, NSString* text)
{
	//65－90 A-Z
	//97-122  a-z
	//48-57 0-9
	if([text length] < minLength || [text length] > maxLength){
		return NO;
	}
	const char* ch = [text UTF8String];
	
	for(int i = 0; i < [text length]; i++){
	
		char c = ch[i];
		if( (c >= '0' && c <= '9') || (c>='a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_')
		{
			continue;
		}
		else 
		{
			return NO;
		}

	}
	
	return YES;
}



//////////////// create form data //////////////////////
static inline NSMutableData* internalPreparePOSTData(NSDictionary*param, BOOL endmark) {
    NSMutableData *data=[NSMutableData data];
    
    NSArray *keys=[param allKeys];
    unsigned i, c=[keys count];
    for (i=0; i<c; i++) {
		NSString *k=[keys objectAtIndex:i];
		NSString *v=[param objectForKey:k];
		
		NSString *addstr = [NSString stringWithFormat:
							@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
							POSTDataSeparator, k, v];
		[data appendData:[addstr dataUsingEncoding:NSUTF8StringEncoding]];
    }
	
    if (endmark) {
		NSString *ending = [NSString stringWithFormat: @"--%@--", POSTDataSeparator];
		[data appendData:[ending dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return data;
}

typedef enum{
	PULLREFRESHPULLING,
	PULLREFRESHNORMAL,
	PULLREFRESHLOADING,	
} PullRefreshState;


