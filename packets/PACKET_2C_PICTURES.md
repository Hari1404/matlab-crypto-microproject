# PACKET 2C: Pictures of the network and the finished demo_point2

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 2 (Graph network)
Goal: draw the communication network. Add the places of the users (`graph_layout`), the drawing with plot commands (`draw_network`), 5 pictures (the network, the shortest path, a shortest cycle, the weak points, the network after a bridge channel is removed) saved as PNG files, the test `test_graph_pictures`, and `demo_point2` now showing the graph, the analysis and the pictures. This finishes Point 2. Update PROGRESS.md, README.md, .gitignore (PNG files in `outputs/` are not committed), run_all_tests and the demo line of test_graph_analysis. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `a7b4363 2B: graph analysis, paths, cycles and removals`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_2C_PICTURES.md` and `packets/MP2C_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_2C_PICTURES.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP2C_files.zip" -DestinationPath "." -Force`
2. Check that these 15 files exist at these paths:
   - `.gitignore` (this one already existed and is now replaced)
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/graph_network/check_picture_files.m`
   - `src/graph_network/demo_point2.m` (this one already existed and is now replaced)
   - `src/graph_network/draw_network.m`
   - `src/graph_network/graph_layout.m`
   - `src/graph_network/mark_edges.m`
   - `src/graph_network/path_to_edges.m`
   - `src/graph_network/picture_options.m`
   - `src/graph_network/plural_s.m`
   - `src/graph_network/save_network_pictures.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_graph_analysis.m` (this one already existed and is now replaced)
   - `tests/test_graph_pictures.m`
3. Check the SHA-256 hash of all 15 files. All 15 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `.gitignore` | `73b8a03bc3fd3ea0c18c65d1b270dc5df1d824ab55c7253deb863430bdfc4292` |
   | `PROGRESS.md` | `dcb86df67086514b9ed80f68afe755b134b6b166b628e86ab2de81344c1ee423` |
   | `README.md` | `23a3d6b282da354f6292279d702727ed20fd2d8a11ab499d34c796b8ab6df1b4` |
   | `src/graph_network/check_picture_files.m` | `0a74d1567e03f3cc5e1a53285f9de45e3fee43d19ba073394ee7ad2fe1afb5f1` |
   | `src/graph_network/demo_point2.m` | `b3068e1443c88ddd0090fc5613ad3a0528367279b141fcd08fae790cd8595969` |
   | `src/graph_network/draw_network.m` | `0ba46d5a479315047094142a8324587ac0bddff6fadbd849d90eb3dbfa5fb9e9` |
   | `src/graph_network/graph_layout.m` | `00fbe1ed397df1cf49515b326e28c25b96907fbe903daad558a15502e82b8816` |
   | `src/graph_network/mark_edges.m` | `b775aaf8d237ff60952a78755dd8d81bcf35067145e196b70a8661b86982d687` |
   | `src/graph_network/path_to_edges.m` | `fb033579c60aed8454d2c7e9b2f9af2eadc879ab9aad9fc00bd09dae7a77ecee` |
   | `src/graph_network/picture_options.m` | `47279dd99a61784bb133e1f290f799bcfab2dad43d14cc0c641c0d15e49b555a` |
   | `src/graph_network/plural_s.m` | `26af73d6bfa8bfb48c82155394dcb34cb2fc17589e7222eba59ff682d2c33a2b` |
   | `src/graph_network/save_network_pictures.m` | `e44ab12fe0cba3dc98d2de73fe94aeb1de9b4875b2c881b569f0298df4a75b73` |
   | `tests/run_all_tests.m` | `f06cd9c28d17ed3a2e8695461f23ca2b0840d849ee0eed81c52375beb77acd9c` |
   | `tests/test_graph_analysis.m` | `f0f534c5555fa257fa0fbcf61e8f581496ae2729f24d799245aee7cbfbecdde6` |
   | `tests/test_graph_pictures.m` | `9111b9b626a3084b62166506729ee323656b3b723ba7546dea3b598060e4146c` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 '.gitignore': '73b8a03bc3fd3ea0c18c65d1b270dc5df1d824ab55c7253deb863430bdfc4292',
 'PROGRESS.md': 'dcb86df67086514b9ed80f68afe755b134b6b166b628e86ab2de81344c1ee423',
 'README.md': '23a3d6b282da354f6292279d702727ed20fd2d8a11ab499d34c796b8ab6df1b4',
 'src/graph_network/check_picture_files.m': '0a74d1567e03f3cc5e1a53285f9de45e3fee43d19ba073394ee7ad2fe1afb5f1',
 'src/graph_network/demo_point2.m': 'b3068e1443c88ddd0090fc5613ad3a0528367279b141fcd08fae790cd8595969',
 'src/graph_network/draw_network.m': '0ba46d5a479315047094142a8324587ac0bddff6fadbd849d90eb3dbfa5fb9e9',
 'src/graph_network/graph_layout.m': '00fbe1ed397df1cf49515b326e28c25b96907fbe903daad558a15502e82b8816',
 'src/graph_network/mark_edges.m': 'b775aaf8d237ff60952a78755dd8d81bcf35067145e196b70a8661b86982d687',
 'src/graph_network/path_to_edges.m': 'fb033579c60aed8454d2c7e9b2f9af2eadc879ab9aad9fc00bd09dae7a77ecee',
 'src/graph_network/picture_options.m': '47279dd99a61784bb133e1f290f799bcfab2dad43d14cc0c641c0d15e49b555a',
 'src/graph_network/plural_s.m': '26af73d6bfa8bfb48c82155394dcb34cb2fc17589e7222eba59ff682d2c33a2b',
 'src/graph_network/save_network_pictures.m': 'e44ab12fe0cba3dc98d2de73fe94aeb1de9b4875b2c881b569f0298df4a75b73',
 'tests/run_all_tests.m': 'f06cd9c28d17ed3a2e8695461f23ca2b0840d849ee0eed81c52375beb77acd9c',
 'tests/test_graph_analysis.m': 'f0f534c5555fa257fa0fbcf61e8f581496ae2729f24d799245aee7cbfbecdde6',
 'tests/test_graph_pictures.m': '9111b9b626a3084b62166506729ee323656b3b723ba7546dea3b598060e4146c',
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
   `git add .gitignore PROGRESS.md README.md src/graph_network/check_picture_files.m src/graph_network/demo_point2.m src/graph_network/draw_network.m src/graph_network/graph_layout.m src/graph_network/mark_edges.m src/graph_network/path_to_edges.m src/graph_network/picture_options.m src/graph_network/plural_s.m src/graph_network/save_network_pictures.m tests/run_all_tests.m tests/test_graph_analysis.m tests/test_graph_pictures.m packets/PACKET_2C_PICTURES.md`
5. Run `git status --short`. It must print exactly these 16 lines and nothing else:
```
M  .gitignore
M  PROGRESS.md
M  README.md
A  packets/PACKET_2C_PICTURES.md
A  src/graph_network/check_picture_files.m
M  src/graph_network/demo_point2.m
A  src/graph_network/draw_network.m
A  src/graph_network/graph_layout.m
A  src/graph_network/mark_edges.m
A  src/graph_network/path_to_edges.m
A  src/graph_network/picture_options.m
A  src/graph_network/plural_s.m
A  src/graph_network/save_network_pictures.m
M  tests/run_all_tests.m
M  tests/test_graph_analysis.m
A  tests/test_graph_pictures.m
```
6. Commit with exactly this message: `2C: pictures of the network and the finished demo_point2`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 15 of 15 match.
2. `git log -1 --oneline` shows the message `2C: pictures of the network and the finished demo_point2`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly seven lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md` and `packets/PACKET_2C_PICTURES.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point2` and press Enter. Expected: the same text as before (the graph and the analysis, with 8 check lines that end with `yes`), then `=== PICTURES OF THE COMMUNICATION NETWORK ===`, the line `The 5 pictures are open in figure windows and are saved as PNG files in this folder:`, the path of the `outputs` folder, and 5 numbered lines with the file names and titles:
   1. `point2_network.png` (The communication network: users are vertices, channels are edges)
   2. `point2_shortest_path.png` (Shortest path: Alice - Bob - Dave - Frank - Grace (length 4))
   3. `point2_cycle.png` (A shortest cycle: Alice - Bob - Dave - Carol - Alice (length 4))
   4. `point2_weak_points.png` (Weak points: 2 bridge channels (red), 2 cut users (orange))
   5. `point2_split.png` (Channel Dave - Frank removed: 2 group(s) of users (one color each))
   and a last block `Checks:` with 3 lines that end with `yes`. In total the demo has 11 check lines, all ending with `yes`, none ending with `NO`.
   Five figure windows must be open. Look at them: the users are circles with their names, the channels are lines marked e1 to e6, no circle touches another one, and each title matches the list above (picture 2 shows the path Alice - Bob - Dave - Frank - Grace in thick green; picture 3 shows the cycle Alice - Bob - Dave - Carol in thick purple; picture 4 shows Dave - Frank and Frank - Grace in red and Dave and Frank in orange; picture 5 shows Dave - Frank dotted and gray, and the two groups in two colors). The 5 PNG files must be in the `outputs` folder.
5. Type `G = define_graph(); A = G.adj; B = remove_channel(A, 4, 5); disp(is_connected(A)); disp(is_connected(B))` and press Enter. Expected: `1` and then `0` (Dave - Frank is edge e5; without it Frank and Grace are cut off from the others).
6. Type `demo_point1` and press Enter. It must still print everything from 1A, 1B and 1C as before.
7. Run `git status --short` in a terminal. It must print nothing: the PNG files in `outputs` are ignored by git.

The planner already ran steps 2 to 5 in GNU Octave 8.4 (with gnuplot): 25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120 and 129 of 129 checks passed, and `demo_point2` with the figures off printed 11 check lines that all say yes. The analysis functions of 2B were also compared with a separate Python program on 476 graphs. The places of the users (`graph_layout`) were compared with a separate Python program on 476 graphs and gave the same places every time. The 5 PNG files were looked at by eye.

Paste line for the agent:

`Read packets/PACKET_2C_PICTURES.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
