/*
 DSLCalendarView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DSLCalendarRange.h"
#import "NSDate+DSLCalendarView.h"
@protocol DSLCalendarViewDelegate;


@interface DSLCalendarView : UIView

@property (nonatomic, weak) id<DSLCalendarViewDelegate>delegate;
@property (nonatomic, copy) NSDateComponents *visibleMonth;
@property (nonatomic, strong) DSLCalendarRange *selectedRange;
@property (nonatomic, assign) BOOL showDayCalloutView;

+ (Class)monthSelectorViewClass;
+ (Class)monthViewClass;
+ (Class)dayViewClass;

- (void)setVisibleMonth:(NSDateComponents *)visibleMonth animated:(BOOL)animated;

- (UIImage *) screenShotView;

@end


@protocol DSLCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(DSLCalendarView*)calendarView didSelectRange:(DSLCalendarRange*)range;
- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents*)month duration:(NSTimeInterval)duration;
- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents*)month;
- (DSLCalendarRange*)calendarView:(DSLCalendarView*)calendarView didDragToDay:(NSDateComponents*)day selectingRange:(DSLCalendarRange*)range;
- (BOOL)calendarView:(DSLCalendarView *)calendarView shouldAnimateDragToMonth:(NSDateComponents*)month;

@end
