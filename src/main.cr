require "option_parser"

require "file_utils"

require "./git-version"

latest_version = false
dev_branch = "dev"
release_branch = "master"
prefix = ""
log_paths = ""

folder = FileUtils.pwd

OptionParser.parse! do |parser|
  parser.banner = "Usage: git-version [arguments]"
  parser.on("-f FOLDER", "--folder=FOLDER", "Execute the command in the defined folder") { |f| folder = f }
  parser.on("-b BRANCH", "--dev-branch=BRANCH", "Specifies the development branch") { |branch| dev_branch = branch }
  parser.on("-r BRANCH", "--release-branch=BRANCH", "Specifies the release branch") { |branch| release_branch = branch }
  parser.on("-p PREFIX", "--version-prefix=PREFIX", "Specifies a version prefix") { |p| prefix = p }
  parser.on("-l PATH", "--log-paths=PATH", "") { |path| log_paths = path }
  parser.on("--latest-version", "Returns the latest tag instead of calculating a new one") { latest_version=true }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

git = GitVersion::Git.new(dev_branch, release_branch, folder, prefix, log_paths)

if latest_version
  puts "#{git.get_latest_version}"
else
  puts "#{git.get_new_version}"
end