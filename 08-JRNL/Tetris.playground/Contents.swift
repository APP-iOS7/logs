import SwiftUI
import PlaygroundSupport
import Combine // Timer를 위해 필요

// MARK: - 데이터 모델

// 블록의 위치를 나타내는 구조체
struct Point: Equatable, Hashable {
  var x: Int
  var y: Int
}

// 테트로미노(블록 조각) 타입 정의
enum TetrominoType: CaseIterable {
  case i, o, t, s, z, j, l

  // 각 타입별 기본 모양 (상대 좌표) 및 색상
  var shape: [Point] {
    switch self {
    case .i: return [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 3, y: 0)] // 가로 일자
    case .o: return [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)] // 네모
    case .t: return [Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 2, y: 1)] // T자
    case .s: return [Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)] // S자
    case .z: return [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 1, y: 1), Point(x: 2, y: 1)] // Z자
    case .j: return [Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 2, y: 1)] // J자
    case .l: return [Point(x: 2, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 2, y: 1)] // L자
    }
  }

  var color: Color {
    switch self {
    case .i: return .cyan
    case .o: return .yellow
    case .t: return .purple
    case .s: return .green
    case .z: return .red
    case .j: return .blue
    case .l: return .orange
    }
  }

  // 회전 중심점 (타입별로 다를 수 있음, 여기서는 단순화)
  // 2x2 블록 중심 근처 (약간의 오프셋 가능)
  var rotationPivot: Point {
    // 대부분의 조각은 두 번째 행의 두 번째 블록 근처를 중심으로 회전하는 것이 자연스러움
    // I 조각은 더 길어서 다른 중심이 필요할 수 있음
    switch self {
    case .i: return Point(x: 2, y: 0) // I는 길어서 중심을 다르게 잡는게 자연스러울 수 있음 (예시)
    case .o: return Point(x: 0, y: 0) // O는 회전 의미 없음
    default: return Point(x: 1, y: 1) // 대부분 이 중심으로 회전
    }
  }
}

// 현재 움직이는 테트로미노를 나타내는 구조체
struct ActivePiece {
  var type: TetrominoType
  var position: Point // 조각의 기준점 (보통 좌상단) 위치
  var blocks: [Point] // 현재 조각의 절대 좌표 블록들

  init(type: TetrominoType, startPosition: Point) {
    self.type = type
    self.position = startPosition
    // 초기 절대 좌표 계산
    self.blocks = type.shape.map { Point(x: $0.x + startPosition.x, y: $0.y + startPosition.y) }
  }

  // 조각 이동
  mutating func move(by delta: Point) {
    position = Point(x: position.x + delta.x, y: position.y + delta.y)
    blocks = blocks.map { Point(x: $0.x + delta.x, y: $0.y + delta.y) }
  }

  // 조각 회전 (시계 방향 90도)
  mutating func rotate() {
    guard type != .o else { return } // O 블록은 회전하지 않음

    let pivot = Point(x: position.x + type.rotationPivot.x, y: position.y + type.rotationPivot.y)

    // 회전 공식: (x, y) -> (pivot.x - (y - pivot.y), pivot.y + (x - pivot.x))
    let rotatedBlocks = blocks.map { block -> Point in
      let relativeX = block.x - pivot.x
      let relativeY = block.y - pivot.y
      // 시계방향 90도 회전: (x, y) -> (y, -x)
      let newRelativeX = relativeY
      let newRelativeY = -relativeX
      return Point(x: pivot.x + newRelativeX, y: pivot.y + newRelativeY)
    }
    // 임시로 회전된 블록 저장 (유효성 검사 후 적용)
    // 실제 게임에서는 이 상태를 바로 적용하지 않고, 유효성 검사 후 적용해야 함
    // 여기서는 유효성 검사 로직을 ViewModel에서 처리하므로, ViewModel에서 새 좌표를 계산
  }

