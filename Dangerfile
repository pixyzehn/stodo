message("Hello, I'm working:)")

declared_trivial = github.pr_title.include? "#trivial"

swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files

warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"
warn("Big PR") if git.lines_of_code > 500
