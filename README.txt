DailyDayCent and its associated utility programs are run from a DOS box in
Windows.  To accomplish this open a Command Prompt window.  Once you have the
DOS window open use the cd command to change to the directory where you have
installed the DailyDayCent files (if necessary).

To run DailyDayCent type:
     DailyDayCent -s <schedule file> -n <output file>
at the DOS prompt.

When running DailyDayCent the directory from which you will be running your
simulations must contain the following files:
     DailyDayCent.exe       <- the DailyDayCent executable
     The parameter files:
          crop.100
          cult.100
          fert.100
          fire.100
          fix.100
          graz.100
          harv.100
          irri.100
          omad.100
          tree.100
          trem.100
          <site>.100  <- your site specific parameter file
          *.sch       <- your schedule file for the simulation
          *.wth       <- historical weather data file for site
          sitepar.in  <- additional site information needed by DailyDayCent
          soils.in    <- a description of the soil layer structure
          outfiles.in <- allows the user to select which ASCII (*.out) output
                         files to create when running a DailyDayCent
                         simulation


Other files which should be in your DailyDayCent directory are:
     DailyDayCent utilities:
          DailyDayCent_event100.exe  <- used to create and/or modify schedule
                                        files
          DailyDayCent_file100.exe   <- used to modify parameter files
          DailyDayCent_list100.exe   <- used to extract output from the binary
                                        output file to ASCII text file
     The parameter definition files (must be in the directory when running
     DailyDayCent_file100):
          crop.def
          cult.def
          fert.def
          fire.def
          fix.def
          graz.def
          harv.def
          irri.def
          omad.def
          site.def
          tree.def
          trem.def

Your DailyDayCent installation includes an example site file, schedule file, and
daily weather data file to help you get started using DailyDayCent.

Other files included with the installation:

     run_DailyDayCent_example.bat - DOS batch file that can be run from
          command line; includes instructions to remove old output files, run
          the DailyDayCent simulation, and extract output from the *.bin file
          using the command line option for running DailyDayCent_file100

     outvars.txt - list of output variables to extract from the *.bin file,
          used by the run_DailyDayCent_example.bat file when running the
          example simulation

Because all DailyDayCent results (favorable or not) help us to improve the
model, we would appreciate a copy of any reports, abstracts, or manuscripts
resulting from the use of DailyDayCent.  When possible, the inclusion of
"DailyDayCent model" in the list of key words or phrases improves our ability
to track the use of the model.  DailyDayCent is protected by a United States
copyright to Colorado State University, all rights reserved.  We ask that you
do not provide copies of the model, source code, or documentation to
colleagues unless you contact us directly about doing so.

If you have questions about parameterizing the model or problems with running
the model please send a message to:
     century@nrel.colostate.edu
Technical support for the DailyDayCent model is provided on a time-available
basis and answers are generally provided within a week.  This support is
limited and is available only to users who have thoroughly read the model
documentation.

DISCLAIMER

Neither the Agricultural System Research Unit - USDA (ASR - formerly Great
Plains System Research Unit) nor Colorado State University nor any of its
employees makes any warranty or assumes any legal liability or responsibility
for the accuracy, completeness, or usefulness of any information, apparatus,
product, or process disclosed, or represents that its use would not infringe
upon privately owned rights.  Reference to any special commercial products,
process, or service by tradename, trademark, manufacturer, or otherwise, does
not necessarily constitute or imply endorsement, recommendation, or favoring
by the ASR or CSU.  The views and opinions of the authors do not necessarily
state or reflect those of ASR or CSU and shall not be used for advertising or
product endorsement.
