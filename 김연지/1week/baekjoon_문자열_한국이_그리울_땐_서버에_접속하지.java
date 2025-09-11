import java.io.*;

/*
1. 패턴 문자를 * 기준으로 자르기(split 사용)
2. N개의 단어를 돌면서 앞 단어들과 뒤의 단어들이 맞는지 확인(문자의 개수만큼 비교하기)
3. 앞, 뒤 둘다 패턴 문자와 맞으면 DA, 틀리면 NE 출력
4. ** 비교할 문자가 패턴 문자의 앞, 뒤를 합친 길이보다 작으면 애초에 오답이므로 바로 NE 출력 **
* */
public class baekjoon_문자열_한국이_그리울_땐_서버에_접속하지 {

    private static int N;

    public static void main(String[] args) throws IOException {

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));

        N = Integer.parseInt(br.readLine());
        String pattern = br.readLine();
        String[] patterns = pattern.split("\\*");

        for(int i = 0; i < N; i++){
            String file = br.readLine();

            int prefix = patterns[0].length();
            int postfix = patterns[1].length();

            if(file.length() < (prefix + postfix)){
                bw.write("NE" + "\n");
                continue;
            }

            if(file.substring(0, prefix).equals(patterns[0])
            && file.substring(file.length() - postfix).equals(patterns[1])){
                bw.write("DA" + "\n");
            }else {
                bw.write("NE" + "\n");
            }
        }


        bw.flush();
        bw.close();

    }
}