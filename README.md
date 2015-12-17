graceful-labeling
=================

A Prolog and python library that generates and verifies graceful labelings for trees.

##Usage
###Generation
To generate graceful labelings for a tree, simply type
`graceful(E,X).`, where E is a list of edges that comprise the tree, and X is an unbound variable.
An edge is formatted `[a,b]` where a and b are integers corresponding to vertices in the tree.  The vertices must be 0-indexed.  So the encoding for the tree that is a straight line with 4 vertices would be `[[0,1],[1,2],[2,3]]`. 
So to generate all graceful labelings for this tree, we type `graceful([[0,1],[1,2],[2,3]],X).`.
Note: you must type `;` each time you want to generate another labeling.  This is how swipl iterates through possible variable bindings.

###Verification
Verifying a labeling for a tree is similar to generation: type `graceful(E,X).`, where E is a list of edges, and X is a labeling.  A labeling is formatted `[a,b,c,...,x,y,z]` where a-z are integer labels.  So to check if `[0,3,1,2]` is a graceful labeling for the tree `[[0,1],[1,2],[2,3]]`, we type `graceful([[0,1],[1,2],[2,3]],[0,3,1,2]).`.

This library was built for the SWI-Prolog interpreter.
To run the interpreter, type `swipl` in the terminal.  Once inside the interpreter, load the file with `[labeler]`.  Make sure your terminal session is in the directory that contains labeler.pl, or swipl will not be able to find the labeler file.

There is also a python file which is probably easier to use.  The python program supports both generation and verification as well, and also supports partially specified generation.  Just run 'python labeler.py "[[0,1],[1,2]]"' to generate all possible graceful labelings.
To verify a tree, run 'python labeler.py "[[0,1],[1,2]]" "[2,0,1]"' to verify whether the labeling where vertex 0 has label 2, vertex 1 has label 0, and vertex 2 has label 1 is graceful.  Labelings may also be specified as a dictionary, like 'python labeler.py "[[0,1],[1,2]]" "{0:2,1:0,2:1}"'.
Partial labelings can also be specified, and any trees with the specified labels will be generated.  To leave a label unspecified, for the array syntax, replace a label with a '_'. With the dictionary syntax, simply don't specify a label for some vertices.  e.g. 'python labeler.py "[[0,1],[1,2]]" "[2,_,1]"' or 'python labeler.py "[[0,1],[1,2]]" "{0:2,1:0}"'
