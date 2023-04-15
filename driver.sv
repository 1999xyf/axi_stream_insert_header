class axi_stream_insert_header_driver extends uvm_driver #(axi_stream_insert_header_transaction);
    `uvm_component_utils(axi_stream_insert_header_driver)

    virtual axi_stream_insert_header_if vif;
    axi_stream_insert_header_sequence sequencer;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual axi_stream_insert_header_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_name(), "Virtual interface not defined! Simulation aborted!");
        if (!uvm_config_db #(axi_stream_insert_header_sequence)::get(this, "", "sequencer", sequencer))
            `uvm_fatal(get_name(), "Sequence not defined! Simulation aborted!");
    endfunction : build_phase
    
    task run_phase(uvm_phase phase);
        axi_stream_insert_header_transaction trans;
        forever begin
            trans = null;
            @(vif.valid_insert);
            if (vif.valid_insert) begin
                trans = axi_stream_insert_header_transaction::type_id::create("trans");
                trans.header = vif.header_insert_reg;
                trans.data = vif.data_insert;
                trans.keep = vif.keep_insert;
                trans.byte_cnt = vif.byte_insert_cnt;
                if (sequencer.put(trans))
                    `uvm_info(get_name(), $sformatf("Inserted header: %h", trans.header), UVM_MEDIUM)
                else
                    `uvm_error(get_name(), "Failed to send transaction to the sequencer!")
            end
        end
    endtask : run_phase
endclass : axi_stream_insert_header_driver

