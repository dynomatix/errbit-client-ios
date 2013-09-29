class ServersController < UITableViewController
  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    rightButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"add_button_pressed:")
    self.navigationItem.rightBarButtonItem = rightButton
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Servers'
  end

  def tableView(tableView, numberOfRowsInSection:section)
    HostSettingsStore.shared.hosts.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
    server = HostSettingsStore.shared.hosts[indexPath.row]

    cell.textLabel.text = server.name
    cell.detailTextLabel.text = server.server
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    server = HostSettingsStore.shared.hosts[indexPath.row]
    @problems = ProblemsController.alloc.initWithServer(server)
    navigationController.pushViewController(@problems, animated:true)
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    host = HostSettingsStore.shared.hosts[indexPath.row]
    @host_settings_controller = HostSettingsController.alloc.initController(host)
    navigationController.pushViewController(@host_settings_controller, animated:true)
  end

  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    true
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      server = HostSettingsStore.shared.hosts[indexPath.row]
      HostSettingsStore.shared.remove_host server
      view.reloadData
    end
  end

  def add_button_pressed(sender)
    host = Host.new()
    @host_settings_controller = HostSettingsController.alloc.initController(host)
    navigationController.pushViewController(@host_settings_controller, animated:true)
  end

  def viewDidAppear(animated)
    view.reloadData
  end
end
