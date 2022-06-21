//
//  CollectionViewCell.h
//  flixter
//
//  Created by Andreas Lordos on 6/17/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movie_image;
@property (nonatomic, strong) Movie *movie;
@end

NS_ASSUME_NONNULL_END
