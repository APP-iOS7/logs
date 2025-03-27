import UIKit
import PlaygroundSupport

class TableViewExampleController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var tableView: UITableView?
  var journalEntries: [[String]] = [
    ["sun.max", "9, Apr 2023", "Nice weather today"],
    ["cloud.rain", "10, Apr 2023", "Heavy rain today"],
    ["cloud.sun", "11, Apr 2023", "It's cloudy out"]
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
    createTableView()
  }

  func createTableView() {
    self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
    self.tableView?.dataSource = self
    self.tableView?.delegate = self
    self.tableView?.backgroundColor = .white
    self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "journalCell")
    self.view.addSubview(self.tableView!)
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return journalEntries.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath)
    let entry = journalEntries[indexPath.row]

    var configuration = cell.defaultContentConfiguration()
    configuration.text = entry[1]
    configuration.secondaryText = entry[2]
    configuration.image = UIImage(systemName: entry[0])
    cell.contentConfiguration = configuration
//
//    cell.imageView?.image = UIImage(systemName: entry[0])
//    cell.textLabel?.text = entry[1]
//    cell.detailTextLabel?.text = entry[2]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Selected row at index \(indexPath.row)")
    let selectedEntry = journalEntries[indexPath.row]
    print(selectedEntry)
  }
}

PlaygroundPage.current.liveView = TableViewExampleController()
