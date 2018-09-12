//
//  AnimalModel.m
//  iOSArchitecture
//
//  Created by peace on 2018/9/10.
//  Copyright © 2018 peace. All rights reserved.
//

#import "AnimalModel.h"

@implementation AnimalModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSArray *animals = @[@"马",@"羊",@"牛",@"狗",@"兔子",@"猫",@"小鸡",@"母鸡",@"狮子",@"老虎",@"鸭子",@"长颈鹿",@"豹子",@"斑马",@"鹅"];
        NSArray *summary = @[@"马在古时候是重要的战争武器，为人类提供交通便利",
                                  @"羊在古时候是重要的战争武器，为人类提供交通便利",
                                  @"牛在古时候是重要的战争武器，为人类提供交通便利",
                                  @"狗在古时候是重要的战争武器，为人类提供交通便利",
                                  @"兔子在古时候是重要的战争武器，为人类提供交通便利",
                                  @"猫在古时候是重要的战争武器，为人类提供交通便利",
                                  @"小鸡在古时候是重要的战争武器，为人类提供交通便利",
                                  @"母鸡在古时候是重要的战争武器，为人类提供交通便利",
                                  @"狮子在古时候是重要的战争武器，为人类提供交通便利",
                                  @"老虎在古时候是重要的战争武器，为人类提供交通便利",
                                  @"鸭子在古时候是重要的战争武器，为人类提供交通便利",
                                  @"长颈鹿在古时候是重要的战争武器，为人类提供交通便利",
                                  @"豹子在古时候是重要的战争武器，为人类提供交通便利",
                                  @"斑马在古时候是重要的战争武器，为人类提供交通便利",
                                  @"鹅在古时候是重要的战争武器，为人类提供交通便利"
                                  ];
        NSArray *urls = @[@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1784133053,1340609512&fm=26&gp=0.jpg",
                          @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=360549509,319315840&fm=200&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2113874716,1264623421&fm=200&gp=0.jpg",
                          @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3393390761,1005233492&fm=200&gp=0.jpg",
                          @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4157526050,1286048764&fm=26&gp=0.jpg",
                          @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3216273833,93409191&fm=200&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=656969992,226185177&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=105290959,2255948986&fm=200&gp=0.jpg",
                          @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2101417843,3135124722&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3747711561,1366093422&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3654810228,4073901045&fm=200&gp=0.jpg",
                          @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4285912113,1564240083&fm=26&gp=0.jpg",
                          @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1036123669,265030709&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2337036369,2260342200&fm=26&gp=0.jpg",
                          @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1780775018,2250430967&fm=200&gp=0.jpg"
                          ];
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        AnimalEntity *entity = nil;
        
        for (NSString *animal in animals) {
            NSInteger index = [animals indexOfObject:animal];
            
            entity = [[AnimalEntity alloc] init];
            entity.identifier = [[NSDate date] timeIntervalSince1970];
            entity.imageUrl = [urls objectAtIndex:index];
            entity.name = animal;
            entity.summary = [summary objectAtIndex:index];
            [mutableArray addObject:entity];
        }
        
        _dataSource = mutableArray;
    }
    return self;
}

- (AnimalEntity *)animalEntityWitIndexPath:(NSInteger)row {
    AnimalEntity *entity = [_dataSource objectAtIndex:row];
    if (entity.imageUrl && !entity.imageData) {
        [self downloadImageWtihEntity:entity];
    }
    
    return entity;
}

- (void)downloadImageWtihEntity:(AnimalEntity *)entity {
    if (entity.isLoading || !entity.imageUrl || entity.imageUrl.length == 0) {
        return;
    }
    
    entity.isLoading = YES;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        
        NSLog(@"开始下载图片:%@", [NSThread currentThread]);
        
        NSURL *imageURL = [NSURL URLWithString:entity.imageUrl];
        //下载图片
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        if (imageData) {
            entity.imageData = imageData;
        }
        NSLog(@"imageData = %@",imageData);
        
        //从子线程回到主线程(方式二：常用)
        //组合：主队列异步执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程:%@", [NSThread currentThread]);
            //更新界面
            if (self.delegate && [self.delegate respondsToSelector:@selector(animalShowImage:row:)]) {
                NSInteger row = [self.dataSource indexOfObject:entity];
                [self.delegate animalShowImage:entity row:row];
            }
        });
    });
}

@end