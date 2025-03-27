// Import necessary frameworks
import SwiftUI
import PlaygroundSupport
import Combine // Needed for ObservableObject

// MARK: - Data Models

// Define the types of gems (e.g., colors or shapes)
enum GemType: CaseIterable, Equatable {
  case red, green, blue, yellow, purple, orange

  var color: Color {
    switch self {
    case .red: return .red
    case .green: return .green
    case .blue: return .blue
    case .yellow: return .yellow
    case .purple: return .purple
    case .orange: return .orange
    }
  }
}

// Represents a single gem on the board
struct Gem: Identifiable, Equatable {
  let id = UUID() // Unique ID for SwiftUI
  var type: GemType
  // Position could be stored here, but it's often easier
  // to infer it from the grid structure in the ViewModel.
}

// Represents a position on the grid
struct Position: Hashable, Equatable {
  var row: Int
  var col: Int
}

// MARK: - Game Logic (ViewModel)

class GameViewModel: ObservableObject {

  @Published var grid: [[Gem?]] = [] // 2D array for the game board. nil represents an empty space.
  @Published var score: Int = 0
  @Published var selectedPosition: Position? = nil
  @Published var isProcessingMove: Bool = false // To disable input during processing

  let gridSize: Int = 8 // Size of the grid (8x8)
  private var processingDelay = 0.3 // Small delay for visual feedback

  init() {
    setupNewGame()
  }

  // 1. Setup New Game
  func setupNewGame() {
    score = 0
    selectedPosition = nil
    isProcessingMove = false
    grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
    fillInitialGrid()
    // In a full game, you'd repeatedly check for initial matches and refill until none exist.
    // For simplicity here, we just fill it once. Let's run one check cycle.
    DispatchQueue.main.async {
      self.processMatchesAndRefill()
    }
  }

  // Fill the grid with random gems initially
  private func fillInitialGrid() {
    for r in 0..<gridSize {
      for c in 0..<gridSize {
        if grid[r][c] == nil { // Only fill if empty
          grid[r][c] = createRandomGem()
        }
      }
    }
  }

  // Creates a new random gem
  private func createRandomGem() -> Gem {
    let randomType = GemType.allCases.randomElement()!
    return Gem(type: randomType)
  }


  // 2. Handle User Interaction
  func handleTap(row: Int, col: Int) {
    guard !isProcessingMove else { return } // Ignore taps during processing

    let tappedPosition = Position(row: row, col: col)

    if let currentSelection = selectedPosition {
      // If tapping the same gem, deselect
      if currentSelection == tappedPosition {
        selectedPosition = nil
        return
      }

      // If tapping an adjacent gem, try to swap
      if areAdjacent(currentSelection, tappedPosition) {
        attemptSwap(pos1: currentSelection, pos2: tappedPosition)
        selectedPosition = nil // Deselect after attempting swap
      } else {
        // If tapping a non-adjacent gem, select the new one
        selectedPosition = tappedPosition
      }
    } else {
      // No gem selected, so select the tapped one
      selectedPosition = tappedPosition
    }
  }

  // Check if two positions are adjacent (horizontally or vertically)
  private func areAdjacent(_ pos1: Position, _ pos2: Position) -> Bool {
    let rowDiff = abs(pos1.row - pos2.row)
    let colDiff = abs(pos1.col - pos2.col)
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
  }

