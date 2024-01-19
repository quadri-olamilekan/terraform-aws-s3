module.exports = {
    branches: "main",
    repositoryUrl: "https://github.com/quadri-olamilekan/terraform-aws-s3-bucket.git",
    plugins: [
      '@semantic-release/commit-analyzer',
      '@semantic-release/release-notes-generator',
      '@semantic-release/git',
      '@semantic-release/github']
     }