




#import "WebServiceEngine.h"

#import "BaseRequest.h"


#define kRequestTimeOutTime 30
#define kRequestError_Str @"请求出错"


@implementation WebServiceEngine

static WebServiceEngine *_sharedEngine = nil;

- (void)AFAsynRequest:(BaseRequest *)req
{
    if (!req)
    {
        return ;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *urlStr = [req url];
        NSData *postData = [req toPostJsonData];
        
        if (urlStr == nil || urlStr.length < 1)
        {
            NSLog(@"[%@]请求出错了", [req class]);
            return ;
        }
        
        NSLog(@"request url = %@", urlStr);
        
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (postData)
        {
            [manger POST:urlStr parameters:postData progress:^(NSProgress * _Nonnull uploadProgress) {
                
                NSLog(@">>>>>>>>>>>>>uploadProgress is %.2f", uploadProgress.completedUnitCount / (float)(uploadProgress.totalUnitCount));
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                

                if (![NSJSONSerialization isValidJSONObject:responseObject])
                {
                    TCILDebugLog(@"sxbparse fail --> %@",responseObject);
                    NSLog(@"请求出错");
                    if (req.failHandler)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            req.response.errorCode = -1;
                            req.response.errorInfo = @"返回数据非Json格式";
                            req.failHandler(req);
                        });
                    }
                }
                else    // 请求数据成功
                {
                    NSError *parseError;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
                    
                    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    TCILDebugLog(@"sxbparse responseString--> %@",responseString);
                    NSLog(@"[%@] request's responseString is :\n================================\n %@ \n================================" , [req class], responseString);
                    //TODO
                    if (responseObject)
                    {
                        TCILDebugLog(@"sxbparse --> %@",responseObject);
                        [req parseResponse:responseObject];
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (error)
                {
                    NSLog(@"Request = %@, Error = %@", req, error);
                    
                    if (req.failHandler)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            req.failHandler(req);
                        });
                    }
                }
                
            }];
        }
        
    });
    
    
    
}

- (void)asyncRequest:(BaseRequest *)req
{
    [self asyncRequest:req wait:YES];
}

- (void)asyncRequest:(BaseRequest *)req wait:(BOOL)wait
{
    [self asyncRequest:req loadingMessage:nil wait:wait];
}


+ (instancetype)sharedEngine
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedEngine = [[WebServiceEngine alloc] init];
    });
    return _sharedEngine;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _sharedSession = [NSURLSession sharedSession];
    }
    return self;
}


- (void)asyncRequest:(BaseRequest *)req loadingMessage:(NSString *)msg wait:(BOOL)wait
{
    
    if (!req)
    {
        return ;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *url = [req url];
        NSData *data = [req toPostJsonData];
        
        if (url == nil || url.length < 1)
        {
            NSLog(@"[%@]请求出错了", [req class]);
            return;
        }
        
        NSLog(@"reqest url = %@", url);
    
        NSURL *URL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        
        if (data)
        {
            [request setValue:[NSString stringWithFormat:@"%ld",(long)[data length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            [request setHTTPBody:data];        
        }
        
        [request setTimeoutInterval:kRequestTimeOutTime];
        
        if (wait)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
            });
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        
        NSURLSessionDataTask *task = [_sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (wait)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [[HUDHelper sharedInstance] syncStopLoading];
                });
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (error != nil)
            {
                NSLog(@"Request = %@, Error = %@", req, error);
                
                
                if (req.failHandler)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        req.failHandler(req);
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[HUDHelper sharedInstance] tipMessage:kRequestError_Str];
                    });
                }
            }
            else
            {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TCILDebugLog(@"sxbparse responseString--> %@",responseString);
                NSLog(@"[%@] request's responseString is :\n================================\n %@ \n================================" , [req class], responseString);
                //TODO
                NSObject *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                if (jsonObj)
                {
                    TCILDebugLog(@"sxbparse --> %@",jsonObj);
                    [req parseResponse:jsonObj];
                }
                else
                {
                    TCILDebugLog(@"sxbparse fail --> %@",jsonObj);
                    NSLog(@"请求出错");
                    if (req.failHandler)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            req.response.errorCode = -1;
                            req.response.errorInfo = @"返回数据非Json格式";
                            req.failHandler(req);
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [[HUDHelper sharedInstance] tipMessage:kRequestError_Str];
                        });
                    }
                }
            }
        }];
        
        [task resume];
    });
}

@end

