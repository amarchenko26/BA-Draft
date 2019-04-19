/* 
* TODO: 1. Place the .txt data file and the dictionary file you downloaded in the work folder, or enter the full path to these files!
*       2. You may have to increase memory using the 'set mem' statement. It is commented out in the code bellow.
*
* If you have any questions or need assistance contact info@socialexplorer.com.
*/

///set mem 512m
clear all
set more off

global repository `c(pwd)'
infile using "$repository/R12122734.dct", using("R12122734_SL860.txt")


