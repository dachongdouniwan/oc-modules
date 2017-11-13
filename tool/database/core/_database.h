
#import <Foundation/Foundation.h>
#import "_building_precompile.h"
#import "_db_config.h"
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface _Database : NSObject

@singleton( _Database )

@property (nonatomic, strong, readonly) FMDatabaseQueue *queue;
@property (nonatomic, strong, readonly) FMDatabase *db;

// 信号量.
@property (nonatomic, strong, nullable) dispatch_semaphore_t semaphore;
@property (nonatomic, copy) NSString * sqliteName;

// 设置操作过程中不可关闭数据库(即closeDB函数无效).
@property (nonatomic, assign) BOOL disableCloseDB;

/**
 关闭数据库.
 */
- (void)closeDB;

/**
 删除数据库文件.
 */
+ (BOOL)deleteSqlite:(NSString *)sqliteName;

//事务操作
- (void)inTransaction:(BOOL (^)())block;

/**
 注册数据变化监听.
 @claName 注册监听的类名.
 @name 注册名称,此字符串唯一,不可重复,移除监听的时候使用此字符串移除.
 @return YES: 注册监听成功; NO: 注册监听失败.
 */
- (BOOL)observeWithName:(NSString * const)name block:(DatabaseDealStateBlock)block;

/**
 移除数据变化监听.
 @name 注册监听的时候使用的名称.
 @return YES: 移除监听成功; NO: 移除监听失败.
 */
- (BOOL)unobserveWithName:(NSString * const)name;

#pragma mark --> 以下是直接存储一个对象的API

/**
 存储一个对象.
 @object 将要存储的对象.
 @ignoreKeys 忽略掉模型中的哪些key(即模型变量)不要存储,nil时全部存储.
 @complete 回调的block.
 */
- (void)saveObject:(id)object ignoredKeys:(nullable NSArray * const)ignoredKeys complete:(nullable DatabaseSuccessBlock)complete;
- (void)saveQueueObject:(id)object ignoredKeys:(nullable NSArray * const)ignoredKeys complete:(nullable DatabaseSuccessBlock)complete;
/**
 批量存储.
 */
- (void)saveObjects:(NSArray *)array ignoredKeys:(nullable NSArray * const)ignoredKeys complete:(nullable DatabaseSuccessBlock)complete;
/**
 批量更新.
 */
- (void)updateObjects:(NSArray *)array ignoredKeys:(nullable NSArray * const)ignoredKeys complete:(nullable DatabaseSuccessBlock)complete;

- (void)queryTableNamesWithComplete:(nullable DatabaseCompleteBlcok)completeHandler;

/**
 根据条件查询对象.
 @param cla 代表对应的类.
 @param where 形式 @[@"key",@"=",@"value",@"key",@">=",@"value"] .
 @param param 额外条件参数 例如排序 @"order by id desc" 等.
 @param complete 回调的block.
 */
- (void)queryObjectWithClass:(__unsafe_unretained _Nonnull Class)cla where:(NSArray* _Nullable)where param:(NSString* _Nullable)param complete:(DatabaseCompleteBlcok _Nullable)complete;
/**
 根据条件查询对象.
 @param cla 代表对应的类.
 @param keys 存放的是要查询的哪些key,为nil时代表查询全部.
 @param where 形式 @[@"key",@"=",@"value",@"key",@">=",@"value"] .
 @param complete 回调的block.
 */
- (void)queryObjectWithClass:(__unsafe_unretained _Nonnull Class)cla keys:(NSArray<NSString*>* _Nullable)keys where:(NSArray* _Nullable)where complete:( nullable DatabaseCompleteBlcok)complete;
/**
 根据keyPath查询对象
 @param cla 代表对应的类.
 @param keyPathValues 数组,形式@[@"user.student.name",Equal,@"小芳",@"user.student.conten",Contains,@"书"]
 即查询user.student.name等于@"小芳" 和 user.student.content中包含@“书”这个字符串的对象.
 */
- (void)queryObjectWithClass:(__unsafe_unretained _Nonnull Class)cla forKeyPathAndValues:(NSArray* _Nonnull)keyPathValues complete:( nullable DatabaseCompleteBlcok)complete;
/**
 根据条件改变对象数据.
 @param object 要更新的对象.
 @param where 数组的形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],为nil时设置全部.
 @param complete 回调的block
 */
