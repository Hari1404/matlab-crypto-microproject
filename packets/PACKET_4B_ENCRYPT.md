# PACKET 4B: encryption with the shared key and the eavesdropper

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 4 (Diffie-Hellman and encryption), second and last packet
Goal: add the encryption with the Diffie-Hellman shared key in `src/encryption/`: `send_message`, `format_numbers`, `try_all_keys`, the printouts `show_encryption` and `show_eavesdropper`; add `eavesdrop_dh` in `src/diffie_hellman/`; change the demo `demo_point4` so that it shows the key exchange, the encryption and the eavesdropper one after the other. Add the test `test_encryption`. Change `test_dh` and `run_all_tests`. Update PROGRESS.md and README.md. One commit, then push. Point 4 is finished with this packet.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `d9bef2c 4A: Diffie-Hellman key exchange`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_4B_ENCRYPT.md` and `packets/MP4B_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_4B_ENCRYPT.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP4B_files.zip" -DestinationPath "." -Force`
2. Check that these 12 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/diffie_hellman/demo_point4.m` (this one already existed and is now replaced)
   - `src/diffie_hellman/eavesdrop_dh.m`
   - `src/encryption/format_numbers.m`
   - `src/encryption/send_message.m`
   - `src/encryption/show_eavesdropper.m`
   - `src/encryption/show_encryption.m`
   - `src/encryption/try_all_keys.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_dh.m` (this one already existed and is now replaced)
   - `tests/test_encryption.m`
3. Check the SHA-256 hash of all 12 files. All 12 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `d44dfa18526d5ad4a46577684c35d56258b48e2c08ca5f3e6382e3b3b133c417` |
   | `README.md` | `d66077058bae49c31ea1e3e798be64bb911118b087e95b992c126fa1af10c5d0` |
   | `src/diffie_hellman/demo_point4.m` | `0dc87c2c6338e0b6fe9a1144a0f3f01e38b390b94019b6a5063e98c97dae0a87` |
   | `src/diffie_hellman/eavesdrop_dh.m` | `b8884ed541a9a2051127716977021ad099c2c0451b343e27fc41411b7bbe1707` |
   | `src/encryption/format_numbers.m` | `70d494640b9df604398825f25192871392bb5c7756b214d9757d7fdd8ce756b1` |
   | `src/encryption/send_message.m` | `5670a48cf70d8c728c2e29b56cc11b5da69f1ddc33ac503d1f2501a461cd1dee` |
   | `src/encryption/show_eavesdropper.m` | `d6f1cd3c3a9c2b3b5963d64a59fb4afa69b32031adfc84f0bbcf5076f9e3ea95` |
   | `src/encryption/show_encryption.m` | `2733576a3f0f594c7ad2775658bf25b1f82e117dd01827ce64a387d24bc92089` |
   | `src/encryption/try_all_keys.m` | `082d8dfd3720d20e50d70b6a058f1ae60bfce961d3208fc58192f97f19621f85` |
   | `tests/run_all_tests.m` | `7f39c300321f9f78699659c35d789add66d784635568d7c4d0398a39bb4f8786` |
   | `tests/test_dh.m` | `97095578086151d988b84200ae478c32be18ab2595feb5ae79066976f6688bde` |
   | `tests/test_encryption.m` | `d4569df3bade46209882188d35828e17130bdf6e3494d012f439687c41640d00` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': 'd44dfa18526d5ad4a46577684c35d56258b48e2c08ca5f3e6382e3b3b133c417',
 'README.md': 'd66077058bae49c31ea1e3e798be64bb911118b087e95b992c126fa1af10c5d0',
 'src/diffie_hellman/demo_point4.m': '0dc87c2c6338e0b6fe9a1144a0f3f01e38b390b94019b6a5063e98c97dae0a87',
 'src/diffie_hellman/eavesdrop_dh.m': 'b8884ed541a9a2051127716977021ad099c2c0451b343e27fc41411b7bbe1707',
 'src/encryption/format_numbers.m': '70d494640b9df604398825f25192871392bb5c7756b214d9757d7fdd8ce756b1',
 'src/encryption/send_message.m': '5670a48cf70d8c728c2e29b56cc11b5da69f1ddc33ac503d1f2501a461cd1dee',
 'src/encryption/show_eavesdropper.m': 'd6f1cd3c3a9c2b3b5963d64a59fb4afa69b32031adfc84f0bbcf5076f9e3ea95',
 'src/encryption/show_encryption.m': '2733576a3f0f594c7ad2775658bf25b1f82e117dd01827ce64a387d24bc92089',
 'src/encryption/try_all_keys.m': '082d8dfd3720d20e50d70b6a058f1ae60bfce961d3208fc58192f97f19621f85',
 'tests/run_all_tests.m': '7f39c300321f9f78699659c35d789add66d784635568d7c4d0398a39bb4f8786',
 'tests/test_dh.m': '97095578086151d988b84200ae478c32be18ab2595feb5ae79066976f6688bde',
 'tests/test_encryption.m': 'd4569df3bade46209882188d35828e17130bdf6e3494d012f439687c41640d00',
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
   `git add PROGRESS.md README.md src/diffie_hellman/demo_point4.m src/diffie_hellman/eavesdrop_dh.m src/encryption/format_numbers.m src/encryption/send_message.m src/encryption/show_eavesdropper.m src/encryption/show_encryption.m src/encryption/try_all_keys.m tests/run_all_tests.m tests/test_dh.m tests/test_encryption.m packets/PACKET_4B_ENCRYPT.md`
5. Run `git status --short`. It must print exactly these 13 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_4B_ENCRYPT.md
M  src/diffie_hellman/demo_point4.m
A  src/diffie_hellman/eavesdrop_dh.m
A  src/encryption/format_numbers.m
A  src/encryption/send_message.m
A  src/encryption/show_eavesdropper.m
A  src/encryption/show_encryption.m
A  src/encryption/try_all_keys.m
M  tests/run_all_tests.m
M  tests/test_dh.m
A  tests/test_encryption.m
```
6. Commit with exactly this message: `4B: encryption with the shared key and the eavesdropper`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 12 of 12 match.
2. `git log -1 --oneline` shows the message `4B: encryption with the shared key and the eavesdropper`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly eleven lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md` and `packets/PACKET_4B_ENCRYPT.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then 101 lines starting with PASS, then `test_encryption: 101 of 101 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point4` and press Enter. Expected: the title `##### POINT 4 DEMO: DIFFIE-HELLMAN KEY EXCHANGE AND ENCRYPTION #####` and then three parts, one after the other. Each part ends with its own `Checks:` block of 7 lines that all end with `yes` (21 lines in all, none ends with `NO`):
   1. `=== DIFFIE-HELLMAN KEY EXCHANGE ===`: the same as after Packet 4A (Alice and Bob get the key 85, the table of the 6 users, the table of keys).
   2. `=== ENCRYPTION WITH THE SHARED KEY ===`: Alice sends the message `Meet me at the library at 5 pm, Bob.` to Bob, with the lines `Alice computes the key B^a mod p = 46^6 mod 97 = 85.` and `Bob computes the key A^b mod p = 8^15 mod 97 = 85.`, the example `85 * 46 mod 97 = 30`, `The 36 numbers that cross the channel:` (3 lines of 12 numbers), `Bob finds the inverse key j = 8 (because 85 * 8 mod 97 = 1)` and `The text that Bob gets: Meet me at the library at 5 pm, Bob.` Then `2. What a wrong key gives` (the key 12 makes the decryption stop) and `The same message goes from every user to every other user, 30 messages in all.`
   3. `=== THE EAVESDROPPER ===`: `She gets 5^6 mod 97 = 8 after 6 tries. So the secret number of Alice is 6.` and `She decrypts the message with the key 85: Meet me at the library at 5 pm, Bob.`; then a table for the primes 97, 1009, 10007 and 100003 with the tries 95, 1007, 10005 and 100001 (the answer is `yes` in every row); then `Keys where the decryption stops (a value that is not a symbol): 18 of 96` and `key 85  gives: Meet me at the library at 5 pm, Bob.`
5. Type `M = send_message('Hello', 1, 2); disp(M.cipher); disp(M.received)` and press Enter. Expected: the five numbers 90, 33, 46, 46 and 10 and then `Hello`.
6. Type `V = eavesdrop_dh(8, 46, 97, 5); disp([V.secret V.tries V.key])` and press Enter. Expected: the three numbers 6, 6 and 85.
7. Type `demo_point1`, then `demo_point2`, then `demo_point3`, and press Enter after each. All three must still print everything as before (`demo_point2` opens its 5 figure windows again, and `demo_point3` has 3 `Checks:` blocks with 18 lines that all end with `yes`).
8. Run `git status --short` in a terminal. It must print nothing.

The planner already ran steps 2 to 6 in GNU Octave 8.4: 25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130, 131 of 131, 71 of 71 and 101 of 101 checks passed, and `demo_point4` printed 21 check lines that all say yes. The new functions were also compared with a separate Python program on 200 cases (primes from 97 to 293, random secret numbers and random texts) and gave the same keys, ciphertext numbers, secret numbers and counts of keys every time. No mutation test was run on the new code.

Paste line for the agent:

`Read packets/PACKET_4B_ENCRYPT.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
