import java.io.*;
import java.util.HashSet;
import java.util.Set;
import java.util.StringTokenizer;

/*
1. Set 자료구조 이용
2. 문자를 돌면서 붙어있는 문자 한개로 만들기 (apple 이면 aple, aaazbz이면 azbz)
3. Set에 저장한 문자열과 2번에서 만든 문자열 개수가 다르면 같은 문자가 떨어져서 나타난 경우이므로 그룹단어 X
4. Set에 저장한 문자열과 2번에서 만든 문자열 개수가 같으면 그룹단어이므로 count++
5. But.... 그냥 visited 배열처럼 하나 만들어서 문자열 돌다가 방문했던 곳을 이후에 다시 방문하면 false로 리턴해도 됐다,,
* */
public class baekjoon_문자열_그룹_단어_체커 {

    private static int N;
    private static int count;

    public static void main(String[] args) throws IOException {

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));


        N = Integer.parseInt(br.readLine());

        for(int i = 0; i < N; i++){
            String word = br.readLine();
            StringBuffer sb = new StringBuffer();
            Set<Character> set = new HashSet<>();

            sb.append(word.charAt(0));
            set.add(word.charAt(0));
            for(int j = 1; j < word.length(); j++){
                char c = word.charAt(j);
                set.add(c);

                //앞의 문자와 다르면 추가하기
                if(word.charAt(j - 1) != c){
                    sb.append(c);
                }
            }

            if(sb.length() == set.size()){
                count++;
            }

        }

        bw.write(String.valueOf(count));

        bw.flush();
        bw.close();

    }
}