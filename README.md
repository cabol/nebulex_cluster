# NebulexCluster
> Cluster handling utilities for external Nebulex adapters.

[![Build Status](https://travis-ci.org/cabol/nebulex_cluster.svg?branch=master)](https://travis-ci.org/cabol/nebulex_cluster)
[![Coverage Status](https://coveralls.io/repos/github/cabol/nebulex_cluster/badge.svg?branch=master)](https://coveralls.io/github/cabol/nebulex_cluster?branch=master)
[![Hex Version](https://img.shields.io/hexpm/v/nebulex_cluster.svg)](https://hex.pm/packages/nebulex_cluster)
[![Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/nebulex_cluster)

This project is especially for those adapters that want to provide cluster
support in a very simple way based on sharding distribution model. For example,
for Redis and Memcached adapters, we can provide multiple connection pools
(connection-pool per node) and client-side sharding on top of them very easy.

## Installation

Add `nebulex_cluster` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nebulex_cluster, "~> 0.1"}
  ]
end
```

Then run `mix deps.get` in your shell to fetch the dependencies.

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
