defmodule NebulexCluster.Pool do
  @moduledoc false

  @default_pool_size System.schedulers_online()

  ## API

  @spec children(module, Keyword.t()) :: [Supervisor.child_spec()]
  def children(module, opts) do
    name = Keyword.fetch!(opts, :name)
    pool_size = Keyword.get(opts, :pool_size, @default_pool_size)

    for index <- 0..(pool_size - 1) do
      opts = Keyword.put(opts, :name, :"#{name}.#{index}")
      {module, opts}
    end
  end

  @spec get_conn(atom, pos_integer) :: atom
  def get_conn(name, pool_size) do
    index = rem(System.unique_integer([:positive]), pool_size)
    :"#{name}.#{index}"
  end
end
