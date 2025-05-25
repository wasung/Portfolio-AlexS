# Load required package
library(fs)

# Set project name
project_name <- "guerrilla-project"

# Create root project folder
dir_create(project_name)

# Define top-level subfolders
subfolders <- c(
  "0_admin",
  "1_data_raw",            # will be expanded in more detail below
  "2_data_clean",
  "3_analysis",
  "4_outputs/plots",
  "5_meta",
  "6_log"
)

# Create top-level folders
for (folder in subfolders) {
  dir_create(path(project_name, folder))
}

# === 1_data_raw structure (Guerrilla-style) ===
raw_base <- path(project_name, "1_data_raw")

# Create submodules inside 1_data_raw
dir_create(c(
  path(raw_base, "Data001/supporting"),
  path(raw_base, "Data001/v01"),
  path(raw_base, "Data002")
))

# Create placeholder files for Data001
file_create(path(raw_base, "Data001", "2024-01-01_cleanroom_counts.csv"))
file_create(path(raw_base, "Data001", "2024-01-01_md5sum_cleanroom_counts.md5"))
file_create(path(raw_base, "Data001", "README.txt"))
file_create(path(raw_base, "Data001/supporting", "cleanroom_import.R"))
file_create(path(raw_base, "Data001/supporting", "md5sum.R"))
file_create(path(raw_base, "Data001/v01", "2023-12-15_cleanroom_counts.csv"))
file_create(path(raw_base, "Data001/v01", "2023-12-15_md5sum_cleanroom_counts.md5"))

# Create placeholder files for Data002
file_create(path(raw_base, "Data002", "README.txt"))
file_create(path(raw_base, "Data002", "experimental_design_notes.xlsx"))

# Create master README for 1_data_raw
file_create(path(raw_base, "README.txt"))

# === Other folders and placeholder files ===
file_create(path(project_name, "guerrilla_project.Rproj"))

# 0_admin
file_create(path(project_name, "0_admin", "README.md"))

# 2_data_clean
file_create(path(project_name, "2_data_clean", "cleaned_data_sample.csv"))

# 3_analysis
file_create(path(project_name, "3_analysis", "01_import_and_clean.R"))
file_create(path(project_name, "3_analysis", "02_analysis.R"))
file_create(path(project_name, "3_analysis", "03_visualizations.R"))

# 5_meta
file_create(path(project_name, "5_meta", "data_dictionary.md"))
file_create(path(project_name, "5_meta", "variable_definitions.md"))

# 6_log
file_create(path(project_name, "6_log", "run_log.md"))

# === Done ===
# Print the directory tree
cat("✅ Guerrilla Analytics project structure created:\n")
dir_tree(project_name, recurse = TRUE)
