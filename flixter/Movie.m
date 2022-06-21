//
//  Movie.m
//  flixter
//
//  Created by Andreas Lordos on 6/20/22.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    self.title = dictionary[@"title"];
    self.desc = dictionary[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullURL = [baseURLString stringByAppendingString:posterURLString];
    self.posterURL = [NSURL URLWithString:fullURL];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullURL2 = [baseURLString stringByAppendingString:backdropURLString];
    self.backdropURL = [NSURL URLWithString:fullURL2];

    return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *resu = [NSMutableArray new];;
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [resu addObject:movie];
    }
    return resu;
}

@end
