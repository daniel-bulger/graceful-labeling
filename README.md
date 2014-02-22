graceful-labeling
=================

A Prolog library that generates and verifies graceful labelings for trees.

##Usage
###Generation
To generate graceful labelings for a tree, simply type
`graceful(E,X).`, where E is a list of edges that comprise the tree, and X is an unbound variable.
An edge is formatted `[a,b]` where a and b are integers corresponding to vertices in the tree.  The vertices must be 1-indexed.  So the encoding for the tree that is a straight line with 4 vertices would be `[[1,2],[2,3],[3,4]]`. 
So to generate all graceful labelings for this tree, we type `graceful([[1,2],[2,3],[3,4]],X).`.
Note: you must type `;` each time you want to generate another labeling.  This is how swipl iterates through possible variable bindings.

###Verification
Verifying a labeling for a tree is similar to generation: type `graceful(E,X).`, where E is a list of edges, and X is a labeling.  A labeling is formatted `[a,b,c,...,x,y,z]` where a-z are integer labels.  So to check if `[1,4,2,3]` is a graceful labeling for the tree `[[1,2],[2,3],[3,4]]`, we type `graceful([[1,2],[2,3],[3,4]],[1,4,2,3]).`.

This library was built for the SWI-Prolog interpreter.
To run the interpreter, type `swipl` in the terminal.  Once inside the interpreter, load the file with `[labeler]`.  Make sure your terminal session is in the directory that contains labeler.pl, or swipl will not be able to find the labeler file.
