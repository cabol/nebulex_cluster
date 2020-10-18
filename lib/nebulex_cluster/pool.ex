defmodule NebulexCluster.Pool do
  @moduledoc false

  @default_pool_size System.schedulers_online()

  ## API

  # sobelow_skip ["DOS.BinToAtom"]
  @spec children(module, Keyword.t()) :: [Supervisor.child_spec()]
  def children(module, opts) do
    name = Keyword.fetch!(opts, :name)
    pool_size = Keyword.get(opts, :pool_size, @default_pool_size)

    for index <- 0..(pool_size - 1) do
      opts = Keyword.put(opts, :name, :"#{name}.#{index}")
      {module, opts}
    end
  end

  # sobelow_skip ["DOS.BinToAtom"]
  @spec get_conn(atom, pos_integer) :: atom
  def get_conn(name, pool_size) do
    # ensure to select the same connection based on the caller PID
    :"#{name}.#{:erlang.phash2(self(), pool_size)}"
  end
end
