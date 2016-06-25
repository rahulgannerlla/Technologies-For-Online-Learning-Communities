//
//  InnerTileView.m
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/13/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "InnerTileView.h"

@implementation InnerTileView

-(id)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.layer.cornerRadius=4.0;
        self.backgroundColor=[UIColor whiteColor];
        self.innerViewId=0;
        self.check=NO;
        self.checkImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 15, 15)];
        [self addSubview:self.checkButton];
        [self addSubview:self.checkImageView];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.check) {
        [self.checkImageView setImage:[UIImage imageNamed:@"tickmark.png"]];
        self.check = YES;
    }
    
    else if (self.check) {
        [self.checkImageView setImage:nil ];
        self.check = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
