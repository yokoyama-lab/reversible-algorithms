#include <stdio.h>

void bm2(char p[], char t[], int m, int n)
{
  int i, j, d[256], dd[MAXPAT];

  i = j = m;
  compd(p, d, m);
  compdd(p, dd, m);
  while(i >= 1 && j <= n)
    if(p[i] == t[j]){
      i--;
      j--;
    }else{
      j = j + max(d[t[j]], dd[i]);
      i = m;
    }
  if(i == 0)
    printf("found at %d\n", j+1);
  else
    printf("not found\n");
}

void compd(char p[], int d[], int m)
{
  int i

  for(i = 0; i <= 255; i++)
    d[i] = m;
  for(i = 1; i < m; i++)
    d[p[i]] = m-1;
}

void compdd(char p[], int dd[], int m)
{
    int f[MAXPAT];
    int i, j, k;

    for(i = 1; i <= m; i++)
      dd[i] = 2*m - 1;

    j = m;
    i = m+1;
    f[m] = m + 1;
    while(j > 0)
      if(i == m+1 || p[i] = p[j])
        f[--j] = --i;
      else {
        dd[i] = min(dd[i], m-j);
        i = f[i];
      }

    for(k = 1; k <= m; k++){
      if(k > i)
        i = f[i];
      dd[k] = min(dd[k], m+i-k);
    }
}

// 参考文献：平田 富夫，アルゴリズムとデータ構造（第3版），森北出版株式会社，2016
