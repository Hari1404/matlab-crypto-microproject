# PACKET 2B: Graph analysis (connectivity, paths, cycles and removals)

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 2 (Graph network)
Goal: analyse the communication network. Add connected groups, breadth-first search, distances, the shortest path between two users, cycles, bridge channels, cut users, and the removal of a channel or a user, with the tests, a new `show_analysis`, and `demo_point2` now showing the graph and then the analysis. Update PROGRESS.md, README.md and run_all_tests. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `4e19b12 2A: graph network, adjacency matrix and list`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_2B_GRAPH.md` and `packets/MP2B_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_2B_GRAPH.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP2B_files.zip" -DestinationPath "." -Force`
2. Check that these 23 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/graph_network/adjacency_to_edges.m`
   - `src/graph_network/bfs_search.m`
   - `src/graph_network/bridge_channels.m`
   - `src/graph_network/connected_components.m`
   - `src/graph_network/cut_users.m`
   - `src/graph_network/cycle_rank.m`
   - `src/graph_network/demo_point2.m` (this one already existed and is now replaced)
   - `src/graph_network/distance_matrix.m`
   - `src/graph_network/find_cycle.m`
   - `src/graph_network/format_groups.m`
   - `src/graph_network/format_names.m`
   - `src/graph_network/is_connected.m`
   - `src/graph_network/reachable_from.m`
   - `src/graph_network/remove_channel.m`
   - `src/graph_network/remove_user.m`
   - `src/graph_network/shortest_path.m`
   - `src/graph_network/show_analysis.m`
   - `src/graph_network/yes_no.m`
   - `tests/raises_error.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_graph_analysis.m`
3. Check the SHA-256 hash of all 23 files. All 23 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `13204a99193e12f0ae011ac8dc04f39f9001e9429188ac7bc27d7b4876fd7c96` |
   | `README.md` | `a09e7d0743b255485fab916120ae566684d6de9750e8e237bd6887fcdfdc17aa` |
   | `src/graph_network/adjacency_to_edges.m` | `0dca7a2b684e8573ca31340301f8dfaaf8b8765e3255fc266dedb7b2b9ba374d` |
   | `src/graph_network/bfs_search.m` | `cde790fda0dc88b3b868bc1f5bd99a849b57304eb9299e647b2adaf1aa87dd53` |
   | `src/graph_network/bridge_channels.m` | `fd2dfb3c34297467bfac8d6510f0a536b671a1b6724ace2064e3d65c9dddc090` |
   | `src/graph_network/connected_components.m` | `d981d07dd01f4a93fc1415e04f8eb78b46b08ca0b7b0066f620dac1af337c972` |
   | `src/graph_network/cut_users.m` | `2b442ab69e5b2b1b355acb9f133d156ec63c719132387712ce21181b3c377173` |
   | `src/graph_network/cycle_rank.m` | `701ea64832680051f380f0ca24a22c56801d228cc2ea0a7d9fb5eebe19ff3238` |
   | `src/graph_network/demo_point2.m` | `8f41ad8f2e91ede9a6089521310bd704597e0065e797b7f6678bbd6f57ea198f` |
   | `src/graph_network/distance_matrix.m` | `37982a155d23d7f1bb87fd0f6c42136ef1150da31fbf4231ca04d166241c3157` |
   | `src/graph_network/find_cycle.m` | `9f6f44a1394ef72d33d8d50383bc29faa53eb5a6ff1317e03799e18e9a583e1b` |
   | `src/graph_network/format_groups.m` | `cae3cfbb9f2ba0ad4f8adb7b6acc39c2e54bbc41172f64a9f66e963034113b89` |
   | `src/graph_network/format_names.m` | `2c9e323b30b0da41e06a17f609c5ea0893928acf4cb92089f5c075633258e58c` |
   | `src/graph_network/is_connected.m` | `332a2c338125a1ce7d56fcaecf10723e208c07b9ef3d1f3f91eb6f939ab59301` |
   | `src/graph_network/reachable_from.m` | `2e91b375239ce6abcffb74e12671a89dfdd7e9caf873245fa5d34025279f9c76` |
   | `src/graph_network/remove_channel.m` | `2a677733d85cd152660ad4d6920979096f4c83a75a6bfc3f0ce9fdd0f5460337` |
   | `src/graph_network/remove_user.m` | `1b102f314eaad683e8dd2d2841c1932ea2204da3f38e0256d55d602215a7617e` |
   | `src/graph_network/shortest_path.m` | `0ac162c8fb0cbc8e3451a2dfb95de555aae60e527cf3b08fb19147283855cfb6` |
   | `src/graph_network/show_analysis.m` | `c3ab561e206334b225f57375eaeba4ddf93718349f805b693ee0f4ef463cbf4b` |
   | `src/graph_network/yes_no.m` | `fa0397104bb4959464ba8f8c87f378fc1a200bd927db098098e32605ffd03d3e` |
   | `tests/raises_error.m` | `24bbff23aa8bbfb49ddd344e297deecd45475679edcdf14e8a499d56603ee0e3` |
   | `tests/run_all_tests.m` | `c1a9e2a797960bb86614f92c129f810d1a40137e8c55f2ebf9a545666e58f86e` |
   | `tests/test_graph_analysis.m` | `b59300d021219548d52adeaae09edbc02a35cab07211c12a2f9179e1114dfd48` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '13204a99193e12f0ae011ac8dc04f39f9001e9429188ac7bc27d7b4876fd7c96',
 'README.md': 'a09e7d0743b255485fab916120ae566684d6de9750e8e237bd6887fcdfdc17aa',
 'src/graph_network/adjacency_to_edges.m': '0dca7a2b684e8573ca31340301f8dfaaf8b8765e3255fc266dedb7b2b9ba374d',
 'src/graph_network/bfs_search.m': 'cde790fda0dc88b3b868bc1f5bd99a849b57304eb9299e647b2adaf1aa87dd53',
 'src/graph_network/bridge_channels.m': 'fd2dfb3c34297467bfac8d6510f0a536b671a1b6724ace2064e3d65c9dddc090',
 'src/graph_network/connected_components.m': 'd981d07dd01f4a93fc1415e04f8eb78b46b08ca0b7b0066f620dac1af337c972',
 'src/graph_network/cut_users.m': '2b442ab69e5b2b1b355acb9f133d156ec63c719132387712ce21181b3c377173',
 'src/graph_network/cycle_rank.m': '701ea64832680051f380f0ca24a22c56801d228cc2ea0a7d9fb5eebe19ff3238',
 'src/graph_network/demo_point2.m': '8f41ad8f2e91ede9a6089521310bd704597e0065e797b7f6678bbd6f57ea198f',
 'src/graph_network/distance_matrix.m': '37982a155d23d7f1bb87fd0f6c42136ef1150da31fbf4231ca04d166241c3157',
 'src/graph_network/find_cycle.m': '9f6f44a1394ef72d33d8d50383bc29faa53eb5a6ff1317e03799e18e9a583e1b',
 'src/graph_network/format_groups.m': 'cae3cfbb9f2ba0ad4f8adb7b6acc39c2e54bbc41172f64a9f66e963034113b89',
 'src/graph_network/format_names.m': '2c9e323b30b0da41e06a17f609c5ea0893928acf4cb92089f5c075633258e58c',
 'src/graph_network/is_connected.m': '332a2c338125a1ce7d56fcaecf10723e208c07b9ef3d1f3f91eb6f939ab59301',
 'src/graph_network/reachable_from.m': '2e91b375239ce6abcffb74e12671a89dfdd7e9caf873245fa5d34025279f9c76',
 'src/graph_network/remove_channel.m': '2a677733d85cd152660ad4d6920979096f4c83a75a6bfc3f0ce9fdd0f5460337',
 'src/graph_network/remove_user.m': '1b102f314eaad683e8dd2d2841c1932ea2204da3f38e0256d55d602215a7617e',
 'src/graph_network/shortest_path.m': '0ac162c8fb0cbc8e3451a2dfb95de555aae60e527cf3b08fb19147283855cfb6',
 'src/graph_network/show_analysis.m': 'c3ab561e206334b225f57375eaeba4ddf93718349f805b693ee0f4ef463cbf4b',
 'src/graph_network/yes_no.m': 'fa0397104bb4959464ba8f8c87f378fc1a200bd927db098098e32605ffd03d3e',
 'tests/raises_error.m': '24bbff23aa8bbfb49ddd344e297deecd45475679edcdf14e8a499d56603ee0e3',
 'tests/run_all_tests.m': 'c1a9e2a797960bb86614f92c129f810d1a40137e8c55f2ebf9a545666e58f86e',
 'tests/test_graph_analysis.m': 'b59300d021219548d52adeaae09edbc02a35cab07211c12a2f9179e1114dfd48',
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
   `git add PROGRESS.md README.md src/graph_network/adjacency_to_edges.m src/graph_network/bfs_search.m src/graph_network/bridge_channels.m src/graph_network/connected_components.m src/graph_network/cut_users.m src/graph_network/cycle_rank.m src/graph_network/demo_point2.m src/graph_network/distance_matrix.m src/graph_network/find_cycle.m src/graph_network/format_groups.m src/graph_network/format_names.m src/graph_network/is_connected.m src/graph_network/reachable_from.m src/graph_network/remove_channel.m src/graph_network/remove_user.m src/graph_network/shortest_path.m src/graph_network/show_analysis.m src/graph_network/yes_no.m tests/raises_error.m tests/run_all_tests.m tests/test_graph_analysis.m packets/PACKET_2B_GRAPH.md`
5. Run `git status --short`. It must print exactly these 24 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_2B_GRAPH.md
A  src/graph_network/adjacency_to_edges.m
A  src/graph_network/bfs_search.m
A  src/graph_network/bridge_channels.m
A  src/graph_network/connected_components.m
A  src/graph_network/cut_users.m
A  src/graph_network/cycle_rank.m
M  src/graph_network/demo_point2.m
A  src/graph_network/distance_matrix.m
A  src/graph_network/find_cycle.m
A  src/graph_network/format_groups.m
A  src/graph_network/format_names.m
A  src/graph_network/is_connected.m
A  src/graph_network/reachable_from.m
A  src/graph_network/remove_channel.m
A  src/graph_network/remove_user.m
A  src/graph_network/shortest_path.m
A  src/graph_network/show_analysis.m
A  src/graph_network/yes_no.m
A  tests/raises_error.m
M  tests/run_all_tests.m
A  tests/test_graph_analysis.m
```
6. Commit with exactly this message: `2B: graph analysis, paths, cycles and removals`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 23 of 23 match.
2. `git log -1 --oneline` shows the message `2B: graph analysis, paths, cycles and removals`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly six lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md` and `packets/PACKET_2B_GRAPH.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point2` and press Enter. Expected: the title `POINT 2 DEMO: THE GRAPH NETWORK`; first the graph exactly as in 2A (6 vertices, 6 edges, the 6 by 6 adjacency matrix, the adjacency list, the degrees 2, 2, 2, 3, 2, 1 with `Sum of the degrees = 12, and 2 x 6 edges = 12`, and four check lines that end with `yes`); then `=== ANALYSIS OF THE COMMUNICATION NETWORK ===` with seven numbered parts: 1 connectivity (1 group, connected: yes), 2 breadth-first search from Alice (visit order Alice, Bob, Carol, Dave, Frank, Grace), 3 the 6 by 6 distance table (Alice's row is `0 1 1 2 3 4`), 4 the shortest path `Alice - Bob - Dave - Frank - Grace (length 4)`, 5 `A shortest cycle: Alice - Bob - Dave - Carol - Alice (length 4)`, 6 removing one channel at a time (ending with `Bridge channels (removing one splits the network): Dave - Frank, Frank - Grace`), 7 removing one user at a time (ending with `Cut users (removing one splits the network): Dave, Frank`); and at the end a block `Checks:` with four lines that end with `yes`. In total the demo has 8 check lines (4 from the graph and 4 from the analysis), all ending with `yes`, and none ending with `NO`.
5. Type `G = define_graph(); A = G.adj; B = remove_channel(A, 4, 5); disp(is_connected(A)); disp(is_connected(B))` and press Enter. Expected: `1` and then `0` (Dave - Frank is edge e5; without it Frank and Grace are cut off from the others).
6. Type `demo_point1` and press Enter. It must still print everything from 1A, 1B and 1C as before.

The planner already ran steps 2 to 5 in GNU Octave 8.4: 25 of 25, 51 of 51, 50 of 50, 51 of 51 and 120 of 120 checks passed. The analysis functions were also compared with a separate Python program on 476 graphs (every graph with up to 4 users, and 400 random graphs with 5 to 9 users) and gave the same results every time.

Paste line for the agent:

`Read packets/PACKET_2B_GRAPH.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
