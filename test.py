from random_points import RandomPointsGenerator

# 初始化生成器，地图宽度100，高度100，生成1000个节点
generator = RandomPointsGenerator(a=100, b=100, n=1000)

# 生成均匀分布的随机点
uniform_points = generator.generate(mode="uniform")

# 生成聚集分布的随机点
clustered_points = generator.generate(mode="clustered")

# 打印前10个随机点
print(uniform_points[:10])
print(clustered_points[:10])
