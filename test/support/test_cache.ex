defmodule NebulexCluster.TestCache do
  @moduledoc false

  use Nebulex.Cache,
    otp_app: :nebulex_cluster,
    adapter: Nebulex.Adapters.Local
end
