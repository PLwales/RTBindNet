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
