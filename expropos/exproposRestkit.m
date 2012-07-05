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
#import "ExproDealItem.h"
#import "ExproMerchant.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "ExproGoods.h"
#import "ExproGoodsType.h"
#import "ExproRole.h"
#import "ExproRoute.h"
#import "ExproDeal.h"
#import "ExproStore.h"

@implementation exproposRestkit

+ (void) router:(RKObjectRouter *)router 
{
    [router routeClass:[ExproMerchant class] toResourcePath:@"/sync/merchant/:gid" forMethod:RKRequestMethodGET];
    [router routeClass:[ExproDeal class] toResourcePath:@"/deals/:gid" forMethod:RKRequestMethodGET];
}

+ (void) objectMapWithManager:(RKObjectManager *)objectManager 
{
    // Update date format so that we can parse Twitter dates properly
	// Wed Sep 29 15:31:08 +0000 2010
//    [RKObjectMapping addDefaultDateFormatterForString:@"E d MMM y HH:mm:ss Z" inTimeZone:nil];
    //NODEJS date format
    //2012-02-14T13:36:55.000Z
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mm:ss.SSS'Z'" inTimeZone:nil];
    
    // Setup our object mappings     
    RKManagedObjectMapping* routeMapping = [RKManagedObjectMapping mappingForClass:[ExproRoute class] inManagedObjectStore:objectManager.objectStore];
    routeMapping.primaryKeyAttribute = @"gid";
    [routeMapping mapKeyPathsToAttributes:@"_id", @"gid", @"description", @"desc", nil];
    [routeMapping mapAttributes:@"pathname", @"module", @"method", nil];
    [objectManager.mappingProvider setMapping:routeMapping forKeyPath:@"route"];

    RKManagedObjectMapping* roleMapping = [RKManagedObjectMapping mappingForClass:[ExproRole class] inManagedObjectStore:objectManager.objectStore];
    roleMapping.primaryKeyAttribute = @"gid";
    [roleMapping mapKeyPathsToAttributes:@"_id", @"gid", @"create_time", @"createTime", nil];
    [roleMapping mapAttributes:@"name", @"comment", nil];
    [roleMapping mapKeyPath:@"route" toRelationship:@"routes" withMapping:routeMapping];
    [objectManager.mappingProvider setMapping:roleMapping forKeyPath:@"role"];

    RKManagedObjectMapping* goodsTypeMapping = [RKManagedObjectMapping mappingForClass:[ExproGoodsType class] inManagedObjectStore:objectManager.objectStore];
    goodsTypeMapping.primaryKeyAttribute = @"gid";
    [goodsTypeMapping mapKeyPathsToAttributes:@"_id", @"gid", @"create_time", @"createTime", @"parent_id", @"parentID", nil];
    [goodsTypeMapping mapAttributes:@"name", @"isleaf", @"level", @"comment", nil];
    [goodsTypeMapping hasOne:@"parent" withMapping:goodsTypeMapping];
    [goodsTypeMapping connectRelationship:@"parent" withObjectForPrimaryKeyAttribute:@"parentID"];
    [objectManager.mappingProvider setMapping:goodsTypeMapping forKeyPath:@"goods_type"];
    
    RKManagedObjectMapping* goodsMapping = [RKManagedObjectMapping mappingForClass:[ExproGoods class] inManagedObjectStore:objectManager.objectStore];
    goodsMapping.primaryKeyAttribute = @"gid";
    [goodsMapping mapKeyPathsToAttributes:@"_id", @"gid", @"create_time", @"createTime", @"type_id", @"typeID", nil];
    [goodsMapping mapAttributes:@"name", @"state", @"code", @"price", @"comment", nil];
    [goodsMapping hasOne:@"type" withMapping:goodsTypeMapping];
    [goodsMapping connectRelationship:@"type" withObjectForPrimaryKeyAttribute:@"typeID"];
    [objectManager.mappingProvider setMapping:goodsMapping forKeyPath:@"goods"];

    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[ExproUser class] inManagedObjectStore:objectManager.objectStore];
    userMapping.primaryKeyAttribute = @"gid";
    [userMapping mapKeyPathsToAttributes:@"_id", @"gid", @"pet_name", @"petName", @"create_time", @"createTime", nil];
    [userMapping mapAttributes:@"cellphone", @"state", @"password", @"name", @"sex", @"birthday", @"idcard", @"email", @"comment", nil];
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"user"];
    
    RKManagedObjectMapping* memberMapping = [RKManagedObjectMapping mappingForClass:[ExproMember class] inManagedObjectStore:objectManager.objectStore];
    memberMapping.primaryKeyAttribute = @"gid";
    [memberMapping mapKeyPathsToAttributes:@"_id", @"gid", @"pet_name", @"petName", @"create_time", @"createTime", @"due_time", @"dueTime", @"role_id", @"roleID", nil];
    [memberMapping mapAttributes:@"state", @"privacy", @"point", @"savings", @"comment", nil];
    [memberMapping mapRelationship:@"user" withMapping:userMapping];
    [memberMapping mapRelationship:@"role" withMapping:roleMapping];
    [memberMapping connectRelationship:@"role" withObjectForPrimaryKeyAttribute:@"roleID"];
    [objectManager.mappingProvider setMapping:memberMapping forKeyPath:@"member"];

    RKManagedObjectMapping *storeMapping = [RKManagedObjectMapping mappingForClass:[ExproStore class] inManagedObjectStore:objectManager.objectStore];
    storeMapping.primaryKeyAttribute = @"gid";
    [storeMapping mapKeyPathsToAttributes:@"_id",@"gid",@"district_code", @"districtCode", @"inventar_num", @"inventarNum", @"create_time", @"createTime", @"map_info", @"mapInfo", @"transit_info", @"transitInfo", nil];
    [storeMapping mapAttributes:@"address", @"comment", @"notice", @"state", @"name", nil];
    [storeMapping mapKeyPath:@"staff" toRelationship:@"staffs" withMapping:memberMapping];
    [objectManager.mappingProvider setMapping:storeMapping forKeyPath:@"store"];

    RKManagedObjectMapping* merchantMapping = [RKManagedObjectMapping mappingForClass:[ExproMerchant class] inManagedObjectStore:objectManager.objectStore];
    merchantMapping.primaryKeyAttribute = @"gid";
    [merchantMapping mapKeyPathsToAttributes:@"_id", @"gid", @"short_name", @"shortName", @"create_time", @"createTime", @"due_time", @"dueTime", nil];
    [merchantMapping mapAttributes:@"state", @"type", @"phone", nil];
    [merchantMapping mapKeyPath:@"store" toRelationship:@"stores" withMapping:storeMapping];
    [merchantMapping mapKeyPath:@"member" toRelationship:@"members" withMapping:memberMapping];
    [merchantMapping mapKeyPath:@"goods" toRelationship:@"goods" withMapping:goodsMapping];
    [objectManager.mappingProvider setMapping:merchantMapping forKeyPath:@"sync_merchant"];

    RKManagedObjectMapping *dealMapping = [RKManagedObjectMapping mappingForClass:[ExproDeal class] inManagedObjectStore:objectManager.objectStore];
    dealMapping.primaryKeyAttribute = @"gid";
    [dealMapping mapKeyPathsToAttributes:@"_id",@"gid",@"store_id",@"storeID",@"dealer_id",@"dealerID",@"customer_id",@"customerID",@"type",@"type",@"state",@"state",@"payment",@"payment",
    @"cash",@"cash",@"point",@"point",@"pay_type",@"payType",@"create_time",@"createTime",nil];
    [dealMapping connectRelationship:@"store" withObjectForPrimaryKeyAttribute:@"storeID"];
    [dealMapping connectRelationship:@"dealer" withObjectForPrimaryKeyAttribute:@"dealerID"];
    [dealMapping connectRelationship:@"customer" withObjectForPrimaryKeyAttribute:@"customerID"];
    
    [dealMapping mapKeyPath:@"dealerID" toRelationship:@"dealer" withMapping:memberMapping];
    [dealMapping mapKeyPath:@"customerID" toRelationship:@"customer" withMapping:memberMapping];
    [dealMapping mapKeyPath:@"storeID" toRelationship:@"store" withMapping:storeMapping];
    [objectManager.mappingProvider setMapping:dealMapping forKeyPath:@"deal"];
 
 //   [objectManager.mappingProvider setEntry:dealMapping forResourcePathPattern:@"/deals"];
