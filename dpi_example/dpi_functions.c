// dpi_functions.c - C functions for DPI
#include <stdio.h>
#include <string.h>
#include "svdpi.h"

// ========== Declare SV functions that C will call ==========
extern int sv_multiply(int a, int b);
extern void sv_display(const char* msg);

// ========== C functions for SV to call ==========

// 简单的加法函数
int c_add(int a, int b) {
    int result = a + b;
    printf("[C] c_add called: %d + %d = %d\n", a, b, result);
    return result;
}

// 打印消息函数
void c_print_message(const char* msg) {
    printf("[C] c_print_message: %s\n", msg);
}

// 回调 SV 函数的测试
int c_callback_test(int value) {
    printf("[C] c_callback_test called with value=%d\n", value);
    
    // C 调用 SV 的 multiply 函数
    printf("[C] Now calling SV function sv_multiply(%d, %d)...\n", value, 2);
    int result = sv_multiply(value, 2);
    printf("[C] sv_multiply returned: %d\n", result);
    
    // C 调用 SV 的 display 函数
    sv_display("Hello from C code!");
    
    return result + 100;
}

// 可选：DPI 初始化函数
void dpi_init() {
    printf("[C] DPI library initialized\n");
}
