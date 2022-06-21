//
//  TableViewCell.m
//  flixter
//
//  Created by Andreas Lordos on 6/15/22.
//

#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    self.movieimage.image = nil;
    
    [self.movieimage setImageWithURL:self.movie.posterURL];
    self.movietitle.text = self.movie.title;
    self.moviedescription.text = self.movie.desc;

}
@end