  // 회전된 블록들의 예상 위치 반환 (유효성 검사 위함)
  func getRotatedBlocks() -> [Point] {
    guard type != .o else { return blocks }

    let pivot = Point(x: position.x + type.rotationPivot.x, y: position.y + type.rotationPivot.y)
    let rotatedBlocks = blocks.map { block -> Point in
      let relativeX = block.x - pivot.x
      let relativeY = block.y - pivot.y
      let newRelativeX = relativeY
      let newRelativeY = -relativeX
      return Point(x: pivot.x + newRelativeX, y: pivot.y + newRelativeY)
    }
    return rotatedBlocks
  }
}

// MARK: - 게임 로직 (ViewModel)

class TetrisGameViewModel: ObservableObject {
  // 게임 보드 크기
  let width = 10
  let height = 20

  // 게임 보드 상태 (비어있으면 nil, 아니면 해당 블록 색상)
  @Published var board: [[Color?]]
  // 현재 움직이는 조각
  @Published var activePiece: ActivePiece?
  // 다음 나올 조각 (미리보기용)
  @Published var nextPieceType: TetrominoType?
  // 게임 점수
  @Published var score: Int = 0
  // 게임 상태
  @Published var isGameOver: Bool = false
  @Published var gamePaused: Bool = false

  // 게임 루프 타이머
  private var timer: AnyCancellable?
  // 타이머 간격 (내려오는 속도)
  private var timerInterval: Double = 0.8

  init() {
    // 보드 초기화 (모두 nil)
    board = Array(repeating: Array(repeating: nil, count: width), count: height)
    spawnNewPiece() // 첫 조각 생성
    assignNextPiece() // 다음 조각 준비
  }

  // 게임 시작 또는 재시작
  func startGame() {
    resetGame()
    isGameOver = false
    gamePaused = false
    startTimer()
  }

  // 게임 일시정지/재개
  func togglePause() {
    gamePaused.toggle()
    if gamePaused {
      stopTimer()
    } else {
      startTimer()
    }
  }


  // 게임 상태 리셋
  private func resetGame() {
    board = Array(repeating: Array(repeating: nil, count: width), count: height)
    activePiece = nil
    nextPieceType = nil
    score = 0
    isGameOver = false
    gamePaused = false
    spawnNewPiece()
    assignNextPiece()
    timerInterval = 0.8 // 속도 초기화
  }

  // 새 조각 생성 및 배치
  private func spawnNewPiece() {
    let pieceType = nextPieceType ?? TetrominoType.allCases.randomElement()!
    assignNextPiece() // 다음 나올 조각 미리 준비

    // 시작 위치 (상단 중앙)
    let startX = width / 2 - 1 // 중앙 정렬을 위해 약간 조정
    let startY = 0 // 최상단

    let newPiece = ActivePiece(type: pieceType, startPosition: Point(x: startX, y: startY))

    // 스폰 위치가 유효한지 (다른 블록과 겹치는지) 확인 -> 게임 오버 조건
    if !isValidPosition(blocks: newPiece.blocks) {
      isGameOver = true
      stopTimer()
      activePiece = nil // 게임 오버 시 현재 조각 제거
    } else {
      activePiece = newPiece
    }
  }

  // 다음 조각 랜덤하게 지정
  private func assignNextPiece() {
    nextPieceType = TetrominoType.allCases.randomElement()!
  }


  // 게임 루프 시작
  private func startTimer() {
    stopTimer() // 기존 타이머 중지
    timer = Timer.publish(every: timerInterval, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self = self, !self.isGameOver, !self.gamePaused else { return }
        self.movePieceDown()
      }
  }

  // 게임 루프 중지
  private func stopTimer() {
    timer?.cancel()
    timer = nil
  }

  // MARK: - 조각 이동 및 회전 처리

  // 왼쪽으로 이동
  func movePieceLeft() {
    guard let currentPiece = activePiece, !gamePaused else { return }
    let delta = Point(x: -1, y: 0)
    let movedBlocks = currentPiece.blocks.map { Point(x: $0.x + delta.x, y: $0.y + delta.y) }

    if isValidPosition(blocks: movedBlocks) {
      activePiece?.move(by: delta)
    }
  }

  // 오른쪽으로 이동
  func movePieceRight() {
    guard let currentPiece = activePiece, !gamePaused else { return }
    let delta = Point(x: 1, y: 0)
    let movedBlocks = currentPiece.blocks.map { Point(x: $0.x + delta.x, y: $0.y + delta.y) }

    if isValidPosition(blocks: movedBlocks) {
      activePiece?.move(by: delta)
    }
  }

