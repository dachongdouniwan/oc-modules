//
//  OTDBHelper.h
//

// The main purpose of this is to store any NSObject into db and query it back, without user implementation the sqlite (or core data) related code.

// THIS DB HANLDER is designed as a light db operation support, to minimize the work for a simple db usage case, for complex cases of data, use core data support is recommended.

// AS this is a light db op set, many of the TODOs listed below I do NOT intent to solve. As much as this is already easy & good for normal usage.

// TODOs :
//  - mapping is only supposed to be functioning ONLY by default getter/setter objects, how to support customized getter/setter will be considered
//  - mapping now is ONLY doing the first level NSString & NSNumber values, others are DROPPED for now, need to consider more on this.
//  - partially DONE - mapping can get properties all the (super) way up to NSObject.
//  - think about auto primary keys - not very necessery

#import "OTDBMigration.h"
#import "OTDBTableVersion.h"


#define KCLocalizedStr(key)  NSLocalizedString(key, @"")

#ifdef  DEBUG
#define KCLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define KCLog(...)
#endif


// TODO - move it out to Category in Framework

@interface NSMutableDictionary (SetOperation)

- (NSMutableDictionary *) addDic : (NSDictionary *) addDictionary;
- (NSMutableDictionary *) minusDic : (NSDictionary *) minusDictionary;

- (NSMutableDictionary *) addByKeyArray : (NSArray *) keyArray;
- (NSMutableDictionary *) minusByKeyArray : (NSMutableArray *) keyArray modifyInput: (BOOL) mInput;

@end

@interface OTDB : NSObject

/**
 *  Fetch instance
 *
 *  @return instance
 */
+ (OTDB *)sharedInstance;

/**
 *  insert or update a class object
 *
 *  @param  Key  the primary key name from the class
 *
 *  @return success(YES) or failure(NO)
 */
- (BOOL)insertOrUpdateWithModelArr:(NSArray *)modelArr byPrimaryKey:(NSString *)pKey;

/**
 *  Query by class
 *
 *  @param modelClass class to query
 *  @param key        query key
 *  @param value      query value
 *  @param oKey       query result order key
 *  @param desc       descending or asecending order
 *
 *  @return query result(s)
 */

- (NSArray *) queryWithClass: (Class)modelClass key: (NSString *) key value :(NSObject *) value orderByKey:(NSString *)oKey desc:(BOOL)desc;

/**
 *  Delete class objects from db
 *
 *  @param arrOfmodel the objects that needs to be removed from db
 *  @param key        the primary key of the class
 *
 *  @return success(YES) or failure(NO)
 */

- (BOOL) deleteModels: (NSArray *)arrOfmodel withPrimaryKey: (NSString *)key;

/**
 *  Delete all object for the class
 *
 *  @param modelClass target class to be pruned
 *
 *  @return success(YES) or failure(NO)
 */
- (BOOL) dropModels: (Class)modelClass;

@end
