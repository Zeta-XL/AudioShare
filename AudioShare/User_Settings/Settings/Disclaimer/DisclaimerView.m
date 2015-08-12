//
//  DisclaimerView.m
//  AudioShare
//
//  Created by lanou3g on 15/8/12.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "DisclaimerView.h"

@implementation DisclaimerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}

-(void)p_setupView
{
    //self.backgroundColor = [UIColor redColor];
    
    //
    
    self.myScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64 - 49)];
    self.myScrollview.backgroundColor = [UIColor whiteColor];
    [self addSubview:_myScrollview];
    
    //
    self.discriptionLabel = [[UILabel alloc]init];
    
    self.discriptionLabel.numberOfLines = 0;
    self.content = @"免责声明:\n  1、一切移动客户端用户在下载并浏览本APP软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本APP相关声明和用户服务协议的约束。\n  2、本APP转载的内容并不代表本APP之意见及观点，也不意味着本APP赞同其观点或证实其内容的真实性。\n  3、本APP转载的文字、图片、音视频等资料均来自互联网，其真实性、准确性和合法性由信息发布人负责。本APP不提供任何保证，并不承担任何法律责任。\n  4、本APP所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。\n  5、本APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由本APP实际控制的任何网页上的内容，本APP不承担任何责任。\n  6、用户明确并同意其使用本APP网络服务所存在的风险将完全由其本人承担；因其使用本APP网络服务而产生的一切后果也由其本人承担，本APP对此不承担任何责任。\n  7、除本APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，本APP概不负责，亦不承担任何法律责任。\n  8、对于因不可抗力或因黑客攻击、通讯线路中断等本APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用本APP，本APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n  9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n  10、本网站相关声明版权及其修改权、更新权和最终解释权均属本APP所有。";
    self.discriptionLabel.text = _content;
    CGSize size = [self contextLabelHeight:_content];
    
    self.discriptionLabel.frame = CGRectMake(10, 10, size.width, size.height);
    self.discriptionLabel.font = [UIFont systemFontOfSize:14.f];
    self.discriptionLabel.textAlignment = NSTextAlignmentNatural;
    [_myScrollview addSubview:_discriptionLabel];
    _myScrollview.contentSize  = CGSizeMake([UIScreen mainScreen].bounds.size.width, size.height+10);
}

- (CGSize)contextLabelHeight:(NSString *)aString
{
    CGRect contextRect = [aString boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return contextRect.size;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self contextLabelHeight:_content];
    self.discriptionLabel.frame = CGRectMake(10, 10, size.width, size.height);
    _myScrollview.contentSize  = CGSizeMake([UIScreen mainScreen].bounds.size.width, size.height+10);
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
