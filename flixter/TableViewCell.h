//
//  TableViewCell.h
//  flixter
//
//  Created by Andreas Lordos on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moviedescription;
@property (weak, nonatomic) IBOutlet UILabel *movietitle;
@property (weak, nonatomic) IBOutlet UIImageView *movieimage;

@end

NS_ASSUME_NONNULL_END
