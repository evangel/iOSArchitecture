//
//  ARDiskMananger.m
//  iOSArchitecture
//
//  Created by peace on 2018/11/6.
//  Copyright © 2018 peace. All rights reserved.
//

#import "HPStorageMananger.h"

@interface HPStorageMananger()

@property (nonatomic,strong) NSArray *ignorePaths;

@end

@implementation HPStorageMananger

#pragma mark -
#pragma mark -- Life Cycle
+ (instancetype)diskManager {
    HPStorageMananger *manager = [[HPStorageMananger alloc] init];
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark -
#pragma mark -- custome
- (NSInteger)storageWithPath:(NSString *)path {
    NSError *error;
    NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (fileAttribute && !error) {
        NSNumber *fileSize = [fileAttribute objectForKey:@"NSFileSize"];
        NSLog(@"fileAttribute = %@",fileAttribute);
        return fileSize.integerValue;
    }
    else {
        return 0;
    }
}

- (NSArray *)components {
    return [self componentsWithPath:NSHomeDirectory()];
}

- (NSArray *)componentsWithPath:(NSString *)path {
    if (!path || path.length == 0) {
        return nil;
    }
    
    NSLog(@"path = %@",path);
    NSError *error = nil;
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        return nil;
    }
    
    NSString *removePath = [NSString stringWithFormat:@"%@",NSHomeDirectory()];
    NSString *rootPath = [path substringFromIndex:removePath.length];
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSString *subpath in subpaths) {
    
        HPDirectory *directory = [[HPDirectory alloc] init];
        directory.superPath = path;
        directory.path = [NSString stringWithFormat:@"%@/%@",path,subpath];
        NSString *levelPath = [NSString stringWithFormat:@"%@/%@",rootPath,subpath];
        directory.rootPath = levelPath;
        
        NSArray *components = [levelPath componentsSeparatedByString:@"/"];
        directory.name = components.lastObject;
        directory.level = components.count - 1;
        NSLog(@"levelPath = %@ level = %lu",levelPath,(unsigned long)components.count);
        
        if (!directory.isDrictor) {
            directory.suffix = [directory.name componentsSeparatedByString:@"."].lastObject;
        }
        
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:directory.path isDirectory:&isDir];
        directory.isDrictor = isDir;
        
        directory.isRead = [[NSFileManager defaultManager] isReadableFileAtPath:directory.path];
        directory.isWrite = [[NSFileManager defaultManager] isWritableFileAtPath:directory.path];
        directory.isDelete = [[NSFileManager defaultManager] isDeletableFileAtPath:directory.path];
        
        [mutableArray addObject:directory];
    }
    
    return mutableArray;
}

- (void)ignorePaths:(NSArray *)paths {
    _ignorePaths = [NSArray arrayWithArray:paths];
}

#pragma mark -
#pragma mark -- Private
- (NSArray *)_sourceComponents {
    NSLog(@"NSHomeDirectory = %@",NSHomeDirectory());
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:NSHomeDirectory()];
    
    
    NSError *error = nil;
    subpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:NSHomeDirectory() error:&error];
    
    
    
    
    for (NSString *subpath in subpaths) {
        NSArray *components = [subpath componentsSeparatedByString:@"/"];
        
        HPDirectory *directory = [[HPDirectory alloc] init];
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:subpath isDirectory:&isDir];
        directory.isDrictor = isDir;
        directory.path = subpath;
        directory.name = components.lastObject;
        directory.level = components.count;
        
        if (!directory.isDrictor) {
            directory.suffix = [directory.name componentsSeparatedByString:@"."].lastObject;
        }
        
        [mutableArray addObject:directory];
    }
    
//    //Document
//    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"document path = %@",documentPath);
//
//    //Cache
//    NSArray *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSLog(@"cache path = %@",cachePath);
//
//    //Tmp
//    NSString *tmpPath = NSTemporaryDirectory();
//    NSLog(@"tmp path = %@",tmpPath);
    
    return mutableArray;
}

- (HPDirectory *)directoryWithPath:(NSString *)path level:(NSInteger)level
{
    if (!path || path.length == 0 || level <= 0) {
        return nil;
    }
    
    NSMutableArray *currentLevelPaths = [NSMutableArray array];
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:path];
    for (NSString *path in subpaths) {
        NSArray *subpaths = [path componentsSeparatedByString:@"/"];
        
    }
    
    HPDirectory *directory = [[HPDirectory alloc] init];
    directory.isDrictor = YES;
    directory.path = path;
    directory.name = level == 1 ? @"Root":@"";
    directory.level = level;
//    directory.subpaths = currentLevelPaths;
    
    return directory;
}

@end

@implementation HPDirectory
@end
