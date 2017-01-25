install_github('tamboRapi','tambora-org')

data <- fromTambora("g[cid]=156")
drawWorldMapAll(data)