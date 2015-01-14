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
    return list(labeling)

def generate_labelings_efficiently(edges,partial_labeling = None):
    # try to place largest, then second largest, etc. with backtracking
    m = len(edges)
    n = len(edges)+1
    labels = []
    for i in range(n/2):
        labels.append(i)
        labels.append(m-i)
    if n%2 == 1:
        labels.append(n/2)
    initial_undetermined_edges = edges[:]
    initial_labels_remaining = labels
    initial_labeling = [None for x in range(n)]
    initial_known_weights = []
    if partial_labeling:
        if not(update_parameters(initial_undetermined_edges,initial_labels_remaining,initial_labeling,initial_known_weights,partial_labeling)):
            return
    for labeling in generate_labelings_efficiently_helper(initial_undetermined_edges,initial_labels_remaining,initial_labeling,initial_known_weights):
        yield labeling

def update_parameters(initial_undetermined_edges,initial_labels_remaining,initial_labeling,initial_known_weights,partial_labeling):
    for idx, label in enumerate(partial_labeling):
        if label is None:
            continue
        if (label < 0) or (label >= len(partial_labeling)):
            return False
        initial_labels_remaining.remove(label)
    determined_edge_indices = []
    for idx, edge in enumerate(initial_undetermined_edges):
        if (partial_labeling[edge[0]] is not None) and (partial_labeling[edge[1]] is not None):
            determined_edge_indices.insert(0,idx)
            initial_known_weights.append(abs(partial_labeling[edge[0]]-partial_labeling[edge[1]]))
    for idx in determined_edge_indices:
        del initial_undetermined_edges[idx]
    if len(set(initial_known_weights)) != len(initial_known_weights):
        return False
    initial_labeling[:] = partial_labeling[:]
    return True



def generate_labelings_efficiently_helper(undetermined_edges, labels_remaining, partial_labeling, known_weights):
    # partial_labeling has None where there is no label set
    if len(labels_remaining) == 0:
        yield partial_labeling
    else:
        # heuristic experiment: check whether largest unknown weight is even possible
        largest_unknown_weight = max(list(set([x for x in range(len(partial_labeling)-1)])-set(known_weights)))
        can_satisfy_largest_unknown_weight = False
        min_remaining_label = min(labels_remaining)
        max_remaining_label = max(labels_remaining)
        for edge in undetermined_edges:
            if(partial_labeling[edge[0]] is None and partial_labeling[edge[1]] is None ):
                if max_remaining_label - min_remaining_label >= largest_unknown_weight:
                    can_satisfy_largest_unknown_weight = True
                    break
        if not can_satisfy_largest_unknown_weight:
            for edge in undetermined_edges:
                known_label = None
                if partial_labeling[edge[0]] is not None:
                    known_label = partial_labeling[edge[0]]
                elif partial_labeling[edge[1]] is not None:
                    known_label = partial_labeling[edge[1]]
                else:
                    continue
                if ((abs(known_label - min_remaining_label) >= largest_unknown_weight) 
                    or (abs(known_label - max_remaining_label) >= largest_unknown_weight)):
                    can_satisfy_largest_unknown_weight = True
                    break
        if not can_satisfy_largest_unknown_weight:
            return
        next_label = labels_remaining[0]
        for idx, label in enumerate(partial_labeling):
            if(label is None):
                #check if placing this label here creates an existing edge length
                creates_existing = False
                new_known_weights = known_weights[:]
                new_undetermined_edges = undetermined_edges[:]
                indices_to_erase = []
                for edge_idx in reversed(range(len(new_undetermined_edges))):
                    edge = new_undetermined_edges[edge_idx]
                    other_label = None
                    if edge[0] == idx:
                        other_label = partial_labeling[edge[1]]
                    elif edge[1] == idx:
                        other_label = partial_labeling[edge[0]]
                    if other_label is None:
                        continue
                    created_weight = abs(next_label-other_label)
                    if created_weight in new_known_weights:
                        creates_existing = True
                        break
                    # remove all edges that have the newly labeled vertex as an endpoint
                    indices_to_erase.append(edge_idx)
                    # add the weight to our known weights
                    new_known_weights.append(created_weight)
                # if we created an existing edge length, we are done
                if creates_existing:
                    continue
                for erase_idx in indices_to_erase: # note that this list is in reverse order so we dont mess up the indices when deleting
                    del new_undetermined_edges[erase_idx]

                new_partial_labeling = partial_labeling[:]
                new_partial_labeling[idx] = next_label

                for full_labeling in generate_labelings_efficiently_helper(new_undetermined_edges,
                    labels_remaining[1:],new_partial_labeling, new_known_weights):
                    yield full_labeling



def check_efficient_correctness(edges):
    old_answers = sorted([x for x in generate_labelings(edges) if x])
    new_answers = sorted([x for x in generate_labelings_efficiently(edges) if x])
    return old_answers == new_answers

if __name__ == "__main__":
    # 0-indexed labeling
    edges = json.loads(sys.argv[1])
    partial_labeling = None
    if len(sys.argv) > 2:
        if sys.argv[2][0] == "[":
            partial_labeling = json.loads(sys.argv[2].replace("_","\"_\""))
            for idx, label in enumerate(partial_labeling):
                if label == "_":
                    partial_labeling[idx] = None
        elif sys.argv[2][0] == "{":
            # must put in quotes on command line
            hacky_dict_text = sys.argv[2].replace("{","{\"").replace(":","\":").replace(",",",\"")
            partial_labeling_dict = json.loads(hacky_dict_text)
            partial_labeling = [None for x in range(len(edges)+1)]
            for key,value in partial_labeling_dict.items():
                partial_labeling[int(key)] = value
    num_answers = 0
    for labeling in generate_labelings_efficiently(edges,partial_labeling):
        if labeling:
            print labeling
            num_answers += 1
    print num_answers
