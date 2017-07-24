//
//  ColumnModel.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/14.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ColumnModel.h"

@implementation ColumnModel

+ (instancetype)columnModelTitle:(NSString *)title state:(itemState)state iconImage:(NSString *)imageName {
    ColumnModel * model = [[ColumnModel alloc] init];
    model.title = title;
    model.state = state;
    model.imageName = imageName;
    return model;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _state = [[aDecoder decodeObjectForKey:@"state"] integerValue];
        _imageName = [aDecoder decodeObjectForKey:@"imageName"];
        _columnUrl = [aDecoder decodeObjectForKey:@"columnUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%lu",(unsigned long)_state] forKey:@"state"];
    [aCoder encodeObject:_imageName forKey:@"imageName"];
    [aCoder encodeObject:_columnUrl forKey:@"columnUrl"];
}

- (id)copyWithZone:(NSZone *)zone {
    ColumnModel * copyModel = [[ColumnModel allocWithZone:zone] init];
    copyModel.title = self.title;
    copyModel.state = self.state;
    copyModel.imageName = self.imageName;
    copyModel.columnUrl = self.columnUrl;
    
    return copyModel;
}



- (NSString *)description {
    return [NSString stringWithFormat:@"%@----%lu--%p",self.title,(unsigned long)self.state,self];
}

@end
