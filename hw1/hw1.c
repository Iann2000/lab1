#include <stdio.h>
#include <stdint.h>

uint16_t count_exponent(uint64_t x)
{
  x |= (x >> 1);
  x |= (x >> 2);
  x |= (x >> 4);
  x |= (x >> 8);
  x |= (x >> 16);
  x |= (x >> 32);

  /* 計算二進制表示中1的個數，以找到前導零數 */
  x -= ((x >> 1) & 0x5555555555555555);
  x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
  x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
  x += (x >> 8);
  x += (x >> 16);
  x += (x >> 32);

  // 直接返回計算的前導零數
  return (32 - (x & 0x7f)); // 32個０減掉msb之後的0數量
}

int main()
{
  uint64_t test_data[] = {0x00000011, 0x00001101, 0x00010011};

  for (int i = 0; i < sizeof(test_data) / sizeof(test_data[0]); i++)
  {
    uint32_t clz = count_exponent(test_data[i]);

    if (clz < 32)
    {
      uint32_t msb = (uint32_t)(31 - clz);
      printf("Test Data %d:\n", i + 1);
      printf("Input: 0x%016llX\n", test_data[i]);
      printf("Leading Zeros: %u\n", clz);
      printf("MSB: %u\n", msb);
    }
    else
    {
      printf("Test Data %d: Invalid input, cannot calculate MSB.\n", i + 1);
    }

    printf("\n");
  }

  return 0;
}
