//
//  CollectionViewCell.m
//  flixter
//
//  Created by Andreas Lordos on 6/17/22.
//

#import "CollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CollectionViewCell

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    self.movie_image.image = nil;
    [self.movie_image setImageWithURL:self.movie.posterURL];

}

@end
