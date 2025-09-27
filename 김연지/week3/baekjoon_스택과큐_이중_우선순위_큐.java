package week3;


import java.io.*;
import java.util.*;

/*
* 1. 앞뒤로 최솟값, 최댓값을 알고 있는 자료구조 필요
* 2. TreeMap : key, value 쌍을 가지면서 key의 최솟값, 최댓값을 가져올 수 있음.
* 3. TreeMap의 기능을 Custom한 클래스를 따로 구현해서 실제 구현 코드는 보기 편하게 함.
*
*
최댓값/최솟값 빠른 접근 → firstKey(), lastKey()

삭제 시 중복 처리 → Value를 1씩 감소시키거나 Key 삭제
*
*
* */
public class baekjoon_스택과큐_이중_우선순위_큐 {

    public static int T;
    public static int K;
    public static StringTokenizer st;

    static class DoublePriorityQueue {

        public TreeMap<Integer, Integer> queue = new TreeMap<>();

        //TreeMap에 값을 추가하는 함수
        public void addValue(int value){
            queue.put(value, queue.getOrDefault(value, 0) + 1);
        }


        //최댓값을 제거하는 함수
        public void removeMaxValue(){
            if(queue.isEmpty())
                return;
            //queue에서의 최댓값
            int key = queue.lastKey();
            if(queue.get(key) == 1) queue.remove(key);
            else queue.put(key, queue.get(key) - 1);
        }

        //최솟값을 제거하는 함수
        public void removeMinValue(){
            if(queue.isEmpty())
                return;
            //queue에서의 최솟값
            int key = queue.firstKey();
            if(queue.get(key) == 1) queue.remove(key);
            else queue.put(key, queue.get(key) - 1);
        }

        //최댓값(key)를 가져오는 함수
        public int getMaxValue(){
            return queue.lastKey();
        }

        //최솟값(key)를 가져오는 함수
        public int getMinValue(){
            return queue.firstKey();
        }

        //queue가 비었는지 확인
        public boolean isEmpty(){
            return queue.isEmpty();
        }

    }

    public static void main(String[] args) throws IOException {

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));

        T = Integer.parseInt(br.readLine());

        for(int i = 0; i < T; i++){
            K = Integer.parseInt(br.readLine());
            DoublePriorityQueue doubleQueue = new DoublePriorityQueue();
            for(int j = 0; j < K; j++){
                st = new StringTokenizer(br.readLine());

                //Insert일 경우 해당 숫자를 queue에 넣기
                if(st.nextToken().equals("I")){
                    doubleQueue.addValue(Integer.parseInt(st.nextToken()));

                    //Delete일 경우 1인지 -1인지에 따라 최솟값 최댓값 중 제거
                }else{

                    if(doubleQueue.isEmpty())
                        continue;
                    //Delete 1인 경우
                    if(Integer.parseInt(st.nextToken()) == 1){
                        doubleQueue.removeMaxValue();
                    }else {
                        doubleQueue.removeMinValue();
                    }
                }
            }

            if(!doubleQueue.isEmpty()){
                bw.write(doubleQueue.getMaxValue() + " " + doubleQueue.getMinValue() + "\n");
            }else{
                bw.write("EMPTY\n");
            }

        }
        bw.flush();
        bw.close();
    }
}
