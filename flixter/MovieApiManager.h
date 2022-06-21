//
//  MovieApiManager.h
//  flixter
//
//  Created by Andreas Lordos on 6/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieApiManager : NSObject
- (void)fetchNowPlaying:(void(^) (NSArray *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
