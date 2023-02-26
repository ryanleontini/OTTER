`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/17/2023 07:22:29 PM
// Module Name: OTTER_WRAPPER
// Target Devices: Basys3
// Description: Top level wrapper for the OTTER_MCU. Adds connections to inputs
// BTNR, SWITCHES, INPUTS, CLK, and connections to outputs ANODES, CATHODES, 
// and LEDS.
//////////////////////////////////////////////////////////////////////////////////


module OTTER_WRAPPER(
    input BTNR, SWITCHES, INPUTS, CLK,
    output ANODES, CATHODES, LEDS
    )

    logic SWITCHES_INPUTS_MUX_OUT

    // clock divider
    logic HALF_CLK

    // switches mux
    logic MUX_SELECT

    // flip-flop mux
    logic FF_MUX_IN

    // flip-flops

    OTTER_MCU otter_mcu(.RST(BTNR), .IOBUS_IN(SWITCHES_INPUTS_MUX_OUT), .CLK(HALF_CLK), 
    .IOBUS_ADDR(MUX_SELECT), .IOBUS_WR(FF_MUX_IN), .IOBUS_OUT())


endmodule
