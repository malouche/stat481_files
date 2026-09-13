# MANIFEST — stat481_files

Built 05 Sep 2026, 07:49 by `make_stat481_files.py`. Every PDF below passed four gates:

1. **filename** — does not look like restricted material
2. **watermark** — its text does not contain *MASTER SOLUTION* / *not for distribution* (every instructor build carries that header)
3. **currency** — the PDF is at least as new as its `.tex`
4. **integrity** — `pdfinfo` reads it, and the md5 of the copy equals the md5 of the source

| kind | file | size | md5 |
|---|---|---|---|
| PDF | `00_syllabus/STAT481_Syllabus_Fall2026.pdf` | 10 pages | `ac63c517c3da` |
| PDF | `01_lectures/00_CourseIntroduction_Aug23.pdf` | 8 pages | `4d0fd3683f33` |
| PDF | `01_lectures/01_L1_OrganisingMultivariateData_Aug25.pdf` | 14 pages | `1bec9fda06db` |
| PDF | `01_lectures/02_L2_SummaryStatistics_Aug27.pdf` | 11 pages | `22008dfb4d45` |
| PDF | `01_lectures/03_L3_RLab_R_RStudio_Quarto_Aug30.pdf` | 13 pages | `31fb7ce2964d` |
| PDF | `01_lectures/04_L4_SeeingMultivariateData_Sep01.pdf` | 26 pages | `d8ff6ab4ee15` |
| PDF | `01_lectures/05_L5_Distance_Sep03.pdf` | 17 pages | `135f72a07edd` |
| PDF | `02_worksheets/Worksheet1_Aug25.pdf` | 3 pages | `15931674a873` |
| PDF | `02_worksheets/Worksheet2_Aug27.pdf` | 4 pages | `88e41536d05c` |
| PDF | `02_worksheets/Worksheet3_Aug30.pdf` | 3 pages | `e64aacc24e22` |
| PDF | `02_worksheets/Worksheet4_Sep01.pdf` | 4 pages | `4621aafe7a9e` |
| PDF | `03_assessments/RLab1_out_Sep03_due_Sep17.pdf` | 7 pages | `b531f357349a` |
| PDF | `03_assessments/SampleQuiz1_Sep08.pdf` | 8 pages | `753389096498` |
| PDF | `04_practice_sheets/PracticeSheet1_Sep06.pdf` | 6 pages | `1578f393b3d8` |
| data | `data/worldhealth2022.csv` | 19.7 KB | `a1faec630864` |
| data | `data/whwide2022.csv` | 68.3 KB | `d0ad10468d42` |
| project | `STAT481.Rproj` | 0.3 KB | `5c331e4d5a4f` |
| R | `R/setup.R` | 26 packages | `ef181e9b9fb2` |
| data | `data/worldhealth2022_CODEBOOK.md` | codebook | `42a690e332ea` |
| data | `data/whwide2022_CODEBOOK.md` | codebook | `4e64a1953624` |
| meta | `README.md` |  | `85500bd60994` |
| meta | `.gitignore` |  | `526287683776` |
| R | `R/L1_code.R` | 16 blocks | `97cacedf5715` |
| R | `R/L2_code.R` | 9 blocks | `0df10985fb12` |
| R | `R/L3_code.R` | 22 blocks | `67c36797b8a4` |
| R | `R/L4_code.R` | 19 blocks | `7e8f60ba0988` |
| R | `R/L5_code.R` | 23 blocks | `b4c75bab6543` |

## Not in this folder, on purpose

- **Every answer key, solution, quiz, midterm and final.** The one exception is the STUDENT copy of each sample quiz, which is posted for the correction session; its key is not.
- **Stages 2-7.** Drafted 18-20 Aug 2026, before the depth upgrade; each is added here as its rebuild and audit close.
- **The eight assessment data panels.** Shipping them would tell students which data the quizzes are built on.
- **The instructor codebooks.** They are design documents: `whwide2022`'s names all eight assessment panels, and `worldhealth2022`'s publishes the L5 Mahalanobis ranking and the L7 eigenvector result before either lecture is taught. The two codebooks here were written fresh for students.
- **The `*_livedemo.R` scripts.** They are the worksheet KEY code - every console block in Worksheets 1-4 is captured from them. Shipping one publishes the answers.
- **The authoring toolchain** - `L*_capture*.R`, `L3_rulecheck.R`, `R/verify_*.R`, `R/build_*.R`. `build_*.R` names the eight assessment panels.
- **`.Rprofile`, `renv/` and `renv.lock`.** The instructor `.Rprofile` sources `renv/activate.R`; a student without `renv/` would get an error on every startup.

## Refreshing it

```bash
cd Fall2026
python3 make_stat481_files.py --check   # verify, copy nothing
python3 make_stat481_files.py           # rebuild (this also rewrites R/L*_code.R)
```

Add a new document by putting one line in the `PDFS` allowlist in that script. Membership is an allowlist by design: a denylist is one forgotten pattern away from publishing a key.

## Publishing it

The repository root is **this folder**, not the course folder. Then no key, no `Stage*/` source and no instructor note can be pushed by accident, whatever anyone types later.

The repository was initialised here on 30 Aug 2026 (`main`, `user.name` / `user.email` set locally). It has **no remote yet**. Run these on the Mac, in Terminal or the RStudio terminal — the GitHub credentials live there and nowhere else:

```bash
cd ~/Documents/GitHub/MultivariateAnalysisSTAT481/Fall2026/stat481_files
rm -rf .git/_to_delete    # stale lock/temp files parked by the sandbox
git remote add origin git@github.com:<user>/STAT481-Fall2026.git
git push -u origin main
```

Create the empty repository on github.com first — no README, no `.gitignore`, no licence, this folder has all three. Use the `https://` URL instead of `git@` if the Mac is not set up for SSH.

Before any push: `git ls-files | grep -Ei 'key|solution|quiz|midterm|final|verify'` must come back empty.

After each rebuild: `git add -A && git commit -m '...' && git push`.
For Blackboard, upload the same PDFs from their folders here, so the two copies are the same bytes.
