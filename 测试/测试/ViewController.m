//
//  ViewController.m
//  测试
//
//  Created by 赵黎明 on 16/7/26.
//  Copyright © 2016年 赵黎明. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dayLB;
@property (weak, nonatomic) IBOutlet UILabel *hourLB;
@property (weak, nonatomic) IBOutlet UILabel *minuteLB;
@property (weak, nonatomic) IBOutlet UILabel *secondLB;

@end


@interface ViewController ()
{
    dispatch_source_t _timer;
}
@end

@implementation ViewController
/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dayLB.textColor    = [UIColor redColor];
    self.hourLB.textColor   = [UIColor grayColor];
    self.minuteLB.textColor = [UIColor greenColor];
    self.secondLB.textColor = [UIColor blueColor];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 350, 200, 200)];
    iconImageView.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:iconImageView];
    
    NSLog(@"Sanjiang");
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 48*3600)];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLB.text = @"";
                        self.hourLB.text = @"00";
                        self.minuteLB.text = @"00";
                        self.secondLB.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLB.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLB.text = @"0天";
                        }else{
                            self.dayLB.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            self.hourLB.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLB.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLB.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLB.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLB.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLB.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
    
    
}
@end
