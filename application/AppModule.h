//
//  AppModule.h
//  component
//
//  Created by fallen.ink on 3/25/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

// 这个类，有点废，要重新设计，module是什么的抽象，应该负责什么东西？要定义好。。。

@interface AppModule : NSObject

/**
 *  初始化数据库
 */
- (void)initDatabase;

/**
 *  初始化崩溃日志管理
 */
- (void)initFabric;
- (void)fabric_RecordError:(NSError *)error;

/**
 *  初始化网络模块
 */
- (void)initNetwork;

/**
 *  初始化一系列组件
 */
- (void)initComponent;

/**
 *  配置图片缓存
 */
- (void)initImageCache;

/**
 *  初始化键盘管理器
 */
- (void)initKeyBoardManager;

/**
 *  初始化定位服务
 */
- (void)initLocationComponent;

/**
 *  初始化远程通知
 */
- (void)initRemoteNotification;

/**
 *  初始化社交分享
 */
- (void)initSnshare;

#pragma mark -

/**
 *  清理磁盘缓存
 */
- (void)clearRecordCache;

@end
