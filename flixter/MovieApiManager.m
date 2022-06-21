//
//  MovieApiManager.m
//  flixter
//
//  Created by Andreas Lordos on 6/20/22.
//

#import "MovieApiManager.h"
#import "Movie.h"

@interface MovieApiManager()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURL *popularURL;
@property (nonatomic, strong) NSURL *nowShowingURL;
@end

@implementation MovieApiManager
- (id)init {
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                            delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSString *apiKey = @"0363a94d02caa988558131c145d73974";
    NSString *urlPopular = @"https://api.themoviedb.org/3/movie/popular?api_key=";
    NSString *urlNowShowing = @"https://api.themoviedb.org/3/movie/now_playing?api_key=";
    NSString *urlPopularFull = [urlPopular stringByAppendingString:apiKey];
    NSString *urlNowShowingFull = [urlNowShowing stringByAppendingString:apiKey];
    
    self.popularURL = [NSURL URLWithString:urlPopularFull];
    self.nowShowingURL = [NSURL URLWithString:urlNowShowingFull];

    return self;
}

- (void)fetchNowPlaying:(void(^) (NSArray *movies, NSError *error))completion {
    
    NSURL *url = self.nowShowingURL;

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *resultsArray = [Movie moviesWithDictionaries:dataDictionary[@"results"]];
            completion(resultsArray, nil);
        }
    }];
    [task resume];
}


- (void)fetchPopular:(void(^) (NSArray *movies, NSError *error))completion {
    
    NSURL *url = self.popularURL;

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *resultsArray = [Movie moviesWithDictionaries:dataDictionary[@"results"]];
            completion(resultsArray, nil);
        }
    }];
    [task resume];
}
@end
