package ram_pkg;
  parameter int N = 5;
int no_of_trans=1;
`include "transaction.sv"
`include "generator.sv"
`include "wr_driver.sv"
`include "rd_driver.sv"
`include "wr_monitor.sv"
`include "rd_monitor.sv"
`include "ref_model.sv"
`include "scoreboard.sv"
endpackage