- (void)updateWithObject:(id _Nonnull)object where:(NSArray* _Nullable)where ignoreKeys:(NSArray* const _Nullable)ignoreKeys complete:( nullable DatabaseSuccessBlock)complete;
/**
 根据keyPath改变对象数据.
 @param keyPathValues 数组,形式@[@"user.student.name",Equal,@"小芳",@"user.student.conten",Contains,@"书"]
 即更新user.student.name=@"小芳" 和 user.student.content中包含@“书”这个字符串的对象.
 */
- (void)updateWithObject:(id _Nonnull)object forKeyPathAndValues:(NSArray* _Nonnull)keyPathValues ignoreKeys:(NSArray* const _Nullable)ignoreKeys complete:( nullable DatabaseSuccessBlock)complete;
/**
 根据条件改变对象的部分变量值.
 @param cla 代表对应的类.
 @param valueDict 存放的是key和value 即@{key:value,key:value}..
 @param where 数组的形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],为nil时设置全部.
 @param complete 回调的block
 */
- (void)updateWithClass:(__unsafe_unretained _Nonnull Class)cla valueDict:(NSDictionary* _Nonnull)valueDict where:(NSArray* _Nullable)where complete:( nullable DatabaseSuccessBlock)complete;
/**
 直接传入条件sql语句更新对象.
 */
- (void)updateObject:(id _Nonnull)object ignoreKeys:(NSArray* const _Nullable)ignoreKeys conditions:(NSString* _Nonnull)conditions complete:( nullable DatabaseSuccessBlock)complete;
/**
 根据条件删除对象表中的对象数据.
 @param cla 代表对应的类.
 @param where 形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],where要非空.
 @param complete 回调的block
 */
- (void)deleteWithClass:(__unsafe_unretained _Nonnull Class)cla where:(NSArray* _Nonnull)where complete:( nullable DatabaseSuccessBlock)complete;
/**
 根据类删除此类所有数据.
 @param cla 代表对应的类.
 @param complete 回调的block
 */
- (void)clearWithClass:(__unsafe_unretained _Nonnull Class)cla complete:( nullable DatabaseSuccessBlock)complete;
/**
 根据类,删除这个类的表.
 @param cla 代表对应的类.
 @param complete 回调的block
 */
- (void)dropWithClass:(__unsafe_unretained _Nonnull Class)cla complete:( nullable DatabaseSuccessBlock)complete;
/**
 将某表的数据拷贝给另一个表
 @param srcCla 源类.
 @param destCla 目标类.
 @param keydict 拷贝的对应key集合,形式@{@"srcKey1":@"destKey1",@"srcKey2":@"destKey2"},即将源类srcCla中的变量值拷贝给目标类destCla中的变量destKey1，srcKey2和destKey2同理对应,以此推类.
 @append YES: 不会覆盖destCla的原数据,在其末尾继续添加；NO: 覆盖掉原数据,即将原数据删掉,然后将新数据拷贝过来.
 */
- (void)copyClass:(__unsafe_unretained _Nonnull Class)srcCla to:(__unsafe_unretained _Nonnull Class)destCla keyDict:(NSDictionary* const _Nonnull)keydict append:(BOOL)append complete:( nullable DatabaseDealStateBlock)complete;

#pragma mark --> 以下是非直接存储一个对象的API

/**
 数据库中是否存在表.
 @name 表名称.
 @complete 回调的block
 */
- (void)isExistWithTableName:( NSString* _Nonnull)name complete:( nullable DatabaseSuccessBlock)complete;
/**
 创建表(如果存在则不创建)
 @name 表名称.
 @keys 数据存放要求@[字段名称1,字段名称2].
 @primaryKey 主键字段,可以为nil.
 @complete 回调的block
 */
- (void)createTableWithTableName:(NSString* _Nonnull)name keys:(NSArray<NSString*>* _Nonnull)keys uniqueKey:(NSString* _Nullable)uniqueKey complete:( nullable DatabaseSuccessBlock)complete;
/**
 插入数据.
 @name 表名称.
 @dict 插入的数据,只关心key和value 即@{key:value,key:value}.
 @complete 回调的block
 */
