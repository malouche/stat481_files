# MANIFEST — stat481_files

Built 30 Aug 2026, 05:16 by `make_stat481_files.py`. Every PDF below passed four gates:

1. **filename** — does not look like restricted material
2. **watermark** — its text does not contain *MASTER SOLUTION* / *not for distribution* (every instructor build carries that header)
3. **currency** — the PDF is at least as new as its `.tex`
4. **integrity** — `pdfinfo` reads it, and the md5 of the copy equals the md5 of the source

| kind | file | size | md5 |
|---|---|---|---|
| PDF | `00_syllabus/STAT481_Syllabus_Fall2026.pdf` | 10 pages | `ac63c517c3da` |
| PDF | `01_lectures/00_CourseIntroduction_Aug23.pdf` | 8 pages | `4d0fd3683f33` |
| PDF | `01_lectures/01_L1_OrganisingMultivariateData_Aug25.pdf` | 13 pages | `f78001aeb54c` |
| PDF | `01_lectures/02_L2_SummaryStatistics_Aug27.pdf` | 10 pages | `740d67b38426` |
| PDF | `01_lectures/03_L3_RLab_R_RStudio_Quarto_Aug30.pdf` | 13 pages | `7a01db873c3d` |
| PDF | `01_lectures/04_L4_SeeingMultivariateData_Sep01.pdf` | 24 pages | `cbeb87d93f6a` |
| PDF | `02_worksheets/Worksheet1_Aug25.pdf` | 3 pages | `69e5e66d8a2a` |
| PDF | `02_worksheets/Worksheet2_Aug27.pdf` | 4 pages | `88bb97120375` |
| PDF | `02_worksheets/Worksheet3_Aug30.pdf` | 3 pages | `ddcfbf52985e` |
| PDF | `02_worksheets/Worksheet4_Sep01.pdf` | 4 pages | `70433642cfaa` |
| PDF | `03_labs/RLab1_out_Aug30_due_Sep06.pdf` | 4 pages | `6ca42066bf6e` |
| data | `data/worldhealth2022.csv` | 19.8 KB | `0d93fb9bf578` |
| data | `data/whwide2022.csv` | 68.7 KB | `a6647ca634c5` |
| project | `STAT481.Rproj` | 0.3 KB | `5c331e4d5a4f` |
| R | `R/setup.R` | 25 packages | `7340c927c78c` |
| data | `data/worldhealth2022_CODEBOOK.md` | codebook | `42a690e332ea` |
| data | `data/whwide2022_CODEBOOK.md` | codebook | `4e64a1953624` |
| meta | `README.md` |  | `9de679b95291` |
| meta | `.gitignore` |  | `93cbcb4b38ba` |

## Not in this folder, on purpose

- **Every answer key, solution, quiz, sample quiz, midterm and final.**
- **L5 and Stages 2-7.** Drafted 18-20 Aug 2026, before the depth upgrade; each is added here as its rebuild and audit close.
- **The eight assessment data panels.** Shipping them would tell students which data the quizzes are built on.
- **The instructor codebooks.** They are design documents: `whwide2022`'s names all eight assessment panels, and `worldhealth2022`'s publishes the L5 Mahalanobis ranking and the L7 eigenvector result before either lecture is taught. The two codebooks here were written fresh for students.
- **`.Rprofile`, `renv/` and `renv.lock`.** The instructor `.Rprofile` sources `renv/activate.R`; a student without `renv/` would get an error on every startup.

## Refreshing it

```bash
cd Fall2026
python3 make_stat481_files.py --check   # verify, copy nothing
python3 make_stat481_files.py           # rebuild
```

Add a new document by putting one line in the `PDFS` allowlist in that script. Membership is an allowlist by design: a denylist is one forgotten pattern away from publishing a key.

## Publishing it

The repository root is **this folder**, not the course folder. Then no keys, no `Stage*/` sources and no instructor notes can be pushed by accident, whatever anyone types later.

**Already done (30 Aug 2026), on `new-mac-laptop-2-local`:** `git init -b main`,
repo-local `user.name`/`user.email`, and one commit `4280879` holding all 20
tracked files. Nothing else was created. The repository has **no remote yet**.

Two things to run on the Mac, in a Terminal or the RStudio terminal, because the
GitHub credentials live there and nowhere else:

```bash
cd ~/Documents/GitHub/MultivariateAnalysisSTAT481/Fall2026/stat481_files
rm -rf .git/_to_delete          # 30 stale lock/temp files parked by the sandbox
git remote add origin git@github.com:<user>/STAT481-Fall2026.git
git push -u origin main
```

Create the empty repository on github.com first (no README, no .gitignore, no
licence — this folder already has all three). Use the `https://` URL instead of
`git@` if the Mac is not set up for SSH.

After each rebuild: `git add -A && git commit -m '...' && git push`.
For Blackboard, upload the same PDFs from their folders here, so the two copies are the same bytes.
