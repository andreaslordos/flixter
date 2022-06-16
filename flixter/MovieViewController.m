//
//  MovieViewController.m
//  flixter
//
//  Created by Andreas Lordos on 6/15/22.
//

#import "MovieViewController.h"
#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"
 
@interface MovieViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *resultsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation MovieViewController


- (void)viewDidLoad {
    [self.activityIndicator startAnimating];
    NSTimeInterval delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

    

    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=0363a94d02caa988558131c145d73974"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               self.resultsArray = dataDictionary[@"results"];
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
       }];
    [task resume];
    self.tableView.dataSource = self;
    [self.activityIndicator stopAnimating];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull TableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    NSDictionary *movie = self.resultsArray[indexPath.row];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullURL = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullURL];
    cell.movieimage.image = nil;
    [cell.movieimage setImageWithURL:posterURL];
    
    cell.movietitle.text = movie[@"title"];
    cell.moviedescription.text = movie[@"overview"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Size: %lu", [self.resultsArray count]);
    return [self.resultsArray count];
}

@end
