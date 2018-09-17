import matplotlib.pyplot as plt
import numpy as np
v = np.loadtxt('sample-l_lcout.txt')
plt.plot(v[:, 0], v[:, 3])
#plt.plot(v[:, 3])
plt.show()
