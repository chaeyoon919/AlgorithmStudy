//문제 접근
//1.HashSet에 N개의 문자열을 저장
//2.M개의 문자열을 하나씩 읽으면서 contains()로 존재여부 확인
//3.존재하면 카운트 증가

import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        int n = Integer.parseInt(st.nextToken());
        int m = Integer.parseInt(st.nextToken());

        Set<String> set = new HashSet<>();
        for (int i = 0; i < n; i++) {
            set.add(br.readLine());
        }

        int count = 0;
        for (int i = 0; i < m; i++) {
            if (set.contains(br.readLine())) count++;
        }

        System.out.print(count);
    }
}
