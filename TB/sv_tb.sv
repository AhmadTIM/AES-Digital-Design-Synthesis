`timescale 1ns/1ps

module fsm_tb_sv;

    // -------------------------------------------------
    // Clock
    // -------------------------------------------------
    logic clk;
    initial clk = 1;
    always #5 clk = ~clk;

    // -------------------------------------------------
    // Interface to DUT
    // -------------------------------------------------
    logic         start;
    logic [1:0]   s;
    logic [127:0] data_in;
    logic         done;
    logic [127:0] data_out;

    // -------------------------------------------------
    // DUT
    // -------------------------------------------------
    fsm dut (
        .clk      (clk),
        .start    (start),
        .s        (s),
        .data_in  (data_in),
        .done     (done),
        .data_out (data_out)
    );

    // -------------------------------------------------
    // Scoreboard
    // -------------------------------------------------
    int passed = 0;
    int failed = 0;

    // -------------------------------------------------
    // BFM
    // -------------------------------------------------
    task automatic send_transaction(input [1:0] sel, input [127:0] din);
        @(negedge clk);
        s       = sel;
        data_in = din;
        start   = 1'b1;
        @(posedge clk);
        start = 1'b0;
    endtask

    // -------------------------------------------------
    // Checker
    // -------------------------------------------------
    task automatic check_result(input [127:0] expected, input [2:0] test_num);
        begin
            if (data_out !== expected) begin
                $display("TEST %d ERROR: expected=%h got=%h",test_num, expected, data_out);
                failed++;
            end else begin
                $display("TEST %d PASS : result=%h",test_num, data_out);
                passed++;
            end
        end
    endtask

    // -------------------------------------------------
    // Assertions
    // -------------------------------------------------
    property one_cycle_done;
        @(posedge clk)
            done |=> !done;
    endproperty
    assert property (one_cycle_done)
        else $error("DONE was not for one cycle");

    property valid_data_when_done;
        @(posedge clk)
            done |-> !$isunknown(data_out);
    endproperty
    assert property (valid_data_when_done)
        else $error("data_out was invalid when done was 1");
    // -------------------------------------------------
    // Coverage
    // -------------------------------------------------

    covergroup fsm_states @(posedge clk);
        coverpoint dut.current_state {
            bins reset    = {dut.State_Reset};
            bins state1   = {dut.State_SubBytes};
            bins state2   = {dut.State_MixColms};
        }
        coverpoint s {
            bins reset_cmds = {2'b01, 2'b11};
            bins op_cmds    = {2'b00, 2'b10};
        }
    endgroup

    covergroup fsm_transitions @(posedge clk);
        coverpoint dut.current_state {
            bins reset_to_s1 = (dut.State_Reset    => dut.State_SubBytes);
            bins s1_to_s2    = (dut.State_SubBytes => dut.State_MixColms);
            bins s2_to_s1    = (dut.State_MixColms => dut.State_SubBytes);
        }
    endgroup

    fsm_states      cg_states = new();
    fsm_transitions cg_trans = new();
    
    // -------------------------------------------------
    // Test Sequence
    // -------------------------------------------------
    initial begin
        start   = 1'b0;
        s       = 2'b01;
        data_in = '0;

	//reset
        send_transaction(2'b01, '0);
        wait (dut.current_state == dut.State_Reset);
        @(posedge clk);

        // -------------------------------------------------
        // TESTS
        // -------------------------------------------------
        // test 1
        send_transaction(2'b00, 128'h19f48d08a0c648be9af8e32be93de22a);  //subbytes
        wait (done);
        check_result(128'hd4bf5d30e0b452aeb84111f11e2798e5, 1);
        @(posedge clk);
        send_transaction(2'b10, 128'h19f48d08a0c648be9af8e32be93de22a);  //subbytes+mixcolumns
        wait (done);
        check_result(128'h046681e5e0cb199a48f8d37a2806264c, 1);
        @(posedge clk);
        //-----------------------------------------------------
        // test 2
        send_transaction(2'b00, 128'h19f48d08a0c648be9af8e32be93de22a);  //subbytes
        wait (done);
        check_result(128'hd4bf5d30e0b452aeb84111f11e2798e5, 2);
        @(posedge clk);
        send_transaction(2'b10, 128'h19f48d08a0c648be9af8e32be93de22a);  //subbytes+mixcolumns
        wait (done);
        check_result(128'h046681e5e0cb199a48f8d37a2806264c, 2);
        @(posedge clk);
        //-----------------------------------------------------
        // test 3
        send_transaction(2'b00, 128'h19f48d08a0c648be9af8e32be93de22a);  //subbytes
        wait (done);
        check_result(128'hd4bf5d30e0b452aeb84111f11e2798e5, 3);
        @(posedge clk);
        send_transaction(2'b10, 128'h19f48d08a0c648be9af8e32be93de22a);  //subbytes+mixcolumns
        wait (done);
        check_result(128'h046681e5e0cb199a48f8d37a2806264c, 3);
        @(posedge clk);
        //-----------------------------------------------------
        // test 4
        send_transaction(2'b00, 128'h193de3bea0f4e22b9ac68d2ae9f84808);  //subbytes
        wait (done);
        check_result(128'hd42711aee0bf98f1b8b45de51e415230, 4);
        @(posedge clk);
        send_transaction(2'b10, 128'h193de3bea0f4e22b9ac68d2ae9f84808);  //subbytes+mixcolumns
        wait (done);
        check_result(128'h6507381668c77ce514c982eb9d5aab51, 4);
        @(posedge clk);
        //-------------------------------------------------------
        // test 5
        send_transaction(2'b00, 128'h5c4390134a5d8692053d6ca08584b0c3);  //subbytes
        wait (done);
        check_result(128'h4a1a607dd64c444f6b2750e0975fe72e, 5);
        @(posedge clk);
        send_transaction(2'b10, 128'h5c4390134a5d8692053d6ca08584b0c3);  //subbytes+mixcolumns
        wait (done);
        check_result(128'ha7a3175e68cdc3f70f35d7111d356f46, 5);
        @(posedge clk);
        //------------------------------------------------------
        // test 6
        send_transaction(2'b00, 128'hea4598c5045db0f065965c2d858333ad);  //subbytes
        wait (done);
        check_result(128'h876e46a6f24ce78c4d904ad897ecc395, 6);
        @(posedge clk);
        send_transaction(2'b11, '0);
        wait (dut.current_state == dut.State_Reset);
        @(posedge clk);
        send_transaction(2'b10, 128'hea4598c5045db0f065965c2d858333ad);  //subbytes+mixcolumns
        wait (done);
        check_result(128'h473794ed40d4e4a5a3703aa64c9f42bc, 6);
        @(posedge clk);
        // -------------------------------------------------
        // Finish
        // -------------------------------------------------
        $display("TEST FINISHED: PASSED=%0d FAILED=%0d", passed, failed);
        $finish;
    end

endmodule
