import sys
import json
import itertools

def generate_labelings(edges):
    for labeling in itertools.permutations([x for x in range(len(edges)+1)]):
        yield generate_labelings_helper(edges[:],labeling,[])
def generate_labelings_helper(edges_remaining,labeling,edge_weights_so_far):
    while edges_remaining:
        next_edge = edges_remaining.pop(0)
        next_weight = abs(labeling[next_edge[1]]-labeling[next_edge[0]])
        if next_weight in edge_weights_so_far:
            return False
        edge_weights_so_far.append(next_weight)
    return labeling
if __name__ == "__main__":
    edges = json.loads(sys.argv[1])
    for labeling in generate_labelings(edges):
        if labeling:
            print labeling
