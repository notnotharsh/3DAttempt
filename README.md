# 3DAttempt
This is a Processing app designed to function as a 3D engine.
##Controls
Press:
z to move forward
x to move back
a to move left
d to move right
w to move up
s to move down
i to rotate up
j to rotate left
l to rotate right, and
k to rotate down
##Files
The file points.txt has some number of lines - each line marks a point with the x, y, and z coordinates delimited by a space.
The file lines.txt has some number of lines - each file contains either a period or a hyphen at first to determine if that line is to be drawn or not, followed by the two numbers that are the numbers of the lines on the points.txt file that specify the line. 
The file surfaces.txt works the same way as lines.txt, with a period or hyphen, followed by three references to points.
The file lights.txt details the number and placement of lights, and after the hyphen/period determining whether the light will be shown or not, it follows the following format: [intensity] [x] [y] [z].