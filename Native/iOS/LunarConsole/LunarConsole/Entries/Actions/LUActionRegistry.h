//
//  LUActionRegistry.h
//  LunarConsole
//
//  Created by Alex Lementuev on 2/24/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LUAction;
@class LUActionRegistry;
@class LUCVar;

@protocol LUActionRegistryDelegate <NSObject>

- (void)actionRegistry:(LUActionRegistry *)registry didAddAction:(LUAction *)action atIndex:(NSUInteger)index;
- (void)actionRegistry:(LUActionRegistry *)registry didRemoveAction:(LUAction *)action atIndex:(NSUInteger)index;
- (void)actionRegistry:(LUActionRegistry *)registry didRegisterVariable:(LUCVar *)variable atIndex:(NSUInteger)index;
- (void)actionRegistry:(LUActionRegistry *)registry didDidChangeVariable:(LUCVar *)variable atIndex:(NSUInteger)index;

@end

@interface LUActionRegistry : NSObject

@property (weak, nonatomic, readonly) NSArray *actions;
@property (weak, nonatomic, readonly) NSArray *variables;

@property (nonatomic, weak) id<LUActionRegistryDelegate> delegate;

+ (instancetype)registry;

- (LUAction *)registerActionWithId:(int)actionId name:(NSString *)name;
- (BOOL)unregisterActionWithId:(int)actionId;

- (LUCVar *)registerVariableWithId:(int)variableId name:(NSString *)name typeName:(NSString *)type value:(NSString *)value;
- (void)setValue:(NSString *)value forVariableWithId:(int)variableId;
- (LUCVar *)variableWithId:(int)variableId;

@end
