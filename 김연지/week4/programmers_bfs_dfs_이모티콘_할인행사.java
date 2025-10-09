package week4;

/*
길이가 짧으니까 다 돌아보기
user별로 각 이모티콘 할인율마다 돌면서 다 돌았을 때의 값과 기존 값을 비교해서 우선순위가 높은 거 넣기.
이모티콘 7개 각각의 할인율 4개 조합 -> 4^7
유저 최대 100명 -> 100*4^7
*/

class Solution_이모티콘_할인행사 {

    static int sign_mem = 0;
    static int sales = 0;

    public int[] solution(int[][] users, int[] emoticons) {

        int[] answer = new int[2];
        int[] emot_arr = new int[emoticons.length];

        dfs(emot_arr, 0, users, emoticons);

        answer[0] = sign_mem;
        answer[1] = sales;

        return answer;
    }

    public void dfs(int[] emot_arr, int start, int[][] users, int[] emoticons){
        if(start == emot_arr.length){
            calculate(emot_arr, users, emoticons);
            return;
        }
        //10, 20, 30, 40의 할인율을 적용하기 위한 for문
        for(int i = 10; i <=40; i+=10){
            emot_arr[start] = i;
            dfs(emot_arr, start+1, users, emoticons);
        }
    }


    void calculate(int[] emot_arr, int[][] users, int[] emoticons){

        int plus_mem = 0;
        int total_price = 0;

        for(int i = 0; i < users.length; i++){
            int price = 0;
            for(int j = 0; j < emoticons.length; j++){
                if(users[i][0] <= emot_arr[j]){
                    price += emoticons[j] * (100 - emot_arr[j]) * 0.01;
                }
            }

            //구매액이 각 유저의 구매비용보다 크다면 이모플 가입, 아니라면 그냥 구매액++
            if(price >= users[i][1]){
                plus_mem++;
            }else{
                total_price += price;
            }
        }

        //모두 계산했을 때 가입멤버가 더 많고 가격이 더 비싸면 갱신
        if(plus_mem > sign_mem){
            sign_mem = plus_mem;
            sales = total_price;
        }else if(plus_mem == sign_mem){
            if(total_price > sales){
                sales = total_price;
            }
        }

    }
}