- (void)insertIntoTableName:(NSString* _Nonnull)name Dict:(NSDictionary* _Nonnull)dict complete:( nullable DatabaseSuccessBlock)complete;
/**
 直接传入条件sql语句查询.
 @name 表名称.
 @conditions 条件语句.例如:@"where name = '标哥' or name = '小马哥' and age = 26 order by age desc limit 6" 即查询name等于标哥或小马哥和age等于26的数据通过age降序输出,只查询前面6条.
 更多条件语法,请查询sql的基本使用语句.
 */
- (void)queryWithTableName:(NSString* _Nonnull)name conditions:(NSString* _Nonnull)conditions complete:( nullable DatabaseCompleteBlcok)complete;
/**
 根据条件查询字段.
 @name 表名称.
 @keys 存放的是要查询的哪些key,为nil时代表查询全部.
 @where 形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],条件key属性只能是系统自带的属性,暂不支持自定义类.
 @complete 回调的block,返回的数组元素是字典 @[@{key:value},@{key:value}] .
 */
- (void)queryWithTableName:(NSString* _Nonnull)name keys:(NSArray<NSString*>* _Nullable)keys where:(NSArray * _Nullable)where complete:( nullable DatabaseCompleteBlcok)complete;
/**
 全部查询.
 @param name 表名称.
 @param param 额外条件参数 例如排序 @"order by id desc" 等.
 @param complete 回调的block,返回的数组元素是字典 @[@{key:value},@{key:value}] .
 */
- (void)queryWithTableName:(NSString* _Nonnull)name param:(NSString* _Nullable)param where:(NSArray* _Nullable)where complete:( nullable DatabaseCompleteBlcok)complete;
/**
 keyPath查询.
 @name 表名称.
 @keyPathValues数组,形式@[@"user.student.name",Equal,@"小芳",@"user.student.conten",Contains,@"书"]
 即查询user.student.name=@"小芳" 和 user.student.content中包含@“书”这个字符串的对象.
 */
-(void)queryWithTableName:(NSString* _Nonnull)name forKeyPathAndValues:(NSArray* _Nonnull)keyPathValues complete:( nullable DatabaseCompleteBlcok)complete;
/**
 更新数据.
 @name 表名称.
 @valueDict 将要更新的数据,存放的是key和value 即@{key:value,key:value}..
 @where 条件数组,形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],为nil时设置全部,条件key属性只能是系统自带的属性,暂不支持自定义类.
 @complete 回调的block.
 */
-(void)updateWithTableName:(NSString* _Nonnull)name valueDict:(NSDictionary* _Nonnull)valueDict where:(NSArray* _Nullable)where complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 直接传入条件sql语句更新.
 */
-(void)updateWithTableName:(NSString* _Nonnull)name valueDict:(NSDictionary* _Nullable)valueDict conditions:(NSString* _Nonnull)conditions complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 根据keypath更新数据.
 @name 表名称.
 @keyPathValues数组,形式@[@"user.student.name",Equal,@"小芳",@"user.student.conten",Contains,@"书"]
 即更新user.student.name=@"小芳" 和 user.student.content中包含@“书”这个字符串的对象.
 */
-(void)updateWithTableName:(NSString* _Nonnull)name forKeyPathAndValues:(NSArray* _Nonnull)keyPathValues valueDict:(NSDictionary* _Nonnull)valueDict complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 根据表名和条件删除表内容.
 @name 表名称.
 @where 条件数组,形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],where要非空.
 @complete 回调的block.
 */
-(void)deleteWithTableName:(NSString* _Nonnull)name where:(NSArray* _Nonnull)where complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 直接传入条件sql语句删除.
 */
-(void)deleteWithTableName:(NSString* _Nonnull)name conditions:(NSString* _Nonnull)conditions complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 根据keypath删除表内容.
 @name 表名称.
 @keyPathValues数组,形式@[@"user.student.name",Equal,@"小芳",@"user.student.conten",Contains,@"书"]
 即删除user.student.name=@"小芳" 和 user.student.content中包含@“书”这个字符串的对象.
 */
-(void)deleteWithTableName:(NSString* _Nonnull)name forKeyPathAndValues:(NSArray* _Nonnull)keyPathValues complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 根据表名删除表格全部内容.
 @name 表名称.
 @complete 回调的block.
 */
