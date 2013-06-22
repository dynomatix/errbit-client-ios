class ProblemsController < UITableViewController

  def initWithServer server
    initWithNibName(nil, bundle:nil)
    @server = server
    self
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    @problems = []

    refreshControl = UIRefreshControl.alloc.init
    refreshControl.addTarget(self, action:'refresh:', forControlEvents:UIControlEventValueChanged)
    self.setRefreshControl(refreshControl)

    @errbit = Errbit.new( server: @server.server, username: @server.username, password: @server.password ) do
      refresh(nil)
    end
  end

  def viewWillAppear(animated)
    navigationItem.title = @server.name
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @problems.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    problem = @problems[indexPath.row]

    cell.textLabel.text = problem['message']
    cell.detailTextLabel.text = "#{problem['app_name']} (#{problem['environment']})"
    cell
  end

  def load_data(&block)
    @errbit.problems do |problems|
      @problems = problems
      block.call if block
    end
  end

  def refresh(sender)
    load_data do
      view.reloadData
      self.refreshControl.endRefreshing
    end
  end
end
