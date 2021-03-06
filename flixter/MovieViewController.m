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
#import "Movie.h"
#import "MovieApiManager.h"

@interface MovieViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *filteredResultsArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MovieViewController



- (void)viewDidLoad {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    
    
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];

    // add refresh control to table view
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self beginRefresh:self.refreshControl];
    
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self.activityIndicator startAnimating];
    [refreshControl setTintColor:[UIColor whiteColor]];

    MovieApiManager *manager = [MovieApiManager new];
    
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
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
            self.resultsArray = [movies mutableCopy];
            self.filteredResultsArray = self.resultsArray;
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            [self.activityIndicator stopAnimating];
        }
    }];
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
    cell.movie = self.filteredResultsArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Size: %lu", [self.resultsArray count]);
    return [self.filteredResultsArray count];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Movie *dataToPass = self.filteredResultsArray[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie* evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.title containsString:searchText];
        }];
        self.filteredResultsArray = [[self.resultsArray filteredArrayUsingPredicate:predicate] mutableCopy];
        NSLog(@"%@", self.filteredResultsArray);
    }
    else {
        self.filteredResultsArray = self.resultsArray;
    }
    [self.tableView reloadData];
}


@end
