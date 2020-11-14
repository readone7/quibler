defmodule Operations do
  """
  Creates a client for consuming :ets
  CRUD operations

  TODO: when should caching occur?
  TODO: should the cache be periodic?
  TODO: refactor for consistent return values
  TODO: refactor try/rescue
  TODO: distribute cache over several nodes, race conditions?
"""
  use Registry

  def new(name, _opts) do
    # create a new key-value cache
    try do
      :ets.new(name, [:set, :public, :set, :named_table])
    rescue
        ArgumentError -> {:error, "could not create cache"}
    end
  end

  def insert(name, {key, value} = values) do
    # values is a tuple of the form <key, values>
    # add a value into cache if it does not already exist
    case get(name, key) do
      {:ok = status, result} -> result
      {:error = status, _} -> :ets.insert_new(name, {key, value})
    end
  end

  def get(name, key) do
    # retrieve values from cache
    case :ets.lookup(name, key) do
      [result | _] -> {:ok, result}
      [] -> {:error, "could not find cached values"}
    end
  end

  def update(name, {key, value} = values) do
    # update values in cache, default behaviour
    # will override table values of a set
    :ets.insert(name, {key, value})
  end

  def delete(name, key) do
    # delete cached value
    :ets.delete(name, key)
  end
end
