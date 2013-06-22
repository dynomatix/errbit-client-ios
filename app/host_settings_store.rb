class HostSettingsStore
  def self.shared
    # Our store is a singleton object.
    @shared ||= HostSettingsStore.new
  end

  def hosts
    @hosts ||= begin
      # Fetch all hosts from the model, sorting by the creation date.
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Host', inManagedObjectContext:@context)
      request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('name', ascending:true)]

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end

  def add_host
    # Yield a blank, newly created Host entity, then save the model.
    yield NSEntityDescription.insertNewObjectForEntityForName('Host', inManagedObjectContext:@context)
    save
  end

  def update_server(host, &block)
    yield host
    save
  end

  def remove_host(host)
    # Delete the given entity, then save the model.
    @context.deleteObject(host)
    save
  end

  private

  def initialize
    # Create the model programmatically. Our model has only one entity, the Host class, and the data will be stored in a SQLite database, inside the application's Documents folder.
    model = NSManagedObjectModel.alloc.init
    model.entities = [Host.entity]

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Hosts.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @hosts = nil
  end
end