  // 아래로 이동 (타이머 또는 사용자 입력)
  func movePieceDown() {
    guard let currentPiece = activePiece, !gamePaused else { return }
    let delta = Point(x: 0, y: 1)
    let movedBlocks = currentPiece.blocks.map { Point(x: $0.x + delta.x, y: $0.y + delta.y) }

    if isValidPosition(blocks: movedBlocks) {
      activePiece?.move(by: delta)
    } else {
      // 이동 불가 -> 현재 위치에 조각 고정
      lockPiece()
      clearLines()
      spawnNewPiece() // 새 조각 생성
    }
  }

  // 조각 회전
  func rotatePiece() {
    guard let currentPiece = activePiece, currentPiece.type != .o, !gamePaused else { return } // O는 회전 불가

    let rotatedBlocks = currentPiece.getRotatedBlocks()

    // 회전 후 위치가 유효한지 검사
    if isValidPosition(blocks: rotatedBlocks) {
      // 유효하면 실제 조각 상태 업데이트
      activePiece?.blocks = rotatedBlocks
    }
    // TODO: Wall Kick 로직 추가하면 더 자연스러움 (회전 시 벽이나 다른 블록에 막힐 때 살짝 옆으로 이동시켜주는 기능)
  }

  // MARK: - 게임 로직 핵심 함수

  // 주어진 블록 위치들이 유효한지 검사 (보드 범위 내 & 다른 블록과 겹치지 않는지)
  private func isValidPosition(blocks: [Point]) -> Bool {
    for block in blocks {
      // 1. 보드 좌우 경계 체크
      if block.x < 0 || block.x >= width {
        return false
      }
      // 2. 보드 하단 경계 체크 (상단은 스폰 시 체크되거나 내려오면서 체크됨)
      if block.y >= height {
        return false
      }
      // 3. 보드 상단 경계 체크 (음수 y 좌표 방지)
      if block.y < 0 {
        // 회전 등으로 인해 위로 올라가는 경우도 고려해야 함
        // 여기서는 단순하게 y < 0 이면 무효 처리
        return false
      }

      // 4. 이미 쌓인 블록과 충돌 체크
      if board[block.y][block.x] != nil {
        return false
      }
    }
    return true // 모든 검사 통과
  }

  // 현재 조각을 보드에 고정시키는 함수
  private func lockPiece() {
    guard let piece = activePiece else { return }
    for block in piece.blocks {
      // 고정 시 블록 위치가 유효한 범위 내에 있는지 한번 더 확인 (안전장치)
      if block.y >= 0 && block.y < height && block.x >= 0 && block.x < width {
        board[block.y][block.x] = piece.type.color
      }
    }
    // 고정 후 현재 활성 조각은 없음
    activePiece = nil
  }

  // 완성된 라인 제거 및 점수 처리
  private func clearLines() {
    var linesCleared = 0
    var newBoard = board // 변경될 보드를 위한 임시 배열

    var y = height - 1 // 맨 아래 줄부터 검사
    while y >= 0 {
      // 현재 행이 꽉 찼는지 확인 (nil이 하나도 없는지)
      if !newBoard[y].contains(nil) {
        linesCleared += 1
        // 해당 줄 제거 (실제로는 위 줄들을 내려서 덮어씀)
        newBoard.remove(at: y)
        // 맨 위에 빈 줄 추가
        newBoard.insert(Array(repeating: nil, count: width), at: 0)
        // y는 그대로 유지 (제거된 줄 위를 다시 검사해야 하므로)
      } else {
        y -= 1 // 다음 윗줄로 이동
      }
    }

    if linesCleared > 0 {
      board = newBoard // 변경된 보드로 업데이트
                       // 점수 계산 (예: 라인 수에 따라 가중치)
      score += calculateScore(lines: linesCleared)
      // 속도 증가 (선택 사항)
      increaseSpeed(linesCleared: linesCleared)
      print("Lines Cleared: \(linesCleared), Score: \(score)")
    }
  }

