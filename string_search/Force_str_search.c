// 力任せ法による文字列検索のCプログラム[1]
// ただし，文字列の先頭の添え字を，教科書では1としてあったが，本プログラムでは0とした
// [1] 平田 富夫，アルゴリズムとデータ構造（第3版），森北出版株式会社，2016

#include <stdio.h>
#include <string.h>             /* for strlen() */

// パターンpの探索場所がiで，サイズをmで表す
// 文字列tの探索場所がjで，サイズをnで表す
int forceStrMatch(char p[], char t[], int m, int n)
{
    int i = 0, j = 0;

    while (i < m && j < n) {
        if (p[i] == t[j]) {
            i++;
            j++;
        } else {
            j = j - i + 1;
            i = 0;
        }
    }

    return j;
}

int main(void)
{
    char pat[1024], text[1024];
    int r;

    scanf("%s", pat);           // パターンの入力
    scanf("%s", text);          // 文字列の入力

    r = forceStrMatch(pat, text, strlen(pat), strlen(text));

    if (r != strlen(text)) {
        printf("found: %lu\n", r - strlen(pat));
    } else {
        printf("not found\n");
    }
}
