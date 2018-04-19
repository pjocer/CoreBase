//
//  BaseDAOStore.m
//  AFNetworking
//
//  Created by Jocer on 2018/4/19.
//

#import "BaseDAOStore.h"

@implementation BaseDAOStore
- (instancetype)init {
    return [self initDBWithName:@"azazie.db"];
}
- (id)getObjectById:(NSString *)objectId {
    NSAssert([self isMemberOfClass:BaseDAOStore.class], @"abstract method");
    return nil;
}
- (void)putObject:(id)object withId:(NSString *)objectId {
    NSAssert([self isMemberOfClass:BaseDAOStore.class], @"abstract method");
}
@end
