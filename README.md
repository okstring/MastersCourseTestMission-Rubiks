# 3단계: 루빅스 큐브 구현하기



## 프로그램 종료

프로그램 실행 후(`startRubiksCube()`) Q 입력 시 혹은 큐브를 다 맞췄을 시 프로그램 종료



## 출력

- 프롬프트 등 프로그램 예시에 맞추고 가독성 있게 출력합니다.
- 출력은 Mission에 제시되어있는 대로 출력합니다.
- 각 `command`  실행시, `printRubiksCube()` 를 실행 시, `shuffleRubiksCube()` 를 실행 시, `RubiksCube` 객체 생성 시 큐브 상태를 출력합니다.



## 코드 동작 설명

- 객체 생성 시 6가지 색깔을 `Section` 의 객체로 생성한다 `Section` 은 큐브의 한 면을 담당하는 객체
- `Init()` 시 sections를 배열에 담아 control하기 용이하게 담아두고 초기 큐브를 프린트, 이용방법을 프린트합니다.
- 가독성을 위해 `Array<Array<String>>` 을 `Matrix` 로 `typealias` 

- `while` 문이 끝나는 조건은 `isComplete` 가 true 이면 종료됩니다(큐브를 다 맞추면)



### 게임 시작 시

- 정답 유무, loop문 break를 위해 게임 시작 시 `quit`, `isComplete` 를 선언
- input을 `readline()` 으로 입력받고 `command` 하나씩 구분
  - 만약 커멘드 뒤에 `'` (작은 따옴표)가 있다면 안전하게 command에 추가시킨다
  - 또는 커멘드 앞에 숫자가 있다면 repeatCount에 할당한다
  - command가 `Q` 면 `quit` 변수에 `true` 를 주고 반복문을 빠져나옵니다(게임을 끝낸다)
- `repeatCount` 와 함께 조건제 맞는 rotate를 실행합니다.. `(executeRotete_, count: Int)`
- Rotate 후 `isCompleteRubikscube()` 에서 각 면의 value가 한가지 종류 즉, 큐브를 다 맞췄는지 검사하고 Bool값을 `isComplete` 에 넣어줍니다

- 게임이 끝나면 경과 시간 및 조작 횟수를 프린트하는 `printElapsedtimeAndResult(result: Bool)` 를 실행
  - start Time은 `startRubiksCube()` 실행 시, end Time은 `printElapsedTimeAndResult(result:Boo;)` 을 실행 시 측정하고 `dataFormatter` 를 통해 형식을 지정



### Rotate 동작 설명

- 큐브를 돌릴 때 앞쪽 면과 `front` 그 면과 인접한 네 개의 면 `top, bottom, right, left` 의 해당하는 줄이 같이 돌아갑니다

- Front

  - 먼저 전치 행렬(Transpose of A Matrix)을 만들고 
    - 90도의 경우 각 열을 `reversed()` 하고
    - -90도의 경우 각 행을 반대로 바꿉니다

- Side

  - 평면으로 정육면체를 펼쳤을 때 각각의 front에 인접하는 row는 인접한 `Section` 입장에서 봤을 때 그 때 그 때 다르게 됩니다.

  - 그러므로 인접하는 `Section` 의 row 방향을 알아야 하기 때문에 `enum` 으로 각각의 케이스를 만들어둡니다.

    ```swift
        enum Side {
            case top
            case bottom
            case right
            case left
            case reverseTop
            case reverseBottom
            case reverseRight
            case reverseLeft
        }
    ```

  - front에 인접한 네 면의 row을 각각의 케이스에 맞춰 `rotateSideValue(top:, topSide:, right:, rightSide:, bottom:, bottomSide:, left:, leftSide:)` 에 대입(reverse면 `reverseRotateSideValue`)

    ```swift
    "O": ["top": [B, Side.bottom], "right": [G, Side.left], 
          "bottom": [R, Side.reverseTop], "left": [W,  Side.reverseRight]],
    "B": ["top": [Y, Side.reverseTop], "right": [G, Side.reverseTop], 
          "bottom": [O, Side.reverseTop], "left": [W, Side.reverseTop]],
    "G": ["top": [B, Side.reverseRight], "right": [Y, Side.left], 
          "bottom": [R, Side.reverseRight], "left": [O, Side.reverseRight]],
    "R": ["top": [O, Side.bottom], "right": [G, Side.bottom], 
          "bottom": [Y, Side.bottom], "left": [W, Side.bottom]],
    "W": ["top": [B, Side.left], "right": [O, Side.left], 
          "bottom": [R, Side.left], "left": [Y, Side.reverseRight]],
    "Y": ["top": [B, Side.reverseTop], "right": [W, Side.left], 
          "bottom": [R, Side.top], "left": [G, Side.reverseRight]]
    ```

  - 각 방향에 맞춰 value를 구해와서 바꿀 `Matrix` 의 `row` 에 대입

    - 이 때 각각의 케이스에 맞춰 value를 구하는 Method는 `findSideValue()`
    - 값을 입력받아 각각의 value를 바꾸는 함수는 `changeSideValue()`
    - `inout` 사용을 최소화하기 위해 `Section.name` 을 입력받아 해당하는 `Section` 탐색

