from itertools import cycle
INPUT = [int(n.strip()) for n in open('input')]

seen = set()
acc = 0
for c in cycle(INPUT):
    acc += c
    if acc in seen:
        print(acc)
        break
    seen.add(acc)
