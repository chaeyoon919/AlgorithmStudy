package week4;

import java.util.*;

class Solution_개인정보_수집_유효기간 {
    public int[] solution(String today, String[] terms, String[] privacies) {
        List<Integer> result = new ArrayList<>();

        int todayToNum = toDays(today);

        HashMap<String, Integer> term_map = new HashMap<>();

        for(String term : terms){
            String[] temp = term.split(" ");
            term_map.put(temp[0], Integer.parseInt(temp[1]));
        }

        for(int i = 0; i < privacies.length; i++){
            String[] info = privacies[i].split(" ");
            int date = toDays(info[0]) + term_map.get(info[1]) * 28;

            if(date <= todayToNum){
                result.add(i+1);
            }
        }

        Collections.sort(result);

        int[] answer = result.stream()
                .mapToInt(Integer::intValue).toArray();

        return answer;
    }

    int toDays(String today){
        String[] parts = today.split("\\.");
        int y = Integer.parseInt(parts[0]);
        int m = Integer.parseInt(parts[1]);
        int d = Integer.parseInt(parts[2]);
        return y * 12 * 28 + m * 28 + d;

    }
}