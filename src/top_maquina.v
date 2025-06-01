`timescale 1ns / 1ps
module top_maquina (
    input clk,
    input reset,
    input [1:0] moneda,
    input comprarA,
    input comprarB,
    output listoA,
    output listoB,
    output [3:0] total,
    output [3:0] cambio
);

    wire vendA, vendB;

    moore_fsm moore_inst (
        .clk(clk),
        .reset(reset),
        .moneda(moneda),
        .comprarA(comprarA),
        .comprarB(comprarB),
        .listoA(listoA),
        .listoB(listoB),
        .total(total),
        .vendA(vendA),
        .vendB(vendB)
    );

    mealy_fsm mealy_inst (
        .clk(clk),
        .reset(reset),
        .total(total),
        .vendA(vendA),
        .vendB(vendB),
        .cambio(cambio)
    );

endmodule
