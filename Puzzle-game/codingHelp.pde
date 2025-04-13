



//! - You *MUST* keep this file in your code folder for *ALL* assignments (not in a subfolder, and do not rename it)
//    1 - as a reference
//    2 - as an honour pledge
//
//  ... or else you will get 0 on the assignment(s)
//





///////////
//coding help for SCIE204                                                                                                                                                                                                                        //20240927 - done after 2023s3, changed mid-way to include app naming & rotation function
//instructor: David Bergman
//
//This is a reference to help students with:
//- honour pledge about academic integrity + not cheating
//- order of main coding parts
//- commenting & formatting
//- file naming
//- and coding
//
//





///////////
// Honour pledge about academic integrity
/*

I pledge to:
  1 - include this codingHelp document in *EVERY* assignment, or I will get 0. 
  2 - read and understand these important points about academic integrity and cheating
  3 - complete each assignment without cheating

I understand:
- being a student is to engage in the honest pursuit of knowledge, research, and scholarship
- being a student is sometimes challenging, but it is always important to maintain academic integrity
- academic integrity means not taking credit for anything that I have not earned (ie. not cheating)

Cheating:
* cheating is wrong and is destructive to basic academic values of honesty, integrity, inclusivity, community, excellence, and it ruins the learning process.
* copying *ANY* small part from anyone else's code is considered cheating
  - ... not a single character from any student, from a tutor, from online, and/or from generative AI
  * it is NOT cheating to *talk* to others or do online research, but *NO* amount of copying is okay
... therefore, I will write my own code and documentation (with the exception of using sample code that David will give all students equally)

Any cheating means 0:
- students are responsible for their actions, whether acting alone or in a group
- if I cheat, anyone involved gets 0 on the assignment... regardless of the size / roll they played
  - past / future assignments will be checked and re-evaluated.
  ... and I understand that this may cause me to fail the course, and this is my responsibility
  ... *REGARDLESS* of the amount of work / effort / struggle put in to any other part of the course.

*/
//




///////////
//order of main coding parts
//
//top comment        <-- tells title, authour, and a brief description of what the app does
//global variables   <-- what variables should all functions see
//setup()            <-- runs once
//draw()             <-- runs all the time
//... then all other custom functions you make, with each commented, and at least 3 spaces between them
//




///////////
//set the app's name in the titlebar
//
//use this "surface..." line as the 1st line in setup() (and remove the comments at the start)
//  *NOTE - "zzz" would be changed to "lab 2", or "a4" for assignment 4, etc.
// surface.setTitle("SCIE204, Your Name, zzz");//set app's name in titlebar




///////////
//commenting and formatting reminders
//
//comment
// - a "top comment" for your main code file
//   - it names the code (eg. assignment 1), gives your name, email address
//     and a description of what the code does
// - above all chunks of code your write:
//   - above if() statements
//   - above for() loops
//   - above functions you make
// - each variable or set of variables you make
// - all lines of code that do something important / notable (eg. clear bg to blue)
//
//formatting
// - { } are vertically aligned
// - use tabbing so you can see what's inside what, or if you're missing a squiggle
// - 3 or 4 spaces between functions for clarity
// - avoid adding spaces inside functions to keep the code compact and legible without
//   having to scroll around.
//
//variable naming
// - the variable's name should tell what data type it is
//eg. int and float numbers can be num___, amnt___, size___, etc.
//eg. booleans should be named like:
//      - "is____"        eg. isSmart, isSunny
//      - or "has____"    eg. hasSunburn, hasMullet
//      - or "can___"     eg. canJump, canCook
//eg. arrays should be named like:
//      - arr____"        eg. arrDogs, arrCats, arrClouds



///////////
//file naming convention
//
//SCIE204_FirstLastName_a#_v#.pde
//
//eg. SCIE204_JaneWong_a1_v3    <-- that would be assignment 1, version 3
//
//NOTES:
// - the PDE file is automatically put into a new folder named *exactly* the same
// - [old v3] the coding PDE file and the folder that it's in must have the SAME name
// - avoid having nested code folders (messy)
// - DONOTUSEALLCAPSFORYOURNAMEBECAUSEITISHARDTOFIGUREOUT
// - donotuseonlylowercaseforthesamereason



///////////
//commenting blocks of code
//
//- comment above the block so it all fits on the screen
//- you need a code block ABOVE any function, if(), and for().

//eg.

//draws a pink pony at the mouse position and zdqws jkdh gfl ajdfjprp qwhl
//jkdh gfl ajwhl zdqws jkdh gfl ajdfjprp qwhl sjkdh gfl ajwhl zdqws jkdh gfl
//ajdfjprp qwhl sjkdh gfl ajwhl zdqws jkdh gfl ajdfjprp qwhl sjkdh gfl ajwhl
//all this is visible above the block of code, and it does not run off the
//page to the right where you cannot read it or you'd have to scroll over
//to read it all
void drawPinkPonyAtMousePos()
{
	//another block of code that needs a comment
	//block above it to explain what's going on
	//inside the if() statement without the comment
	//going way off to the right where you'd have
	//to scroll to be able to see it all.
	if(12 != 24)
	{
		//nested code
	}
	
	//another block of code that needs a comment block
	//above it because zdqws jkdh gfl ajdfjprp qwhl sjkdh
	//gfl ajwh zdqws jkdh gfl ajdfjprp qwhl sjkdh gfl ajwhl
	for(int i=0; i<42; i++)
	{
		//code here
	}
}



///////////
//what to submit
//
//- submit exactly what is requested for each assignment and not extra files/folders
//  - see assignment handout
//- remove all junk/old code that doesn't need to be in the assignment's code
//  ...eg. sometimes a jpg screenshot and a reference is needed, and sometimes not
//- remove all files and subfolders that are not requested
//- always leave the codingHelp.pde file for your own reference



///////////
//how to submit via FTP
//
//use an FTP client like Filezilla, Fetch, or perhaps
//WaterFox (with the FireFTP plugin) to send your entire code folder
//to ECU's FTP server, and into the Dropbox folder for this course
//
//login to ECU's FTP server with:
// - host is = ftp.ecuad.ca
// - your ECU username (not including "@ecuad.ca")
// - your ECU password
// - port = 21



///////////
//locations on ftp.ecuad.ca
// 1 - The starting location you login to is your own personal space
// 2 - Dropbox folder is located:  /home/students/Dropboxes/dbergman
// 3 - Public folder is located:   /home/students/Public/Instructor/D_Bergman



///////////
//suggestions + hints
//
//- keep an old copy of your code to refer to (this is why versions and naming your folder well is very important)
//- make versioned backups in various places - not only on your flashdisk, but also to your FTP private folder
//- start with code that works and build on it
//  - remove what you don't need, then add to it... then save as a new version.
//- code in baby steps, and keep the code working
//- to comment/uncomment large chunks of code, select it, then ctrl-/
//- use /* */ commenting as little as possible so you can use it to comment out large chunks of code for
//  testing when you need to
//






//override of println() using camelCase to avoid confusing for students
void printLn(String str)
{
  println(str);//passing the content on to this version of the print() function
}//end of f





//rotate function that takes degrees instead of radians
void rotateByDeg(float degToRot)
{
  rotate(radians(degToRot));//change deg to rad, then call for rotation
}//end of f
