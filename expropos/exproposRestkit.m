//
//  exproposRestkit.m
//  expropos
//
//  Created by gbo on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposRestkit.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@implementation exproposRestkit
+ (void) objectMapWithManager:(RKObjectManager *)objectManager 
{
    // Update date format so that we can parse Twitter dates properly
	// Wed Sep 29 15:31:08 +0000 2010
//    [RKObjectMapping addDefaultDateFormatterForString:@"E d MMM y HH:mm:ss Z" inTimeZone:nil];
    //GSTE NODEJS date format
    //2012-02-14T13:36:55.000Z
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mm:ss.SSS'Z'" inTimeZone:nil];
    
    // Setup our object mappings     
    
    objectManager.serializationMIMEType = RKMIMETypeJSON;
    // Uncomment this to use XML, comment it to use JSON
    //  objectManager.acceptMIMEType = RKMIMETypeXML;
    //  [objectManager.mappingProvider setMapping:statusMapping forKeyPath:@"statuses.status"];
}

+ (void) InitRestKit {
    // Initialize RestKit
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURLString:kWebServiceURL];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Initialize object store
#ifdef RESTKIT_GENERATE_SEED_DB
    NSString *seedDatabaseName = nil;
    NSString *databaseName = RKDefaultSeedDatabaseFileName;
#else
    NSString *seedDatabaseName = RKDefaultSeedDatabaseFileName;
    NSString *databaseName = @"RKGSTEData.sqlite";
#endif
    
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName usingSeedDatabaseName:seedDatabaseName managedObjectModel:nil delegate:self];
    //    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName];
    //    [objectManager.objectStore deletePersistantStore];

    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    [exproposRestkit objectMapWithManager:objectManager];
        
    // Database seeding is configured as a copied target of the main application. There are only two differences
    // between the main application target and the 'Generate Seed Database' target:
    //  1) RESTKIT_GENERATE_SEED_DB is defined in the 'Preprocessor Macros' section of the build setting for the target
    //      This is what triggers the conditional compilation to cause the seed database to be built
    //  2) Source JSON files are added to the 'Generate Seed Database' target to be copied into the bundle. This is required
    //      so that the object seeder can find the files when run in the simulator.
#ifdef RESTKIT_GENERATE_SEED_DB
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    RKManagedObjectSeeder* seeder = [RKManagedObjectSeeder objectSeederWithObjectManager:objectManager];
    
    // Seed the database with instances of RKTStatus from a snapshot of the RestKit Twitter timeline
    [seeder seedObjectsFromFile:@"restkit.json" withObjectMapping:statusMapping];
    
    // Seed the database with RKTUser objects. The class will be inferred via element registration
    [seeder seedObjectsFromFiles:@"users.json", nil];
    
    // Finalize the seeding operation and output a helpful informational message
    [seeder finalizeSeedingAndExit];
    
    // NOTE: If all of your mapped objects use keyPath -> objectMapping registration, you can perform seeding in one line of code:
    // [RKManagedObjectSeeder generateSeedDatabaseWithObjectManager:objectManager fromFiles:@"users.json", nil];
#endif
}

@end
