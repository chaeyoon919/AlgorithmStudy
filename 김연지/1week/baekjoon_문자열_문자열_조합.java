import java.io.*;
import java.util.*;

/*
1. N개의 단어를 해시셋에 저장
2. M개의 단어를 돌면서 해시셋에 해당하는 값이 있는지 확인
3. 단어가 있으면 count++
4. count 출력
* */
public class baekjoon_문자열_문자열_조합 {

    private static int N;
    private static int M;
    private static Set<String> set = new HashSet<>();
    private static int count;

    public static void main(String[] args) throws IOException {

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
        StringTokenizer st = new StringTokenizer(br.readLine());

        N = Integer.parseInt(st.nextToken());
        M = Integer.parseInt(st.nextToken());

        for(int i = 0; i < N; i++){
            String word = br.readLine();
            set.add(word);
        }

        for(int i = 0; i < M; i++){
            String word = br.readLine();
            if(set.contains(word)){
                count++;
            }
        }

        bw.write(String.valueOf(count));

        bw.flush();
        bw.close();

    }
}