//
//  BPPCalendar.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendar.h"
#import "BPPCalendarModel.h"
#import "BPPCalendarCell.h"


@interface BPPCalendar () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
//顶部导航view
@property (nonatomic,strong) UIView * navView;
@property (nonatomic, strong) UILabel * titlelabel;
//操作view
@property (nonatomic,strong) UIView * controlView;
//下一月按钮
@property (nonatomic,strong) UIButton * nextBtn;
//星期view
@property (nonatomic,strong) UIView * weekView;
@property (nonatomic, strong) UICollectionView *calendarCollectView;

@property (nonatomic, strong)  BPPCalendarModel *calendarModel;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, assign) NSUInteger index;
//日期项宽度
@property (nonatomic,assign) float itemWidth;
@property (nonatomic, strong) NSMutableDictionary *mutDict;
//现在的年
@property (nonatomic,assign) NSUInteger year;
//现在的月
@property (nonatomic,assign) NSUInteger month;
//现在的日
@property (nonatomic,assign) NSUInteger day;
//显示的年
@property (nonatomic,assign) NSUInteger showYear;
//显示的月
@property (nonatomic,assign) NSUInteger showMonth;
@end

@implementation BPPCalendar

#pragma mark  ----  生命周期函数

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.year = 0;
        self.month = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initDataSourse];
        
        [self addSubview:self.navView];
        [self addSubview:self.controlView];
        [self addSubview:self.weekView];
        [self addSubview:self.calendarCollectView];
    }
    return self;
}

#pragma mark  ----  代理函数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_dayArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.bounds.size.width/7.0, self.bounds.size.width/7.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BPPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dayArray[indexPath.row];
    
    if (self.showYear == self.year && self.showMonth == self.month) {
        
        //显示时间就是当前的年月
        if (indexPath.row < self.index) {
            
            //本月当前日前的日子
            BOOL hasCache = NO;
            for (NSUInteger i = 0; i < self.dataArray.count; i++) {
                
                NSDictionary * dic = [self getMonthAndDay:self.dataArray[i]];
                NSString * month = dic[@"month"];
                NSString * day = dic[@"day"];
                if (month.integerValue == self.month && [day isEqualToString:self.dayArray[indexPath.row]]) {
                    
                    hasCache = YES;
                }
            }
            
            if (hasCache) {
                
                cell.showPoint = YES;
                cell.textLabel.textColor = [UIColor blackColor];
            }
            else{
                
                cell.showPoint = NO;
                cell.textLabel.textColor = [UIColor grayColor];
            }
            
            cell.textLabel.clipsToBounds = NO;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        if (indexPath.row == self.index) {
            
            //当日
            NSString * dayStr = self.dayArray[indexPath.row];
            self.day = dayStr.integerValue;
            cell.showPoint = NO;
            cell.textLabel.layer.cornerRadius = cell.textLabel.frame.size.height/2.0;
            cell.textLabel.clipsToBounds = YES;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor redColor];
        }else if(indexPath.row > self.index){
            
            //本月当前日后的日子
            cell.showPoint = NO;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.clipsToBounds = NO;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
    }
    else if ((self.showYear == self.year && self.month == self.showMonth +1) || (self.year == self.showYear + 1 && self.showMonth == self.month + 11)){
        
        //显示的时间是上一月
        if (indexPath.row < self.index) {
            
            //本月当前日前的日子
            cell.showPoint = NO;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.clipsToBounds = NO;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        if (indexPath.row == self.index) {
            
            //当日
            BOOL hasCache = NO;
            for (NSUInteger i = 0; i < self.dataArray.count; i++) {
                
                NSDictionary * dic = [self getMonthAndDay:self.dataArray[i]];
                NSString * month = dic[@"month"];
                NSString * day = dic[@"day"];
                if (month.integerValue == self.month && [day isEqualToString:self.dayArray[indexPath.row]]) {
                    
                    hasCache = YES;
                }
            }
            
            if (hasCache) {
                
                cell.showPoint = YES;
                cell.textLabel.textColor = [UIColor blackColor];
            }
            else{
                
                cell.showPoint = NO;
                cell.textLabel.textColor = [UIColor grayColor];
            }
            cell.textLabel.clipsToBounds = NO;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }else if(indexPath.row > self.index){
            
            //本月当前日后的日子
            BOOL hasCache = NO;
            for (NSUInteger i = 0; i < self.dataArray.count; i++) {
                
                NSDictionary * dic = [self getMonthAndDay:self.dataArray[i]];
                NSString * month = dic[@"month"];
                NSString * day = dic[@"day"];
                if (month.integerValue == self.showMonth && [day isEqualToString:self.dayArray[indexPath.row]]) {
                    
                    hasCache = YES;
                }
            }
            
            if (hasCache) {
                
                cell.showPoint = YES;
                cell.textLabel.textColor = [UIColor blackColor];
            }
            else{
                
                cell.showPoint = NO;
                cell.textLabel.textColor = [UIColor grayColor];
            }
            cell.textLabel.clipsToBounds = NO;
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
    }
    else{
     
        cell.showPoint = NO;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.clipsToBounds = NO;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showYear == self.year){
        
        BOOL isSelectRightDay = NO;
        for (NSUInteger i = 0; i < self.dataArray.count; i++) {

            NSDictionary * dic = [self getMonthAndDay:self.dataArray[i]];
            NSString * month = dic[@"month"];
            NSString * day = dic[@"day"];
            if (month.integerValue == self.showMonth && [day isEqualToString:self.dayArray[indexPath.row]]) {

                isSelectRightDay = YES;
            }
        }
        
        if (isSelectRightDay) {
            
            NSString * day = self.dayArray[indexPath.row];
            self.block(self.showYear, self.showMonth, day.integerValue);
        }
    }
}


#pragma mark  ----  自定义函数
//初始化数据
- (void)initDataSourse {
    
    __weak typeof(self) weakSelf = self;
    _weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
   _calendarModel = [[BPPCalendarModel alloc] init];
    self.calendarModel.block = ^(NSUInteger year, NSUInteger month) {
        
        if (weakSelf.year == 0 && weakSelf.month == 0) {
            
            weakSelf.year = year;
            weakSelf.month = month;
        }
        weakSelf.showYear = year;
        weakSelf.showMonth = month;
        weakSelf.titlelabel.text = [NSString stringWithFormat:@"%ld年%ld月",year,month];;
    };
    _dayArray = [_calendarModel setDayArr];
    self.index = _calendarModel.index;
    _mutDict = [NSMutableDictionary new];
}

-(void)backBtnClicked{
    
    [self removeFromSuperview];
}



- (void)lastMonthClick {
    
    [self.mutDict removeAllObjects];
    self.dayArray = [self.calendarModel lastMonthDataArr];
    [self.calendarCollectView reloadData];
    
    if (self.showYear >= self.year && self.showMonth >= self.month) {
        
        self.nextBtn.hidden = YES;
    }
    else{
        
        self.nextBtn.hidden = NO;
    }
}

- (void)nextMonthClick {
    
    [self.mutDict removeAllObjects];
    self.dayArray = [self.calendarModel nextMonthDataArr];
    [self.calendarCollectView reloadData];
    
    if (self.showYear >= self.year && self.showMonth >= self.month) {
        
        self.nextBtn.hidden = YES;
    }
    else{
        
        self.nextBtn.hidden = NO;
    }
}


#pragma mark  ----  懒加载
-(UIView *)navView{
    
    if (!_navView) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        _navView.backgroundColor = Color_87BA4B;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, SCREENWIDTH - 120, 44)];
        titleLabel.textColor = Color_FFFFFF;
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"日历";
        [_navView addSubview:titleLabel];
        
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(0, 20, 60, 44)];
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 27);
        [backBtn setImage:[UIImage imageNamed:@"JHLivePlayBundle.bundle/fanhui_w.tiff"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:backBtn];
    }
    return _navView;
}