  // 3. Swap Logic
  private func attemptSwap(pos1: Position, pos2: Position) {
    guard let gem1 = grid[pos1.row][pos1.col], let gem2 = grid[pos2.row][pos2.col] else {
      print("Error: Trying to swap with an empty space.")
      return
    }

    isProcessingMove = true // Disable input

    // Perform the swap visually
    grid[pos1.row][pos1.col] = gem2
    grid[pos2.row][pos2.col] = gem1

    // Use a short delay before checking matches to let the UI update (basic animation feel)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      let matches = self.findAllMatches()
      if matches.isEmpty {
        // No matches formed - Invalid swap, swap back
        print("Invalid swap - swapping back")
        // Swap back visually
        self.grid[pos1.row][pos1.col] = gem1
        self.grid[pos2.row][pos2.col] = gem2
        // Re-enable input after another short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          self.isProcessingMove = false
        }
      } else {
        // Matches found - Process them
        print("Valid swap - processing matches")
        self.processMatchesAndRefill() // Start the match processing chain
      }
    }
  }

  // 4. Match Detection
  private func findAllMatches() -> Set<Position> {
    var matchedPositions = Set<Position>()

    // Check Horizontal Matches
    for r in 0..<gridSize {
      for c in 0..<(gridSize - 2) {
        if let gem1 = grid[r][c], let gem2 = grid[r][c+1], let gem3 = grid[r][c+2],
           gem1.type == gem2.type && gem2.type == gem3.type {
          var currentMatchLength = 3
          matchedPositions.insert(Position(row: r, col: c))
          matchedPositions.insert(Position(row: r, col: c+1))
          matchedPositions.insert(Position(row: r, col: c+2))

          // Check for longer matches
          for k in (c+3)..<gridSize {
            if let nextGem = grid[r][k], nextGem.type == gem1.type {
              matchedPositions.insert(Position(row: r, col: k))
              currentMatchLength += 1
            } else {
              break // Sequence broken
            }
          }
          // Score based on match length (simple scoring)
          // score += (currentMatchLength - 2) * 10 // e.g., 3-match=10, 4-match=20
        }
      }
    }

    // Check Vertical Matches
    for c in 0..<gridSize {
      for r in 0..<(gridSize - 2) {
        if let gem1 = grid[r][c], let gem2 = grid[r+1][c], let gem3 = grid[r+2][c],
           gem1.type == gem2.type && gem2.type == gem3.type {
          var currentMatchLength = 3
          matchedPositions.insert(Position(row: r, col: c))
          matchedPositions.insert(Position(row: r+1, col: c))
          matchedPositions.insert(Position(row: r+2, col: c))

          // Check for longer matches
          for k in (r+3)..<gridSize {
            if let nextGem = grid[k][c], nextGem.type == gem1.type {
              matchedPositions.insert(Position(row: k, col: c))
              currentMatchLength += 1
            } else {
              break // Sequence broken
            }
          }
          // Score based on match length (simple scoring)
          // Moved scoring to removeMatches to avoid double counting overlaps
        }
      }
    }

    return matchedPositions
  }

  // 5. Process Matches and Refill Cycle (Chain of Actions)
  private func processMatchesAndRefill() {
    isProcessingMove = true // Ensure input is disabled

    let matches = findAllMatches()

    if matches.isEmpty {
      // No more matches, cycle ends, re-enable input
      print("Board stable.")
      isProcessingMove = false
      return
    }

    // --- Action 1: Remove Matches ---
    removeMatches(matches)
    print("Removed \(matches.count) gems. Score: \(score)")

    // --- Action 2: Apply Gravity (after a delay) ---
    DispatchQueue.main.asyncAfter(deadline: .now() + processingDelay) {
      let gemsMoved = self.applyGravity()
      print("Applied gravity. Gems moved: \(gemsMoved)")

      // --- Action 3: Refill Grid (after another delay) ---
      DispatchQueue.main.asyncAfter(deadline: .now() + (gemsMoved ? self.processingDelay : 0.05)) { // Shorter delay if nothing moved
        let gemsAdded = self.refillGrid()
        print("Refilled grid. Gems added: \(gemsAdded)")

        // --- Action 4: Check for NEW matches recursively (after final delay) ---
        DispatchQueue.main.asyncAfter(deadline: .now() + (gemsAdded ? self.processingDelay : 0.05)) {
          print("Checking for cascading matches...")
          self.processMatchesAndRefill() // Recursive call to handle cascades
        }
      }
    }
  }


  // Remove matched gems (set to nil) and update score
  private func removeMatches(_ positions: Set<Position>) {
    var pointsEarned = 0
    for pos in positions {
      if grid[pos.row][pos.col] != nil { // Ensure we don't double-remove/score
        grid[pos.row][pos.col] = nil
        pointsEarned += 10 // Simple score: 10 points per gem
      }
    }
    score += pointsEarned
    // Trigger UI update explicitly if needed, though @Published should handle it.
    // objectWillChange.send()
  }

  // Make gems fall down into empty spaces
  private func applyGravity() -> Bool {
    var gemsMoved = false
    // Iterate columns from bottom up
    for c in 0..<gridSize {
      var emptyRow = gridSize - 1 // Start checking from the bottom row

      // Find the lowest empty spot in the current column
      for r in (0..<gridSize).reversed() {
        if grid[r][c] == nil {
          emptyRow = r // Found an empty spot
        } else if emptyRow > r {
          // Found a gem above an empty spot, move it down
          grid[emptyRow][c] = grid[r][c]
          grid[r][c] = nil
          gemsMoved = true
          emptyRow -= 1 // The next empty spot is now one row above
        }
      }
    }
    return gemsMoved
  }


  // Add new random gems to the top empty spaces
  private func refillGrid() -> Bool {
    var gemsAdded = false
    // Iterate columns, check from the top row down
    for c in 0..<gridSize {
      for r in 0..<gridSize {
        if grid[r][c] == nil {
          // Found an empty space, add a new gem
          grid[r][c] = createRandomGem()
          gemsAdded = true
        }
      }
    }
    return gemsAdded
  }
}

