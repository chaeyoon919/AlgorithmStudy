package week4;

import java.util.*;


class Solution_가장_많이_받은_선물 {
    public int solution(String[] friends, String[] gifts) {

        int answer = 0;

        //이름 담을 dic 선언
        HashMap<String, Integer> dic = new HashMap<>();

        //선물지수 표
        int[] giftDegree = new int[friends.length];

        //주고받은 선물 표
        int[][] giftGraph = new int[friends.length][friends.length];

        //dic에 이름 넣기(인덱스 부여)
        for(int i = 0; i < friends.length; i++){
            dic.put(friends[i], i);
        }

        //이름을 보고 분배해서 선물지수와 주고받은 선물 표에 기록
        for(String gift : gifts){
            String[] names = gift.split(" ");

            //준 사람 선물지수 ++
            giftDegree[dic.get(names[0])]++;
            //받은 사람 선물지수 --
            giftDegree[dic.get(names[1])]--;

            //주고 받은 거 기록하기
            giftGraph[dic.get(names[0])][dic.get(names[1])]++;

        }


        for(int i = 0; i < friends.length; i++){
            int num = 0;

            for(int j = 0; j < friends.length; j++){
                if(i == j) continue; //본인이 본인이랑 주고받는 부분 제외

                //무지 기준 예시 : 무지 > 프로도 랑 프로도 > 무지 서로 주고받은 선물 비교하기
                //더 많이 줬거나, 주고받은 개수가 동일(서로 주고받지 않은 경우도 포함)한데 선물지수가 높으면 선물 받기
                if(giftGraph[i][j] > giftGraph[j][i] ||
                        (giftGraph[i][j] == giftGraph[j][i] && giftDegree[i] > giftDegree[j])){

                    num++;
                }
            }
            if(answer < num)
                answer = num;

        }

        return answer;
    }
}