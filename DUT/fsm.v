module fsm(
    input  wire         clk,
    input  wire         start,
    input  wire [1:0]   s,
    input  wire [127:0] data_in,
    output reg          done,
    output reg [127:0]  data_out
);

    localparam [1:0] State_Reset    = 2'b01,
                     State_SubBytes = 2'b00,
                     State_MixColms = 2'b10;

    reg [127:0] data_reg; 

    wire [127:0] sb_out;
    wire [127:0] mc_out;
    wire reset = s[0];
    wire chain = s[1];

    subBytes u_sub(.in(data_reg), .out(sb_out));
    mix_coloumns u_mix(.Col_in(sb_out), .Col_out(mc_out));

    reg [1:0] current_state, next_state;
    reg done_nxt;
    reg calc_wait, calc_wait_nxt;

    always @(*) begin
        next_state    = current_state;
        calc_wait_nxt = 1'b0;
        
        done_nxt      = calc_wait; 

        case (current_state)
            State_Reset: begin
                if (start) begin
                    calc_wait_nxt = 1'b1; 
                    if (chain) next_state = State_MixColms;
                    else       next_state = State_SubBytes;
                end
            end

            State_SubBytes: begin
                if (chain) begin
                    next_state    = State_MixColms;
                    calc_wait_nxt = 1'b1;
                    done_nxt      = 1'b0;
                end else begin
                    next_state = State_SubBytes;
                end
            end

            State_MixColms: begin
                if (!chain) begin
                    next_state    = State_SubBytes;
                    calc_wait_nxt = 1'b1;
                    done_nxt      = 1'b0;
                end else begin
                    next_state = State_MixColms;
                end
            end

            default: next_state = State_Reset;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= State_Reset;
            data_reg      <= 128'b0;
            data_out      <= 128'b0;
            done          <= 1'b0;
            calc_wait     <= 1'b0;
        end else begin
            current_state <= next_state;
            done          <= done_nxt;
            calc_wait     <= calc_wait_nxt;

            if (start) begin
                data_reg <= data_in;
            end

            if (current_state == State_SubBytes) begin
                data_out <= sb_out;
            end

            if (current_state == State_MixColms) begin
                data_out <= mc_out;
            end
        end
    end

endmodule
