// tb.sv - SystemVerilog Testbench with DPI
module tb;

  // ========== Import C functions ==========
  // SV 调用 C 函数
  import "DPI-C" function int c_add(input int a, input int b);
  import "DPI-C" function void c_print_message(input string msg);
  import "DPI-C" context function int c_callback_test(input int value);
  
  // ========== Export SV functions ==========
  // C 调用 SV 函数
  export "DPI-C" function sv_multiply;
  export "DPI-C" function sv_display;
  
  // SV 实现的函数，供 C 调用
  function int sv_multiply(input int a, input int b);
    sv_multiply = a * b;
    $display("[SV] sv_multiply called: %0d * %0d = %0d", a, b, sv_multiply);
  endfunction
  
  function void sv_display(input string msg);
    $display("[SV] sv_display called: %s", msg);
  endfunction
  
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
    
    $display("\n=== All tests completed ===");
    $finish;
  end

endmodule