//    [storeMapping mapKeyPath:@"deal" toRelationship:@"deals" withMapping:dealMapping];
    
 
    
    RKManagedObjectMapping *dealItemMapping = [RKManagedObjectMapping mappingForClass:[ExproDealItem class] inManagedObjectStore:objectManager.objectStore];
    dealItemMapping.primaryKeyAttribute = @"gid";
    [dealItemMapping mapKeyPathsToAttributes:@"_id",@"gid",@"closing_cost",@"closingCost",@"total_cost",@"totalCost", 
     @"deal_id",@"deal_ID",@"goods_id",@"goodsID",nil];
    [dealItemMapping mapAttributes:@"num", nil];
    [dealItemMapping connectRelationship:@"deal" withObjectForPrimaryKeyAttribute:@"dealID"];
    [dealItemMapping connectRelationship:@"goods" withObjectForPrimaryKeyAttribute:@"goodsID"];
    [dealItemMapping mapKeyPath:@"dealID" toRelationship:@"deal" withMapping:dealMapping];
    [dealItemMapping mapKeyPath:@"goodsID" toRelationship:@"goods" withMapping:goodsMapping];
    
    
    [objectManager.mappingProvider setMapping:dealItemMapping forKeyPath:@"deal_item"];
    
    
  //  [dealItemMapping mapKeyPath:@"deal" toRelationship:@"deal" withMapping:dealMapping];
   
    
    
    [[self class] router:objectManager.router];
    objectManager.serializationMIMEType = RKMIMETypeJSON;
    objectManager.acceptMIMEType = RKMIMETypeJSON;
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
//    objectManager.objectStore.cacheStrategy = [RKFetchRequestManagedObjectCache new];
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
