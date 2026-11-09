#include <stdio.h>

void bm1(char p[], char t[], int m, int n)
{
  int i, j, d[256];

  i = j = m;
  compd(p, d, m);
  while(i >= 1 && j <= n)
    if(p[i] == t[j]){
      i--;
      j--;
    }else{
      if(i == m)
        j = j + d[t[j]];
      else
        j = j + m - i + d[p[m]];
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

// 参考文献：平田 富夫，アルゴリズムとデータ構造（第3版），森北出版株式会社，2016
