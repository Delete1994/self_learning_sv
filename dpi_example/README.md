# DPI Example - C and SystemVerilog Interaction

这个示例演示了如何使用 SystemVerilog DPI (Direct Programming Interface) 实现 C 代码和 SystemVerilog 之间的互相调用。

## 文件说明

- **tb.sv**: SystemVerilog testbench
  - 定义了导入的 C 函数 (import "DPI-C")
  - 定义了导出的 SV 函数 (export "DPI-C")
  - 包含测试逻辑

- **dpi_functions.c**: C 实现文件
  - 实现了供 SV 调用的 C 函数
  - 调用了 SV 导出的函数

- **Makefile**: 编译和运行脚本
  - 支持 VCS、QuestaSim、Xcelium 仿真器

## 功能演示

### 1. SV 调用 C 函数
```systemverilog
result = c_add(10, 20);  // SV 调用 C 的加法函数
```

### 2. C 调用 SV 函数
```c
int result = sv_multiply(value, 2);  // C 调用 SV 的乘法函数
sv_display("Hello from C!");         // C 调用 SV 的显示函数
```

### 3. 回调机制
```
SV -> c_callback_test() -> sv_multiply() -> 返回给 C -> 返回给 SV
```

## 使用方法

### VCS

VCS 提供了三种使用 DPI 的方式：

#### 1. 直接编译 C 文件（推荐用于开发）
```bash
make vcs
```
- 将 C 文件直接编译到仿真可执行文件中
- 最简单直接的方式

#### 2. 编译时链接共享库
```bash
make vcs_svlib
```
- 先将 C 代码编译为 `libdpi_functions.so`
- 编译时将共享库链接到 simv
- 适合需要复用共享库的场景

#### 3. 运行时加载共享库
```bash
make vcs_runtime
```
- 编译 SV 代码时不链接 DPI 库
- 运行时通过 `-sv_lib` 选项动态加载
- 优点：可以不重新编译就替换 DPI 库
- 适合频繁修改 C 代码的场景

### QuestaSim/ModelSim
```bash
make questa
```

### Xcelium
```bash
make xcelium
```

### 查看所有选项
```bash
make help
```

### 清理生成文件
```bash
make clean
```

## 预期输出

```
=== DPI Example: C and SystemVerilog Interaction ===

Test 1: SV calls C function
[C] c_add called: 10 + 20 = 30
[SV] Result from c_add(10, 20) = 30

Test 2: SV calls C print function
[C] c_print_message: Hello from SystemVerilog!

Test 3: C calls SV function (callback)
[C] c_callback_test called with value=15
[C] Now calling SV function sv_multiply(15, 2)...
[SV] sv_multiply called: 15 * 2 = 30
[C] sv_multiply returned: 30
[SV] sv_display called: Hello from C code!
[SV] Result from callback test = 130

Test 4: Multiple interactions
[C] c_add called: 10 + 5 = 15
[SV] Iteration 1: c_add(10, 5) = 15
[C] c_add called: 20 + 10 = 30
[SV] Iteration 2: c_add(20, 10) = 30
[C] c_add called: 30 + 15 = 45
[SV] Iteration 3: c_add(30, 15) = 45

=== All tests completed ===
```

## 系统要求

- Linux 操作系统
- 以下任一仿真器：
  - Synopsys VCS
  - Mentor QuestaSim/ModelSim
  - Cadence Xcelium
- GCC 编译器

## 注意事项

1. **路径设置**: 确保仿真器在 PATH 中
2. **许可证**: 需要有效的仿真器许可证
3. **DPI 支持**: 使用 SystemVerilog 2005 或更高版本
4. **共享库命名**:
   - VCS 运行时 `-sv_lib xxx` 会查找 `xxx.so`
   - 标准库命名是 `libxxx.so`
   - Makefile 自动创建符号链接解决命名差异

## 三种方式的对比

| 方式 | 命令 | 编译时间 | 运行时 | 适用场景 |
|------|------|---------|--------|---------|
| 直接编译 | `make vcs` | 快 | 快 | 开发调试 |
| 编译时链接 | `make vcs_svlib` | 中等 | 快 | 生产环境 |
| 运行时加载 | `make vcs_runtime` | 快（仅 SV） | 稍慢 | C 代码频繁修改 |

**选择建议**:
- 简单项目或快速验证：使用 `make vcs`
- 需要复用 DPI 库：使用 `make vcs_svlib`
- 调试 C 代码时：使用 `make vcs_runtime`（改 C 代码后只需重新编译 .so）

## 扩展方向

- 传递结构体/数组
- 使用 open array
- 处理复杂数据类型
- 多线程交互
- 性能优化