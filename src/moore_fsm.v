`timescale 1ns / 1ps
module moore_fsm (
    input logic clk, reset,
    input logic [1:0] moneda,
    input logic comprarA, comprarB,
    output logic listoA, listoB,
    output logic [3:0] total,
    output logic vendA, vendB
);

    typedef enum logic [2:0] {
        IDLE, WAIT, READY_A, READY_B
    } state_t;

    state_t estado, siguiente;

    logic [3:0] acumulado;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            estado <= IDLE;
        else
            estado <= siguiente;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            acumulado <= 0;
        else begin
            if ((estado == IDLE || estado == WAIT) && moneda != 0) begin
                case (moneda)
                    2'b01: acumulado <= acumulado + 2;
                    2'b10: acumulado <= acumulado + 3;
                    2'b11: acumulado <= acumulado + 4;
                    default: acumulado <= acumulado;
                endcase
            end else if (vendA || vendB) begin
                acumulado <= acumulado;
            end else begin
                acumulado <= acumulado;
            end
        end
    end

    assign total = acumulado;

    always_comb begin
        siguiente = estado;
        listoA = 0;
        listoB = 0;
        vendA = 0;
        vendB = 0;

        case (estado)
            IDLE: begin
                if (acumulado >= 2)
                    siguiente = WAIT;
                else
                    siguiente = IDLE;
            end
            WAIT: begin
                if (acumulado >= 3 && comprarB) begin
                    vendB = 1;
                    listoB = 1;
                    siguiente = IDLE;
                end else if (acumulado >= 2 && comprarA) begin
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

endmodule
