//
//  DetailsViewController.m
//  flixter
//
//  Created by Andreas Lordos on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Movie.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdrop;
@property (weak, nonatomic) IBOutlet UIImageView *details_poster;
@property (weak, nonatomic) IBOutlet UILabel *details_title;
@property (weak, nonatomic) IBOutlet UILabel *details_desc;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    
    Movie *movie = self.detailDict;
    [super viewDidLoad];
    self.details_title.text = movie.title;
    self.details_desc.text = movie.desc;
    
    self.details_poster.image = nil;
    [self.details_poster setImageWithURL:movie.posterURL];

    self.backdrop.image = nil;
    [self.backdrop setImageWithURL:movie.backdropURL];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