-(void)clearTable:(NSString* _Nonnull)name complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 删除表.
 @name 表名称.
 @complete 回调的block.
 */
-(void)dropTable:(NSString* _Nonnull)name complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 删除表(线程安全).
 */
-(void)dropSafeTable:(NSString* _Nonnull)name complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 动态添加表字段.
 @name 表名称.
 @key 将要增加的字段.
 @complete 回调的block.
 */
- (void)addTable:(NSString* _Nonnull)name key:(NSString* _Nonnull)key complete:(DatabaseSuccessBlock _Nullable)complete;
/**
 查询该表中有多少条数据
 @name 表名称.
 @where 条件数组,形式 @[@"key",@"=",@"value",@"key",@">=",@"value"],为nil时返回全部数据的条数.
 */
- (NSInteger)countForTable:(NSString * _Nonnull)name where:(NSArray * _Nullable)where;
/**
 直接传入条件sql语句查询数据条数.
 */
- (NSInteger)countForTable:(NSString * _Nonnull)name conditions:(NSString * _Nullable)conditions;
/**
 keyPath查询数据条数.
 */
- (NSInteger)countForTable:(NSString * _Nonnull)name forKeyPathAndValues:(NSArray * _Nonnull)keyPathValues;
/**
 直接调用sqliteb的原生函数计算sun,min,max,avg等.
 */
- (NSInteger)sqliteMethodForTable:(NSString* _Nonnull)name type:(bg_sqliteMethodType)methodType key:(NSString* _Nonnull)key where:(NSString* _Nullable)where;
/**
 刷新数据库，即将旧数据库的数据复制到新建的数据库,这是为了去掉没用的字段.
 @name 表名称.
 @keys 新表的数组字段.
 */
- (void)refreshTable:(NSString* _Nonnull)name keys:(NSArray<NSString*>* const _Nonnull)keys complete:(DatabaseDealStateBlock _Nullable)complete;
- (void)refreshQueueTable:(NSString* _Nonnull)name keys:(NSArray<NSString*>* const _Nonnull)keys complete:(DatabaseDealStateBlock _Nullable)complete;
- (void)refreshTable:(NSString* _Nonnull)name keyDict:(NSDictionary * const _Nonnull)keyDict complete:(DatabaseDealStateBlock _Nullable)complete;
/**
 直接执行sql语句
 @className 要操作的类名
 */
- (id _Nullable)bg_executeSql:(NSString * const _Nonnull)sql className:(NSString * _Nullable)className;

#pragma mark 存储数组.
/**
 直接存储数组.
 */
- (void)saveArray:(NSArray * _Nonnull)array name:(NSString * _Nonnull)name complete:( nullable DatabaseSuccessBlock)complete;
/**
 读取数组.
 */
- (void)queryArrayWithName:(NSString * _Nonnull)name complete:( nullable DatabaseCompleteBlcok)complete;
/**
 读取数组某个元素.
 */
- (id _Nullable)queryArrayWithName:(NSString* _Nonnull)name index:(NSInteger)index;
/**
 更新数组某个元素.
 */
- (BOOL)updateObjectWithName:(NSString * _Nonnull)name object:(id _Nonnull)object index:(NSInteger)index;
/**
 删除数组某个元素.
 */
- (BOOL)deleteObjectWithName:(NSString * _Nonnull)name index:(NSInteger)index;


#pragma mark 存储字典.
/**
 直接存储字典.
 */
- (void)saveDictionary:(NSDictionary * _Nonnull)dictionary complete:( nullable DatabaseSuccessBlock)complete;
/**
 添加字典元素.
 */
- (BOOL)bg_setValue:(id _Nonnull)value forKey:(NSString* const _Nonnull)key;
/**
 更新字典元素.
 */
- (BOOL)bg_updateValue:(id _Nonnull)value forKey:(NSString* const _Nonnull)key;
/**
 遍历字典元素.
 */
- (void)bg_enumerateKeysAndObjectsUsingBlock:(void (^ _Nonnull)(NSString* _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop))block;
/**
 获取字典元素.
 */
- (id _Nullable)bg_valueForKey:(NSString * const _Nonnull)key;
/**
 删除字典元素.
 */
- (BOOL)bg_deleteValueForKey:(NSString * const _Nonnull)key;

@end

NS_ASSUME_NONNULL_END
