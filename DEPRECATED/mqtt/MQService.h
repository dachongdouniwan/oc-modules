//
//  MessageService.h
// fallen.ink
//
//  Created by 李杰 on 2/9/15.
//

#import "_greats.h"

#undef NOTIF_NAME_MQTT
#define NOTIF_NAME_MQTT( __command_id_ ) ([NSString stringWithFormat:@"Notification.Mqtt.%ld", (long)__command_id_])

@protocol MQTTServiceDelegate;

@interface MQService : NSObject <
    MQTTSessionDelegate
>

@property (nonatomic, weak) id <MQTTServiceDelegate> delegate;

@property (atomic, assign)  BOOL isAlive;
@property (atomic, assign)  BOOL isSubscribe;

@property (atomic, assign) BOOL mqttConfigRequesting;
@property (atomic, assign) BOOL mqttIsConnecting;

@singleton( MQService )

- (void)patchReconnect;
- (void)patchConnect;
- (void)patchDisconnect;
- (void)unpackSubscribes;

@end

@protocol MQTTServiceDelegate <NSObject>

- (void)MQTTService:(MQService *)service didConnected:(BOOL)isConnected;

- (void)MQTTService:(MQService *)service didDisconnected:(BOOL)isDisconnected;

- (void)MQTTService:(MQService *)service didReceiveMessage:(NSDictionary *)messageDictionary;

- (BOOL)isUserLogined;

@optional // 待实现

@end