// MARK: - SwiftUI Views

// View for a single Gem
struct GemView: View {
  let gem: Gem? // Can be nil for empty spaces
  let size: CGFloat
  let isSelected: Bool

  var body: some View {
    Group {
      if let currentGem = gem {
        Circle()
          .fill(currentGem.type.color)
          .overlay(
            Circle() // Add a border for selection
              .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
          )

      } else {
        // Empty space representation (optional)
        Rectangle()
          .fill(Color.gray.opacity(0.2)) // Faint background for empty cells
      }
    }
    .frame(width: size, height: size)
    // Basic animation for appearance/disappearance
    .animation(.easeInOut(duration: 0.2), value: gem)
    .animation(.easeInOut(duration: 0.1), value: isSelected) // Animate selection border
  }
}

// Main Game View
struct ContentView: View {
  @StateObject private var viewModel = GameViewModel()
  private let spacing: CGFloat = 2 // Spacing between gems
  private let gemSizeRatio: CGFloat = 0.9 // Reduce gem size slightly for spacing

  var body: some View {
    GeometryReader { geometry in
      let totalGridWidth = geometry.size.width * 0.9 // Use 90% of available width
      let cellSize = (totalGridWidth - spacing * CGFloat(viewModel.gridSize - 1)) / CGFloat(viewModel.gridSize)
      let gemSize = cellSize * gemSizeRatio
      let actualTotalGridWidth = cellSize * CGFloat(viewModel.gridSize) + spacing * CGFloat(viewModel.gridSize - 1)
      let actualTotalGridHeight = actualTotalGridWidth // Make it square

      VStack(spacing: 20) {
        Text("Score: \(viewModel.score)")
          .font(.title)
          .padding(.top)

        // The Game Grid
        LazyVGrid(
          columns: Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: viewModel.gridSize),
          spacing: spacing
        ) {
          ForEach(0..<viewModel.gridSize, id: \.self) { row in
            ForEach(0..<viewModel.gridSize, id: \.self) { col in
              // Ensure we access grid safely if dimensions change (though they shouldn't here)
              if row < viewModel.grid.count && col < viewModel.grid[row].count {
                let position = Position(row: row, col: col)
                let isSelected = viewModel.selectedPosition == position

                GemView(gem: viewModel.grid[row][col], size: gemSize, isSelected: isSelected)
                  .onTapGesture {
                    print("Tapped: (\(row), \(col))")
                    viewModel.handleTap(row: row, col: col)
                  }
                // Center the gem within the cell
                  .frame(width: cellSize, height: cellSize)


              } else {
                // Placeholder if grid dimensions are somehow incorrect
                Rectangle().fill(Color.black).frame(width: cellSize, height: cellSize)
              }
            }
          }
        }
        .frame(width: actualTotalGridWidth, height: actualTotalGridHeight)
        .background(Color.gray.opacity(0.3)) // Grid background
        .padding()
        // Overlay to indicate processing
        .overlay(
          viewModel.isProcessingMove ? Color.black.opacity(0.3).edgesIgnoringSafeArea(.all) : Color.clear.edgesIgnoringSafeArea(.all)
        )


        Button("New Game") {
          viewModel.setupNewGame()
        }
        .padding()
        .buttonStyle(.borderedProminent)

        Spacer() // Push content to top

      }
      // Center the VStack horizontally
      .frame(width: geometry.size.width)

    }
    // Add padding around the entire content if needed
    // .padding()
  }
}

// MARK: - Playground Execution

// Instantiate the main view
let contentView = ContentView().frame(width: 500, height: 700)

// Set the live view
PlaygroundPage.current.setLiveView(contentView)
