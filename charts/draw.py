import random
import sys
from algorithm import AOP_multiprogress, AOP_simple, NNA, ok_path
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton
from PyQt5.QtGui import QPainter, QPen
from PyQt5.QtCore import Qt, QPointF

class Map(QWidget):
    def __init__(self, a, b, c):
        super().__init__()

        # 生成100个随机点
        random_points = [(random.randint(0, 100), random.randint(0, 100)) for _ in range(100)]
        # 添加起点和终点
        points = [(100, 100)] + random_points + [(0, 0)]

        self.a = a  # 地图的宽度
        self.b = b  # 地图的高度
        self.c = c  # 随机生成的点的数量
        self.points = []  # 存储生成的随机点
        self.path = []  # 存储计算出的最短路径
        self.initUI()

    def initUI(self):
        """初始化用户界面"""
        self.setGeometry(100, 100, self.a, self.b)  # 设置窗口的位置和大小
        self.setWindowTitle('Point Generator')

        layout = QVBoxLayout()  # 垂直布局

        # 创建按钮，点击时生成随机点并计算最短路径
        generateButton = QPushButton('Generate Points and Find Path', self)
        generateButton.clicked.connect(self.generatePointsAndFindPath)
        layout.addWidget(generateButton)

        self.setLayout(layout)  # 将布局应用到窗口




if __name__ == '__main__':
    app = QApplication(sys.argv)
    a, b, c = 1000, 1000, 100  # 设置地图大小和随机点数量
    algorithm = NNA
    # 这里需要设置算法接口标准，存在多线程与单线程两种情况，算法接口也应该分为两种情况，输入一个列表，返回一个排序后的列表，该进行只负责进行GUI显示，不负责算法逻辑。
    # 返回内容包括地图尺寸，生成节点个数，排序后列表与路径总长度。鉴于在算法计算过程中多数情况下已经得到了距离矩阵。
    map = Map(100, 100, 100)
    map.show()
    sys.exit(app.exec_())