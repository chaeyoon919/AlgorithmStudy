package week3;


import java.io.*;
import java.util.*;

/*
 * 큐에 삽입과 삭제 연산을 수행하는데 삭제 연산이 두가지로 구분된다.
 * D -1일 경우에는 큐에 들어있는 값 중 최솟값을 삭제하고
 * D 1일 경우에는 최댓값을 삭제해야 한다.
 * 기존 우선순위 큐는 최댓값만 먼저 뽑거나, 최솟값만 먼저 뽑거나 하는 방식이라 사용할 수 없다고 생각.
 * 1. 앞뒤로 최솟값, 최댓값을 알고 있고 동일한 수도 삽입될 수 있으므로 몇개가 들어왔는지 개수까지 알고 있는 자료구조 필요
 * 2. TreeMap : key, value 쌍을 가지면서 key의 최솟값, 최댓값을 가져올 수 있음. (firstKey(), lastKey())
 * 2-1. key에는 실제 들어간 값, I 16과 같은 연산이 들어왔을 때 key는 16이고 같은 수가 삽입될 수도 있으므로 들어온 개수에 따라 value를 업데이트.
 * 2-2. 삭제 시 중복 처리 → value를 1씩 감소시키거나 Key 삭제
 * 3. TreeMap의 기능을 Custom한 클래스를 따로 구현해서 실제 구현 코드는 간결하게 함.
 *
 * */
public class baekjoon_스택과큐_이중_우선순위_큐 {

    public static int T;
    public static int K;
    public static StringTokenizer st;

    static class DoublePriorityQueue {

        public TreeMap<Integer, Integer> queue = new TreeMap<>();

        //TreeMap에 값을 추가하는 함수
        //key가 존재하는 경우, 즉 이미 같은 값이 큐에 있는 경우는 기존 값에 +1, 아닌 경우 1로 설정)
        public void addValue(int key){
            queue.put(key, queue.getOrDefault(key, 0) + 1);
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

            //남아있는 큐에서 최대, 최솟값을 찾아 출력
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
