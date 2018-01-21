//
//  jiluTableViewCell.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/31.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "jiluTableViewCell.h"
#import <UIImageView+WebCache.h>

#define imgHeight 80

@implementation jiluTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBanner{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    CGSize size = CGSizeMake(1000,1000);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 127.734375+BEGIN_X+5)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:backView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X,20, SCREEN_WIDTH-2*BEGIN_X, 0)];
    //contentLabel.text = _content;
    if (_content) {
        if (_theTag) {
            contentLabel.text = [NSString stringWithFormat:@"%@\n#%@#",_content,_theTag];
        }else{
        contentLabel.text = [NSString stringWithFormat:@"%@",_content];
        }
    }
    contentLabel.textColor = BLACK_COLOR;
    //contentLabel.backgroundColor = BLACK_COLOR;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:18];
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    [self.contentView addSubview:contentLabel];
    
    float xPosition = BEGIN_X;
    float yPosition = 10+BUTTONY(contentLabel);
    int i;
    int count = 0;
    if (_imgArrayReal) {
        count = (int)_imgArrayReal.count;
    }else if(_imgArray){
        count = (int)_imgArray.count;
    }
    for (i = 0; i<count; i++) {
        if (i == 3) {
            xPosition = BEGIN_X;
            yPosition += imgHeight+10;
        }
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, imgHeight, imgHeight)];
        img.tag = 100+i;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *imgTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction:)];
        imgTapRecognizer.numberOfTapsRequired = 1;
        imgTapRecognizer.delegate = self;
        [img addGestureRecognizer:imgTapRecognizer];
        if (_imgArrayReal) {
            [img setImage:_imgArrayReal[i]];
        }else{
            [img sd_setImageWithURL:_imgArray[i] placeholderImage:[self buttonImageFromColor:[UIColor grayColor]]];
//            AVFile *file =[AVFile fileWithURL:_imgArray[i]];
//            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                [img setImage:[UIImage imageWithData:data]];
//            } progressBlock:^(NSInteger percentDone) {
//                //下载的进度数据，percentDone 介于 0 和 100。
//            }];
        }
        xPosition+= 5+imgHeight;
        [self.contentView addSubview:img];
    }
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [UIColor grayColor];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];//此处使用的formater格式要与字符串格式完全一致，否则转换失败
    dateLabel.text =  [formatter1 stringFromDate:_date];
    NSDictionary *attr2=@{NSFontAttributeName:dateLabel.font};
    CGSize labelsize3 =[dateLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr2 context:nil].size;
    if (count == 0) {
        [dateLabel setFrame:CGRectMake(BEGIN_X, yPosition, labelsize3.width, labelsize3.height)];
//        NSLog(@"%@ \ncount == %d\nypo == %f\ncontent == %f\ndateLabel == %f",_content,count,yPosition,BUTTONY(contentLabel),GETY(dateLabel));
    }else{
        [dateLabel setFrame:CGRectMake(BEGIN_X, yPosition+imgHeight+10, labelsize3.width, labelsize3.height)];
//        NSLog(@"%@ \ncount == %d\nypo == %f\ncontent == %f\ndateLabel == %f",_content,count,yPosition,BUTTONY(contentLabel),GETY(dateLabel));
    }
    [self.contentView addSubview:dateLabel];
    
    [backView setFrame:CGRectMake(0, 5, SCREEN_WIDTH, BUTTONY(dateLabel)+10)];
    _jiluHeight = BUTTONY(dateLabel)+15;
}

-(void)update{
    [self setBanner];
}


-(void)imgAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *imgview =(UIImageView *)tap.view;
    [self.delegate show:imgview];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
