#this is fairly stupid
#but 0 to 1 indexing is necessary here
import sys

if __name__ == "__main__":
    assert len(sys.argv) > 1
    with open(sys.argv[1], "r") as in_file:
        for line in in_file:
            first, second = map(int, line.split())
            first += 1
            second += 1
            print first, second
