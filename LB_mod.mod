#Sets#
set STATIONS;
set TASKS;
set ZS within {TASKS,TASKS};
set ZD within {TASKS,TASKS};
set IP within {TASKS,TASKS};

#Parameters#
param T{TASKS};
param C{STATIONS};
param Cost{STATIONS};

#Variables#
var X {TASKS,STATIONS} binary;

#Objective Function#
minimize Total:sum{i in TASKS,j in STATIONS}Cost[j]*X[i,j];

#Constraints#
subject to Time {k in STATIONS}:sum{i in TASKS}T[i]*X[i,k]<=C[k];					#1
subject to Task {i in TASKS}:sum{K in STATIONS}X[i,K]=1;							#2
subject to Precedence{(i,j) in IP,b in STATIONS}:X[j,b]<=sum{k in 1..b}X[i,k];		#3
subject to Zoning1 {(i,j) in ZS,k in STATIONS}:X[i,k]-X[j,k]=0;						#4
subject to Zoning2 {(I,J) in ZD,k in STATIONS}:X[I,k]+X[J,k]<=1;					#5


