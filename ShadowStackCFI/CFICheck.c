#include <stdio.h>

void CFICheck(long long target)
{
    long long *CFICheckAddressPtr = 0x1FFFFFFFFFFFFFFF;
    int CFICheckAddressNum = 0x1FFFFFFF;
    int low = 0, high = CFICheckAddressNum - 1, mid;
    while (low <= high)
    {
        mid = low + (high - low) / 2;
        if (mid >= high)
        {
            break;
        }
        if (CFICheckAddressPtr[mid] == target)
        {
            puts("found it!\n");
            return;
        }
        else if (CFICheckAddressPtr[mid] > target)
        {
            //ii_b = my_itoa(CFICheckAddressPtr[mid], , 10);
            puts("larger!\n");
            high = mid - 1;
        }
        else
        {
            puts("smaller!\n");
            low = mid + 1;
        }
    }
    //abort();
    exit(-1);
}
