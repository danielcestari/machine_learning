
set xr [-0.5:1.5]
set yr [-0.5:1.5]

#spl "and1.dat" notitle with points lt 1 pt 6, "and2.dat" notitle with points lt 3 pt 6, f(x,y)
set xlabel "A"
set ylabel "B"
set zlabel "d"

spl "and1.dat" notitle with points lt 1 pt 6, "and2.dat" notitle with points lt 3 pt 6 

