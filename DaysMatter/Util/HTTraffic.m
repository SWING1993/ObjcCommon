//
//  HTTraffic.m
//  Moments
//
//  Created by 宋国华 on 2018/10/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "HTTraffic.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation HTTraffic

+ (NSDictionary *)trafficMonitorings {
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    
    long long WiFiSent = 0;
    long long WiFiReceived = 0;
    long long WiFiTotal = 0;

    long long WWANSent = 0;
    long long WWANReceived = 0;
    long long WWANTotal = 0;

    if (getifaddrs(&addrs) == 0)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
#ifdef DEBUG
                const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                if (ifa_data != NULL)
                {
                    NSLog(@"Interface name %s: sent %tu received %tu",cursor->ifa_name,ifa_data->ifi_obytes,ifa_data->ifi_ibytes);
                }
#endif
                
                // name of interfaces:
                // en0 is WiFi
                // pdp_ip0 is WWAN
                NSString *name = @(cursor->ifa_name);
                if ([name hasPrefix:@"en"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if (ifa_data != NULL)
                    {
                        WiFiSent += ifa_data->ifi_obytes;
                        WiFiReceived += ifa_data->ifi_ibytes;
                    }
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
                    if (ifa_data != NULL)
                    {
                        WWANSent += ifa_data->ifi_obytes;
                        WWANReceived += ifa_data->ifi_ibytes;
                    }
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    WiFiTotal = WiFiSent + WiFiReceived;
    WWANTotal = WWANSent + WWANReceived;
    return @{DataCounterKeyWiFiSent : @(WiFiSent),
             DataCounterKeyWiFiReceived : @(WiFiReceived),
             DataCounterKeyWiFiTotal : @(WiFiTotal),
             DataCounterKeyWWANSent : @(WWANSent),
             DataCounterKeyWWANReceived : @(WWANReceived),
             DataCounterKeyWWANTotal: @(WWANTotal)};
}

+ (NSString *)bytesToAvaiUnit:(long long)bytes {
    if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

@end
