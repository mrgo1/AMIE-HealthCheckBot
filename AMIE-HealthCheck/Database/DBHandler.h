//
//  DBHandler.h
//
//  Created by Abilash Cumulations on 03/05/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBHandler : NSObject

+ (instancetype)sharedManager;
- (void)saveContextwithStatus:(void(^)(BOOL))completion;


#pragma -mark -  iOS 10 core data properties
@property (readonly, strong) NSPersistentContainer *persistentContainer;

#pragma -mark -  iOS 10 below core data properties
@property (readonly, strong) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end
