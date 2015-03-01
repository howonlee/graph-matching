import json
import pickle
import collections

if __name__ == "__main__":
    first_dict, second_dict, match_dict = {}, {}, {}
    with open("first_dict.pickle", "r") as first_file:
        first_dict = pickle.load(first_file)
    with open("second_dict.pickle", "r") as second_file:
        second_dict = pickle.load(second_file)
    with open("prop_result.json", "r") as match_file:
        match_dict = json.load(match_file)
    print match_dict
    first_rev = {v: k for (k, v) in first_dict.items()}
    first_rev2 = collections.defaultdict(str)
    for k, v in first_rev.iteritems():
        first_rev2[k] = v
    second_rev = {v: k for (k, v) in second_dict.items()}
    second_rev2 = collections.defaultdict(str)
    for k, v in second_rev.iteritems():
        second_rev2[k] = v
    match_2 = {int(k):v for (k, v) in match_dict.items()}
    match_3 = {first_rev2[v]:second_rev2[k] for (k, v) in match_2.items()}
    print match_3
