This is how to compile C source code!

    cc <source-file(s)> -o <binary-file>

This is how to run the binary that you made!

    ./<binary-file>

If you want to add more flags here are some useful ones:

    -O<n>       optimization level
    -g          compile with debug symbols
    -D<k>=<v>   predefine macro value (e.g. NDEBUG might be useful for some programs)
    -E          only run the preprocessor, useful for debugging macros
    -Wall       generate all warnings instead of just the really important ones
    -pedantic   if you a freak
    -std=c23    to use all of the fancy new stuff
    -std=c99    to use the classic version that everybody pretty much loves
    -std=c89    to use the version that will run on literally anything you want it to
    -l<lib>     link a given library into the program. for example you will probably have to do `-lmath` if you want to use the math library/header
    -I<dir>     add directory to lookup path for included libraries
    -c          we don't need a main just make an object file

    cc -c mylib.c -o 
