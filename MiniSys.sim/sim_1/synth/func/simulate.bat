@echo off
set xv_path=D:\\Vivado\\2016.2\\bin
call %xv_path%/xsim line_sim_func_synth -key {Post-Synthesis:sim_1:Functional:line_sim} -tclbatch line_sim.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0