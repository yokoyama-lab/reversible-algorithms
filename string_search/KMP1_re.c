#include <stdio.h>
#include <string.h>
void compf(char p[], int m, int f[]);

int kmp(char p[], char t[], int m, int n)
{
  int i =1, j = 1;
  int f[strlen(p)];

  compf(p, m, f);
  while (i <= m && j <= n) {
    if (i == 0 || p[i] == t[j]) {
      i++;
      j++;
    } else {
      i = f[i];
    }
  }

  return j;
}

void compf(char p[], int m, int f[])
{
  int i = 0, j = 1;
  f[1] = 0;

  while (j < m) {
    if (i == 0 || p[i] == p[j]) {
      f[++j] = ++i;
    } else {
      i = f[i];
    }
  }
}

int main(void)
{
  char pat[1000], text[1000];
  int r;

  printf("text :");
  scanf("%s", text);
  printf("pat  :");
  scanf("%s", pat);

  r = kmp(pat, text, strlen(pat), strlen(text));

  if (r != strlen(text)) {
    printf("found\n");
  } else {
    printf("not found\n");
  }
}
