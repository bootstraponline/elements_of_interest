//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Dec  8 2015 15:34:27).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <objc/NSObject.h>

#import <XCTest/XCAccessibilityElement.h>
#import <XCTest/NSSecureCoding-Protocol.h>
#import <XCTest/XCElementAttributesPrivate-Protocol.h>

@class NSArray, NSDictionary, NSString, XCAccessibilityElement, XCUIApplication;

@interface XCElementSnapshot : NSObject <XCElementAttributesPrivate, NSSecureCoding>
{
    NSString *_identifier;
    id _value;
    NSString *_placeholderValue;
    _Bool _enabled;
    _Bool _selected;
    _Bool _isMainWindow;
    _Bool _hasKeyboardFocus;
    _Bool _hasFocus;
    XCUIApplication *_application;
    unsigned long long _generation;
    NSString *_title;
    NSString *_label;
    unsigned long long _elementType;
    long long _horizontalSizeClass;
    long long _verticalSizeClass;
    XCAccessibilityElement *_accessibilityElement;
    XCAccessibilityElement *_parentAccessibilityElement;
    XCElementSnapshot *_parent;
    NSArray *_children;
    unsigned long long _traits;
    NSArray *_userTestingAttributes;
    NSDictionary *_additionalAttributes;
    struct CGRect _frame;
}

+ (_Bool)supportsSecureCoding;
- (id)_allDescendants;
- (_Bool)_frameFuzzyMatchesElement:(id)arg1;
- (_Bool)_fuzzyMatchesElement:(id)arg1;
- (_Bool)_isAncestorOfElement:(id)arg1;
- (_Bool)_isDescendantOfElement:(id)arg1;
- (_Bool)_matchesElement:(id)arg1;
- (id)_rootElement;
- (id)_uniquelyIdentifyingObjectiveCCode;
- (id)_uniquelyIdentifyingSwiftCode;
@property(retain) XCAccessibilityElement *accessibilityElement; // @synthesize accessibilityElement=_accessibilityElement;
@property(copy) NSDictionary *additionalAttributes; // @synthesize additionalAttributes=_additionalAttributes;
@property(nonatomic) XCUIApplication *application; // @synthesize application=_application;
@property(copy) NSArray *children; // @synthesize children=_children;
@property(readonly, copy) NSString *compactDescription;
- (void)dealloc;
- (id)descendantsByFilteringWithBlock:(BOOL(^)(XCElementSnapshot *snapshot))block;
- (id)description;
- (id)elementSnapshotMatchingAccessibilityElement:(id)arg1;
@property unsigned long long elementType; // @synthesize elementType=_elementType;
- (void)encodeWithCoder:(id)arg1;
- (void)enumerateDescendantsUsingBlock:(void(^)(XCElementSnapshot *snapshot))block;
@property struct CGRect frame; // @synthesize frame=_frame;
@property(nonatomic) unsigned long long generation; // @synthesize generation=_generation;
//- (BOOL)hasDescendantMatchingFilter:(CDUnknownBlockType)arg1;
@property _Bool hasFocus; // @synthesize hasFocus=_hasFocus;
@property _Bool hasKeyboardFocus; // @synthesize hasKeyboardFocus=_hasKeyboardFocus;
@property(readonly) struct CGPoint hitPoint;
@property(readonly) struct CGPoint hitPointForScrolling;
- (id)hitTest:(struct CGPoint)arg1;
@property long long horizontalSizeClass; // @synthesize horizontalSizeClass=_horizontalSizeClass;
@property(copy) NSString *identifier; // @synthesize identifier=_identifier;
@property(readonly, copy) NSArray *identifiers;
- (id)init;
- (id)initWithCoder:(id)arg1;
@property(getter=isEnabled) _Bool enabled; // @synthesize enabled=_enabled;
@property _Bool isMainWindow; // @synthesize isMainWindow=_isMainWindow;
@property(getter=isSelected) _Bool selected; // @synthesize selected=_selected;
@property(copy) NSString *label; // @synthesize label=_label;
@property XCElementSnapshot *parent; // @synthesize parent=_parent;
@property(retain) XCAccessibilityElement *parentAccessibilityElement; // @synthesize parentAccessibilityElement=_parentAccessibilityElement;
@property(readonly, copy) NSString *pathDescription;
@property(copy) NSString *placeholderValue; // @synthesize placeholderValue=_placeholderValue;
@property(readonly) NSString *recursiveDescription;
@property(readonly) NSString *recursiveDescriptionIncludingAccessibilityElement;
- (id)recursiveDescriptionWithIndent:(id)arg1 includeAccessibilityElement:(_Bool)arg2;
@property(readonly) XCElementSnapshot *scrollView;
@property(copy) NSString *title; // @synthesize title=_title;
@property unsigned long long traits; // @synthesize traits=_traits;
@property(copy) NSArray *userTestingAttributes; // @synthesize userTestingAttributes=_userTestingAttributes;
@property(copy) id value; // @synthesize value=_value;
@property long long verticalSizeClass; // @synthesize verticalSizeClass=_verticalSizeClass;
@property(readonly) NSArray *suggestedHitpoints;
@property(readonly, copy) NSString *truncatedValueString;
@property(readonly) struct CGRect visibleFrame;

@end
