`timescale 1ns / 1ps
module top_maquina (
    input logic clk,
    input logic reset,
    input logic [1:0] moneda,
    input logic comprarA,
    input logic comprarB,
    output logic listoA,
    output logic listoB,
    output logic [3:0] total,
    output logic [3:0] cambio
);

    logic vendA, vendB;

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

