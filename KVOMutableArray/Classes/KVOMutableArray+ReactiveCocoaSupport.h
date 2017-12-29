//
//  KVOMutableArray+ReactiveCocoaSupport.h
//  Pods
//
//  Created by Hai Feng Kao on 2015/6/1.
//
//

#import "KVOMutableArray.h"

@class RACSignal;
@interface KVOMutableArray (ReactiveCocoaSupport)

/**will add--
 数组初始化以及增加、减少产生的信号
 
 @return RACSignal
 */
- (RACSignal*)initialAndChangeSignal;

/**will add--
 数组初始化以及增加、减少、某个元素发生变化产生的信号
 
 @return RACSignal
 */
- (RACSignal*)changeSignalContainElements;

- (RACSignal*)changeSignal;
@end
