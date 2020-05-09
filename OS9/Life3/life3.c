/* Life by Jim Gerrie 2004 */

#include <stdio.h>

int A[24][80];
int X, Y, XL, XP, YL, YP, NM;
int HX, LX, HY, LY, GN;
int MX, MY;
int L[2][9] = {
                { 0, 0, 0, 1, 0, 0, 0, 0, 0 },
                { 2, 2, 0, 0, 2, 2, 2, 2, 2 }
              };
int POINT[80][24];
int NY,NX;
char I;

main ()
{
printf("\f"); 
printf("John Conway's Life Simulation\n");
MX = 0;
MY = 0;
while (MX < 1 || MX > 80 || MY < 1 || MY > 23)
{
  printf ("\nHorizontal screen size (80 max): ");
  scanf ("%d", &MX);
  printf ("\nVertical screen size (23 max):   ");
  scanf ("%d", &MY);
}
HX = MX - 1;
LX = 0;
HY = MY - 1;
LY = 0;
NX = HX - 1;
NY = HY - 1;

for (X = LX; X <= HX; ++X)
{
  for (Y = LY; Y <= HY; ++Y)
  {
    A[Y][X] = 0;
    POINT[X][Y] = 0;
  }
}

printf ("\n\nRun the R Pentomino (y/n)? ");
while (getchar() != '\n') {}
I = getchar();
if (I == 'Y' || I == 'y')
{
   A[11][21] = 1;
   A[10][22] = 1;
   A[10][21] = 1;
   A[11][20] = 1;
   A[12][21] = 1;
}
else
{
   printf ("\nRun the Glider (y/n)? ");
   while (getchar() != '\n') {}
   I = getchar();
   if (I == 'Y' || I == 'y')
   {
      A[5][22] = 1;
      A[6][23] = 1;
      A[7][23] = 1;
      A[7][22] = 1;
      A[7][21] = 1;
    }
    else
    {
      while (X != -1)
      {
      MakeScreen ();
      printf ("     Enter X Y corrdinates (-1 -1 to end): ");
      scanf ("%d%d", &X, &Y);
      if (X >= 0 && Y >= 0 && X < MX && Y < MY)
         A[Y][X] = 1;
      }
    }
}

/* Main Loop */

GN = 1;
while (GN < 30000)
{
  X =  0;
  XL = HX;
  XP = X + 1;
  for (Y = 1; Y <= NY; ++Y)
  {
    YL =Y - 1;
    YP =Y + 1;
    Normal ();
  }
  X  = HX;
  XL = X - 1;
  XP = 0;
  for (Y = 1; Y <= NY; ++Y)
  {
    YL = Y - 1;
    YP = Y + 1;
    Normal ();
  }
  Y  = 0;
  YL = HY;
  YP = Y + 1;
  for (X = 1; X <= NX; ++X)
  {
    XL = X - 1;
    XP = X + 1;
    Normal ();
  }
  Y  = HY;
  YL = Y - 1;
  YP = 0;
  for (X = 1; X <= NX; ++X)
  {
    XL = X - 1;
    XP = X + 1;
    Normal ();
  }

  X = 0;
  Y = 0;
  Border ();
  Y = HY;
  Border ();
  X = HX;
  Border ();
  Y = 0;
  Border ();

  for (Y = 1; Y <= NY; ++Y)
  {
    for (X = 1; X <= NX; ++X)
    {
      XL = X - 1;
      XP = X + 1;
      YL = Y - 1;
      YP = Y + 1;
      Normal ();
    }
  }
  MakeScreen ();
  ++GN;
}

/* End of Main loop */

}
/* Program End */

/* Function to Print Screen */

MakeScreen ()
{
printf ("\1");
for (Y = LY; Y <= HY; ++Y)
{
  for (X = LX; X <= HX; ++X)
  {
    switch (A[Y][X])
    {
    case 0:
      putchar (' ');
      POINT[X][Y] = 0;
      break;
    case 1:
      putchar ('O'); 
      POINT[X][Y] = 1;
      break;
    default:
      printf("Error in MakeScreen");
      break;
    }
  }
}
printf("Generation: %d", GN); 
}

/* Function to Check Borders */

Border ()
{
XL = X - 1;
if (XL == -1)
  XL = HX;
XP = X + 1;
if (XP == MX)
  XP = 0;
YL = Y - 1;
if (YL == -1)
  YL = HY;
YP = Y + 1;
if (YP == MY)
  YP = 0;
Normal ();
}

/* Function to do Normal Cells */ 

Normal ()
{
NM = POINT[XL][YL] + POINT[X][YL] + POINT[XP][YL] + POINT[XL][Y];
NM = NM + POINT[XP][Y] + POINT[XL][YP] + POINT[X][YP] + POINT[XP][YP];
switch (L[POINT[X][Y]][NM])
{
  case 1:
    A[Y][X] = 1;
    break;
  case 2:
    A[Y][X] = 0;
    break;
  default:
    break;
}
}

