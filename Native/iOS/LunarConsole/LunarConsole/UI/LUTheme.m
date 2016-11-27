//
//  LUTheme.m
//
//  Lunar Unity Mobile Console
//  https://github.com/SpaceMadness/lunar-unity-console
//
//  Copyright 2016 Alex Lementuev, SpaceMadness.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LUTheme.h"

#import "Lunar.h"

static LUTheme * _mainTheme;

@interface LUTheme ()

@property (nonatomic, strong) UIColor *tableColor;
@property (nonatomic, strong) UIColor *logButtonTitleColor;
@property (nonatomic, strong) UIColor *logButtonTitleSelectedColor;

@property (nonatomic, strong) LUCellSkin *cellLog;
@property (nonatomic, strong) LUCellSkin *cellError;
@property (nonatomic, strong) LUCellSkin *cellWarning;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *fontSmall;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat indentHor;
@property (nonatomic, assign) CGFloat indentVer;
@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, assign) CGFloat buttonHeight;

@property (nonatomic, strong) UIImage *collapseBackgroundImage;
@property (nonatomic, strong) UIColor *collapseBackgroundColor;
@property (nonatomic, strong) UIColor *collapseTextColor;

@property (nonatomic, strong) UIFont  *actionsWarningFont;
@property (nonatomic, strong) UIColor *actionsWarningTextColor;
@property (nonatomic, strong) UIFont  *actionsFont;
@property (nonatomic, strong) UIColor *actionsTextColor;
@property (nonatomic, strong) UIColor *actionsBackgroundColorLight;
@property (nonatomic, strong) UIColor *actionsBackgroundColorDark;
@property (nonatomic, strong) UIFont  *actionsGroupFont;
@property (nonatomic, strong) UIColor *actionsGroupTextColor;
@property (nonatomic, strong) UIColor *actionsGroupBackgroundColor;

@property (nonatomic, strong) UIFont  *contextMenuFont;
@property (nonatomic, strong) UIColor *contextMenuBackgroundColor;
@property (nonatomic, strong) UIColor *contextMenuTextColor;
@property (nonatomic, strong) UIColor *contextMenuTextHighlightColor;

@end

@interface LUCellSkin ()

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColorLight;
@property (nonatomic, strong) UIColor *backgroundColorDark;

@end

static UIColor * UIColorMake(int rgb)
{
    CGFloat red = ((rgb >> 16) & 0xff) / 255.0;
    CGFloat green = ((rgb >> 8) & 0xff) / 255.0;
    CGFloat blue = (rgb & 0xff) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

static UIImage * CreateCollapseBackgroundImage()
{
    UIImage *collapseImage = [UIImage imageNamed:@"lunar_console_collapse_background.png"];

    if ([UIScreen mainScreen].scale == 2.0)
    {
        CGFloat offset = 23 / 2.0;
        return [collapseImage resizableImageWithCapInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
    }
    
    if ([UIScreen mainScreen].scale == 1.0) // should not get there - just a sanity check
    {
        CGFloat offset = 11;
        return [collapseImage resizableImageWithCapInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
    }
    
    CGFloat offset = 35 / 3.0;
    return [collapseImage resizableImageWithCapInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
}

@implementation LUTheme

+ (void)initialize
{
    if ([self class] == [LUTheme class])
    {
        LUCellSkin *cellLog = [LUCellSkin cellSkin];
        cellLog.icon = [UIImage imageNamed:@"lunar_console_icon_log.png"];
        cellLog.textColor = UIColorMake(0xb1b1b1);
        cellLog.backgroundColorLight = UIColorMake(0x3c3c3c);
        cellLog.backgroundColorDark = UIColorMake(0x373737);
        
        LUCellSkin *cellError = [LUCellSkin cellSkin];
        cellError.icon = [UIImage imageNamed:@"lunar_console_icon_log_error.png"];
        cellError.textColor = cellLog.textColor;
        cellError.backgroundColorLight = cellLog.backgroundColorLight;
        cellError.backgroundColorDark = cellLog.backgroundColorDark;
        
        LUCellSkin *cellWarning = [LUCellSkin cellSkin];
        cellWarning.icon = [UIImage imageNamed:@"lunar_console_icon_log_warning.png"];
        cellWarning.textColor = cellLog.textColor;
        cellWarning.backgroundColorLight = cellLog.backgroundColorLight;
        cellWarning.backgroundColorDark = cellLog.backgroundColorDark;
        
        _mainTheme = [LUTheme new];
        _mainTheme.tableColor = UIColorMake(0x2c2c27);
        _mainTheme.logButtonTitleColor = UIColorMake(0xb1b1b1);
        _mainTheme.logButtonTitleSelectedColor = UIColorMake(0x595959);
        _mainTheme.cellLog = cellLog;
        _mainTheme.cellError = cellError;
        _mainTheme.cellWarning = cellWarning;
        _mainTheme.font = [self createCustomFontWithSize:10];
        _mainTheme.fontSmall = [self createCustomFontWithSize:8];
        _mainTheme.lineBreakMode = NSLineBreakByWordWrapping;
        _mainTheme.cellHeight = 32;
        _mainTheme.indentHor = 10;
        _mainTheme.indentVer = 2;
        _mainTheme.buttonWidth = 46;
        _mainTheme.buttonHeight = 30;
        _mainTheme.collapseBackgroundImage = CreateCollapseBackgroundImage();
        _mainTheme.collapseBackgroundColor = UIColorMake(0x424242);
        _mainTheme.collapseTextColor = cellLog.textColor;
        _mainTheme.actionsWarningFont = [UIFont systemFontOfSize:18];
        _mainTheme.actionsWarningTextColor = cellLog.textColor;
        _mainTheme.actionsFont = [self createCustomFontWithSize:12];
        _mainTheme.actionsTextColor = cellLog.textColor;
        _mainTheme.actionsBackgroundColorDark = cellLog.backgroundColorDark;
        _mainTheme.actionsBackgroundColorLight = cellLog.backgroundColorLight;
        _mainTheme.actionsGroupFont = [self createCustomFontWithSize:12];
        _mainTheme.actionsGroupTextColor = [UIColor whiteColor];
        _mainTheme.actionsGroupBackgroundColor = UIColorMake(0x262626);
        _mainTheme.contextMenuFont = [self createCustomFontWithSize:12];
        _mainTheme.contextMenuBackgroundColor = UIColorMake(0x3c3c3c);
        _mainTheme.contextMenuTextColor = cellLog.textColor;
        _mainTheme.contextMenuTextHighlightColor = [UIColor whiteColor];
    }
}


+ (UIFont *)createCustomFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"Menlo-regular" size:size];
    if (font != nil)
    {
        return font;
    }
    
    return [UIFont systemFontOfSize:size];
}

+ (LUTheme *)mainTheme
{
    return _mainTheme;
}

@end

@implementation LUCellSkin

+ (instancetype)cellSkin
{
    return [[[self class] alloc] init];
}


@end
