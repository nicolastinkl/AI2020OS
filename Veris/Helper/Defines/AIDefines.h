//
//  AIDefines.h
//  AIVeris
//
//  Created by 王坜 on 16/6/30.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//


/*
 XCode LLVM XXX - Preprocessing中Debug会添加 DEBUG=1 标志
 */
#ifdef DEBUG
#define AIOCLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define AIOCLog(FORMAT, ...) nil
#endif