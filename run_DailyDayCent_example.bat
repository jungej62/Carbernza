@REM  This batch file was created to run the example DailyDayCent simulations
@REM  on the PC.

@REM  Remove old output files
erase example.bin
erase example.lis

@REM  Run the example simulation
erase example_log.txt
DailyDayCent -s example -n example > example_log.txt
DailyDayCent_list100 example example outvars.txt
