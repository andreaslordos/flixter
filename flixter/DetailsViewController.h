//
//  DetailsViewController.h
//  flixter
//
//  Created by Andreas Lordos on 6/16/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Movie *detailDict;
@end

NS_ASSUME_NONNULL_END
