# PACKET 2A: The graph network (vertices, edges, adjacency matrix and list)

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 2 (Graph network)
Goal: add the communication network as a graph (the users are the vertices, the 6 channels are the edges), the adjacency matrix and the adjacency list with the conversions between them, the degrees, the tests, and a new demo `demo_point2`. Update PROGRESS.md and README.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `b65d279 1C: encryption and decryption functions`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_2A_GRAPH.md` and `packets/MP2A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_2A_GRAPH.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP2A_files.zip" -DestinationPath "." -Force`
2. Check that these 10 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/graph_network/adjacency_to_list.m`
   - `src/graph_network/define_graph.m`
   - `src/graph_network/demo_point2.m`
   - `src/graph_network/edges_to_adjacency.m`
   - `src/graph_network/list_to_adjacency.m`
   - `src/graph_network/show_graph.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_graph.m`
3. Check the SHA-256 hash of all 10 files. All 10 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `80ff0ab41048dd70e89418f114868d1c39a2a6d4ec85cb723bb263c98692b8ce` |
   | `README.md` | `de4cac20bca12281c0ff6e23bfa17998065b1d49830a9809c405e3d77e4e4ab8` |
   | `src/graph_network/adjacency_to_list.m` | `18c1757936fe52ba2bd72dd4dd72786f0a31e69f35b3347289f43cb47c76ffb4` |
   | `src/graph_network/define_graph.m` | `191ba4563df55961fdb939e9faefcf4a0d07360a0577f3b1e497f8f228946bd3` |
   | `src/graph_network/demo_point2.m` | `1b5e274ad6baceca163887da1ad605039220739f60133e82edacb99eec194909` |
   | `src/graph_network/edges_to_adjacency.m` | `96e7b20744e57ed3ccd56cf52555098ae8acefec345b087d75a781934bc8a94c` |
   | `src/graph_network/list_to_adjacency.m` | `ea8975ff6f52e6ca141690b835f9810484e78a61bdf037cf46fc4060ba9994e3` |
   | `src/graph_network/show_graph.m` | `f2084236117129d0c8a6934a681f5fc4d849066b6f7c84b31454264a45950a06` |
   | `tests/run_all_tests.m` | `e28408e77110348e9a59fb700c6f2de130815f521e52d435ed53a4e8a48870b9` |
   | `tests/test_graph.m` | `2e2629c77cd7b397c922e62c8926ce5bd8f76b71983bea14117f7c0da177d511` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '80ff0ab41048dd70e89418f114868d1c39a2a6d4ec85cb723bb263c98692b8ce',
 'README.md': 'de4cac20bca12281c0ff6e23bfa17998065b1d49830a9809c405e3d77e4e4ab8',
 'src/graph_network/adjacency_to_list.m': '18c1757936fe52ba2bd72dd4dd72786f0a31e69f35b3347289f43cb47c76ffb4',
 'src/graph_network/define_graph.m': '191ba4563df55961fdb939e9faefcf4a0d07360a0577f3b1e497f8f228946bd3',
 'src/graph_network/demo_point2.m': '1b5e274ad6baceca163887da1ad605039220739f60133e82edacb99eec194909',
 'src/graph_network/edges_to_adjacency.m': '96e7b20744e57ed3ccd56cf52555098ae8acefec345b087d75a781934bc8a94c',
 'src/graph_network/list_to_adjacency.m': 'ea8975ff6f52e6ca141690b835f9810484e78a61bdf037cf46fc4060ba9994e3',
 'src/graph_network/show_graph.m': 'f2084236117129d0c8a6934a681f5fc4d849066b6f7c84b31454264a45950a06',
 'tests/run_all_tests.m': 'e28408e77110348e9a59fb700c6f2de130815f521e52d435ed53a4e8a48870b9',
 'tests/test_graph.m': '2e2629c77cd7b397c922e62c8926ce5bd8f76b71983bea14117f7c0da177d511',
}
ok = True
for f, h in files.items():
    actual = hashlib.sha256(open(f, 'rb').read()).hexdigest()
    same = (actual == h)
    ok = ok and same
    print(f, same)
print('ALL_MATCH:', ok)
"
```

   If the last line is not `ALL_MATCH: True`, stop.
4. Stage only these paths, with this exact command:
   `git add PROGRESS.md README.md src/graph_network/adjacency_to_list.m src/graph_network/define_graph.m src/graph_network/demo_point2.m src/graph_network/edges_to_adjacency.m src/graph_network/list_to_adjacency.m src/graph_network/show_graph.m tests/run_all_tests.m tests/test_graph.m packets/PACKET_2A_GRAPH.md`
5. Run `git status --short`. It must print exactly these 11 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_2A_GRAPH.md
A  src/graph_network/adjacency_to_list.m
A  src/graph_network/define_graph.m
A  src/graph_network/demo_point2.m
A  src/graph_network/edges_to_adjacency.m
A  src/graph_network/list_to_adjacency.m
A  src/graph_network/show_graph.m
M  tests/run_all_tests.m
A  tests/test_graph.m
```
6. Commit with exactly this message: `2A: graph network, adjacency matrix and list`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 10 of 10 match.
2. `git log -1 --oneline` shows the message `2A: graph network, adjacency matrix and list`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly five lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md` and `packets/PACKET_2A_GRAPH.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point2` and press Enter. Expected: the title `POINT 2 DEMO: THE GRAPH NETWORK`, then the graph with 6 vertices (1 Alice to 6 Grace) and 6 edges (e1 Alice - Bob, e2 Alice - Carol, e3 Bob - Dave, e4 Carol - Dave, e5 Dave - Frank, e6 Frank - Grace); a 6 by 6 adjacency matrix with 12 ones (Alice's row is `0 1 1 0 0 0`); the adjacency list (Alice: Bob, Carol; Bob: Alice, Dave; Carol: Alice, Dave; Dave: Bob, Carol, Frank; Frank: Dave, Grace; Grace: Frank); the degrees 2, 2, 2, 3, 2, 1 with `Sum of the degrees = 12, and 2 x 6 edges = 12`; and four check lines that all end with `yes`.
5. Type `demo_point1` and press Enter. It must still print everything from 1A, 1B and 1C as before.

The planner already ran steps 2 to 4 in GNU Octave 8.4: 25 of 25, 51 of 51, 50 of 50 and 51 of 51 passed.

Paste line for the agent:

`Read packets/PACKET_2A_GRAPH.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
