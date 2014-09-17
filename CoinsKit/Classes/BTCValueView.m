//
//  BTCValueView.m
//  Coins
//
//  Created by Sam Soffes on 4/23/14.
//  Copyright (c) 2014 Nothing Magical, Inc. All rights reserved.
//

#import "BTCValueView.h"
#import "BTCDefines.h"
#import "UIColor+Coins.h"

@implementation BTCValueView

#pragma mark - Accessors

@synthesize conversionRates = _conversionRates;
@synthesize valueButton = _valueButton;
@synthesize inputButton = _inputButton;

- (void)setConversionRates:(NSDictionary *)conversionRates {
	_conversionRates = conversionRates;

	static NSNumberFormatter *currencyFormatter = nil;
	static dispatch_once_t currencyOnceToken;
	dispatch_once(&currencyOnceToken, ^{
		currencyFormatter = [[NSNumberFormatter alloc] init];
		currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
	});

	NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"Coins"];
	currencyFormatter.currencyCode = [userDefaults stringForKey:kBTCSelectedCurrencyKey];
	double value = [userDefaults doubleForKey:kBTCNumberOfCoinsKey] * [conversionRates[currencyFormatter.currencyCode] doubleValue];
	[self.valueButton setTitle:[currencyFormatter stringFromNumber:@(value)] forState:UIControlStateNormal];

	static NSNumberFormatter *numberFormatter = nil;
	static dispatch_once_t numberOnceToken;
	dispatch_once(&numberOnceToken, ^{
		numberFormatter = [[NSNumberFormatter alloc] init];
		numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
		numberFormatter.currencySymbol = @"";
		numberFormatter.minimumFractionDigits = 0;
		numberFormatter.maximumFractionDigits = 10;
		numberFormatter.roundingMode = NSNumberFormatterRoundDown;
	});

	// Ensure it's a double for backwards compatibility with 1.0
	NSNumber *number = @([[userDefaults stringForKey:kBTCNumberOfCoinsKey] doubleValue]);

	NSString *title = [numberFormatter stringFromNumber:number];
	[self.inputButton setTitle:[NSString stringWithFormat:@"%@ BTC", title] forState:UIControlStateNormal];
}

- (UIButton *)valueButton {
	if (!_valueButton) {
		_valueButton = [[UIButton alloc] init];
		_valueButton.translatesAutoresizingMaskIntoConstraints = NO;
		_valueButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80.0f : 50.0f];
		_valueButton.titleLabel.adjustsFontSizeToFitWidth = YES;
		_valueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
		[_valueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	return _valueButton;
}


- (UIButton *)inputButton {
	if (!_inputButton) {
		_inputButton = [[UIButton alloc] init];
		_inputButton.translatesAutoresizingMaskIntoConstraints = NO;
		_inputButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0f : 20.0f];
		[_inputButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateNormal];
	}
	return _inputButton;
}


#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundColor = [UIColor clearColor];
		
		[self addSubview:self.valueButton];
		[self addSubview:self.inputButton];

		[self setupConstraints];
	}
	return self;
}


#pragma mark - Private

- (void)setupConstraints {
	NSDictionary *views = @{
		@"valueButton": self.valueButton,
		@"inputButton": self.inputButton
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[valueButton]-|" options:kNilOptions metrics:nil views:views]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.valueButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-20.0]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[inputButton]-|" options:kNilOptions metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[valueButton]-(-15)-[inputButton]" options:kNilOptions metrics:nil views:views]];
}

@end