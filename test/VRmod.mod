#Sets#
set DAYS;                                                # DAYS is d
set VEHICLES;                                            # VEHICLES is k
set NODES;                                               # NODES is i,j


#Parameters#
param T;                                                                                        # Daily capacity in hours per vehicle
param s{NODES, DAYS};                                                                           #SERVICE TIME FOR CUSTOMER i ON DAY d          
param L;                                                                                         #MAXIMUM ARRIVAL TIME VARIATION};                  # Between two customers 
param Q;                                                                                        #MAXIMUM CAPACITY OF EACH VEHICLE};
param q{NODES, DAYS};                                                                         #DEMAND OF CUSTOMER i ON DAY d};                 
param w{NODES, DAYS} binary;                                                                  # {1 INDICATES CUSTOMER i REQUIRES SERVICE ON DAY d, 0 INDICATES OTHERWISE}
param t{NODES, NODES};                                    

#Decision Variables#
var x {NODES,NODES,VEHICLES,DAYS} binary;                                                      # {1 INDICATES VEHICLE k VISITS CUSTOMER j AFTER CUSTOMER i ON DAY d, 0 INDICATES OTHERWISE} 
var y {NODES,VEHICLES,DAYS} binary;                                                          # {1 INDICATES VEHICLE k VISITS CUSTOMER i ON DAY d, 0 INDICATES OTHERWISE} 
var a {NODES,DAYS};                                                                          # {ARRIVAL TIME TO CUSTOMER i ON DAY d (i = 0 AT DEPOT)}
var u {NODES,DAYS} integer;                                                                  # {AUXILLIARY VARIABLE FOR SUBTOUR ELIMINATION}

#Objective Function#
minimize Total:sum{d in DAYS,k in VEHICLES, i in NODES, j in NODES} t[i,j]*x[i,j,k,d];

#Constraints#
subject to two {k in VEHICLES,d in DAYS}:y[0,k,d]=1;                                                                              # constraint 2 in paper
subject to three {d in DAYS}:a[0,d]=0;                                                                                             # constraint 3 in paper
subject to four {i in 1..4,d in DAYS}:sum {k in VEHICLES}y[i,k,d]=w[i,d];                                                            # constraint 4 in paper
subject to five {d in DAYS,k in VEHICLES}:sum {i in 1..4} q[i,d]*y[i,k,d]<=Q;                                                      # constraint 5 in paper  [not sure if i in NODES also needs to go in the forall statement; also little q seems to be a defined function]
subject to six {j in NODES,k in VEHICLES,d in DAYS}:sum {i in 1..4}x[i,j,k,d]=y[j,k,d];                                             # constraint 6 in paper  [not sure if i in NODES also needs to go in the forall statement]
subject to seven {j in NODES,k in VEHICLES,d in DAYS}:sum {i in 1..4}x[j,i,k,d]=y[j,k,d];                                         # constraint 7 in paper  [not sure if i in NODES also needs to go in the forall statement]
subject to eight {d in DAYS,e in DAYS,i in NODES,k in VEHICLES: d<>e}:w[i,d]+w[i,e]-2=y[i,k,d]-y[i,k,e];                               # constraint 8 in paper; confirm alpha and beta phraseology                                                        # constraint 3 in paper
subject to nine {d in DAYS,e in DAYS,i in NODES,k in VEHICLES: d<>e}:w[i,d]+w[i,e]-2=y[i,k,e]-y[i,k,d];                               # constraint 9 in paper; confirm alpha and beta phraseology                                                        # constraint 3 in paper
subject to ten {i in NODES,j in 1..4,k in VEHICLES,d in DAYS}:a[i,d]+x[i,j,k,d]*(s[i,d]+t[i,j])-(1-x[i,j,k,d])*T<=a[j,d];                                                        # constraint 10 in paper
subject to eleven {i in NODES,j in 1..4,k in VEHICLES,d in DAYS}:a[i,d]+x[i,j,k,d]*(s[i,d]+t[i,j])-(1-x[i,j,k,d])*T>=a[j,d];                                                        # constraint 11 in paper
subject to twelve {i in NODES,d in DAYS: i>=1}:a[i,d]+w[i,d]*(s[i,d]+t[i,0])>=0;                                                        
subject to thirteen {i in 1..4,d in DAYS}:a[i,d]+w[i,d]*(s[i,d]+t[i,0])<=T*w[i,d];                                                        
subject to fourteen {d in DAYS,e in DAYS,i in NODES: d<>e}:a[i,d]-a[i,e]<=L+T*(2-w[i,d]-w[i,e]);                                                        # constraint 14 in paper
subject to fifteen {d in DAYS,e in DAYS,i in NODES: d<>e}:a[i,e]-a[i,d]<=L+T*(2-w[i,d]-w[i,e]);                                                        # constraint 15 in paper
subject to sixteen {i in NODES,j in NODES,k in VEHICLES,d in DAYS: j>=1}:u[i,d]+1<=u[j,d]+ card(NODES)*(1-x[i,j,k,d]);                                                        # constraint 16 in paper
#subject to seventeen {i in NODES,j in NODES,k in VEHICLES,d in DAYS}:x[i,j,k,d] binary;                                                        # constraint 17 in paper; how indicate "element of" in formula
#subject to eighteen {i in NODES,k in VEHICLES,d in DAYS}:y[i,k,d] binary;                                                        # constraint 18 in paper; how indicate "element of" in formula
subject to nineteen {i in NODES,d in DAYS}:a[i,d]>=0;                                                                                   # constraint 19 in paper; how indicate "element of" in formula
subject to twenty {i in NODES,d in DAYS}:u[i,d]>=0;                                                                                            # constraint 20 in paper; how indicate "element of" in formula



