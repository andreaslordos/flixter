//
//  MovieViewController.m
//  flixter
//
//  Created by Andreas Lordos on 6/15/22.
//

#import "MovieViewController.h"
#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *resultsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MovieViewController

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self.activityIndicator startAnimating];
    [refreshControl setTintColor:[UIColor whiteColor]];

    NSTimeInterval delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){


      // Create NSURL and NSURLRequest

      NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                            delegate:nil
                                                       delegateQueue:[NSOperationQueue mainQueue]];
      session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  
      NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=0363a94d02caa988558131c145d73974"];

      NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
      NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          if (error != nil) {
              UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies"
                                         message:@"The internet connection appears to be offline."
                                         preferredStyle:UIAlertControllerStyleAlert];

              UIAlertAction* retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {[self beginRefresh:self.refreshControl];}];

              [alert addAction:retryAction];
              [self presentViewController:alert animated:YES completion:nil];

          }
          else {
              
              // ... Use the new data to update the data source ...
              NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"%@", dataDictionary);

              self.resultsArray = dataDictionary[@"results"];

              // Reload the tableView now that there is new data
               [self.tableView reloadData];

              // Tell the refreshControl to stop spinning
               [refreshControl endRefreshing];
          }
          [self.activityIndicator stopAnimating];
      }];
      
      [task resume];
    });
}


- (void)viewDidLoad {

    

    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];

    // add refresh control to table view
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self beginRefresh:self.refreshControl];
    
    self.tableView.dataSource = self;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *dataToPass = self.resultsArray[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

@end
