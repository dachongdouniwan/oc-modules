//
//  OTDBMigration.h
//

#ifndef TZS_TZSDBMigration_h
#define TZS_TZSDBMigration_h

@protocol OTDBMigrationProtocol

@required

/**
 *  Return the version number of class
 *
 *  @param
 *
 *  @return Version - unsigned int version, default(initial) version to 0
 */
- (NSNumber *) dataVersionOfClass;

/**
 *  Return the primary key of class
 *
 *  @param
 *
 *  @return
 */
- (NSString *) primaryKey;

/**
 *  Return the added keys compare to last version
 *
 *  @param version - unsigned int target version
 *
 *  @return array of added key strings
 */
- (NSArray *) addedKeysForVersion: (NSNumber *) version;

/**
 *  Return the deleted keys compare to last version
 *
 *  @param version - unsigned int target version
 *
 *  @return array of deleted key strings
 */
- (NSArray *) deletedKeysForVersion: (NSNumber *) version;

/**
 *  Return the renamed keys compare to last version
 *
 *  @param version - unsigned int target version
 *
 *  @return array of renamed key strings
 */
- (NSDictionary *) renamedKeysForVersion: (NSNumber *) version;

@end


#endif
