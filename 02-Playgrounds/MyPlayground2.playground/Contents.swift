import Foundation

func normalizedStarRating(forRating rating: Float, ofPossibleTotal total: Float) -> (Int, String) {
    let fraction = rating / total
    let ratingOutOf5 = fraction * 5
    let rounedRating = round(ratingOutOf5)
    let numberOfStars = Int(rounedRating)
    let ratingString = "\(numberOfStars) Star Movie"
    return (numberOfStars, ratingString)
}

let ratingAndDisplayString = normalizedStarRating(forRating: 5, ofPossibleTotal: 10)
let ratingNumber = ratingAndDisplayString.0
let ratingString = ratingAndDisplayString.1
print("Rating: \(ratingNumber), Rating String: \(ratingString)")
