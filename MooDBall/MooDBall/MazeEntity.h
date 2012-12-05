//
//  MazeEntity.h
//  MooDBall
//
//  Created by Vladislav Saveliev on 29 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//


@interface MazeEntity : NSManagedObject

@property (nonatomic) int16_t height;
@property (nonatomic) int16_t width;
@property (nonatomic, retain) NSData * data;

@end
