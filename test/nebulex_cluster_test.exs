defmodule NebulexClusterTest do
  use ExUnit.Case
  use Nebulex.Adapter.HashSlot
  doctest NebulexCluster

  alias NebulexCluster.TestCache

  @nodes :nebulex_cluster
         |> Application.fetch_env!(TestCache)
         |> Keyword.fetch!(:nodes)
         |> Enum.reduce([], fn {node_name, node_opts}, acc ->
           [{node_name, Keyword.get(node_opts, :pool_size, 2)} | acc]
         end)

  setup do
    {:ok, pid} = start()
    :ok

    on_exit(fn ->
      _ = :timer.sleep(10)
      if Process.alive?(pid), do: stop(pid)
    end)
  end

  test "get_conn/4" do
    for k <- 1..1000, do: assert_conn(k)
  end

  test "get_conn/3" do
    assert_conn({:"$hash_slot", :node1})
  end

  test "group_keys_by_hash_slot/3" do
    %{
      {:"$hash_slot", :node1} => node1,
      {:"$hash_slot", :node2} => node2
    } = NebulexCluster.group_keys_by_hash_slot(1000..2000, @nodes, __MODULE__)

    assert length(node1) > 1
    assert length(node2) > 1
  end

  test "group_keys_by_hash_slot/3 wirh objects" do
    objs = for x <- 1000..2000, do: %Nebulex.Object{key: x, value: x}

    %{
      {:"$hash_slot", :node1} => node1,
      {:"$hash_slot", :node2} => node2
    } = NebulexCluster.group_keys_by_hash_slot(objs, @nodes, __MODULE__)

    assert length(node1) > 1
    assert length(node2) > 1
  end

  ## Private Functions

  defp start do
    opts = Application.get_env(:nebulex_cluster, TestCache, [])
    {:ok, children} = NebulexCluster.init([cache: TestCache] ++ opts)
    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

  defp stop(pid) do
    Supervisor.stop(pid)
  end

  defp assert_conn({:"$hash_slot", node_name} = arg) do
    assert {^node_name, index} = get_conn(arg)
    assert index >= 0 and index < Keyword.fetch!(@nodes, node_name)
  end

  defp assert_conn(key) do
    assert {node_name, index} = get_conn(key)
    assert index >= 0 and index < Keyword.fetch!(@nodes, node_name)
  end

  defp get_conn(arg) do
    [_, _, _, node_name, index] =
      NebulexCluster
      |> apply(:get_conn, build_args(arg))
      |> to_string()
      |> String.split(".")

    {String.to_atom(node_name), String.to_integer(index)}
  end

  defp build_args({:"$hash_slot", node_name}) do
    [TestCache, @nodes, node_name]
  end

  defp build_args(key) do
    [TestCache, @nodes, key, __MODULE__]
  end
end
