class axi_agent extends uvm_agent;
    // Configuration object
    axi_agent_cfg cfg;
    
    // Interface
    axi_stream_insert_header intf;
    
    // Sequencer
    axi_sequencer seqr;
    
    // Driver
    axi_driver drv;
    
    // Monitor
    axi_monitor mon;
    
    // Constructor
    function new(string name = "axi_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Interface
        intf = axi_stream_insert_header::type_id::create("intf", this);
        // Set configuration object
        cfg = axi_agent_cfg::type_id::create("cfg", this);
    endfunction
    
    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect Interface to DUT
        DUT.intf.connect(intf);
    endfunction
    
endclass : axi_agent
