require "option_parser"

require "file_utils"

require "../git-version"

dev_branch = "dev"
release_branch = "master"
patch_cmd = nil

folder = FileUtils.pwd

OptionParser.parse! do |parser|
  parser.banner = "Usage: git-version [arguments]"
  parser.on("-f FOLDER", "--folder=FOLDER", "Execute the command in the defined folder") { |f| folder = f }
  parser.on("-b BRANCH", "--dev-branch=BRANCH", "Specifies the development branch") { |branch| dev_branch = branch }
  parser.on("-r BRANCH", "--release-branch=BRANCH", "Specifies the release branch") { |branch| release_branch = branch }
  parser.on("-p PATCHCMD", "--patch-command=BRANCH", "Specifies the command to run to bump the minor") { |patchcmd| patch_cmd = patchcmd }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

git = GitVersion::Git.new(dev_branch, release_branch, patch_cmd, folder)

puts "#{git.get_version}"
