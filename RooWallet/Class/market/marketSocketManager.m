//
//  marketSocketManager.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//


#import "marketSocketManager.h"
#import "SRWebSocket.h"
@interface marketSocketManager ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;

@property (nonatomic,assign)FLSocketStatus fl_socketStatus;

@property (nonatomic,weak)NSTimer *timer;
@property (nonatomic,weak)NSTimer * heartBeat;
@property (nonatomic,copy)NSString *urlString;

@end

@implementation marketSocketManager{
    NSInteger _reconnectCounter;
}


+ (instancetype)shareManager{
    static marketSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 10;
    });
    return instance;
}

- (void)fl_open:(NSString *)urlStr connect:(FLSocketDidConnectBlock)connect receive:(FLSocketDidReceiveBlock)receive failure:(FLSocketDidFailBlock)failure{
    [marketSocketManager shareManager].connect = connect;
    [marketSocketManager shareManager].receive = receive;
    [marketSocketManager shareManager].failure = failure;
    [self fl_open:urlStr];
}

- (void)fl_close:(FLSocketDidCloseBlock)close{
    [marketSocketManager shareManager].close = close;
    [self fl_close];
}

// Send a UTF8 String or Data.
- (void)fl_send:(id)data{
    switch ([marketSocketManager shareManager].fl_socketStatus) {
        case FLSocketStatusConnected:
        case FLSocketStatusReceived:{
            NSLog(@"发送中。。。");
            [self.webSocket send:data];
            break;
        }
        case FLSocketStatusFailed:
            NSLog(@"发送失败");
            break;
        case FLSocketStatusClosedByServer:
            [self.webSocket send:data];
             [self fl_reconnect];
            NSLog(@"已经关闭Market");
            break;
        case FLSocketStatusClosedByUser:
            NSLog(@"已经关闭");
            break;
    }
    
}

#pragma mark -- private method
- (void)fl_open:(id)params{
    //    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [marketSocketManager shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    self.webSocket.requestCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    [self.webSocket open];
}

- (void)fl_close{
    
    [self.webSocket close];
    self.webSocket.delegate = nil;
    [self destoryHeartBeat];
    self.webSocket = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    [_heartBeat invalidate];
    _heartBeat=nil;
    
    
}


- (void)fl_reconnect{
    
    [self destoryHeartBeat];
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(fl_open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else{
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    
}
- (void)initHeartBeat
{
    WeakSelf;
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        NSTimer*timer= [NSTimer timerWithTimeInterval:15 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        weakSelf.heartBeat=timer;
    })
}
-(void)sentheart{
    //    MYLog(@"C2C");
    NSDictionary*dic=@{@"cmd":@"ping"};
    NSString*data=[dic mj_JSONString];
    [self sendData:data];
}
- (void)sendData:(id)data {
    //    NSLog(@"socketSendData --------------- %@",data);
    
    WeakSelf;
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    
    dispatch_async(queue, ^{
        if (weakSelf.webSocket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.webSocket.readyState == SR_OPEN) {
                
                [weakSelf.webSocket send:data];    // 发送数据
                
            } else if (weakSelf.webSocket.readyState == SR_CONNECTING) {
                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                // 代码有点长，我就写个逻辑在这里好了
                [self fl_reconnect];
                
            } else if (weakSelf.webSocket.readyState == SR_CLOSING || weakSelf.webSocket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                
                //                NSLog(@"重连1111");
                
                [self fl_reconnect];
            }
        } else {
            //            NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
            //            NSLog(@"其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网");
        }
    });
}
//取消心跳
- (void)destoryHeartBeat
{
    WeakSelf;
    dispatch_main_async_safe(^{
        if (weakSelf.heartBeat) {
            if ([weakSelf.heartBeat respondsToSelector:@selector(isValid)]){
                if ([weakSelf.heartBeat isValid]){
                    [weakSelf.heartBeat invalidate];
                    weakSelf.heartBeat = nil;
                }
            }
        }
    })
}
#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    
    [marketSocketManager shareManager].connect ? [marketSocketManager shareManager].connect() : nil;
    [marketSocketManager shareManager].fl_socketStatus = FLSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
    [self initHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    //    NSLog(@":( Websocket Failed With Error %@", error);
    [marketSocketManager shareManager].fl_socketStatus = FLSocketStatusFailed;
    [marketSocketManager shareManager].failure ? [marketSocketManager shareManager].failure(error) : nil;
    // 重连
    [self fl_reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    //    NSLog(@":( Websocket Receive With message %@", message);
    [marketSocketManager shareManager].fl_socketStatus = FLSocketStatusReceived;
    [marketSocketManager shareManager].receive ? [marketSocketManager shareManager].receive(message,FLSocketReceiveTypeForMessage) : nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);
    if (reason) {
        [marketSocketManager shareManager].fl_socketStatus = FLSocketStatusClosedByServer;
        // 重连
        [self fl_reconnect];
    }
    else{
        [marketSocketManager shareManager].fl_socketStatus = FLSocketStatusClosedByUser;
    }
    [marketSocketManager shareManager].close ? [marketSocketManager shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [marketSocketManager shareManager].receive ? [marketSocketManager shareManager].receive(pongPayload,FLSocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    // Close WebSocket
    [self fl_close];
}


@end



