Read carefully 

If you want to run this script, make sure you have the following pathway setup:

C:\Security

If that folder exists, then the only thing you will need to do from there is to put the entire PJUsage folder in the C: Drive. Once completed, the PJUsage folder's pathway should be: C:\PJUsage. I will restate this in my Instructions.txt file

Known bugs: Setup script references itself on Line 33, and generates several errors because of it. Move-Item should be Copy-Item, wrong path is referenced on Line 35. $ComputerName isn't being recognized because it isn't saved with a global scope. 

-Carson Bybee
