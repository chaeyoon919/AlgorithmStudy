//문제접근
//1.입력 문자열에서 이 패턴들을 모두 임시 문자 하나로 치환
//2.치환이 끝난 문자열의 길이가 답

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // 크로아티아 알파벳에 해당하는 특수 문자열 배열
        String[] croatiaAlphabet = {"c=", "c-", "dz=", "d-", "lj", "nj", "s=", "z="};
        String a = scanner.next();

        // 크로아티아 알파벳 배열에 있는 문자열을 모두 @ 로 치환 → 크로아티아 알파벳을 하나의 문자처럼 계산하기 위함
        for(int i =0; i < croatiaAlphabet.length; i++){
            a = a.replace(croatiaAlphabet[i], "@");
        }
        System.out.println(a.length());

    }
}
