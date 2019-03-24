defmodule NebulexCluster.TestConn do
  @moduledoc false

  use GenServer

  ## API

  @doc false
  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc false
  def child_spec(opts) do
    %{
      id: Keyword.fetch!(opts, :name),
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  @doc false
  def ping(conn) do
    GenServer.call(conn, :ping)
  end

  ## GenServer Callbacks

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end
end
