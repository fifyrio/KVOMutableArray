//
//  KVOMutableArray+ReactiveCocoaSupport.m
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/1.
//
//

#import "KVOMutableArray+ReactiveCocoaSupport.h"
#import "RACEXTKeyPathCoding.h"
#import "NSObject+RACPropertySubscribing.h"
#import "KVOMutableArrayObserver.h"
#import "RACSignal+Operations.h"
#import <objc/runtime.h>


@interface KVOMutableArray (ReactiveCocoaSupportInternal)
- (KVOMutableArrayObserver*)observer;
@end

@implementation KVOMutableArray (ReactiveCocoaSupport)

@implementation KVOMutableArray (ReactiveCocoaSupport)


/**
 数组初始化以及增加、减少产生的信号

 @return RACSignal
 */
- (RACSignal*)initialAndChangeSignal{
    KVOMutableArrayObserver* observer = [self observer];
    RACSignal* signal = [observer rac_valuesAndChangesForKeyPath:@keypath(observer, arr)
                                                         options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                                        observer:observer];       
    return mergedSignal;
}


/**
 数组初始化以及增加、减少、某个元素发生变化产生的信号

 @return RACSignal
 */
- (RACSignal*)changeSignalContainElements{
    KVOMutableArrayObserver* observer = [self observer];
    RACSignal* signal = [observer rac_valuesAndChangesForKeyPath:@keypath(observer, arr)
                                                         options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                                        observer:observer];
    
    NSMutableArray *signals = @[].mutableCopy;
    [signals addObject:signal];
    
    [observer.arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([obj class], &count);
        for (unsigned int i = 0; i<count; i++) {
            const char *propertyName = property_getName(propertyList[i]);
            NSString *path = [NSString stringWithUTF8String:propertyName];
            RACSignal *subSignal = [obj rac_valuesAndChangesForKeyPath:path options:NSKeyValueObservingOptionNew observer:nil];
            [signals addObject:subSignal];
        }
    }];
    RACSignal *mergedSignal = [RACSignal merge:signals.copy];
    return mergedSignal;
}

- (RACSignal*)changeSignal
{
    
    KVOMutableArrayObserver* observer = [self observer];
    RACSignal* signal = [observer rac_valuesAndChangesForKeyPath:@keypath(observer, arr)
                                                     options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                                    observer:observer];
    return signal;
}
@end
