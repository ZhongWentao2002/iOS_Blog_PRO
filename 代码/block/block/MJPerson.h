//
//  MJPerson.h
//  block
//
//  Created by Clutch Powers on 2022/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MJBlock)(void);

@interface MJPerson : NSObject

@property (nonatomic, copy) MJBlock block;

- (void)test;

@end

NS_ASSUME_NONNULL_END
