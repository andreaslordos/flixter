//
//  Movie.h
//  flixter
//
//  Created by Andreas Lordos on 6/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSURL *backdropURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
