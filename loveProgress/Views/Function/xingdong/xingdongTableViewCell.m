
//
//  xingdongTableViewCell.m
//  loveProgress
//
//  Created by 彭天浩 on 2017/12/30.
//  Copyright © 2017年 彭天浩. All rights reserved.
//

#import "xingdongTableViewCell.h"

@implementation xingdongTableViewCell

#define lineLength 60
#define triangleLength 20
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X, BEGIN_X, backView.frame.size.width-20, 40)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = _name;
    if(UI_IS_IPHONE5){
        nameLabel.font = [UIFont systemFontOfSize:20];
    }else if (UI_IS_IPHONE6){
        nameLabel.font = [UIFont systemFontOfSize:25];
    }else{
        nameLabel.font = [UIFont systemFontOfSize:30];
    }
    
    nameLabel.textColor = ZANGQING_COLOR;
    [self.contentView addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-120, BEGIN_X+10, 120, 30)];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:20];
    dateLabel.textColor = ZANGQING_COLOR;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];//此处使用的formater格式要与字符串格式完全一致，否则转换失败
    dateLabel.text =  [formatter1 stringFromDate:_date];
    NSDictionary *attr2=@{NSFontAttributeName:dateLabel.font};
    CGSize labelsize3 =[dateLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr2 context:nil].size;
    [dateLabel setFrame:CGRectMake(SCREEN_WIDTH-BEGIN_X-labelsize3.width, BEGIN_X+10, labelsize3.width, labelsize3.height)];
    [backView addSubview:dateLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(dateLabel.frame.origin.x,BUTTONY(dateLabel) + 5, GETWIDTH(dateLabel), 1.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineView];
    
    //    overday1 = "已经过了 ";
    //    overday2 = " 天";
    //    overday3 = " 天";
    
    UILabel *yijingLabel =[[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(nameLabel)+10 ,30, dateLabel.frame.size.height)];
    yijingLabel.font = [UIFont systemFontOfSize:20];
    yijingLabel.textAlignment = NSTextAlignmentLeft;
    yijingLabel.text =LOCAL(@"haiyou");
    
    CGSize labelsize = [LOCAL(@"haiyou") sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    [yijingLabel setFrame:CGRectMake(BEGIN_X,BUTTONY(nameLabel)+10 , labelsize.width, labelsize.height)];
    [self.contentView addSubview:yijingLabel];
    if (![globalFunction isChineseLanguage]) {
        yijingLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    UILabel *dayLabel =[[UILabel alloc] initWithFrame:CGRectMake(yijingLabel.frame.origin.x+GETWIDTH(yijingLabel),GETY(yijingLabel) ,100, 0)];
    dayLabel.font = [UIFont boldSystemFontOfSize:20];
    dayLabel.textAlignment = NSTextAlignmentLeft;
    dayLabel.text =[NSString stringWithFormat:@" %ld ",[self dayCount:_date]];
    NSDictionary *attr=@{NSFontAttributeName:dayLabel.font};
    CGSize labelsize2 =[dayLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    [dayLabel setFrame:CGRectMake(yijingLabel.frame.origin.x+GETWIDTH(yijingLabel),GETY(yijingLabel), labelsize2.width, labelsize2.height)];
    dayLabel.textColor = HONG_COLOR;
    [self.contentView addSubview:dayLabel];
    
    UILabel *tian = [[UILabel alloc] initWithFrame:CGRectMake(dayLabel.frame.origin.x+GETWIDTH(dayLabel), GETY(dayLabel), 100, GETHEIGHT(dayLabel))];
    if ([self dayCount:_date]>1) {
        tian.text = LOCAL(@"haiyouday2");
    }else{
        tian.text = LOCAL(@"haiyouday3");
    }
    tian.font = [UIFont systemFontOfSize:20];
    tian.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:tian];
    
    UILabel *neirongLabel =[[UILabel alloc] initWithFrame:CGRectMake(BEGIN_X,BUTTONY(yijingLabel)+10 ,30, yijingLabel.frame.size.height)];

    neirongLabel.font = [UIFont systemFontOfSize:15];
    neirongLabel.textAlignment = NSTextAlignmentLeft;
    neirongLabel.text =LOCAL(@"neirong");
    neirongLabel.textColor = [UIColor grayColor];
    
    NSDictionary *attr3=@{NSFontAttributeName:neirongLabel.font};
    CGSize labelsize4 =[neirongLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr3 context:nil].size;
    [neirongLabel setFrame:CGRectMake(BEGIN_X,BUTTONY(yijingLabel)+10 , labelsize4.width, labelsize4.height)];
    if (![globalFunction isChineseLanguage]) {
        [neirongLabel setFrame:CGRectMake(BEGIN_X,GETY(neirongLabel)+10 ,labelsize4.width, labelsize4.height)];
    }
    [self.contentView addSubview:neirongLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(neirongLabel.frame.origin.x+GETWIDTH(neirongLabel),GETY(neirongLabel), SCREEN_WIDTH-GETWIDTH(neirongLabel)-2*BEGIN_X, GETHEIGHT(neirongLabel)*2)];
    //contentLabel.text = _content;
    if (![globalFunction isChineseLanguage]) {
        [contentLabel setFrame:CGRectMake(neirongLabel.frame.origin.x+GETWIDTH(neirongLabel),GETY(neirongLabel), SCREEN_WIDTH-GETWIDTH(neirongLabel)-2*BEGIN_X, GETHEIGHT(neirongLabel)*2)];
    }
    if (_content) {
        contentLabel.text = [NSString stringWithFormat:@"%@\n",_content];
    }
    contentLabel.textColor = [UIColor grayColor];
    //contentLabel.backgroundColor = BLACK_COLOR;

    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 2;
    //[contentLabel sizeThatFits:CGSizeMake(GETWIDTH(contentLabel), MAXFLOAT)];
    //[contentLabel setFrame:CGRectMake(neirongLabel.frame.origin.x+GETWIDTH(neirongLabel),BUTTONY(yijingLabel)+10  , SCREEN_WIDTH-(neirongLabel.frame.origin.x+GETWIDTH(neirongLabel))-BEGIN_X, size.height)];
    [self.contentView addSubview:contentLabel];
    
    if(_isTop == 1){
        UIImageView *topImage = [[UIImageView alloc] initWithImage:[globalFunction scaleToSize:[UIImage imageNamed:@"totop"] size:CGSizeMake(20, 20)]];
        [topImage setFrame:CGRectMake(backView.frame.size.width-25, 7, 20, 20)];
        [backView addSubview:topImage];
    }
}

-(void)update{
    [self setBanner];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(NSInteger)dayCount:(NSDate *)theDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate ;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:theDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    NSInteger day = [dayComponents day];
    return -day;
}

-(NSDate *)nextDate:(NSDate *)thisDate{
    NSDate *theDate =thisDate;
    
    NSDate *senddate=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: senddate];
    NSDate *localDate = [senddate dateByAddingTimeInterval: interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:theDate];
    NSString *todayDayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *thisYearStr =[NSString stringWithFormat:@"%@%@",[todayDayStr substringWithRange:NSMakeRange(0,4)],[oneDayStr substringWithRange:NSMakeRange(4,6)]] ;
    NSDate *thisYearDate = [dateFormatter dateFromString:thisYearStr];
    
    if([[oneDayStr substringWithRange:NSMakeRange(4,6)] isEqualToString: @"-02-29"]){
        NSString *nextYearStr = [NSString stringWithFormat:@"%d%@",[[oneDayStr substringWithRange:NSMakeRange(0,4)] intValue]+4,@"-02-29"];
        NSLog(@"nextyear = %@",nextYearStr);
        return [dateFormatter dateFromString:nextYearStr];
    }else{
        if([self compareOneDay:localDate withAnotherDay:thisYearDate] == 1 ||[self compareOneDay:localDate withAnotherDay:thisYearDate] == 0){
            NSString *nextYearStr =[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%d",[[todayDayStr substringWithRange:NSMakeRange(0,4)] intValue]+1],[oneDayStr substringWithRange:NSMakeRange(4,6)]];
            NSDate *nextYearDate = [dateFormatter dateFromString:nextYearStr];
            return nextYearDate;
        }else{
            return thisYearDate;
        }
    }
}

-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"%@  is in the future",oneDay);
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"%@ is in the past",oneDay);
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
