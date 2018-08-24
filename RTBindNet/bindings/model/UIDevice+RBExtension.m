//
//  UIDevice+RBExtension.m
//  Pods
//
//  Created by baxiang on 2017/9/27.
//

#import "UIDevice+RBExtension.h"
 #import <SystemConfiguration/CaptiveNetwork.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/utsname.h>
@implementation UIDevice (RBExtension)

+ (NSString *)deviceName
{
    static NSString *deviceName = nil;
    
    if (deviceName == nil) {
        struct utsname systemInfo;
        uname(&systemInfo);
        //UI_USER_INTERFACE_IDIOM
        deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    return deviceName;
}

+ (NSString *)platformString{
    
    NSString *platform = [self deviceName];
    
    if ([platform hasPrefix:@"iPhone"]) {
        
        if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
        if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
        if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
        
        return @"iPhone";
    }
    
    if ([platform hasPrefix:@"iPod"]) {
        
        if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1";
        if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
        if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
        if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
        if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
        if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6";
        
        return @"iPod Touch";
    }
    
    if ([platform hasPrefix:@"iPad"]) {
        
        if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
        if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
        if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
        if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
        if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
        if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
        if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
        if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
        if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
        if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
        if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
        if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
        if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
        if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
        if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (CDMA)";
        if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
        if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (Cellular)";
        if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
        if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
        if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (Cellular)";
        if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
        if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
        if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
        if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
        if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7-inch (WiFi)";
        if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7-inch (Cellular)";
        if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9-inch (WiFi)";
        if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9-inch (Cellular)";
        if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
        if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
        if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9-inch (WiFi)";
        if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9-inch (Cellular)";
        if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5-inch (WiFi)";
        if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5-inch (Cellular)";
        
        return @"iPad";
    }
    
    if ([platform hasPrefix:@"Watch"]) {
        
        if ([platform isEqualToString:@"Watch1,1"])      return @"Apple Watch 38mm";
        if ([platform isEqualToString:@"Watch1,2"])      return @"Apple Watch 42mm";
        if ([platform isEqualToString:@"Watch2,6"])      return @"Apple Watch Series 1 38mm";
        if ([platform isEqualToString:@"Watch2,7"])      return @"Apple Watch Series 1 42mm";
        if ([platform isEqualToString:@"Watch2,3"])      return @"Apple Watch Series 2 38mm";
        if ([platform isEqualToString:@"Watch2,4"])      return @"Apple Watch Series 2 42mm";
        
        return @"Apple Watch";
        
    }
    
    if ([platform hasPrefix:@"AppleTV"]) {
        
        return @"AppleTV";
    }
    
    if ([platform isEqualToString:@"i386"])              return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])            return @"Simulator";
    if ([platform isEqualToString:@"Simulator"])         return @"Simulator";
    
    return @"未知设备";
}



+ (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

+ (NSString *)wiFiIPAddress {
    return [UIDevice ipAddressWithIfaName:@"en0"];
}

+ (NSString *)cellIPAddress {
    return [UIDevice ipAddressWithIfaName:@"pdp_ip0"];
}

+(NSString *)wiFiSSID
{
#if TARGET_OS_SIMULATOR
    return @"(simulator)";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;
    
    return ssid;
#endif
}
@end
