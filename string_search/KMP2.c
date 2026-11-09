#include <stdio.h>
//配列の添え字は１から開始するものと考える．++i,++jを排除して整理した．
//compfはテーブルの作成

void kmp(char p[], char t[], int m, int n)
{
  int i = 1;
  int j = 1;
  int f[MAX_PATTERN];

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

//テーブルを作るための関数
void compf(char p[], int m, int f[])
{
  //jは何番目のパターンの値を求めているか
  //iはサブパターンの何番目を参照しているか
  int i = 1;
  int j = 0;
  f[1] = 0;

  while(j < m)
    if(i == 0 || p[i] == p[j]){
      j++;
      i++;
      f[j] = i;
    }else
      i = f[i];
}

// 参考文献：平田 富夫，アルゴリズムとデータ構造（第3版），森北出版株式会社，2016