  // 점수 계산 로직
  private func calculateScore(lines: Int) -> Int {
    switch lines {
    case 1: return 100
    case 2: return 300
    case 3: return 500
    case 4: return 800 // 테트리스!
    default: return 0
    }
  }

  // 게임 속도 증가 로직 (라인 클리어 시)
  private func increaseSpeed(linesCleared: Int) {
    // 예시: 10줄 클리어마다 속도 증가 (최소 속도 제한)
    let speedIncreaseFactor = 0.05 // 줄일 값
    let minInterval = 0.1 // 최대 속도 (최소 간격)

    // 간단하게 라인 수만큼 조금씩 빨라지게 하거나, 특정 마일스톤마다 빨라지게 할 수 있음
    timerInterval = max(minInterval, timerInterval - Double(linesCleared) * 0.01) // 약간씩 빨라짐

    // 변경된 속도로 타이머 재시작
    if !gamePaused && !isGameOver {
      startTimer()
    }
  }
}

// MARK: - SwiftUI 뷰

struct TetrisGameView: View {
  // 게임 로직을 관리하는 ViewModel 인스턴스 (@StateObject로 뷰 생명주기와 연결)
  @StateObject private var viewModel = TetrisGameViewModel()

  // 블록 하나의 크기
  let blockSize: CGFloat = 20

  var body: some View {
    VStack(spacing: 20) {
      Text("SwiftUI Tetris")
        .font(.largeTitle)

      HStack(alignment: .top, spacing: 30) {
        // 게임 보드 영역
        gameBoardView()
          .overlay(gameOverOverlay()) // 게임 오버 시 오버레이 표시
          .overlay(pauseOverlay()) // 일시정지 시 오버레이 표시

        // 오른쪽 정보 영역 (점수, 다음 블록, 컨트롤 버튼)
        VStack(spacing: 15) {
          Text("Score: \(viewModel.score)")
            .font(.title2)

          VStack {
            Text("Next:")
              .font(.headline)
            nextPieceView() // 다음 블록 미리보기
              .frame(width: blockSize * 4, height: blockSize * 2) // 적절한 크기 지정
              .border(Color.gray, width: 1)
          }


          Spacer() // 버튼들을 아래로 밀기

          // 컨트롤 버튼 영역
          VStack(spacing: 10) {
            Button("Rotate") { viewModel.rotatePiece() }
              .buttonStyle(TetrisButtonStyle())

            HStack {
              Button("Left") { viewModel.movePieceLeft() }
                .buttonStyle(TetrisButtonStyle())
              Button("Right") { viewModel.movePieceRight() }
                .buttonStyle(TetrisButtonStyle())
            }
            Button("Down") { viewModel.movePieceDown() }
              .buttonStyle(TetrisButtonStyle())
          }

          Spacer().frame(height: 30) // 시작/일시정지 버튼 공간

          // 게임 시작/일시정지 버튼
          Button(viewModel.isGameOver ? "New Game" : (viewModel.gamePaused ? "Resume" : "Pause")) {
            if viewModel.isGameOver {
              viewModel.startGame()
            } else {
              viewModel.togglePause()
            }
          }
          .buttonStyle(TetrisButtonStyle(color: .blue))


        }
        .frame(width: blockSize * 6) // 오른쪽 영역 너비 고정
      }
    }
    .padding()
    .onAppear {
      // 뷰가 나타날 때 게임 시작 (초기 상태는 게임 오버와 유사하게 둠)
      // viewModel.startGame() // -> New Game 버튼으로 시작하도록 변경
    }
  }

