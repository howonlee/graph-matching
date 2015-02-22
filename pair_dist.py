import matplotlib.pyplot as plt
import numpy as np
import math

def circle(x, y):
    return (x ** 2 + y ** 2)

def pair_dist(x, y):
    #do it the num-pythonic way
    r = np.where(x > y, x / y, y /x)
    return np.sqrt(r - 1)

if __name__ == "__main__":
    xx = np.linspace(-2, 100, 400)
    yy = np.linspace(-2, 100, 400)
    [X, Y] = np.meshgrid(xx, yy)
    Z = pair_dist(X, Y)
    plt.figure()
    plt.contour(X, Y, Z, [1,2,3,4,5])
    plt.show()

#unit distance for this pair distance business
