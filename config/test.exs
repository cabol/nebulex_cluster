use Mix.Config

config :nebulex_cluster, NebulexCluster.TestCache,
  connection_module: NebulexCluster.TestConn,
  nodes: [
    node1: [
      host: "127.0.0.1",
      port: 9001,
      pool_size: 2
    ],
    node2: [
      host: "127.0.0.1",
      port: 9002,
      pool_size: 4
    ]
  ]
