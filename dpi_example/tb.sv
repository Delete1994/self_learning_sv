// tb.sv - SystemVerilog Testbench with DPI
module tb;

  // 时钟信号
  logic clk = 0;
  always #5 clk = ~clk;  // 10ns 周期

  // ========== Import C functions ==========
  // SV 调用 C 函数
  import "DPI-C" function int c_add(input int a, input int b);
  import "DPI-C" function void c_print_message(input string msg);
  import "DPI-C" context function int c_callback_test(input int value);
  import "DPI-C" context task c_test_task_call();  // 必须是 task，因为会调用带时间延迟的 SV task
  
  // ========== Export SV functions ==========
  // C 调用 SV 函数
  export "DPI-C" function sv_multiply;
  export "DPI-C" function sv_display;
  export "DPI-C" task sv_wait_cycles;
  
  // SV 实现的函数，供 C 调用
  function int sv_multiply(input int a, input int b);
    sv_multiply = a * b;
    $display("[SV] sv_multiply called: %0d * %0d = %0d", a, b, sv_multiply);
  endfunction
  
  function void sv_display(input string msg);
    $display("[SV] sv_display called: %s", msg);
  endfunction
  
  // SV 实现的 task（带时间延迟），供 C 调用
  task sv_wait_cycles(input int cycles);
    $display("[SV] sv_wait_cycles: Starting to wait %0d cycles at time %0t", cycles, $time);
    repeat(cycles) @(posedge clk);
    $display("[SV] sv_wait_cycles: Completed waiting %0d cycles at time %0t", cycles, $time);
  endtask
  
  // ========== Testbench logic ==========
  initial begin
    int result;
    
    $display("=== DPI Example: C and SystemVerilog Interaction ===\n");
    
    // 1. SV 调用 C 函数进行加法运算
    $display("Test 1: SV calls C function");
    result = c_add(10, 20);
    $display("[SV] Result from c_add(10, 20) = %0d\n", result);
    
    // 2. SV 调用 C 函数打印消息
    $display("Test 2: SV calls C print function");
    c_print_message("Hello from SystemVerilog!");
    $display("");
    
    // 3. C 函数回调 SV 函数
    $display("Test 3: C calls SV function (callback)");
    result = c_callback_test(15);
    $display("[SV] Result from callback test = %0d\n", result);
    
    // 4. 多次交互测试
    $display("Test 4: Multiple interactions");
    for (int i = 1; i <= 3; i++) begin
      result = c_add(i * 10, i * 5);
      $display("[SV] Iteration %0d: c_add(%0d, %0d) = %0d", i, i*10, i*5, result);
    end
    
    // 5. C 调用 SV task（带时间延迟）
    $display("\nTest 5: C calls SV task with time delay");
    c_test_task_call();
    
    $display("\n=== All tests completed ===");
    $finish;
  end

endmodule
