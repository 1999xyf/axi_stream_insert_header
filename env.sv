class test_env extends uvm_env;
    // Agent
    axi_agent axi_agt;
    
    // Driver
    axi_driver axi_drv;
    
    // Monitor
    axi_monitor axi_mon;
    
    // Sequencer
    axi_sequencer axi_seqr;
    
    // Constructor
    function new(string name = "test_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create Agent
        axi_agt = axi_agent::type_id::create("axi_agt", this);
        
        // Create Driver
        axi_drv = axi_driver::type_id::create("axi_drv", this);
        axi_drv.rst_n.connect(axi_agt.rst_n);
        axi_drv.clk.connect(axi_agt.clk);
        axi_drv.agent_cfg = axi_agt.cfg;
        
        // Create Sequencer
        axi_seqr = axi_sequencer::type_id::create("axi_seqr", this);
        axi_seqr.clk.connect(axi_agt.clk);
        axi_seqr.rst_n.connect(axi_agt.rst_n);
        
        // Create Monitor
        axi_mon = axi_monitor::type_id::create("axi_mon", this);
        axi_mon.clk.connect(axi_agt.clk);
        axi_mon.rst_n.connect(axi_agt.rst_n);
        axi_mon.agent_cfg = axi_agt.cfg;
        
        // Set Sequencer and Driver to Agent
        axi_agt.seqr = axi_seqr;
        axi_agt.drv = axi_drv;
        
        // Set Monitor to Agent
        axi_agt.mon = axi_mon;
    endfunction
    
    // Run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // Start Sequencer
        axi_seqr.start(seqr_cfg);
        // Wait for Sequencer to finish
        axi_seqr.wait_for_sequences();
    endtask
    
endclass : test_env
