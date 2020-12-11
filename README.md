# 2단계: 평면 큐브 구현하기



## 프로그램 종료

 `Q` 입력 시 프로그램 종료



## 코드 동작 정리

- readLine을 통해 입력을 받습니다

- 올바른 입력은 다음 문자열중에 포함되어야 합니다

  > `"U", "U'", "R", "R'", "L", "L'", "B", "B'", "Q"`

- 객체 생성 시 `(Cube)` 2차원 Array(CubeMatrix)를 입력받게 합니다. 이는 Mission 요구사항 중 객체 활용을 위함입니다.
- FlatCubeGame 생성시에는 위에서 생성한 Cube를 넣어주고 출력 메소드를 호출합니다

- 밀어내는 방향, 밀어낼 row 또는 col을 enum으로 분류합니다. 
  - 특히 row 또는 col은 index를 지정해주어 후에 코드 양을 줄입니다
- `readLine()` 을 계속 입력받게하는 loop와 각각의 command를 실행하기위한 loop가 있으므로 Bool 타입의 `exit` 로 조건에 충족하면 while문을 끝내도록(프로그램을 종료하도록) 합니다
- input을 받고 command를 파악합니다 
  - `'` 가 붙어있는지 `input.first` 를 통해 확인합니다
  - `Q` 를 입력받은 경우 `break`, `exit`에 `true` 값을 줍니다(프로그램을 끝냅니다)

- `switch` 문으로 각 command에 따른 Method를 실행합니다
  - `private mutating func verticalPush(col: SideLineToMove, direction: VerticalPushDirection)` 
    - TopValue를 변수로 저장해두고 값을 하나씩 올리거나 내립니다
    - column Index는 enum rawValue를 활용합니다
  - `private mutating func horisonPush(row: UpperAndLowerLineToMove, direction: HorizonPushDirection)` 
    - 해당 행의 첫번째 값 / 마지막 값을 빼서 반대로 가져와 합쳐줍니다 
    - Row Index는 enum rawValue를 활용합니다

## 기타

- Mission의 동작 예시에 맞춰 newLine을 맞춥니다
- Mission 요구사항에 맞춰 Method를 나눕니다
