defmodule NebulexCluster do
  @moduledoc """
  NebulexCluster.
  """

  alias NebulexCluster.{NodeSupervisor, Pool}

  @type hash_slot :: {:"$hash_slot", term}

  @type node_entry :: {node_name :: atom, pool_size :: pos_integer}

  @type nodes_config :: [node_entry]

  ## API

  @spec init(Keyword.t()) :: {:ok, [:supervisor.child_spec() | {module(), term()} | module()]}
  def init(opts) do
    cache = Keyword.fetch!(opts, :cache)
    conn_mod = Keyword.fetch!(opts, :connection_module)

    children =
      for {node_name, node_opts} <- Keyword.get(opts, :nodes, []) do
        arg = {conn_mod, [name: pool_name(cache, node_name)] ++ node_opts}
        Supervisor.child_spec({NodeSupervisor, arg}, type: :supervisor, id: {cache, node_name})
      end

    {:ok, children}
  end

  @spec get_conn(Nebulex.Cache.t(), nodes_config, atom) :: atom
  def get_conn(cache, nodes, node_name) do
    pool_size = Keyword.fetch!(nodes, node_name)

    cache
    |> pool_name(node_name)
    |> Pool.get_conn(pool_size)
  end

  @spec get_conn(Nebulex.Cache.t(), nodes_config, term, module) :: atom
  def get_conn(cache, nodes, key, module) do
    {node_name, pool_size} = get_node(module, nodes, key)

    cache
    |> pool_name(node_name)
    |> Pool.get_conn(pool_size)
  end

  @spec group_keys_by_hash_slot(Enum.t(), nodes_config, module) :: map
  def group_keys_by_hash_slot(enum, nodes, module) do
    Enum.reduce(enum, %{}, fn
      %Nebulex.Object{key: key} = object, acc ->
        hash_slot = hash_slot(module, key, nodes)
        Map.put(acc, hash_slot, [object | Map.get(acc, hash_slot, [])])

      key, acc ->
        hash_slot = hash_slot(module, key, nodes)
        Map.put(acc, hash_slot, [key | Map.get(acc, hash_slot, [])])
    end)
  end

  @spec pool_name(Nebulex.Cache.t(), atom) :: atom
  def pool_name(cache, node_name), do: :"#{cache}.#{node_name}"

  ## Private Functions

  defp get_node(module, nodes, key) do
    index = module.keyslot(key, length(nodes))
    Enum.at(nodes, index)
  end

  defp hash_slot(module, key, nodes) do
    node =
      module
      |> get_node(nodes, key)
      |> elem(0)

    {:"$hash_slot", node}
  end
end
