#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>  // using malloc functions


// count cycle
typedef uint64_t ticks;

static inline ticks getticks(void)

{   uint64_t result;
    uint32_t l, h, h2;
    asm volatile(
        "rdcycleh %0\n"
        "rdcycle %1\n"
        "rdcycleh %2\n"
        "sub %0, %0, %2\n"
        "seqz %0, %0\n"
        "sub %0, zero, %0\n"
        "and %1, %1, %0\n"
        : "=r"(h), "=r"(l), "=r"(h2));
    result = (((uint64_t) h) << 32) | ((uint64_t) l);
    return result;
}

// def linkedlist structure
typedef struct Node {
    uint32_t data; // 32 bits unsigned integers
    struct Node* next;
} Node;

// calculate 32bits  unsigned int count of leading zeros
uint16_t count_leading_zeros(uint32_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x1f)); // 32 bits unsigned int leading zeors
}

// calculate all linkedlists node clz and sum
uint64_t sum_of_leading_zeros(Node* head)
{
    uint64_t sum = 0;

    while (head != NULL) {
        uint16_t leadingZeros = count_leading_zeros(head->data);
        sum += leadingZeros;
        head = head->next;
    }

    return sum;
}


int main()
{
    ticks t0 = getticks();
    
    
    // create a simple linked list
    Node* head = NULL;
    Node* node1 = malloc(sizeof(Node));
    node1->data = 23;
    node1->next = NULL;
    head = node1;

    Node* node2 = malloc(sizeof(Node));
    node2->data = 15;
    node2->next = NULL;
    node1->next = node2;

    Node* node3 = malloc(sizeof(Node));
    node3->data = 1
    ;
    node3->next = NULL;
    node2->next = node3;

    // calculate sum of linkedlist node leading zeors for 32bits unsigned integers
    uint64_t totalLeadingZeros = sum_of_leading_zeros(head);
    printf("Sum of Leading Zeros: %llu\n", totalLeadingZeros);

    // release linked list node memory
    while (head != NULL) {
        Node* temp = head;
        head = head->next;
        free(temp);
    }
    
    ticks t1 = getticks();
    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);    //cycle number
   
    return 0;
}
