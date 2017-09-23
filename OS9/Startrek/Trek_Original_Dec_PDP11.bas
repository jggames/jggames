DK:TREK.BAS    to TT:
1000    REM     TREK.BAS        27-JUL-73       ARON K. INSINGA PROJECT DELTA
1002    REM     CRTREK.B2S      30-JUL-77       JAMES E. THOMPSON       IPG
1003    REM     TREK.BAS        21-DEC-78       BOB SUPNIK      SSE
1005    RANDOMIZE
1010    E$ = CHR$(155%)\ Y$ = E$ + "Y"  \ REM ESCAPE MOVE CURSOR
1011    E1$ = E$ + "J" \ D1% = 8%       \ REM ERASE SCREEN FROM CURSOR DOWNWARD
1012    H0$ = E$ + "H"\ B$ = CHR$(8%)   \ REM HOME BACKSPACE
1016    H2$ = Y$ + CHR$(52%) + CHR$(32%) + E1$ \ REM ERASE BOTTOM
1020    S8% = 60% + 32%\ S9% = 9% + 32% \ REM DEFINE SECTOR ORIGIN
1021    G8% = 4% + 32%\ G9% = 16% + 32% \ REM DEFINE GALAXY ORIGIN
1022    P8% = 46% + 32%\ P9% = 9% + 32% \ REM DEFINE COMPASS ORIGIN
1024    D8% = 18% + 32%\ D9% = 20% + 32%        \ REM DEFINE DAMAGE ORIGIN
1025    DIM V%(7%),L$(3%)                       \ REM HOLDS OFFSETS FOR STATUS VARIABLES
1026    DATA 9,10,9,7,7,9,9
1027    FOR I%=1% TO 7% \ READ V%(I%) \ NEXT I%
1030    DEF FNS$(X%,Y%) = Y$ + CHR$(S9%-(Y%-1%)) +CHR$(S8%+((X%-1%)*2%))
1031    DEF FNQ$(X%,Y%) = Y$ + CHR$(G9%-((Y%-1%)*2%)) + CHR$(G8%+((X%-1%)*4%))
1032    DEF FNP$(X%,Y%) = Y$ + CHR$(P9%+Y%) + CHR$(P8%+X%)
1035    DEF FNV$(I%) = Y$ + CHR$(S9%+1%+I%) + CHR$(S8%+V%(I%))
1036    DEF FNO$(X%,Y%) = SEG$(".EKB*",Q%(X%,Y%)+1%,Q%(X%,Y%)+1%)
1037    DEF FNG$(X%,Y%) = SEG$(STR$(Z%(X%,Y%)+1000%),2%,4%)
1038    DEF FND$(X%,Y%) = Y$ + CHR$(D9%+(Y%-1%)) + CHR$(D8%+X%)
1039    DEF FNZ$(X%,Y%) = SEG$(".E...",Q%(X%,Y%)+1%,Q%(X%,Y%)+1%)
1040    REM
1045    REM     OBTAIN TERMINAL CHARACTERISTICS
1050    REM
1052    PRINT H0$; E1$; "Star Trek V2.0" \ PRINT
1054    PRINT "Terminal baud rate";\ INPUT B5%
1055    F% = B5%/300%                   \ REM SET NO. OF TIMES TO FLICKER
1056    B5$ = ""\ PRINT "Sound effects";\ INPUT A$
1057    IF SEG$(A$,1,1) = "Y" THEN B5$ = CHR$(7%)
1060    M9%=0%                          \ REM MASTER GAME SWITCH
1062    PRINT "Master game"; \ INPUT A$
1064    IF SEG$(A$,1,1)="Y" THEN M9%=-1%
1066    X9%=200% \ IF M9%<>0% THEN X9%=1000%
1068    DIM R(9%),D$(8%),G%(8%,8%),Q%(8%,8%),K%(9%,3%),D%(8%),Z%(8%,8%)
1070    FOR I%=1% TO D1% \ READ D$(I%) \ D%(I%)=0% \ NEXT I%
1072    FOR I%=1% TO 9% \ READ R(I%) \ NEXT I%
1074    FOR I%=1% TO 3% \ READ L$(I%) \ NEXT I%
1076    FOR I%=1% TO 8% \ FOR J%=1% TO 8% \ Z%(I%,J%)=0% \ NEXT J% \ NEXT I%
1080    DATA "Warp engines","S.R. sensors","L.R. sensors","Phaser beam"
1090    DATA "Torpedo tubes","Damage cntrl","Computer","Battle analyzer"
1100    DATA .0001, .01, .03, .08, .23, 1.28, 3.28, 6.28, 13.28
1105    DATA "Battle Report:","[Dist/Energy]",""
1110    T% = INT(RND*20+20)*100%\ T0% = T%\  E% = 3000%\ E0% = E%
1120    P% = 10%\ P0% = P%              \ REM INITIAL CONDITIONS
1125    T9% = 40%\ IF M9%<>0% THEN T9% = 30% + INT(RND*20)
1130    DEF FNF(X%) = SQR((K%(X%,1%)-S1%)^2%+(K%(X%,2%)-S2%)^2%)
1140    DEF FNR%(X%) = INT(RND*8+1)
1150    Q1% = FNR%(X%)\ Q2% = FNR%(X%)\ S1% = FNR%(X%) \ S2% = FNR%(X%)
1159    REM
1160    REM SET UP THE GALAXY
1161    REM
1170    B9% = 0%\ K9% = 0%
1180    FOR I% = 1% TO 8%\ FOR J% = 1% TO 8%
1182      K3% = 0%\ C1 = RND * 64
1184      FOR K0%=1% TO 9%\ IF C1 < R(K0%) THEN K3%=K3%+1%
1185      NEXT K0%
1186      K9%=K9%+K3%\ B3%=0%\ IF RND > .9 THEN B3%=1%
1188      B9% = B9% + B3%\ G%(I%,J%) = (K3%*100%)+(B3%*10%)+FNR%(X%)
1190    NEXT J%
1192    NEXT I%
1220    K0% = K9%
1222    REM
1224    REM     MAKE SURE THERE IS AT LEAST ONE BASE
1126    REM
1230    IF B9% = 0% THEN I%=FNR%(X%)\ J% = FNR%(X%)\ G%(I%,J%) = G%(I%,J%) + 10%\B9%=1%
1240    PRINT H0$; E1$; "Orders:        Stardate =";T%\ PRINT
1250    PRINT "You must destroy the Klingon invasion force of";K9%;"battle"
1260    PRINT "cruisers.  You have";T9%;"solar years to complete your mission."
1300    PRINT "Ready";\ INPUT A$
1310    PRINT H0$; E1$\ GOSUB 2600      \ REM BLANK SCREEN & DRAW THE GALAXY
1399    REM
1400    REM     SET UP QUADRANT
1401    REM
1420    K3% = 0%\ B3% = 0%\ S3% = 0%\ H8% = 0%\ K8% = 0%
1430    X = G%(Q1%,Q2%)                 \ REM GET WORD WHICH DESCRIBES OCCUPANTS OF THIS QUAD
1440    K3% = INT(X/100)\ B3% = INT(X/10)-(10*K3%)\ S3% = X-(INT(X/10) * 10)
1445    FOR I%=1% TO 8%\ FOR J%=1% TO 8%\ Q%(I%,J%)=0%\ NEXT J%\ NEXT I%
1448    FOR I%=1% TO 9%\ FOR J%=1% TO 3%\ K%(I%,J%)=0%\ NEXT J%\ NEXT I%
1450    Q%(S1%,S2%) = 1%                \ REM INSERT ENTERPRISE
1460    FOR I% = 1% TO K3%
1462      GOSUB 5200                    \ REM SELECT RANDOM EMPTY SECTOR
1464      Q%(R1%,R2%) = 2%              \ REM AND PUT A KLINGON IN IT
1466      K%(I%,1%) = R1%\ K%(I%,2%) = R2%\ K%(I%,3%) = X9% + INT(RND*(X9%/2%))
1468    NEXT I%
1470    FOR I% = 1% TO B3%\ GOSUB 5200 \ Q%(R1%,R2%) = 3%\ NEXT I% \ REM INSERT BASE(S)
1480    FOR I% = 1% TO S3%\ GOSUB 5200 \ Q%(R1%,R2%) = 4%\ NEXT I% \ REM INSERT STAR(S)
1490    GOSUB 1500\ GOSUB 1580          \ REM SET STATUS, DISPLAY QUAD
1495    GOSUB 2370                      \ REM KLINGON ATTACK
1497    GO TO 1650                      \ TO CMD DECODER
1499    REM
1500    REM     RED/ORANGE/YELLOW/GREEN STATUS [SUBROUTINE]
1501    REM
1520    C$="Green "\ IF E%<=E0%/10% THEN C$="Yellow"
1521    FOR I% = Q1%-1% TO Q1%+1%
1523    FOR J% = Q2%-1% TO Q2% + 1%
1524            IF I%>0% THEN IF I%<9% THEN IF J%>0% THEN IF J%<9% THEN GOTO 1526
1525            GOTO 1528               \ REM INVALID SECTOR
1526            IF G%(I%,J%)>99% THEN C$="Orange"\ GO TO 1530
1528    NEXT J%
1529    NEXT I%
1530    FOR I% = S1%-1% TO S1% + 1%
1532    FOR J% = S2%-1% TO S2%+1%
1534            IF I%>0% THEN IF I%<9% THEN IF J%>0% THEN IF J%<9% THEN IF Q%(I%,J%)=3 THEN GOTO 1536
1535            GOTO 1538
1536            FOR I1% = 1% TO 8%\ D%(I1%) = 0%\ NEXT I1%\ C$ = "Docked"
1537            E% = E0%\ P%=P0%\ PRINT FNV$(5%); E%; FNV$(6%); P%;\ GOTO 1570
1538    NEXT J%
1540    NEXT I%
1550    IF K3% <> 0% THEN C$ = "Red   " \ REM IF NOT DOCKED & KLINGON(S) IN QUADRANT
1570    PRINT\ PRINT FNV$(2%); C$; \ RETURN     \ REM PUT NEW CODITION IN STATUS DISPLAY
1579    REM
1580    REM     SCAN QUADRANT SECTOR BY SECTOR [SUBROUTINE]
1581    REM
1590    FOR I% = 8% TO 1% STEP -1%
1592      PRINT FNS$(1%,I%);
1594      FOR J%=1% TO 8%
1596        IF D%(2%) =0% THEN PRINT FNO$(I%,J%); " ";
1598        IF D%(2%)<>0% THEN PRINT FNZ$(I%,J%); " ";
1600      NEXT J%\ PRINT "|"
1605    NEXT I%
1610    RETURN
1649    REM
1650    REM     COMMAND DECODER
1651    REM
1655    GOSUB 1500                      \ REM OBTAIN CURRENT CONDITION
1660    A$ = ""\ PRINT H2$;
1665    Z%(Q1%,Q2%) = G%(Q1%,Q2%)       \ REM UPDATE GALAXY (NOT DISPLAYED YET, THO)
1670    PRINT "Command";\ INPUT A$\ A% = POS("WSLPTDCEB",SEG$(A$,1%,1%),1%)
1680    IF A%=0% THEN GO TO 4000
1690    ON A% GOTO 1700, 5100, 1960, 2040, 2140, 2310, 5000, 2550, 5400
1699    REM
1700    REM     WARP DRIVE [W COMMAND]
1701    REM
1710    PRINT H2$;
1715    PRINT "Course (1-8.99), Warp factor (0-12)";\ INPUT C1, W1
1720    IF W1*C1 = 0 GOTO 1650 
1721    IF C1>=1 THEN IF C1<=9 THEN IF W1>=0 THEN IF W1<=12 GOTO 1725
1722    PRINT "Invalid course, please reenter.";\ GOSUB 9000\ GOTO 1710
1725    Z5% = 0%                        \ REM FLAG FOR QUADRANT DETECTION
1730    IF W1 > .25 THEN IF D%(1%) < 0% THEN PRINT "Warp engines are damaged, max speed = Warp .25"\ GOSUB 9000\ GOTO 1710
1740    IF K3% > 0% THEN GOSUB 2370     \ REM ALLOW KLINGON ATTACK IF ANY PRESENT
1745    IF M9%=0% THEN GO TO 1830       \ NO DAMAGE IN BASIC GAME
1750    FOR I%=1% TO D1%\ IF D%(I%)<0% THEN D%(I%)=D%(I%)+1%
1752    NEXT I%                         \ REM IMPROVE STATUS
1755    IF RND > .20 GOTO 1825          \ REM ONE CHANCE IN FIVE OF DISASTER
1760    IF RND > .5 GOTO 1790
1765    I% = INT((RND*D1%)+1)
1770    PRINT "*** Space storm: "; D$(I%); " damaged. ***"
1780    D%(I%) = D%(I%) - INT((RND*3)+1)\ GOTO 1825
1790    FOR I%=1% TO D1%\ IF D%(I%)<0% THEN GOTO 1810
1800    NEXT I%\ GOTO 1825
1810    D%(I%) = D%(I%)-INT((RND*D%(I%))-1)
1812    IF D%(I%) > 0% THEN D%(I%) = 0%
1820    PRINT "*** "; D$(I%); " state of repair improved. ***"
1825    REM
1830    N% = INT(W1*8%)\ IF E%-N% <= 0% THEN 2450
1831    IF T%+1% > T0%+T9% THEN 2450    \ REM LOST
1832    Q%(S1%,S2%) = 0%                \ REM REMOVE "E" IN SECTOR
1834    X = (Q1%*8%)+(S1%-1%)\ Y = (Q2%*8%)+(S2%-1%)\GOSUB 2300 \ REM POSITION AND DIRECTION
1840    FOR I% = 1% TO N%
1841      PRINT                         \ REM RESET LINE COUNTER
1842      X = X + X1\ Y = Y + X2        \ REM MOVE ONE UNIT IN PROPER DIRECTION
1844      Z3% = (INT(X+0.5))/8% \ Z4% = (INT(Y+0.5))/8% \ REM CALC NEW QUADRANT
1846      Z1% = INT(X+0.5)-(Z3%*8%)+1%\ Z2% = INT(Y+0.5)-(Z4%*8%)+1% \ REM NEW SECTOR
1850      IF Z3% = Q1% THEN IF Z4% = Q2% THEN 1870 \ REM SKIP IF SAME QUADRANT
1860      IF Z3%>0% THEN IF Z3%<9% THEN IF Z4%>0% THEN IF Z4%<9% THEN 1862
1861      GOTO 1910                     \ REM OUT OF GALAXY
1862            IF Z5% <> 0% THEN 1866 
1863            Z5% = 1%\ FOR I1%=1% TO 8%\ FOR J1%=1% TO 8%\ Q%(I1%,J1%)=0%\ NEXT J1%\ NEXT I1%
1864            FOR J% = 1% TO 8%\ PRINT FNS$(1%,J%); "               "\ NEXT J%
1866            PRINT\ PRINT FNQ$(Q2%,Q1%); FNG$(Q1%,Q2%);FNQ$(Z4%,Z3%); " E "; \ REM UPDATE GALAXY DISPLAY
1868            Q1% = Z3%\ Q2% = Z4%\ PRINT FNV$(3%); Q2%; "-"; Q1%;
1870      IF Q%(Z1%,Z2%) <> 0% THEN 1900 \ REM CAN BE BLOCKED ONLY IN ORIGINAL QUAD
1872      PRINT FNS$(S2%,S1%);\ IF Z5% = 1% THEN PRINT " ";\ GOTO 1874
1873      PRINT ".";                    \ REM REMOVE "E" FROM OLD SECTOR
1874      S1% = Z1%\ S2% = Z2%\ PRINT\ PRINT FNS$(S2%,S1%); "E";
1876      FOR J%=1% TO F%\ PRINT B$; " "; B$; "E";\ NEXT J%
1880      PRINT                         \ REM RESET LINE POINTER
1890    NEXT I%
1892    GOTO 1910
1900    PRINT H2$; "ENTERPRISE blocked by object at sector"; Z2%; "-"; Z1% \ GOSUB 9000
1910    T% = T% + 1%\ PRINT FNV$(1%); T% \ REM ADVANCE STARDATE
1914    PRINT FNV$(4%); S2%; "-"; S1%;  \ REM UPDATE SECTOR
1916    E% = E% - N%\ PRINT FNV$(5%); E%;       \ REM ENERGY LOSS = 1 UNIT/UNIT DISTANCE
1920    Q%(S1%,S2%) = 1%\ IF Z5% = 1% THEN 1400 
1930    GOTO 1650
1959    REM
1960    REM     LONG RANGE SENSOR SCAN [L COMMAND]
1961    REM
1970    IF D%(3%)<>0% THEN PRINT "Long range sensors are inoperable."\ GOSUB 9000\ GOTO 1650
1980    FOR I% = Q1%+1% TO Q1%-1% STEP -1%
1990      FOR J% = Q2%-1% TO Q2%+1% STEP 1%
2000            IF I%>0% THEN IF I%<9% THEN IF J%>0% THEN IF J%<9% THEN 2010
2005            GOTO 2020
2010            Z%(I%,J%) = G%(I%,J%)
2012            IF I% = Q1% THEN IF J% = Q2% THEN 2020
2015            PRINT FNQ$(J%,I%); FNG$(I%,J%);
2020      NEXT J%
2030    NEXT I%
2031    GOTO 1650                        \ REM GO GET NEXT COMMAND
2039    REM
2040    REM     PHASER CONTROL [P COMMAND]
2041    REM
2050    IF D%(4%)<>0% THEN PRINT "Phaser control is disabled."\ GOSUB 9000\ GOTO 1650
2055    IF K3%<=0% THEN PRINT "No Klingons in quadrant."\ GOSUB 9000\ GOTO 1650
2060    PRINT H2$;
2065    IF D%(7%)<>0% THEN PRINT "Computer failure reduces phaser effectiveness."
2070    PRINT "Number of units to fire";\ INPUT X%
2080    IF X% <= 0% GOTO 1650
2082    IF X% > E% THEN PRINT "Only";E%;"energy units available.";\ GOSUB 9000\ GOTO 2060
2084    E% = E% - X%
2085    PRINT FNV$(5%); E%              \ REM SHOW REDUCED ENERGY
2088    IF D%(7%)<>0% THEN X% = X%/INT(RND*5+1)
2090    FOR I% = 1% TO 9%
2095      IF K%(I%,3%) <= 0% THEN 2130  \ REM DON'T REDUCE IF ALREADY DEAD
2100      H% = INT(X%/FNF(I%)*((2*RND)+1%))     \ REM CALCULATE ENERGY IN HIT
2105      K%(I%,3%) = K%(I%,3%) - H%    \ REM REDUCE KLINGON'S ENERGY
2107      GOSUB 3100\ IF K%(I%,3%) <= 0% THEN GOSUB 3200
2110      PRINT H2$; H%; "unit hit on Klingon at sector";K%(I%,2%); "-"; K%(I%,1%)
2115      IF K%(I%,3%) > 0% THEN PRINT "    ("; K%(I%,3%); "remain)"
2128      GOSUB 9000\ IF K9% <= 0% THEN 2500 \ REM QUIT IF LAST KLINGON DESTROYED
2130    NEXT I%
2131    GOSUB 2370\ GOTO 1650           \ REM GIVE THE KLINGONS THEIR TURN
2139    REM
2140    REM     PHOTON TORPEDOS [T COMMAND]
2141    REM
2150    IF D%(5%)<>0% THEN PRINT "Photon tubes are not operational."\ GOSUB 9000\ GOTO 1650
2160    IF P% <= 0% THEN PRINT "All photon torpedoes expended."\ GOSUB 9000\ GOTO 1650
2165    PRINT H2$;
2170    PRINT "Torpedo course (1-8.9999)";\ INPUT C1
2180    IF C1 =0 THEN 1650
2182    IF C1>=1 THEN IF C1<9 THEN GOTO 2186
2184    PRINT H2$;"Invalid course, please reenter."\ GOSUB 9000\ GOTO 2165
2186    GOSUB 2300
2190    X = S1%\ Y = S2%\ P% = P% - 1%\ PRINT FNV$(6%); P%; \ REM REDUCE TORPEDO COUNT
2200    X = X + X1\ Y = Y + X2          \ REM MOVE ONE UNIT IN SELECTED DIRECTION
2201    Z1% = INT(X+0.5)\ Z2% = INT(Y+0.5) \ REM SET INTERMEDIATE LOCATION
2202    IF Z1%>0% THEN IF Z1%<9% THEN IF Z2%>0% THEN IF Z2%<9% THEN 2204
2203    PRINT H2$; "   Missed";\ GOTO 2290
2204    PRINT\ PRINT FNS$(Z2%,Z1%);
2206    IF Q%(Z1%,Z2%) <> 0% THEN 2220  \ REM JUMP IF HIT SOMETHING
2208    FOR I% = 1% TO F%
2209    PRINT "T"; B$; " "; B$;\ NEXT I% \ REM FLICKER TORPEDO
2210    PRINT "."; B$;\ GOTO 2200
2220    FOR I% = 1% TO 8%\ PRINT "T"; B$; FNO$(Z1%,Z2%); B$;\ NEXT I%
2230    IF Q%(Z1%,Z2%) <> 2% THEN 2250  \ REM JUMP IF NOT A KLINGON
2240    FOR I% = 1% TO 9%               \ REM FIND OUT WHICH KLINGON
2242            IF K%(I%,1%) <> Z1% THEN 2246
2243            IF K%(I%,2%) <> Z2% THEN 2246
2244            GOSUB 3200 \ PRINT H2$; "*** Klingon Destroyed! ***"\GOTO 2290
2246    NEXT I%
2250    PRINT "."; B5$; H2$
2260    IF Q%(Z1%,Z2%) = 4% THEN S3% = S3% - 1% \PRINT "   Star destroyed"
2270    IF Q%(Z1%,Z2%) = 3% THEN B3% = B3% - 1% \PRINT "*** Starbase destroyed...Congratulations ***"
2280    Q%(Z1%,Z2%) = 0%\ G%(Q1%,Q2%) = (K3%*100%) + (B3%*10%) + S3%
2290    GOSUB 9000 \ IF K9% <= 0% THEN 2500 
2295    GOSUB 2370 \ GOTO 1650
2300    X1 = SIN((C1-1)*.785398)\ X2 = COS((C1-1)*.785398)\ RETURN
2309    REM
2310    REM     DAMAGE CONTROL REPORT [D COMMAND]
2311    REM
2320    IF D%(6%)<>0% THEN PRINT "Damage control system is non-functional."\ GOSUB 9000\ GOTO 1650
2322    PRINT H2$; "Damage Report:";
2325    FOR I%=1% TO 3%
2330      FOR J%=1% TO 3%\ I0%=(I%-1%)*3%+J%
2335            IF I0%<=D1% THEN PRINT\ PRINT FND$((J%-1%)*20%,I%);D$(I0%);"=";D%(I0%);
2338      NEXT J%
2340    NEXT I%
2350    GOSUB 9000
2360    GO TO 1650
2369    REM
2370    REM     KLINGON ATTACK [SUBROUTINE]
2371    REM
2380    IF K3% = 0% THEN RETURN         \ REM IMMEDIATE RETURN IF NO KLINGONS
2390    IF C$ = "Docked" THEN PRINT H2$; "Starbase shields protect the ENTERPRISE"\ GOSUB 9000 \ RETURN
2395    H8% = 0%\ K8% = 0%              \ REM TOTAL COUNTERS
2400    FOR I% = 1% TO 9%
2404    H1% = K%(I%,3%)\ IF H1% <= 0% THEN 2440 \ REM SKIP ATTACK IF HE HAS NO ENERGY
2406    IF M9%<>0% THEN IF RND <= .3 THEN GOTO 2440
2408    IF M9%<>0% THEN H1% =  H1%/INT(RND*4+2)\ K%(I%,3%)=K%(I%,3%)-H1%
2410    H% = INT((H1%/FNF(I%))*((2*RND)+1%)) \ REM HIT INVERSE TO DISTANCE
2415    GOSUB 3100                      \ REM FLICKER THE ATTACKER
2420    PRINT H2$; H%; "unit hit from Klingon at sector";K%(I%,2%); "-"; K%(I%,1%) \ REM REPORT HIT
2425    H8% = H8% + H%\ K8% = K8% + 1%  \ REM INCREMENT TOTALS
2430    E% = E% - H%\ PRINT FNV$(5%); E%; \ REM SHOW TOTAL ENERGY REMAINING
2435    GOSUB 9000
2440    NEXT I%
2442    IF K8% > 1% THEN PRINT H2$; H8%; "units lost during attack by"; K8%; "enemy ships."\ GOSUB 9000
2445    IF E% > 0% THEN RETURN          \ REM FALL THRU IF NO ENERGY REMAINING
2450    PRINT H0$; E1$; "It is Stardate"; T% \ PRINT
2460    PRINT "The ENTERPRISE has been destroyed."
2470    PRINT "The Federation will be conquered."
2480    PRINT "There are still"; K9%; "Klingon battle cruisers in the galaxy."
2490    PRINT "You are dead."\ GOTO 2570
2500    PRINT H0$; E1$; "It is Stardate"; T% \ PRINT
2510    PRINT "The last Klingon battle cruiser in the galaxy has been destroyed."
2520    PRINT "The Federation has been saved."
2530    PRINT "You have been promoted to Admiral."
2540    PRINT K0%;"Klingons in";T%-T0%;"years. ";
2545    PRINT "Rating = "; (K0% * 100%)/(T% - T0%)*10% \ GO TO 2570
2550    PRINT H0$; E1$; "It is Stardate"; T% \ PRINT
2555    PRINT "There are still"; K9%; "Klingon battle cruisers in the galaxy."
2560    PRINT "The ENTERPRISE has been placed in more capable hands."
2565    PRINT "You have been put on the retired list with an inadequate pension."
2570    PRINT \ PRINT "Another game";\ INPUT A$
2580    IF SEG$(A$,1,1)="Y" THEN GOTO 1076
2590    STOP
2599    REM
2600    REM     CHART ENTIRE GALAXY [SUBROUTINE]
2601    REM
2610    PRINT H0$;                              \ REM CURSOR HOME
2620    PRINT "            >>Galaxy  Map<<"
2630    FOR I% = 8% TO 1% STEP -1%
2640    PRINT "   +---+---+---+---+---+---+---+---+"
2645    PRINT I%;"|";
2650    FOR J% = 1% TO 8%
2652            IF I% = Q1% THEN IF J% = Q2% THEN A$ = " E "\ GOTO 2656
2654            A$ = SEG$(STR$(1000%+Z%(I%,J%)),2%,4%)
2656            PRINT A$; "|";
2658    NEXT J%
2660    PRINT
2670    NEXT I%
2675    PRINT "   +---+---+---+---+---+---+---+---+"
2680    PRINT "   ";\FOR I%=1% TO 8%\ PRINT " "; I%; \ NEXT I%
2682    PRINT FNS$(0%,10%); " >>Quadrant  Map<<"
2684    PRINT FNS$(0%,9%); "+-----------------+"
2685    FOR I%=8% TO 1% STEP -1%\ PRINT FNS$(0%,I%); "|                 |"\ NEXT I%
2686    PRINT FNS$(0%,0%); "+-----------------+" \ REM OTHER SECTOR BOUNDARY
2688    PRINT FNS$(1%,-1%); "Stardate:"; T%; FNS$(1%,-2%); "Condition:"
2690    PRINT FNS$(1%,-3%); "Quadrant:"; Q2%; "-"; Q1%;
2692    PRINT FNS$(1%,-4%); "Sector:"; S2%; "-"; S1%
2694    PRINT FNS$(1%,-5%); "Energy:"; E%; FNS$(1%,-6%); "Torpedos:"; P%
2696    PRINT FNS$(1%,-7%); "Klingons:"; K9%
2699    REM
2700    REM     PRINT COMPASS (POINTER)
2701    REM
2710    PRINT FNP$(0%,-3%); "3"
2720    PRINT FNP$(-2%,-2%); "4 ! 2"
2730    PRINT FNP$(-1%,-1%); "\!/"
2740    PRINT FNP$(-3%,0%); "5--E--1"
2750    PRINT FNP$(-1%,1%); "/!\"
2760    PRINT FNP$(-2%,2%); "6 ! 8"
2770    PRINT FNP$(0%,3%); "7"
2780    RETURN
3099    REM
3100    REM     BLINK THE KLINGON WHO IS CURRENTLY ATTACKING (OR BEING ATTACKED)
3101    REM
3110    PRINT\ PRINT FNS$(K%(I%,2%),K%(I%,1%));
3120    FOR F7% = 1% TO F%
3125    PRINT " "; B$; "K"; B$;
3129    NEXT F7%
3130    RETURN
3199    REM
3200    REM     REMOVE A KLINGON (HURRAH!)
3201    REM
3210    PRINT "."; B5$                  \ REM ASSUME LAST CHARACTER IN FLICKER WAS BACKSPACE
3220    K3% = K3% - 1%\ K9% = K9% - 1%  \ REM REDUCE SECTOR, GALAXY COUNTS
3230    PRINT FNV$(7%); K9%             \ REM UPDATE STATUS DISPLAY
3240    Q%(K%(I%,1%),K%(I%,2%)) = 0%    \ REM REMOVE FROM QUADRANT
3245    K%(I%,3%) = 0%                  \ REM MAKE SURE KLINGON STAYS DEAD (DARE YA TO DELETE 3245)
3250    G%(Q1%,Q2%) = G%(Q1%,Q2%) - 100%        \ REM AND FROM GALAXY
3260    RETURN                          \ REM PREPARE FOR NEXT MESSAGE
3999    REM
4000    REM     ERROR RECOVERY
4001    REM
4010    PRINT H2$;
4100    PRINT "Valid commands are C, S, L, P, T, W, D, B, and E."
4110    GOSUB 9000 \ GO TO 1650
5000    REM
5010    REM     CHART ENTIRE GALAXY [C COMMAND]
5020    REM
5030    PRINT H0$; E1$;                 \ REM ERASE SCREEN
5040    GOSUB 2600 \ GOSUB 1580         \ REM CHART GALAXY AND QUADRANT
5050    GOTO 1650
5100    REM
5110    REM     SHORT RANGE SENSOR SCAN [S COMMAND]
5120    REM
5130    IF D%(2%)<>0% THEN PRINT "Short range sensors are inoperable."\ GOSUB 9000\ GOTO 1650
5140    GOSUB 1580
5150    GOTO 1650
5200    REM
5210    REM     FIND EMPTY SECTOR [SUBROUTINE]
5220    REM
5230    R1%=FNR%(X%)\ R2%=FNR%(X%)\ IF Q%(R1%,R2%)<>0% THEN 5230
5240    RETURN
5400    REM
5410    REM     BATTLE ANALYSIS [B COMMAND]
5420    REM
5430    IF D%(8%)<>0% THEN PRINT "Battle analyzer is out of commission."\ GOSUB 9000\ GOTO 1650
5440    IF K3%<=0% THEN PRINT "No Klingons in quadrant."\ GOSUB 9000\ GOTO 1650
5450    PRINT H2$;
5460    FOR I%=1% TO 3%
5470      PRINT FND$(-18%,I%);L$(I%);
5480      FOR J%=1% TO 3%\ I0%=(I%-1%)*3+J%
5490            IF K%(I0%,3%)<=0% THEN GOTO 5550
5500            PRINT\ PRINT FND$((J%-1%)*20%,I%);"K@ ";STR$(K%(I0%,2%));"-";STR$(K%(I0%,1%));
5510            PRINT " = ";STR$(INT(FNF(I0%)));"/";STR$(K%(I0%,3%));
5520    REM
5530    REM     INSERT COMPUTER PRINTOUT HERE
5540    REM
5550      NEXT J%
5560    NEXT I%
5570    GOSUB 9000
5580    GOTO 1650
9000    REM
9010    REM     SLEEP FOR TWO SECONDS
9020    REM
9030    FOR Z9%=1% TO 4000% \ NEXT Z9% \ RETURN
32767   END
