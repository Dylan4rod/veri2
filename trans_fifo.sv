//////////////////////////////////////////////////////////////
// Definición del tipo de transacciones posibles en la fifo //
//////////////////////////////////////////////////////////////

typedef enum {lectura, escritura, reset, esc_lect} tipo_trans;

//////////////////////////////////////////////////////////////
//Transacción: este objeto representa las transacciones que entran y salen de la fifo. //
//////////////////////////////////////////////////////////////

class trans_fifo #(parameter width = 16);
    rand int retardo;           // tiempo de retardo en ciclos de reloj que se debe esperar antes de ejecutar la transacción
    rand bit [width-1:0] dato;   // este es el dato de la transacción
    int tiempo;                 //Representa el tiempo de la simulación en el que se ejecutó la transacción
    rand tipo_trans tipo;       // lectura, escritura, reset:
    int max_retardo;
    
    constraint const_retardo {retardo < max_retardo; retardo>0;}
    
    function new();
        this.retardo = 0;
        this.dato = 0;
        this.tiempo = 0;
        this.tipo = lectura;
        this.max_retardo = 10;
    endfunction
        
    function clean;
        this.retardo = 0;
        this.dato = 0;
        this.tiempo = 0;
        this.tipo = lectura;
    endfunction
    
    function void print(string tag = "");
        $display(" [%g] %s Tiempo=%g Tipo=%s Retardo=%g dato=0x%h", $time, tag, tiempo, this.tipo, this.retardo, this.dato);
    endfunction

endclass


//////////////////////////////////////////////////////////////
// Objeto de transacción usado en el scroreboard //
//////////////////////////////////////////////////////////////

class trans_sb #(parameter width=16);
    bit [width-1:0] dato_enviado;
    int tiempo_push;
    int tiempo_pop;
    bit completado;
    bit overflow;
    bit underflow;
    bit reset;
    int latencia;
    
    function clean();
        this.dato_enviado = 0;
        this.tiempo_push = 0;
        this.tiempo_pop = 0;
        this.completado = 0;
        this.overflow = 0;
        this.underflow = 0;
        this.reset = 0;
        this.latencia = 0;
    endfunction
    
    task calc_latencia;
        this.latencia = this.tiempo_pop - this.tiempo_push;
    endtask

    function print (string tag);
        $display( "[%g] %s dato=%h, t_push=2g, t_pop=g, cmplt=%g, ovrflu=%g, undrflu=%g, rst=%g, ltncy=%g",
        $time,
        tag,
        this.dato_enviado,
        this.tiempo_push,
        this.tiempo_pop,
        this.completado,
        this.overflou,
        this.underflow,
        this.reset,
        this.latencia) ;
    endfunction
endclass

////////////////////////////////////////////////////////////////////////////
//comandos al scroreboard
////////////////////////////////////////////////////////////////////////////
typedef enum {retardo_promedio, reporte} solicitud_sb;

////////////////////////////////////////////////////////////////////////////
//comandos al agente
////////////////////////////////////////////////////////////////////////////
typedef enum {llenado_aleatorio, trans_aleatoria, trans_especifica, sec_trans_aleatorias} instrucciones_agente;


///////////////////////////////////////////////////////////////////////////
//       MAILBOXES
///////////////////////////////////////////////////////////////////////////

//comunicar las interfaces 
typedef mailbox #(trans_fifo) trans_fifo_mbx;

typedef mailbox #(trans_sb) trans_sb_mbx;

typedef mailbox #(solicitud_sb) comando_test_sb_mbx;

typedef mailbox #(instrucciones_agente) comando_test_agente_mbx;
