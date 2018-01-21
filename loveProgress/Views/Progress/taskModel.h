//
//  taskModel.h
//  loveProgress
//
//  Created by 彭天浩 on 2018/1/5.
//  Copyright © 2018年 彭天浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface taskModel : NSObject
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *countName;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *detail;

@property (nonatomic,assign) BOOL isCount;

@property (nonatomic,assign) int relationship;
@property (nonatomic,assign) int countOrder;

@end
