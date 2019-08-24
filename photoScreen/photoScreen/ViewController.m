
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UILabel *noLabel;//上面的序号
@property (nonatomic,strong) UIImageView *iconImage;//中间的大图
@property (nonatomic,strong) UILabel *descLabel;//下面的描述
@property (nonatomic,strong) UIButton *leftButton;//左边的按钮
@property (nonatomic,strong) UIButton *rightButton;//右边的按钮

@property (nonatomic,assign) int index;//当前显示的照片索引
@property (nonatomic,strong)NSArray *imageList;//装入图片的数组

@end

@implementation ViewController

#pragma mark - 控件的加载

- (NSArray *)imageList{
    
    if (_imageList == nil) {
        
        //获得imageList.plist的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pic.plist" ofType:nil];
        
        //从文件加载到数组中
        _imageList = [NSArray arrayWithContentsOfFile:path];
    }
    return _imageList;
}

//加载label控件
- (UILabel *)noLabel{
    
    if (_noLabel == nil) {
        
        //self.view.bounds.size.width
        _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
        
        //居中对齐
        _noLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:_noLabel];
    }
    
    return _noLabel;
}

- (UIImageView*)iconImage
{
    if (_iconImage == nil) {
        
        CGFloat imageW = 200;
        CGFloat imageH = 200;
        
        CGFloat imageX = (self.view.bounds.size.width - imageW)*0.5;
        CGFloat imageY = CGRectGetMaxY(self.noLabel.frame)+20;//取出矩形最大的Y值,noLabel下面20个y
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        
        [self.view addSubview:_iconImage];
        
    }
    return _iconImage;
}


- (UILabel *)descLabel
{
    if (_descLabel==nil) {
        
        CGFloat descY = CGRectGetMaxY(self.iconImage.frame);
        
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, descY, self.view.bounds.size.width, 100)];
        
        _descLabel.textAlignment = NSTextAlignmentCenter;
        
        //需要label具有足够的高度，不限制显示行数
        _descLabel.numberOfLines = 0;
        
        [self.view addSubview:_descLabel];
        
    }
    return _descLabel;
}
//左按钮
- (UIButton *)leftButton
{
    if (_leftButton == nil) {
        
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        CGFloat centerY = self.iconImage.center.y;
        CGFloat centerX = self.iconImage.frame.origin.x*0.5;
        
        _leftButton.center = CGPointMake(centerX, centerY);
        
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_normal"] forState:UIControlStateNormal];
        
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_highlighted"] forState:UIControlStateHighlighted];
        
        [self.view addSubview:_leftButton];
        
        _leftButton.tag = -1;
        
        [_leftButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
//右按钮
- (UIButton *)rightButton
{
    if (_rightButton ==nil) {
        
        //先设置按钮的宽高
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        //再设置按钮的中心点
        CGFloat centerX = self.iconImage.frame.origin.x*0.5;
        CGFloat centerY = self.iconImage.center.y;
        _rightButton.center = CGPointMake(self.view.bounds.size.width - centerX, centerY);
        
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_normal"] forState:UIControlStateNormal];
        
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_highlighted"] forState:UIControlStateHighlighted];
        
        [self.view addSubview:_rightButton];
        
        //添加监听方法
        [_rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightButton.tag = 1;
        
        //显示照片信息(序号，照片，描述)
        [self showPhotoInfo];
        
    }
    return _rightButton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self showPhotoInfo];
    [self noLabel];
    [self iconImage];
    [self descLabel];
    [self leftButton];
    [self rightButton];
    
}
#pragma mark - 显示图片方法和点击按钮方法

//显示照片信息(序号，照片，描述)
- (void)showPhotoInfo
{
    //设置序号
    self.noLabel.text = [NSString stringWithFormat:@"%d/%d",self.index+1,5];
    
    //图像和描述：分别取出数组里每个字典的键值对应的内容
    self.iconImage.image = [UIImage imageNamed:self.imageList[self.index][@"icon"]];
    self.descLabel.text = self.imageList[self.index][@"title"];
    
    //控制按钮状态:序号显示5和1的情况下禁用右按钮和左按钮
    self.rightButton.enabled = (self.index != 4);
    self.leftButton.enabled = (self.index != 0);
    
}

//在OC中，很多方法的第一个参数都是触发该方法的对象
- (void)clickButton:(UIButton *)button
{
    //根据按钮显示图片等索引
    self.index+=button.tag;
    [self showPhotoInfo];
}
@end
