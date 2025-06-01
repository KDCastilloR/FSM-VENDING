`timescale 1ns / 1ps
module mealy_fsm (
    input clk,
    input reset,
    input [3:0] total,
    input vendA,
    input vendB,
    output reg [3:0] cambio
);

    reg [3:0] saldo;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            saldo <= 0;
            cambio <= 0;
        end else begin
            if (vendA) begin
                saldo <= total - 4'd2;
                cambio <= total - 4'd2;
            end else if (vendB) begin
                saldo <= total - 4'd3;
                cambio <= total - 4'd3;
            end else begin
                saldo <= total;
                cambio <= 0;
            end
        end
    end

endmodule
