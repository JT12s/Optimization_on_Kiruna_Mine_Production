# EX:a1=a^'  ;a2=a^⋀;a3=a^~
#Sets#
set K;                       #set of ore grades
set V;                       #set of shaft groups
set A;                       #set of machine placement
set A{ v in V} within A;     #set of machine placements in shaft group v
set IA;                      #set of inactive machine placements
set AV{a in A} within A;     #set of machine placements whose start date is restricted vertically by machine placement a
set AH{a in A} within A;     #set of machine placements whose start date is forced by adjacency to machine placement a
set A{t in T} within A;      #set of machine placements that can start to be mined in time period t
set B ;                      #set of production blocks
set B{a in A} within B;      #set of production blocks in machine placement a
set B{b in L} within B;      #set of production blocks in drawdown line l
set B{t in T} within B;      #set of production blocks that can be mined in time period t
set L ;                      #set of drawdown lines
set L{a in A} within L;      #last (i.e., most deeply positioned) drawdown line in machine placement
set LC within L ;            #set of drawdown lines constrained by another drawdown line
set L{l in L} within L;      #set set of drawdown lines that vertically constrain drawdown line l
set LV{a in A} within L;     #drawdown line whose finish date vertically restricts starting to mine machine placement a
set LH{a in A} within L;     #drawdown line whose finish date forces the start date of machine placement a by adjacency
set L{t in T} within L;      #set of drawdown lines that can be mined in time period t
set T;                       #set of time periods composing the long-term time horizon (T1 is the complement thereof)
set T1 within T;             #set of time periods composing the short-term time horizon
set T{a in A} within T;      #set of time periods in which machine placement a can start to be mined (restricted by machine placement location and the start dates of other relevant machine placements)        
set T{b in B} within T;      #set of time periods in which production block b can be mined (restricted by production block location and the start dates of other relevant production blocks)
set T{l in L} within T;      #set of time periods in which drawdown line l can finish being mined (restricted by drawdown line location and the finish times of other relevant drawdown lines)
set T2{l in L} within T;     #time period by which all production blocks in drawdown line l must finish being mined

#Parameters#
set p{t in T: t=|T|+1-t};
set LHD{t in T};
set LHD{v in V};
set d{k in K,t in T};
set r{a in A,t1 in T,t in T,k in K};
set g{a in A,t1 in T,t in T} binary;
set R{b in B,k in K};
set Max_c{a in A,t in T};
set Min_c{a in A,t in T};


#variables
var az{k in K,t in T};
var bz{k in K,t in T};
var x{b in B, t in T};
var w{l in L, t in T} binary;
var y{a in A, t in T} binary;

#Objective Function#
minimize Total:sum{k in K,t in T} p[t]*(bz[k,t]+az[k,t];

#constraint
subject to two{k in K,t in T}:sum{a in A[t], t1 in T[a]:t1<=t}r[a,t1,t,k]*y[a,t1]+sum{b in B[t]}(R[b,k]*x[b,t]/(sum{k1 in K}R[b,k1])+bz[k,t]-az[bt])=d[k,t];
subject to three{t in T1}:sum{a in A[t],k in K,t1 in T[a]:t1<=t}r[a,t1,t,k]*y[a,t1]+sum{b in B[t]}x[b,t]=sum{k in K}d[k,t];
subject to four{v in V,t in T[l],t2 in T2[l]}:sum{a in A[v]and in A[t1],t1 in T[a]:t1<=t}g[a,t1,t]*y[a,t1]+sum{a in A[v], l in L[a] and in L[t]} (1-w[l,t2])<=LHD[v];
subject to five{t in T}:sum{a in IA and in A[t]} y[a,t]<=LHD[t];
subject to six{b in B}:sum{t in T[b]}x[b,t]<=sum{k in K}R[b,k];
subject to seven{l in L,t in T[l]}:sum{b, in B[l],u in T[l]:u<=t}x[b,u]>=sum{b in B[l],k in K} R[b,k]*w[l,t]
subject to eight{l in LC, b in B[l],l2 in L[l],t in T[l2]}:sum{u in T[l2]:u<=t}x[b,u]<=sum{k in K}R[b,k]*w[l2,t];
subject to nine{t in T[l]}:sum{b in B[a] and in B[t]}x[b,t]<=Max_c[a,t]*(1-w[l,t])
subject to ten{t in T[l]}:sum{b in B[a] and in B[t]}x[b,t]>=min_c[a,t]*(1-w[l,t])
subject to eleven{a in A,a3 in AV[a],l in LV[a],t in T[a3]}:w[l,t]>=y[a3,t];
subject to twelve{a in A,a3 in AH[a],l in LH[a],t2 in T[l]}:sum{t in T[a3]:t<=t2}y[a3,t]>=w[l,t2];
subject to thirteen{a in A,a2 in AV[a],t2 in T[a2]:a2<>a}:sum{t in T[a]}y[a,t]>=y[a2,t2];
subject to fourteen{a in A,a1 in AH[a],t in T[a]:a1<>a}:sum{t1 in T[a1]}y[a1,t1]>=y[a,t];
subject to fifteen{a in A,




