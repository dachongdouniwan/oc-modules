//
//  _module_x.h
//  kata
//
//  Created by fallen.ink on 22/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

/**
 *  @brief 在系统核心服务之上，进行包装
 
 *  1. service之间不允许依赖，如果依赖，则依赖方上至component
 */
#import "_service.h"
#import "_service_manager.h"

/**
 *  @brief 包含业务逻辑的组件模块
 
 *  1.
 */
#import "_component.h"
#import "_component_loader.h"

#import "_docker_protocol.h"
#import "_docker_view.h"
#import "_docker_window.h"
#import "_docker_manager.h"

//#import "_application.h"

// 有待研究
// 1. https://github.com/fallending/Modular
// 2. https://github.com/alibaba/BeeHive, 这里重要的概念，就是注解
// 3. https://github.com/wujunyang/jiaModuleDemo, 写的比较详细
// 4. https://github.com/facebook/buck
// 5. https://github.com/fulldecent/swift3-module-template, 工程工具

@interface _module_x : NSObject

@end