-(UIView *)controlView{
    
    if (!_controlView) {
        
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), SCREENWIDTH, 30)];
        
        UIButton * lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 60, 30)];
        [lastBtn setTitle:@"上一月" forState:UIControlStateNormal];
        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lastBtn addTarget:self action:@selector(lastMonthClick) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:lastBtn];
        
        [_controlView addSubview:self.titlelabel];
        
        UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 0, 60, 30)];
        nextBtn.hidden = YES;
        [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextMonthClick) forControlEvents:UIControlEventTouchUpInside];
        self.nextBtn = nextBtn;
        [_controlView addSubview:nextBtn];
        
    }
    return _controlView;
}

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 60, 0, 120, 30)];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}




-(UIView *)weekView{

    if (!_weekView) {
        
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.controlView.frame) , SCREENWIDTH, self.itemWidth)];
        for (int i = 0; i < [_weekArray count]; i ++) {
            UIButton *weekBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * self.itemWidth, 0, self.itemWidth, self.itemWidth)];
            [weekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weekBtn setTitle:_weekArray[i] forState:UIControlStateNormal];
            [_weekView addSubview:weekBtn];
        }
    }
    return _weekView;
}

-(float)itemWidth{
    
   return self.bounds.size.width/7.0;
}

-(UICollectionView *)calendarCollectView{
    
    if (!_calendarCollectView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        _calendarCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weekView.frame), self.bounds.size.width, self.bounds.size.height - self.itemWidth) collectionViewLayout:flowlayout];
        _calendarCollectView.delegate = self;
        _calendarCollectView.dataSource = self;
        _calendarCollectView.backgroundColor = [UIColor whiteColor];
        [_calendarCollectView registerClass:[BPPCalendarCell class] forCellWithReuseIdentifier:@"cell"];
        self.calendarCollectView.alwaysBounceVertical=YES;
    }
    return _calendarCollectView;
}

-(NSDictionary *)getMonthAndDay:(NSString *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* localzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setTimeZone:localzone];
    
    NSDate * chooseDate = [formatter dateFromString:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];;
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:chooseDate];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    NSDictionary * dic = @{@"month":[[NSString alloc] initWithFormat:@"%ld",month],@"day":[[NSString alloc] initWithFormat:@"%ld",day]};
    return dic;
}
@end
