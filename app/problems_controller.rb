class ProblemsController < UITableViewController
  API_URL = 'http://jenkins.local:8088/api/json'

  def viewDidLoad
    view.dataSource = view.delegate = self
    @problems = []
    load_data
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Problems'
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @problems.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    problem = @problems[indexPath.row]

    # cell.textLabel.text = @date_formatter.stringFromDate(problem.creation_date)
    cell.textLabel.text = "#{problem['name']} - #{problem['color']}"
    # cell.detailTextLabel.text = "%0.3f, %0.3f" % [location.latitude, location.longitude]
    cell
  end

  def load_data
    puts "Loading data here..."
  end

  def reload_data
    view.reloadData
  end
end
