import json
import pickle

if __name__ == "__main__":
    first_dict, second_dict, match_dict = {}, {}, {}
    with open("first_dict.pickle", "r") as first_file:
        first_dict = pickle.load(first_file)
    with open("second_dict.pickle", "r") as second_file:
        second_dict = pickle.load(second_file)
    with open("prop_result.json", "r") as match_file:
        match_dict = json.load(match_file)
    print match_dict
