package week4;


import java.io.*;
import java.util.Arrays;
import java.util.StringTokenizer;

/*
* 1 2 4 8 9
* 1. 우선 정렬하기(정렬이 되어야 이진탐색이 가능)
* 2. 양쪽으로 우선 놓기 (1, 9)
* 3. ....?
*--------
* 1. 우선 정렬
* 2. 최소 거리 t가 1부터 시작해서 공유기를 설치하기
* 공유기를 다 놓았을 때
* - 실제 공유기 수 < 설치한 공유기 수 => t 줄이기
* - 실제 공유기 수 > 설치한 공유기 수 => t 늘이기
* - 실제 공유기 수 == 설치한 공유기 수 => 최소거리 늘리기 => 이때 다시 부합하지 않으면 그 직전값이 정답(최대거리)
* 가능한 최소 t : 1
* 가능한 최대 t : 가장 멀리 있는 집 (예시에서는 9)
* mid를 찾아서 탐색 ((9-1) / 2)
* 필요한 것
* 집의 좌표 담을 int[]
* 공유기 개수 저장 int
* 최소 거리 저장 int
*
* */

public class baekjoon_이분탐색_공유기_설치 {

    public static int[] house;
    public static int N; // 집의 개수
    public static int low; //최소거리
    public static int hi; //최대거리
    public static int mid; //탐색할 때 사용할 거리
    public static int C; //공유기 개수
    public static int position; //공유기 설치한 현재 위치
    public static StringTokenizer st;


    public static void main(String[] args) throws IOException {

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
        st = new StringTokenizer(br.readLine());

        N = Integer.parseInt(st.nextToken());
        C = Integer.parseInt(st.nextToken());

        house = new int[N];
        for(int i = 0; i < N; i++){
            house[i] = Integer.parseInt(br.readLine());
        }

        Arrays.sort(house);

        //답이 될 수 있는 최솟값과 최댓값 지정
        low = 1;
        hi = house[N - 1];

        while (low < hi){

            int mid = (low + hi) / 2;
            position = 0;
            int cnt = 1; //설치한 공유기(첫번째 집에 이미 설치)
            //집을 돌면서 앞집이랑의 거리가 최소거리 이상이면 공유기 설치하기
            for(int i = 1; i < N; i++){
                if(house[i] - house[position] >= mid){
                    position = i;
                    cnt++;
                }
            }
            if(cnt < C) {
                hi = mid - 1; //가진 공유기보다 적게 설치했으면 공유기 더 놔야 하니까 최소거리 줄이기
                continue;
            }

            //가진 공유기보다 많이 설치했으면 공유기 덜 놔도 되니까 최소거리 늘리기
            low = mid + 1;
        }

        bw.write(String.valueOf(hi));

        bw.flush();
        bw.close();

    }
}
