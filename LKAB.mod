#Sets#
set K;                       #set of ore grades
set V;                       #set of shaft groups
set A;                       #set of machine placement
set T;                       #set of time periods composing the long-term time horizon (T3 is the complement thereof)
set L;                       #set of drawdown lines
set Av{ v in V} within A;     #set of machine placements in shaft group v
set IA;                      #set of inactive machine placements
set AVa{a in A} within A;     #set of machine placements whose start date is restricted vertically by machine placement a
set AHa{a in A} within A;     #set of machine placements whose start date is forced by adjacency to machine placement a
set At{t in T} within A;      #set of machine placements that can start to be mined in time period t
set B ;                      #set of production blocks
set Ba{a in A} within B;      #set of production blocks in machine placement a
set Bl{l in L} within B;      #set of production blocks in drawdown line l
set Bt{t in T} within B;      #set of production blocks that can be mined in time period t
set La{a in A} within L;      #last (i.e., most deeply positioned) drawdown line in machine placement
set LC within L ;            #set of drawdown lines constrained by another drawdown line
set Ll{l in L} within L;      #set set of drawdown lines that vertically constrain drawdown line l
set LVa{a in A} within L;     #drawdown line whose finish date vertically restricts starting to mine machine placement a
set LHa{a in A} within L;     #drawdown line whose finish date forces the start date of machine placement a by adjacency
set Lt{t in T} within L;      #set of drawdown lines that can be mined in time period t
set T3 in T;                 # T3 is the complement thereof for T
set T1 within T;             #set of time periods composing the short-term time horizon
set Ta{a in A} within T;      #set of time periods in which machine placement a can start to be mined (restricted by machine placement location and the start dates of other relevant machine placements)        
set Tb{b in B} within T;      #set of time periods in which production block b can be mined (restricted by production block location and the start dates of other relevant production blocks)
set Tl{l in L} within T;      #set of time periods in which drawdown line l can finish being mined (restricted by drawdown line location and the finish times of other relevant drawdown lines)
set T2{l in L} within T;     #time period by which all production blocks in drawdown line l must finish being mined

#Parameters#
param p{t in T}:=card(T)+1-t;
param LHDt{t in T};
param LHDv{v in V};
param d{k in K,t in T};
param r{a in A,t1 in T,t in T,k in K};
param g{a in A,t1 in T,t in T} binary;
param R{b in B,k in K};
param Maxc{a in A,t in T};
param Minc{a in A,t in T};


#variables
var az{k in K,t in T} >=0;
var bz{k in K,t in T} >=0;
var x{b in B, t in T} >=0;
var w{l in L, t in T} binary;
var y{a in A, t in T} binary;

#Objective Function#
minimize Total:sum{k in K,t in T} p[t]*(bz[k,t]+az[k,t]);

#constraint
subject to two{k in K,t in T}:sum{a in At[t], t1 in Ta[a]:t1<=t}r[a,t1,t,k]*y[a,t1]+sum{b in Bt[t]}(R[b,k]*x[b,t]/(sum{k1 in K}R[b,k1])+bz[k,t]-az[b,t])=d[k,t];
subject to three{t in T1}:sum{a in At[t],k in K,t1 in Ta[a]:t1<=t}r[a,t1,t,k]*y[a,t1]+sum{b in Bt[t]}x[b,t]=sum{k in K}d[k,t];
subject to four{v in V, l in L, t in Tl[l],t2 in T2[l]}:sum{a in(Av[v] inter At[t2]),t1 in Ta[a]:t1<=t}g[a,t1,t]*y[a,t1]+sum{a in Av[v],ll in (La[a] inter Lt[t])} (1-w[ll,t2])<=LHDv[v];
subject to five {t in T}:sum{a in (IA inter At[t])} y[a,t]<=LHDt[t];
subject to six {b in B}:sum{t in Tb[b]}x[b,t]<=sum{k in K}R[b,k];
subject to seven {l in L,t in Tl[l]}:sum{b in Bl[l],u in Tl[l]:u<=t}x[b,u]>=sum{b in Bl[l],k in K} R[b,k]*w[l,t];
subject to eight {l in LC, b in Bl[l],l2 in Ll[l],t in Tl[l2]}:sum{u in Tl[l2]:u<=t}x[b,u]<=sum{k in K}R[b,k]*w[l2,t];
subject to nine {a in A,l in La[a],t in Tl[l]}:sum{b in(Ba[a] inter Bt[t])} x[b,t]<=(Maxc[a,t]);
subject to ten {a in A,l in La[a],t in Tl[l]}:sum{b in (Ba[a] inter Bt[t])}x[b,t]>=(Minc[a,t]*(1-w[l,t]));
subject to eleven {a in A,a3 in AVa[a],l in LVa[a],t in Ta[a3]}:w[l,t]>=y[a3,t];
subject to twelve {a in A,a3 in AHa[a],l in LHa[a],t2 in Tl[l]}:sum{t in Ta[a3]:t<=t2}y[a3,t]>=w[l,t2];
subject to thirteen {a in A,a2 in AVa[a],t2 in Ta[a2]:a2<>a}:sum{t in Ta[a]}y[a,t]>=y[a2,t2];
subject to fourteen {a in A,a1 in AHa[a],t in Ta[a]:a1<>a}:sum{t1 in Ta[a1]}y[a1,t1]>=y[a,t];
subject to fifteen {a in A}:sum{t in Ta[a]}y[a,t]<=1;
subject to sixteen {a in A}:sum{t in Ta[a]}y[a,t]<=1;
subject to seventeen {l in L,t in T2[l]}:w[l,t]=1;





