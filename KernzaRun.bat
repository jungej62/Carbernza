@REM  Remove old output files
move kernza2.lis .\simulations\KernzaRunLast\
move kernza2.bin .\simulations\KernzaRunLast\
@REM  Run the example simulation
DailyDayCent -s kernza2 -n kernza2 -e spin
DailyDayCent_list100 kernza2 kernza2 outvars.txt
