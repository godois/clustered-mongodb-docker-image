config= {_id: "labcluster",members: [{_id: 0,host: "mongonode1.example.com:27017"}]};
rs.initiate(config);
rs.add("mongonode2.example.com:27017");
rs.add("mongonode3.example.com:27017");
rs.conf();
cfg = rs.conf()
cfg.members[0].priority = 1
cfg.members[1].priority = 2
cfg.members[2].priority = 0
rs.reconfig(cfg);
rs.status();
conf = rs.conf();
conf.members[0].tags = { "dc": "SP", "use": "prod" }
conf.members[1].tags = { "dc": "SP", "use": "prod" }
conf.members[2].tags = { "use": "report" }
rs.reconfig(conf);
