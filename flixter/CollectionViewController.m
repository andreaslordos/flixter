//
//  CollectionViewController.m
//  flixter
//
//  Created by Andreas Lordos on 6/17/22.
//

#import "CollectionViewController.h"
#import "MovieViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CollectionViewCell.h"
#import "DetailsViewController.h"
#import "MovieApiManager.h"
@interface CollectionViewController ()
@property (nonatomic, strong) NSMutableArray *resultsArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"movie_poster";


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
            [self.collectionView reloadData];
            [refreshControl endRefreshing];
            [self.activityIndicator stopAnimating];
        }
    }];
}



- (void)viewDidLoad {

    

    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];

    // add refresh control to table view
    [self.collectionView insertSubview:self.refreshControl atIndex:0];

    [self beginRefresh:self.refreshControl];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    Movie *dataToPass = self.resultsArray[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.resultsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.movie = self.resultsArray[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
