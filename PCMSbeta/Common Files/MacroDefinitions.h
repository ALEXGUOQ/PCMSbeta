//
//  MacroDefinitions.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-8.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

/**
 *  通用宏定义文件
 */
#ifndef PCMSbeta_MacroDefinitions_h
#define PCMSbeta_MacroDefinitions_h

#define RGBColorMake(_R_,_G_,_B_,_alpha_) [UIColor colorWithRed:_R_/255.0 green:_G_/255.0 blue:_B_/255.0 alpha:_alpha_]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MANAGED_OBJECT_CONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define HOST_IP                         @"59.53.87.12:8080"
#define STEP_PATH                       @"sale-manage/StepServlet"
#define LOGIN_PATH                      @"sale-manage/UserServlet"
#define SIGNIN_PATH                     @"sale-manage/TaskServlet?method=sign"
#define ACHIEVE_PATH                    @"sale-manage/AchievementServlet"
#define ORDERFORM_PATH                  @"sale-manage/OrderFormServlet"
#define CLIENT_TABLE_NAME               @"t_a_client"
#define AGENT_TABLE_NAME                @"t_a_agent"
#define AGENT_USER_TABLE_NAME           @"t_a_agent_user"
#define CLIENT_ROOM_TABLE_NAME          @"t_a_client_room"
#define CLIENT_ROOM_DEVICE_TABLE_NAME   @"t_a_client_room_device"
#define CLIENT_USER_TABLE_NAME          @"t_a_client_user"
#define TASK_TABLE_NAME                 @"t_a_task"
#define USER_TABLE_NAME                 @"t_p_user"
#define PRODUCT_TABLE_NAME              @"t_a_product"
#define PRODUCT_ORDER_TABLE_NAME        @"t_a_product_order"
#endif
