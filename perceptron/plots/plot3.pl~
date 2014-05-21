set xr [-0.5:1.5]
set yr [-0.5:1.5]

set xlabel "A"
set ylabel "B"
set zlabel "d"

#spl "and1.dat" notitle with points lt 1 pt 6, "and2.dat" notitle with points lt 3 pt 6 
esperada(x, y) = -0.5*x -0.5*y +1.0 

obtida(x, y) = 0.5*x +0.5*y +3

spl "and1.dat" notitle with points lt 1 pt 6, "and2.dat" notitle with points lt 3 pt 6, obtida(x,y)

