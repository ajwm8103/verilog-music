module music(clk, speaker);
    input clk;
    output speaker;
    //parameter clkdivider = 27000000/440/2;

    logic[6:0] pitch;
    logic[14:0] durationms;
    logic[25:0] duration;
    logic[4:0] octave;

    

    // Count down until note is done
    reg [25:0] counter_note = 0;
    always @(posedge clk) if(counter_note==0) counter_note <= duration; else counter_note <= counter_note-1;

    // Change note id when note is done
    reg[9:0] note_id = 0;
    always @(posedge clk) if (counter_note==0) note_id <= note_id+1;

    logic[8:0] clkdivider = 0;
    song_level1 u0(note_id, pitch, durationms, octave);
    pitch_to_freq u1(pitch, clkdivider);
    durationms_to_duration u2(durationms, duration);

    reg [23:0] tone = 0;
    always @(posedge clk) tone <= tone+1;

    reg [14:0] counter = 0;
    always @(posedge clk) if(counter==0) counter <= (tone[23] ? clkdivider/2-1 : clkdivider-1); else counter <= counter-1;

    reg [7:0] counter_octave = 0;
    always @(posedge clk)
        if(counter_note==0)
        begin
            if(counter_octave==0)
                counter_octave <= (octave==0?511:octave==1?255:octave==2?127:octave==3?63:octave==4?31:octave==5?15:octave==6?7:octave==7?3:octave==8?1:0);
            else
                counter_octave <= counter_octave-1;
        end

    reg speaker = 0;
    always @(posedge clk) if(counter==0) speaker <= ~speaker;
endmodule

module pitch_to_freq(input logic[6:0] pitch, output logic[8:0] clkdivider);
    always_comb
        case (pitch)
            0: clkdivider = 14080; // A
            1: clkdivider = 14917; // A#/Bb
            2: clkdivider = 15804; // B
            3: clkdivider = 8372; // C
            4: clkdivider = 8870; // C#/Db
            5: clkdivider = 9397; // D
            6: clkdivider = 9956; // D#/Eb
            7: clkdivider = 10548; // E
            8: clkdivider = 11175; // F
            9: clkdivider = 11840; // F#/Gb
            10: clkdivider = 12544; // G
            11: clkdivider = 13290; // G#/Ab
            12: clkdivider = 0; // should never happen
            13: clkdivider = 0; // should never happen
            14: clkdivider = 0; // should never happen
            15: clkdivider = 0; // should never happen
        endcase
endmodule

module durationms_to_duration(input logic[14:0] durationms, output logic[25:0] duration);
    assign duration = durationms * 27000;
endmodule

module song_level1(input logic[9:0] note_id, output logic[6:0] pitch,
                    output logic[14:0] duration, output logic[4:0] octave);
    always_comb begin
        case (note_id)
            0 : begin
                pitch = 0;
                duration = 100; // in ms
                octave = 4;
            end
            1 : begin
                pitch = 1;
                duration = 100; // in ms
                octave = 4;
            end
        endcase
    end
endmodule
/*
module musicc(input clk, output speaker);
    parameter clkdivider = 27000000/440/2;
    reg[14:0] counter;
    always @(posedge clk)
    begin
        if (counter == 0) begin
            counter <= counter+1;
            speaker <= ~speaker;
        end
    end
endmodule*/