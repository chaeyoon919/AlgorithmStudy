package week4;

/*
DFS & 백트래킹

백트래킹 조건
1. 맨해튼 거리가 정수 k보다 작을 경우 절대 도달할 수 없으므로 impossible
2. (k - 거리)가 홀수라면 impossible
*/

class Solution_미로_탈출_명령어 {

    static int N, M, X, Y, R, C, K;
    static int[] dx = {1, 0, 0, -1};
    static int[] dy = {0, -1, 1, 0};
    static char[] dir = {'d', 'l', 'r', 'u'};
    static String answer = null;

    public String solution(int n, int m, int x, int y, int r, int c, int k) {
        N = n;
        M = m;
        X = x;
        Y = y;
        R = r;
        C = c;
        K = k;

        int distance = get_dist(X, Y, R, C, K);

        //맨해튼 거리가 K보다 크면 도달할 수 없음
        if(distance > K) return "impossible";

        //k와 distance를 각각 2로 나눈 나머지가 다르면 도달할 수 없음
        if(distance % 2 != K % 2)
            return "impossible";

        dfs(X, Y, new StringBuffer(""));

        return answer;
    }

    void dfs(int cx, int cy, StringBuffer sb) {

        //문자열이 비어있지 않으면 정답 도출이므로 리턴
        if (answer != null) return;

        //문자열 개수가 K과 같고 끝점에 도달했다면 답 도출하고 return
        if (sb.length() == K && cx == R && cy == C) {
            answer = sb.toString();
            return;
        } else if (sb.length() == K) return;

        //현재 지점에서 도착점까지의 남은거리 계산해서 K가 남은거리보다 적게 남았을 경우에
        //도달 불가능하므로 return
        int distance = get_dist(cx, cy, R, C, K);
        if (K - sb.length() < distance) return;


        for (int i = 0; i < 4; i++) {
            int nx = cx + dx[i], ny = cy + dy[i];

            //격자의 바깥이면 다음 for문 조건으로
            if (nx < 1 || nx > N || ny < 1 || ny > M)
                continue;

            //해당하는 방향 추가하기
            sb.append(dir[i]);

            dfs(nx, ny, sb);
            sb.delete(sb.length() - 1, sb.length());
        }

    }

    int get_dist(int x, int y, int r, int c, int k){
        return Math.abs(r - x) + Math.abs(c - y);
    }

}
