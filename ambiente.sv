class ambiente #(parameter width =16, parameter depth = 5);

    // Declaración de los componentes del ambiente
    driver #(.width(width)) driver_inst;
    check #(.width(width), .depth(depth)) checker_inst;
    score_board #(.width(width)) scoreboard_inst;
    agent #(.uidth(width), .depth(depth)) agent_inst;

    // Declaración de la interface que conecta el DUT
    virtual fifo_if #(.width(width)) _if;

    //declaración de los mailboxes
    trans_fifo_mbx agnt_drv_mbx;            //mailbox del agente al driver
    trans_fifo_mbx drv_chkr_mbx;            //mailbox del driver al checher
    trans_sb_mbx chkr_sb_mbx;               //mailbox del checker al scoreboard
    comando_test_sb_mbx test_sb_mbx;        //mailbox del test al scoreboard
    comando_test_agent_mbx test_agent_mbx;  //mailbox del test al agente
    
    function new();
        // Instanciación de los mailboxes
        drv_chkr_mbx    = new();
        agnt_drv_mbx    = new();
        chkr_sb_mbx     = new();
        test_sb_mbx     = new();
        test_agent_mbx  = new();

        // instanciación de los componentes del ambiente
        driver_inst         = new();
        checker_inst        = new();
        scoreboard_inst     = new();
        agent_inst          = new();

        // conexion de las interfaces y mailboxes en el ambiente
        driver_inst.vif              = _if;
        driver_inst.drv_chkr_mbx     = drv_chkr_mbx;
        driver_inst.agnt_drv_mbx     = agnt_drv_mbx;
        checker_inst .drv_chkr_mbx   = drv_chkr_mbx;
        checker_inst.chkr_sb_mbx     = chkr_sb_mbx;
        scoreboard_inst .chkr_sb_mbx = chkr_sb_mbx;
        scoreboard_inst.test_sb_mbx  = test_sb_mbx;
        agent_inst.test_agent_mbx    = test_agent_mbx;
        agent_inst.agnt_drv_mbx      = agnt_drv_mbx;
    endfunction
    
    virtual task run();
        $display("[%g] El ambiente fue inicializado",$time);
        fork
            driver_inst.run();
            checker_inst.run();
            scoreboard_inst.run();
            agent_inst.run();
        join_none
    endtask
endclass