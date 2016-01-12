#include <stdio.h>
#include <os9.h>
#include <ctype.h>
#include <time.h>
/* Key bits */
#define LEFT  0X20
#define RIGHT 0X40

/* Flags */
#define TRUE  1
#define FALSE 0

FILE  *hi_file;
struct sgtbuf systime;
struct registers reg;
static int old_x, old_y; 
static char r;
float getseed();
static char highname[5] = {'J','i','m','\n','\0'};
static int highscore = 0;
static int a = 0, c = 0;
static int p, px, py;
static int x = 0, y = 0;
static int bx = 0, by = 0;
static int lv, level;
static int hit;
static int hits = 0;
static int kills = 0, totalkills;
static int cont = TRUE;
static int rank = 0;
static int dead = FALSE, stopfire = FALSE;
static int march, steps, swings, target;
static int finished = 0;
static int offset = 0;
static int limit;
static int jumps[8] = {5,5,4,4,3,3,2,2};
static int drops[8] = {3,2,3,2,3,2,3,2};
static int ax = 0, ay = 0;
static char shot = '\d149';
static char blank = '\d128';
static char home = '\d001';
static char projectile[2] = {'\d197','\d202'};
static char screen[480];
static char aliens[6][256];
static char bigblank[3] = {'\d128','\d128','\d128'};
static int  offcalc[480]; 
static char player[4] = {'\d128','\d167','\d171','\d128'};
static char alien[8][4] = {
  {'\d128','\d142','\d141','\d128'},
  {'\d128','\d158','\d157','\d128'},
  {'\d128','\d174','\d173','\d128'}, 
  {'\d128','\d190','\d189','\d128'},
  {'\d128','\d206','\d205','\d128'},
  {'\d128','\d222','\d221','\d128'},
  {'\d128','\d238','\d237','\d128'},
  {'\d128','\d254','\d253','\d128'}
};
main()  {
intro();
setuplimit();
do {
  px = random(10) + 10;
  py = 14;
  old_x = px;
  old_y = py;
  p = (32 * py) + px;
  lv = 0;
  level = 0;
  totalkills = 0;
  curoff();
  dead = FALSE;
  while (dead != TRUE)  {
    curxy(0,15);
    printf("Wave %-4d                      ", level+1);
    fflush(stdout);
    initscrn();
    makelevels();
    rank = 0;
    steps = 8;
    kills = 0;
    hits = 0;
    bx = 0;
    by = 0;
    offset = 0;
    swings = 0;
    target = random(jumps[lv]) + 1;
    r = blank;
    a = 0;
    ax = 0;
    ay = 0;
    player[1] = '\d167';
    player[2] = '\d171';
    putchar(home);
    fflush(stdout);
    write(1,screen,480);
    movealiens();
    finished = FALSE;
    while (!finished && a < 480) {
      for (march = 0; march < steps; ++march, ++a, ++ax)
        updatescreen();
      advance();
      if (finished || a > 479)
        break;
      for (march = 0; march < steps; ++march, --a, --ax)
        updatescreen();
      advance();
    }
  curxy(px, py);
  write(1, player,4);
  ++level;
  if (++lv > 7)
    lv = 1;
  }
  checkhigh();
  curxy(6,0);
  printf("High Score: %-4d %3s", highscore, highname);
  curxy(0,15);
  printf("Kills %-4d  Play again (y/n)? ", totalkills);
  fflush(stdout);
  while (r != 'y' && r != 'n' && r != 'N' && r != 'Y') 
    r = inkey();
  if (r == 'y' || r == 'Y')
     cont = TRUE;
  else
    cont = FALSE;
} while (cont == TRUE);
curon();
savehi();
printf("\nSaving high score...\n");
system("tmode echo pause");
}
updatescreen()  {
  if (screen[(p + 1) - a] != blank || screen[(p + 2) - a] != blank)
    die();
  curxy(px, py);
  write(1, player,4);
  bombaway();
  curxy(ax,ay);
  write(1,screen,offcalc[a]);
  keyin();
}
die()  {
 player[1] += 32;
 player[2] += 32;
 if (player[1] > 255)
   player[1] = 151;
 if (player[2] > 255)
   player[2] = 155;
 bx = FALSE;
 dead = TRUE;
 stopfire = TRUE;
 finished = TRUE;
 curxy(px, py);
 write(1, player,4);
}
advance()  {
  steps += offset;
  offset = 0;
  if (++swings == target)  {
    ++ay;
    a += 32;
    swings = 0;
    target = random(jumps[lv]) + 1;
  }
}
bombaway() {
  if (bx == 0) {
    if (!random(drops[lv]))  {
      for (x = px + 1, y = py - 1; y > ay; --y) {
        if (( hit = ((32 * y) + x) - a) > 0)  {
          if (screen[hit] != blank)  {
            bx = x;
            by = y;
          }
        }
      }
    }
  }
  else  {
    curxy(bx,by);
    write(1,bigblank,2);
    if (++by < 13)  {
       curxy(bx,by);
       write(1,projectile,2);
    }
    else if (by == 15) 
      bx = FALSE;
    else {
      curxy(bx,by);
      write(1,projectile,2);
      if (((bx == px) || (bx == (px + 1)) || (bx == (px + 2))) && by == py)
        die();
    }
  }
}
fire() {
  for (x = px + 1, y = py - 1; y > 0; --y) {
    if (y == by && ((x == bx) || (x == (bx + 1))))
      break;
    curxy(x,y);
    putchar(shot);
    if ((hit = ((32 * y) + x) - a) > 0)  {;
      if (screen[hit] != blank) {
        ++totalkills;
        if (++kills == 24 )  {
          aliendestroyed();
          finished = TRUE;
        }
        else if (++hits == 4)  {
          steps += 2;
          offset += 2;
          hits = 0;
          ++rank;
          movealiens();
          if (ay == 0) {
            a += 32;
            ++ay;
          }
        }
        else {
          aliendestroyed();
        }
      break;
      }
    }
  }
  for (x = px + 1, c = py - 1; c >= y; --c) {
    curxy(x,c);
    putchar(blank);
  }
}
aliendestroyed()  {
  curxy(x - 1, y);
  write(1,bigblank,3);
  screen[hit] = blank;
  screen[hit - 1] = blank;
  screen[hit + 1] = blank;
}
makelevels()  {
  int ranks;
  int cols;
  int rows;
  int c;
  int limit;
  for (ranks = 0; ranks < 6; ++ranks)  { 
    c = 0;
    for (rows = 0; rows < 4; ++rows)  {
      limit = 32 + (ranks * 2);
      for (cols = 0; cols < limit; ++cols)  {
        aliens[ranks][c] = blank;
        c++;
      }
      limit = 24 - (ranks * 4);
      for (cols = 0; cols < limit; cols += 4)  {
        aliens[ranks][c]   = alien[lv][0];
        aliens[ranks][c+1] = alien[lv][1];
        aliens[ranks][c+2] = alien[lv][2];
        aliens[ranks][c+3] = alien[lv][3];
        c += 4;
      }
      limit = 8 + (ranks * 2);
      for (cols = 0; cols < limit; ++cols)  {
        aliens[ranks][c] = blank;
        c++;    
      }
    }
  }
}
movealiens()  {
  for (c = 0; c < 248; ++c)
    screen[c] = aliens[rank][c];
}
setuplimit()  {
  for (x = 0; x < 224; ++x)
    offcalc[x] = 248;
  for (x = 224, y = 0; x < 480; ++x, ++y)
    offcalc[x] = 256 - y;
}
intro() {
  cls();
  curoff();
  system("tmode -echo -pause");
  loadhi();
  curxy(11,5);
  printf("Invasion!\n");
  curxy(9,6);
  printf("by Jim Gerrie\n");
  curxy(6,14);
  printf("press a key to begin\n");
  while ((r = inkey()) == NULL);
  cls();
}
initscrn()  {
  for (x = 0; x < 480; ++x)
    screen[x] = blank;
}
inkey() {
  char r;
  reg.rg_a = 1;
  reg.rg_b = SS_READY;
  _os9(I_GETSTT,&reg);
  if (reg.rg_b == 0XF6)
    return(NULL);
  read(1,&r,1);
  return(r);
}
cls() {
  putchar(0X0C);
  fflush(stdout);
}
curoff() {
  printf("%c%c",0X05,0X20);
}
curon() {
  printf("%c%c",0X05,0X21);
}
curxy(x,y)
  char x,y;
{
  putchar(0X02);
  putchar(x += 0X20);
  putchar(y += 0X20);
  fflush(stdout);
}
float getseed() {
  static float seed;
  float fltconv;
  int intconv;
  struct sgtbuf time;
  if ((seed < 1) || (seed > 9999)) {
    getime(&time);
    seed = time.t_minute * 100 + 1234;
    seed += time.t_second;
  }
  seed *= 221;
  seed += 2113;
  intconv = seed / 10000;
  fltconv = intconv;
  fltconv *= 10000;
  seed -= fltconv;
  return(seed);
}
random(num)
  int num;
{
  float seed,get;
  int rnd;
  seed = getseed();
  get = 10000 / num;
  rnd = seed / get;
  return(rnd);
}
keyin() {
  reg.rg_a = 1;
  reg.rg_b = 0X27;
  _os9(I_GETSTT,&reg);
  switch (reg.rg_a)  {
    case 0:
      stopfire = FALSE;
      break;
    case -96:
    case -64:
    case -112:
    case -120:
    case -128:
      if (!stopfire)
        fire();
      stopfire = TRUE;
      break;
    case LEFT:
      old_x = px--;
      checkH();
      break;
    case RIGHT:
      old_x = px++;
      checkH();
      break;
    case 8:
      old_y = py--;
      checkV();
      break;
    case 16:
      old_y = py++;
      checkV();
    default:
      stopfire = FALSE;
  }
}
checkV()  {
  if (py < 13 || py > 14)
    py = old_y;
  p = (32 * py) + px;
  stopfire = FALSE;
  curxy(old_x, old_y);
  write(1, bigblank,4);
}
checkH()  {
  if (px < 0 || px > 28) 
    px = old_x;
  p = (32 * py) + px;
  stopfire = FALSE;
}
loadhi() {
  hi_file = fopen ("invade_hi.scr","r");
  if (hi_file == (FILE *) NULL )
    printf ("High score file not found.");
  else
    fscanf(hi_file,"%d %s",&highscore,highname);
  fclose(hi_file);
}
savehi() {
  int *hs = highscore;
  hi_file = fopen ("invade_hi.scr","w");
  if (hi_file == (FILE *) NULL )
    printf ("High score file not found.");
  else
    fprintf(hi_file,"%d %s",hs,highname);
  fclose(hi_file);
}
checkhigh()  {
 curon();
 if (totalkills > highscore)  {
    curxy(0,15);
    printf("Enter initials: ");
    fflush(stdout);
    while ((r = inkey()) != NULL);
    c = 0;
    do {
      curxy(16 + c, 15);
      while ((r = inkey()) == NULL)
        ;
      if (c < 3 && isalpha(r))  {
        highname[c] = r;
        putchar(r);
        fflush(stdout);
        c++;
      }
      else
        c = 0;
    } while (r != '\n');
    highscore = totalkills;
  }
  curoff();
}
