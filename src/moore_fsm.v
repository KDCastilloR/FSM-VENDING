`timescale 1ns / 1ps
module moore_fsm (
    input clk,
    input reset,
    input [1:0] moneda,
    input comprarA,
    input comprarB,
    output reg listoA,
    output reg listoB,
    output reg [3:0] total,
    output reg vendA,
    output reg vendB
);

    localparam IDLE   = 3'b000;
    localparam WAIT   = 3'b001;

    reg [2:0] estado, siguiente;
    reg [3:0] acumulado;

    always @(posedge clk or posedge reset) begin
        if (reset)
            estado <= IDLE;
        else
            estado <= siguiente;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            acumulado <= 0;
        else begin
            if ((estado == IDLE || estado == WAIT) && moneda != 0) begin
                case (moneda)
                    2'b01: acumulado <= acumulado + 4'd2;
                    2'b10: acumulado <= acumulado + 4'd3;
                    2'b11: acumulado <= acumulado + 4'd4;
                    default: acumulado <= acumulado;
                endcase
            end else if (vendA || vendB) begin
                acumulado <= acumulado;
            end else begin
                acumulado <= acumulado;
            end
        end
    end

    always @(*) begin
        siguiente = estado;
        listoA = 0;
        listoB = 0;
        vendA = 0;
        vendB = 0;

        case (estado)
            IDLE: begin
                if (acumulado >= 4'd2)
                    siguiente = WAIT;
                else
                    siguiente = IDLE;
            end
            WAIT: begin
                if (acumulado >= 4'd3 && comprarB) begin
                    vendB = 1;
                    listoB = 1;
                    siguiente = IDLE;
                end else if (acumulado >= 4'd2 && comprarA) begin
                    vendA = 1;
                    listoA = 1;
                    siguiente = IDLE;
                end else begin
                    siguiente = WAIT;
                end
            end
            default: siguiente = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            total <= 0;
        else
            total <= acumulado;
    end

endmodule
