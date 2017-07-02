//
//  main.m
//  luaoc
//
//  Created by tajoy on 2017/7/2.
//  Copyright © 2017年 tajoy. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <objc/objc.h>
#include <objc/message.h>
#include <objc/runtime.h>

#include "stdio.h"
#include <string>

#include "lua.hpp"


void addLuaLoader(lua_State* L, lua_CFunction func)
{
    if (!func) return;
    
    // stack content after the invoking of the function
    // get loader table
    lua_getglobal(L, "package");                                  /* L: package */
    lua_getfield(L, -1, "loaders");                               /* L: package, loaders */
    
    // insert loader into index 2
    lua_pushcfunction(L, func);                                   /* L: package, loaders, func */
    for (int i = (int)(lua_objlen(L, -2) + 1); i > 2; --i)
    {
        lua_rawgeti(L, -2, i - 1);                                /* L: package, loaders, func, function */
        // we call lua_rawgeti, so the loader table now is at -3
        lua_rawseti(L, -3, i);                                    /* L: package, loaders, func */
    }
    lua_rawseti(L, -2, 2);                                        /* L: package, loaders */
    
    // set loaders into package
    lua_setfield(L, -2, "loaders");                               /* L: package */
    
    lua_pop(L, 1);
}

void skipBOM(const char*& chunk, int& chunkSize)
{
    // UTF-8 BOM? skip
    if (static_cast<unsigned char>(chunk[0]) == 0xEF &&
        static_cast<unsigned char>(chunk[1]) == 0xBB &&
        static_cast<unsigned char>(chunk[2]) == 0xBF)
    {
        chunk += 3;
        chunkSize -= 3;
    }
}

int luaLoadBuffer(lua_State *L, const char *chunk, int chunkSize, const char *chunkName)
{
    int r = 0;
    
    skipBOM(chunk, chunkSize);
    r = luaL_loadbuffer(L, chunk, chunkSize, chunkName);

    if (r)
    {
        switch (r)
        {
            case LUA_ERRSYNTAX:
                NSLog(@"[LUA ERROR] load \"%s\", error: syntax error during pre-compilation.", chunkName);
                break;
                
            case LUA_ERRMEM:
                NSLog(@"[LUA ERROR] load \"%s\", error: memory allocation error.", chunkName);
                break;
                
            case LUA_ERRFILE:
                NSLog(@"[LUA ERROR] load \"%s\", error: cannot open/read file.", chunkName);
                break;
                
            default:
                NSLog(@"[LUA ERROR] load \"%s\", error: unknown.", chunkName);
        }
    }
    return r;
}

typedef struct {
    unsigned char * data;
    size_t size;
} Data;
static NSFileManager* s_fileManager = [NSFileManager defaultManager];

NSString * fullpath(std::string filePath)
{
    if (filePath.empty())
    {
        return nil;
    }
    
    if (filePath[0] == '/')
    {
        return  [NSString stringWithUTF8String:filePath.c_str()];
    }
    
    std::string path;
    std::string file;
    size_t pos = filePath.find_last_of("/");
    if (pos != std::string::npos)
    {
        file = filePath.substr(pos+1);
        path = filePath.substr(0, pos+1);
    }
    else
    {
        file = filePath;
    }
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* fullpath = [bundle pathForResource:[NSString stringWithUTF8String:file.c_str()]
                                          ofType:nil
                                     inDirectory:[NSString stringWithUTF8String:path.c_str()]];
    if (fullpath == nil)
    {
        path = "src/" + path;
        fullpath = [bundle pathForResource:[NSString stringWithUTF8String:file.c_str()]
                                 ofType:nil
                            inDirectory:[NSString stringWithUTF8String:path.c_str()]];
        return fullpath;
    }
    return fullpath;
}

bool isFileExist(std::string filePath)
{
    
    if (filePath.empty())
    {
        return false;
    }
    
    bool ret = false;
    
    if (filePath[0] != '/')
    {
        NSString* fullPath =  fullpath(filePath);
        if (fullPath != nil) {
            ret = true;
        }
    }
    else
    {
        // Search path is an absolute path.
        if ([s_fileManager fileExistsAtPath:[NSString stringWithUTF8String:filePath.c_str()]]) {
            ret = true;
        }
    }
    
    return ret;
}

Data getDataFromFile(std::string filePath)
{
    Data ret;
    NSData* data = [s_fileManager contentsAtPath:fullpath(filePath)];
    void* newdata = malloc([data length]);
    memcpy(newdata, [data bytes], [data length]);
    ret.data = (unsigned char *)newdata;
    ret.size = [data length];
    return ret;
}

int resource_lua_loader(lua_State *L)
{
    static const std::string BYTECODE_FILE_EXT    = ".luac";
    static const std::string NOT_BYTECODE_FILE_EXT = ".lua";
    
    std::string filename(luaL_checkstring(L, 1));
    size_t pos = filename.rfind(BYTECODE_FILE_EXT);
    if (pos != std::string::npos)
    {
        filename = filename.substr(0, pos);
    }
    else
    {
        pos = filename.rfind(NOT_BYTECODE_FILE_EXT);
        if (pos == filename.length() - NOT_BYTECODE_FILE_EXT.length())
        {
            filename = filename.substr(0, pos);
        }
    }
    
    pos = filename.find_first_of(".");
    while (pos != std::string::npos)
    {
        filename.replace(pos, 1, "/");
        pos = filename.find_first_of(".");
    }
    
    // search file in package.path
    Data chunk;
    chunk.data = NULL;
    chunk.size = 0;
    std::string chunkName;
    
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "path");
    std::string searchpath(lua_tostring(L, -1));
    lua_pop(L, 1);
    size_t begin = 0;
    size_t next = searchpath.find_first_of(";", 0);
    
    do
    {
        if (next == std::string::npos)
            next = searchpath.length();
        std::string prefix = searchpath.substr(begin, next);
        if (prefix[0] == '.' && prefix[1] == '/')
        {
            prefix = prefix.substr(2);
        }
        
        pos = prefix.find("?.lua");
        chunkName = prefix.substr(0, pos) + filename + BYTECODE_FILE_EXT;
        if (isFileExist(chunkName))
        {
            chunk = getDataFromFile(chunkName);
            break;
        }
        else
        {
            chunkName = prefix.substr(0, pos) + filename + NOT_BYTECODE_FILE_EXT;
            if (isFileExist(chunkName))
            {
                chunk = getDataFromFile(chunkName);
                break;
            }
        }
        
        begin = next + 1;
        next = searchpath.find_first_of(";", begin);
    } while (begin < (int)searchpath.length());
    
    if (chunk.data)
    {
        luaLoadBuffer(L, reinterpret_cast<const char*>(chunk.data),
                             static_cast<int>(chunk.size), chunkName.c_str());
    }
    else
    {
        NSLog(@"can not get file data of %s", chunkName.c_str());
        return 0;
    }
    
    if (chunk.data)
    {
        free(chunk.data);
    }
    
    return 1;
}

int main(int argc, char * args[])
{
    @autoreleasepool {
        lua_State* L = luaL_newstate();
        luaL_openlibs(L);
        addLuaLoader(L, resource_lua_loader);
        NSBundle * bundle = [NSBundle mainBundle];
        NSString * main_file = [bundle pathForResource:@"test/main" ofType:@"lua"];
        NSLog(@"run file: %@", main_file);
        luaL_dofile(L, [main_file UTF8String]);
        const char* msg = lua_tostring(L, -1);
        if (msg)
        {
            NSLog(@"%s", msg);
        }
    }
    return 0;
}
