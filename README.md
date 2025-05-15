# surface-water-pilot
A sandbox to test approaches to analyze surface water data to provide technical support to planning groups. 

## 📦 Project Structure

This project uses an [**`renv`**](https://rstudio.github.io/renv/) environment to ensure reproducible R package management and supports [**Quarto**](https://quarto.org/) for generating reports and notebooks.

## 🔄 Getting Started

After cloning this repository:

1. 📁 **Open the R Project**
   - Open the file `surface-water-pilot.Rproj` in RStudio.

2. 🧱 **Restore the Environment**
   - Run this in the R console:
     ```r
     renv::restore()
     ```
   - This installs all packages listed in `renv.lock` into a project-local library.

3. 📑 **Render Any Quarto Documents**
   - If the project contains `.qmd` files, you can render them with:
     ```r
     quarto::render("your-document.qmd")
     ```

4. 📊 **Run Analysis Scripts**
   - Use RStudio interactively or run scripts from the main project directory.

## ✅ Notes

- 📌 The folder `renv/library/` is intentionally excluded from version control.
- 🚫 Do not install packages globally—always work within the `renv` environment.
- 🔄 Remember to run `renv::snapshot()` if you add or update packages.

## 🧼 .gitignore Highlights

This project ignores:
- `renv/library/`
- `.Rhistory`, `.RData`, `.Rproj.user/`
- Common Quarto outputs (`*.html`, `*.pdf`, etc.)

## 🔁 Reproducibility Promise

By usi