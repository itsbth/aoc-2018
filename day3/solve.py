from collections import defaultdict
from re import compile

PARSE_LINE = compile(r"""#(\d+) @ (\d+),(\d+): (\d+)x(\d+)""")

fabric = defaultdict(lambda: 0)

claims = [list(map(int, PARSE_LINE.match(line).groups())) for line in open('input')]
for pid, x, y, w, h in claims:
    coords = [(x + xo, y + yo) for xo in range(w) for yo in range(h)]
    for x, y in coords:
        fabric[(x, y)] += 1

for y in range(10):
    for x in range(10):
        print(fabric[(x, y)], end='')
    print()

print(sum(1 for _, v in fabric.items() if v > 1))

for pid, x, y, w, h in claims:
    coords = [(x + xo, y + yo) for xo in range(w) for yo in range(h)]
    if all(fabric[(x, y)] == 1 for x, y in coords):
        print(pid)
