#include <stdio.h>
//配列の添え字は１から開始するものと考える
//compfはテーブルの作成

void kmp(char p[], char t[], int m, int n)
{
  int i =1, j = 1;
  int f[MAXPAT]

  compf(p, m, f);
  while(i <= m && j <= n)
    if(i == 0 || p[i] == t[j]){
      i++;
      j++;
    }else
      i = f[i];
  if(i == m+1)
    printf("found at %d\n", j-m);
  else
    printf("not found\n");
}

void compf(char p[], int m, int f[])
{
  int i = 0, j = 1;

  f[1] = 0;
  while(j < m)
    if(i == 0 || p[i] == p[j])
      f[++j] = ++i;
    else
      i = f[i];
}

// 参考文献：平田 富夫，アルゴリズムとデータ構造（第3版），森北出版株式会社，2016
