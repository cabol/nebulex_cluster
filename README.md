# NebulexCluster
> ### Cluster handling utilities for external Nebulex adapters.

This project is specially for those adapters that want to provide cluster
support in a very simple way based on sharding distribution model. For example,
for Redis and Memcached adapters, we can provide multiple connection pools
(connection-pool per node) and client-side sharding on top of them very easy.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nebulex_cluster` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nebulex_cluster, "~> 0.1"}
  ]
end
```

## Usage

Check out [NebulexRedisAdapter](https://github.com/cabol/nebulex_redis_adapter)
to learn more about how to use **NebulexCluster**.

## Testing

```
$ mix test
```

## Copyright and License

Copyright (c) 2019, Carlos Bolaños.

NebulexCluster source code is licensed under the [MIT License](LICENSE).
