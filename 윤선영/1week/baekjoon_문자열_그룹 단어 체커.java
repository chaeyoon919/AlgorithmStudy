//문제접근
//1.각 단어를 순차 탐색
//2.이전에 나온 적 있는 문자가 다시 등장했는지 검사
//3.현재 문자를 다음 루프의 prev로 설정해서 반복문으로 문자열 탐색
//4.그룹단어 true인 것 count++

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        int N = Integer.parseInt(br.readLine());

        int count=0;
        for(int i=0;i<N;i++){
            String str = br.readLine();
            if(isGroupWord(str)){
                count++;
            }
        }
        System.out.println(count);
    }

    public static boolean isGroupWord(String str){
        boolean[] arr = new boolean[26];
        char prev=0;

        for(int i=0;i<str.length();i++){
            char cur = str.charAt(i);
          
             // 이전 문자와 다르다면 새로운 문자가 나타남
            if(cur!=prev){
                // 이미 등장했던 문자라면 그룹 단어 false
                if(arr[cur-'a']){
                    return false;
                }
                // 새로운 문자라면 그룹 단어 체크
                arr[cur-'a'] = true;
            }
            // 현재 문자를 다음 루프의 prev로 설정
            prev=cur; 
        }
        return true;
    }

}