  // 게임 보드를 그리는 뷰
  @ViewBuilder
  private func gameBoardView() -> some View {
    // Grid 사용 (iOS 16+, macOS 13+), 이전 버전은 VStack/HStack 사용 필요
    if #available(iOS 16.0, macOS 13.0, *) {
      Grid(horizontalSpacing: 1, verticalSpacing: 1) {
        ForEach(0..<viewModel.height, id: \.self) { y in
          GridRow {
            ForEach(0..<viewModel.width, id: \.self) { x in
              let point = Point(x: x, y: y)
              let blockColor = blockColorAt(point: point)

              Rectangle()
                .fill(blockColor)
                .frame(width: blockSize, height: blockSize)
            }
          }
        }
      }
      .border(Color.black, width: 1) // 보드 테두리
    } else {
      // iOS 16 미만 또는 macOS 13 미만 대체 구현 (VStack/HStack)
      VStack(spacing: 1) {
        ForEach(0..<viewModel.height, id: \.self) { y in
          HStack(spacing: 1) {
            ForEach(0..<viewModel.width, id: \.self) { x in
              let point = Point(x: x, y: y)
              let blockColor = blockColorAt(point: point)

              Rectangle()
                .fill(blockColor)
                .frame(width: blockSize, height: blockSize)
            }
          }
        }
      }
      .border(Color.black, width: 1)
    }
  }

  // 다음 나올 조각을 보여주는 뷰
  @ViewBuilder
  private func nextPieceView() -> some View {
    // 다음 조각 타입이 있으면 그림
    if let nextType = viewModel.nextPieceType {
      // 4x2 그리드에 표시 (가장 일반적인 크기)
      let shape = nextType.shape
      let offsetX = 1 // 중앙 정렬을 위한 오프셋 (필요에 따라 조정)
      let offsetY = 0

      VStack(spacing: 1) {
        ForEach(0..<2, id: \.self) { y in // 높이 2칸 가정
          HStack(spacing: 1) {
            ForEach(0..<4, id: \.self) { x in // 너비 4칸 가정
              let relativePoint = Point(x: x - offsetX, y: y - offsetY)
              let isBlock = shape.contains(relativePoint)
              Rectangle()
                .fill(isBlock ? nextType.color : Color.gray.opacity(0.2))
                .frame(width: blockSize, height: blockSize)
            }
          }
        }
      }

    } else {
      // 다음 조각이 없으면 빈 공간 표시
      Rectangle().fill(Color.gray.opacity(0.1))
    }
  }


  // 특정 좌표의 블록 색상 결정 (보드 + 현재 조각 포함)
  private func blockColorAt(point: Point) -> Color {
    // 1. 현재 움직이는 조각의 블록인지 확인
    if let activePiece = viewModel.activePiece, activePiece.blocks.contains(point) {
      return activePiece.type.color
    }
    // 2. 보드에 고정된 블록인지 확인 (범위 체크 필수)
    if point.y >= 0 && point.y < viewModel.height && point.x >= 0 && point.x < viewModel.width {
      if let boardColor = viewModel.board[point.y][point.x] {
        return boardColor
      }
    }
    // 3. 비어있는 칸
    return Color.gray.opacity(0.2) // 빈 칸 색상
  }

  // 게임 오버 시 표시될 오버레이
  @ViewBuilder
  private func gameOverOverlay() -> some View {
    if viewModel.isGameOver {
      Color.black.opacity(0.7) // 반투명 검은 배경
        .overlay(
          VStack {
            Text("Game Over")
              .font(.largeTitle)
              .fontWeight(.bold)
              .foregroundColor(.red)
            Text("Score: \(viewModel.score)")
              .font(.title2)
              .foregroundColor(.white)
          }
        )
    }
  }

  // 일시정지 시 표시될 오버레이
  @ViewBuilder
  private func pauseOverlay() -> some View {
    if viewModel.gamePaused && !viewModel.isGameOver {
      Color.black.opacity(0.5) // 반투명 검은 배경
        .overlay(
          Text("Paused")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.yellow)
        )
    }
  }
}

// MARK: - 커스텀 버튼 스타일

struct TetrisButtonStyle: ButtonStyle {
  var color: Color = .gray
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .padding(.vertical, 8)
      .padding(.horizontal, 15)
      .frame(minWidth: 60) // 최소 너비
      .foregroundColor(.white)
      .background(configuration.isPressed ? color.opacity(0.7) : color)
      .cornerRadius(8)
      .shadow(radius: 3)
  }
}


// MARK: - Playground Live View 설정

// TetrisGameView 인스턴스를 생성하여 라이브 뷰로 설정
PlaygroundPage.current.setLiveView(TetrisGameView().frame(width: 500, height: 600)) // 뷰 크기 지정
