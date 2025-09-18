package week2;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

/*
---예시---
4
1 3
2 5
3 5
6 7
--예시 끝--
* 1. 그은 선들을 시작점 기준으로 "정렬"하기
* 2. 처음 선 하나 먼저 긋기.
* 3. 다음 선부터 시작점이 기존 선과 겹쳐지는 지 확인하기.
* 3-1. {2, 5}의 시작점은 2니까, 이미 그어진 {1, 3} 사이에 2가 포함되어 있는지 확인하기(끝점보다 작거나 같은지 확인)
* 3-2. 포함되어있던 선은 저장해두기.(이후에 그 선부터 확인하면 된다. 어차피 그 이전 선에서 시작할 일이 없다.)
* 4-1. 만약 이미 그은 선에 시작점이 포함된 경우
    -> 끝점을 둘 중에 큰 값으로 바꾸기(예시에서는 첫번째 선이 3까지 그어져 있으니까 두번째 선인 5로 변경 -> {1, 5}
* 4.2. 지금까지 그은 선에 포함되지 않는 경우
    -> 새로 긋기 ex) {6, 7}
* */
public class baekjoon_정렬_선_긋기 {

    public static int N;
    public static int[][] lines;
    public static List<int[]> total_lines = new ArrayList<int[]>();
    public static int compare = 0;
    public static StringTokenizer st;
    public static int answer = 0;

    public static void main(String[] args) throws IOException {

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));

        //선을 그은 횟수 저장
        N = Integer.parseInt(br.readLine());
        lines = new int[N][2];

        //2차원 배열에 선들 저장
        for(int i = 0; i < N; i++){
            st = new StringTokenizer(br.readLine());
            lines[i] = new int[]{Integer.parseInt(st.nextToken()), Integer.parseInt(st.nextToken())};
        }

        //각 행의 첫 번째 값을 기준으로 오름차순 정렬
        Arrays.sort(lines, (a, b) -> Integer.compare(a[0], b[0]));

        total_lines.add(lines[0]);

        for(int i = 1; i < N; i++){
            for(int j = compare; j < total_lines.size(); j++){
                //현재 비교하는 선이 기존 선과 겹쳐져 있는지 순차적으로 확인
                if(lines[i][0] <= total_lines.get(compare)[1]){
                    //겹친다면 기존 선과 비교 선 중 큰 값으로 바꾸기
                    total_lines.get(compare)[1] = Math.max(lines[i][1], total_lines.get(compare)[1]);
                    break;
                }else {
                    compare = j;
                    if(compare == total_lines.size() - 1){
                        total_lines.add(lines[i]);
                        break;
                    }
                }
            }
        }

        for(int i = 0; i < total_lines.size(); i++){
            answer += total_lines.get(i)[1] - total_lines.get(i)[0];
        }

        System.out.println(answer);

        bw.flush();
        bw.close();

    }
}
